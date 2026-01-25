import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/message_model.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/providers/chat_provider.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/widgets/chat_input.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/widgets/message_bubble.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';

/// Chat detail screen for conversation
class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _scrollController = ScrollController();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Mark as read when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatActionsProvider.notifier).markAsRead(widget.chatId);
      // Set this as the active chat (suppresses notifications for this chat)
      ref.read(activeChatIdProvider.notifier).state = widget.chatId;
      // Clear notification tracking for this chat
      ref.read(messageNotificationProvider.notifier).clearChatTracking(widget.chatId);
    });
  }

  @override
  void deactivate() {
    // Clear active chat when navigating away
    // Capture notifier before deferring to avoid using ref after dispose
    final notifier = ref.read(activeChatIdProvider.notifier);
    Future.microtask(() {
      notifier.state = null;
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatByIdProvider(widget.chatId));
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final authState = ref.watch(authStateChangesProvider);
    final currentUserId = authState.valueOrNull?.uid ?? '';
    final chatActionsState = ref.watch(chatActionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(chatAsync, currentUserId),
      body: Column(
        children: [
          // Swap context banner
          _buildSwapBanner(chatAsync),

          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (_isFirstLoad && messages.isNotEmpty) {
                  _isFirstLoad = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }

                if (messages.isEmpty) {
                  return _buildEmptyMessages();
                }

                return _buildMessagesList(messages, currentUserId);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              ),
              error: (_, __) => _buildError(),
            ),
          ),

          // Typing indicator
          _buildTypingIndicator(chatAsync, currentUserId),

          // Chat input
          ChatInput(
            onSend: (text) async {
              final message = await ref
                  .read(chatActionsProvider.notifier)
                  .sendMessage(chatId: widget.chatId, content: text);
              if (message != null) {
                _scrollToBottom();
              }
            },
            onTypingChanged: (isTyping) {
              ref.read(chatActionsProvider.notifier).setTyping(widget.chatId, isTyping);
            },
            onAttachmentTap: () {
              // Show attachment options (camera/photo library)
              _showAttachmentOptions(context);
            },
            isSending: chatActionsState.isSending,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    AsyncValue<ChatModel?> chatAsync,
    String currentUserId,
  ) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_rounded),
        color: AppColors.textPrimary,
      ),
      title: chatAsync.when(
        data: (chat) {
          if (chat == null) return const Text('Chat');

          final otherParticipant = getOtherParticipant(chat, currentUserId);
          return GestureDetector(
            onTap: () {
              final otherId = chat.participants.firstWhere(
                (id) => id != currentUserId,
                orElse: () => '',
              );
              if (otherId.isNotEmpty) {
                UserProfileRoute(userId: otherId).push(context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    UserAvatar(
                      imageUrl: otherParticipant?.photoUrl,
                      name: otherParticipant?.name ?? 'User',
                      size: AvatarSize.sm,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: Dimensions.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      otherParticipant?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Active now',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Text('Loading...'),
        error: (_, __) => const Text('Chat'),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.textPrimary,
          ),
          onSelected: (value) => _handleMenuAction(value, chatAsync.valueOrNull),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'swap',
              child: Row(
                children: [
                  Icon(Icons.swap_horiz, size: 20),
                  SizedBox(width: 12),
                  Text('View Swap Details'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuAction(String action, ChatModel? chat) {
    if (chat == null) return;

    final authState = ref.read(authStateChangesProvider);
    final currentUserId = authState.valueOrNull?.uid ?? '';
    final otherId = chat.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    switch (action) {
      case 'profile':
        if (otherId.isNotEmpty) {
          UserProfileRoute(userId: otherId).push(context);
        }
        break;
      case 'swap':
        // Set navigation to Matches tab (index 1)
        ref.read(navigationIndexProvider.notifier).state = 1;
        // Navigate to main shell with bottom nav
        const HomeRoute().go(context);
        break;
    }
  }

  Widget _buildSwapBanner(AsyncValue<ChatModel?> chatAsync) {
    return chatAsync.when(
      data: (chat) {
        if (chat == null) return const SizedBox.shrink();

        return FutureBuilder(
          future: ref.read(swapRepositoryProvider).getSwapById(chat.swapId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            return snapshot.data!.fold(
              (_) => const SizedBox.shrink(),
              (swap) => _SwapContextBanner(
                swap: swap,
                onScheduleTap: () {
                  ScheduleSessionRoute(swapId: swap.id).push(context);
                },
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMessagesList(List<MessageModel> messages, String currentUserId) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
        vertical: Dimensions.md,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;
        final isMine = message.senderId == currentUserId;
        final isRead = message.readBy.length > 1; // Read by someone other than sender

        return Column(
          children: [
            // Date separator
            if (shouldShowDateSeparator(message, previousMessage))
              DateSeparator(date: message.createdAt),

            // Message bubble
            MessageBubble(
              message: message,
              isMine: isMine,
              isRead: isRead,
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.waving_hand_rounded,
              size: 48,
              color: AppColors.gray300,
            ),
            const SizedBox(height: Dimensions.md),
            const Text(
              'Start the conversation!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Introduce yourself and discuss your swap plans.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.lg),
            QuickReplySuggestions(
              suggestions: [
                "Hi! I'm excited about our swap!",
                "When works best for you?",
                "What would you like to learn first?",
              ],
              onTap: (text) async {
                await ref.read(chatActionsProvider.notifier).sendMessage(
                      chatId: widget.chatId,
                      content: text,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(
    AsyncValue<ChatModel?> chatAsync,
    String currentUserId,
  ) {
    final typingAsync = ref.watch(typingStatusProvider(widget.chatId));

    return typingAsync.when(
      data: (typing) {
        final otherIsTyping = typing.entries
            .where((e) => e.key != currentUserId && e.value)
            .isNotEmpty;

        if (!otherIsTyping) return const SizedBox.shrink();

        final chat = chatAsync.valueOrNull;
        if (chat == null) return const SizedBox.shrink();

        final otherParticipant = getOtherParticipant(chat, currentUserId);

        return Padding(
          padding: const EdgeInsets.only(
            left: Dimensions.screenPaddingH,
            bottom: Dimensions.xs,
          ),
          child: TypingIndicator(userName: otherParticipant?.name ?? 'User'),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: Dimensions.md),
          const Text(
            'Failed to load messages',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.md),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(chatMessagesProvider(widget.chatId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primaryBlue,
                  ),
                ),
                title: const Text('Camera'),
                subtitle: const Text('Take a new photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera capture in future
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Camera feature coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.secondaryTeal,
                  ),
                ),
                title: const Text('Photo Library'),
                subtitle: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement photo picker in future
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo library feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Swap context banner at top of chat
class _SwapContextBanner extends StatelessWidget {
  final SwapModel swap;
  final VoidCallback? onScheduleTap;

  const _SwapContextBanner({
    required this.swap,
    this.onScheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
        vertical: Dimensions.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        border: Border(
          bottom: BorderSide(color: AppColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skill exchange
                Row(
                  children: [
                    Text(
                      swap.requesterOffers.skillName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Text(
                      swap.requesterWants.skillName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Status line
                Text(
                  '${swap.duration}h session  •  ${_getStatusText(swap.status)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Action button based on status
          if (_shouldShowButton(swap.status))
            TextButton(
              onPressed: onScheduleTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _getButtonText(swap.status),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getStatusText(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return 'Pending approval';
      case SwapStatus.accepted:
        return 'Schedule a session';
      case SwapStatus.scheduled:
        return 'Session scheduled';
      case SwapStatus.inProgress:
        return 'In progress';
      case SwapStatus.completed:
        return 'Completed';
      case SwapStatus.declined:
        return 'Declined';
      case SwapStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool _shouldShowButton(SwapStatus status) {
    return status == SwapStatus.accepted;
  }

  String _getButtonText(SwapStatus status) {
    switch (status) {
      case SwapStatus.accepted:
        return 'Schedule';
      case SwapStatus.scheduled:
        return 'View';
      default:
        return '';
    }
  }
}