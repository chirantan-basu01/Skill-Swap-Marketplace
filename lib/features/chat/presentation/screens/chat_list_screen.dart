import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/empty_state.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/error_widget.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/shimmer_loading.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/providers/chat_provider.dart';

/// Chat list screen showing all conversations
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(userChatsProvider);
    final authState = ref.watch(authStateChangesProvider);
    final currentUserId = authState.valueOrNull?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userChatsProvider);
            },
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _ChatListItem(
                  chat: chat,
                  currentUserId: currentUserId ?? '',
                  onTap: () {
                    ChatDetailRoute(chatId: chat.id).push(context);
                  },
                );
              },
            ),
          );
        },
        loading: () => _buildLoading(),
        error: (_, __) => _buildError(context, ref),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateNoMessages(
      onFindPartners: () => const HomeRoute().go(context),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ShimmerChatItem();
      },
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    return LoadFailureWidget(
      itemType: 'messages',
      onRetry: () => ref.invalidate(userChatsProvider),
    );
  }
}

/// Individual chat list item
class _ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final String currentUserId;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final otherParticipant = getOtherParticipant(chat, currentUserId);
    final unreadCount = chat.unreadCount[currentUserId] ?? 0;
    final hasUnread = unreadCount > 0;
    final isCompleted = chat.swapContext?.status == 'completed';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.screenPaddingH,
          vertical: Dimensions.md,
        ),
        decoration: BoxDecoration(
          color: hasUnread ? AppColors.primarySurface : AppColors.surface,
          border: const Border(
            bottom: BorderSide(color: AppColors.gray100),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                UserAvatar(
                  imageUrl: otherParticipant?.photoUrl,
                  name: otherParticipant?.name ?? 'User',
                  size: AvatarSize.md,
                ),
                // Online indicator - positioned at bottom right of avatar
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: Dimensions.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row with badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherParticipant?.name ?? 'User',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Badge: either unread count or completed
                      if (hasUnread) ...[
                        const SizedBox(width: Dimensions.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else if (isCompleted) ...[
                        const SizedBox(width: Dimensions.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Swap context line
                  if (chat.swapContext != null) ...[
                    Text(
                      _getSwapContextText(chat.swapContext!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                  ],

                  // Last message preview
                  if (chat.lastMessage != null) ...[
                    Text(
                      _getLastMessagePreview(chat.lastMessage!),
                      style: TextStyle(
                        fontSize: 13,
                        color: hasUnread
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                  ],

                  // Timestamp
                  Text(
                    chat.lastMessage != null
                        ? formatLastMessageTime(chat.lastMessage!.createdAt)
                        : formatLastMessageTime(chat.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSwapContextText(SwapContext context) {
    return '${context.offeredSkillName} ↔ ${context.wantedSkillName} swap';
  }

  String _getLastMessagePreview(LastMessage lastMessage) {
    final isFromMe = lastMessage.senderId == currentUserId;
    final prefix = isFromMe ? 'You: ' : '';

    switch (lastMessage.type) {
      case MessageType.image:
        return '${prefix}Sent a photo';
      case MessageType.system:
        return lastMessage.text;
      case MessageType.text:
        return '$prefix${lastMessage.text}';
    }
  }
}