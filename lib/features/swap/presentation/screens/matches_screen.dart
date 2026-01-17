import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/providers/chat_provider.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/widgets/swap_card.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'My Swaps',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            _buildTabWithBadge('Pending', _getPendingCount()),
            _buildTabWithBadge('Active', _getActiveCount()),
            const Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PendingSwapsTab(),
          _ActiveSwapsTab(),
          _CompletedSwapsTab(),
        ],
      ),
    );
  }

  Widget _buildTabWithBadge(String label, AsyncValue<int> countAsync) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          countAsync.when(
            data: (count) {
              if (count == 0) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  AsyncValue<int> _getPendingCount() {
    final incoming = ref.watch(incomingSwapRequestsProvider);
    final outgoing = ref.watch(outgoingSwapRequestsProvider);

    return incoming.when(
      data: (inList) => outgoing.when(
        data: (outList) => AsyncValue.data(inList.length + outList.length),
        loading: () => AsyncValue.data(inList.length),
        error: (e, s) => AsyncValue.error(e, s),
      ),
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    );
  }

  AsyncValue<int> _getActiveCount() {
    return ref.watch(activeSwapsProvider).whenData((swaps) => swaps.length);
  }
}

/// Pending swaps tab showing incoming and outgoing requests
class _PendingSwapsTab extends ConsumerWidget {
  const _PendingSwapsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingAsync = ref.watch(incomingSwapRequestsProvider);
    final outgoingAsync = ref.watch(outgoingSwapRequestsProvider);
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid ?? '';

    return incomingAsync.when(
      data: (incoming) => outgoingAsync.when(
        data: (outgoing) {
          if (incoming.isEmpty && outgoing.isEmpty) {
            return _buildEmptyStateWithContext(
              context,
              icon: Icons.swap_horiz_rounded,
              title: 'No pending requests',
              subtitle: 'When you send or receive swap requests, they\'ll appear here',
              ctaText: 'Find Someone to Swap With',
              onCtaTap: () => const HomeRoute().go(context),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(Dimensions.screenPaddingH),
            children: [
              // Incoming requests section
              if (incoming.isNotEmpty) ...[
                _buildSectionHeader(
                  'Incoming Requests',
                  incoming.length,
                  Icons.call_received_rounded,
                ),
                const SizedBox(height: Dimensions.sm),
                ...incoming.map((swap) => SwapCard(
                  swap: swap,
                  currentUserId: currentUserId,
                  onAccept: () => _acceptSwap(context, ref, swap.id),
                  onDecline: () => _declineSwap(context, ref, swap.id),
                  onTap: () => _viewSwapDetails(context, swap),
                )),
                const SizedBox(height: Dimensions.lg),
              ],

              // Outgoing requests section
              if (outgoing.isNotEmpty) ...[
                _buildSectionHeader(
                  'Outgoing Requests',
                  outgoing.length,
                  Icons.call_made_rounded,
                ),
                const SizedBox(height: Dimensions.sm),
                ...outgoing.map((swap) => SwapCard(
                  swap: swap,
                  currentUserId: currentUserId,
                  onTap: () => _viewSwapDetails(context, swap),
                )),
              ],
            ],
          );
        },
        loading: () => _buildLoading(),
        error: (e, s) => _buildError(e, s),
      ),
      loading: () => _buildLoading(),
      error: (e, s) => _buildError(e, s),
    );
  }

  Future<void> _acceptSwap(BuildContext context, WidgetRef ref, String swapId) async {
    final confirmed = await _showConfirmDialog(
      context,
      'Accept Swap Request',
      'Are you sure you want to accept this swap request? You will need to schedule a session after accepting.',
      'Accept',
    );

    if (confirmed == true) {
      final chatId = await ref.read(swapActionsNotifierProvider.notifier).acceptSwap(swapId);
      if (context.mounted) {
        if (chatId != null) {
          // Show success dialog with option to chat
          final goToChat = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Swap Accepted!'),
              content: const Text('You can now chat with your swap partner to coordinate your session.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Later'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Start Chatting'),
                ),
              ],
            ),
          );

          if (goToChat == true && context.mounted) {
            ChatDetailRoute(chatId: chatId).push(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Swap request accepted!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    }
  }

  Future<void> _declineSwap(BuildContext context, WidgetRef ref, String swapId) async {
    final confirmed = await _showConfirmDialog(
      context,
      'Decline Swap Request',
      'Are you sure you want to decline this swap request?',
      'Decline',
      isDestructive: true,
    );

    if (confirmed == true) {
      final success = await ref.read(swapActionsNotifierProvider.notifier).declineSwap(swapId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Swap request declined' : 'Failed to decline swap'),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  void _viewSwapDetails(BuildContext context, SwapModel swap) {
    // Navigate to user profile for now
    UserProfileRoute(userId: swap.providerId).push(context);
  }
}

/// Active swaps tab showing accepted and scheduled swaps
class _ActiveSwapsTab extends ConsumerWidget {
  const _ActiveSwapsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(activeSwapsProvider);
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid ?? '';

    return activeAsync.when(
      data: (swaps) {
        if (swaps.isEmpty) {
          return _buildEmptyStateWithContext(
            context,
            icon: Icons.handshake_rounded,
            title: 'No active swaps',
            subtitle: 'Accept a request or have one accepted to start swapping',
            ctaText: 'Browse Pending Requests',
            onCtaTap: () => const MatchesRoute().go(context),
          );
        }

        // Group by status
        final accepted = swaps.where((s) => s.status == SwapStatus.accepted).toList();
        final scheduled = swaps.where((s) => s.status == SwapStatus.scheduled).toList();
        final inProgress = swaps.where((s) => s.status == SwapStatus.inProgress).toList();

        return ListView(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          children: [
            // In Progress section
            if (inProgress.isNotEmpty) ...[
              _buildSectionHeader(
                'In Progress',
                inProgress.length,
                Icons.play_circle_filled_rounded,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: Dimensions.sm),
              ...inProgress.map((swap) => SwapCard(
                swap: swap,
                currentUserId: currentUserId,
                onTap: () => ActiveSessionRoute(swapId: swap.id).push(context),
                onChat: () => _navigateToChat(context, ref, swap.id),
                onComplete: () => _completeSwap(context, ref, swap.id),
              )),
              const SizedBox(height: Dimensions.lg),
            ],

            // Scheduled section
            if (scheduled.isNotEmpty) ...[
              _buildSectionHeader(
                'Scheduled',
                scheduled.length,
                Icons.event_rounded,
                color: AppColors.info,
              ),
              const SizedBox(height: Dimensions.sm),
              ...scheduled.map((swap) => SwapCard(
                swap: swap,
                currentUserId: currentUserId,
                onTap: () => ActiveSessionRoute(swapId: swap.id).push(context),
                onChat: () => _navigateToChat(context, ref, swap.id),
                onComplete: () => _completeSwap(context, ref, swap.id),
              )),
              const SizedBox(height: Dimensions.lg),
            ],

            // Accepted (needs scheduling) section
            if (accepted.isNotEmpty) ...[
              _buildSectionHeader(
                'Needs Scheduling',
                accepted.length,
                Icons.schedule_rounded,
                color: AppColors.warning,
              ),
              const SizedBox(height: Dimensions.sm),
              ...accepted.map((swap) => SwapCard(
                swap: swap,
                currentUserId: currentUserId,
                onSchedule: () => ScheduleSessionRoute(swapId: swap.id).push(context),
                onChat: () => _navigateToChat(context, ref, swap.id),
              )),
            ],
          ],
        );
      },
      loading: () => _buildLoading(),
      error: (e, s) => _buildError(e, s),
    );
  }
}

/// Completed swaps tab
class _CompletedSwapsTab extends ConsumerWidget {
  const _CompletedSwapsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAsync = ref.watch(completedSwapsProvider);
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid ?? '';

    return completedAsync.when(
      data: (swaps) {
        if (swaps.isEmpty) {
          return _buildEmptyStateWithContext(
            context,
            icon: Icons.emoji_events_rounded,
            title: 'No completed swaps yet',
            subtitle: 'Complete your first swap to start building your reputation',
            ctaText: 'Start Your First Swap',
            onCtaTap: () => const HomeRoute().go(context),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          itemCount: swaps.length,
          itemBuilder: (context, index) {
            final swap = swaps[index];
            // Check if user has rated using the swap's ratings map
            final hasRated = swap.ratings.containsKey(currentUserId);

            return SwapCard(
              swap: swap,
              currentUserId: currentUserId,
              onTap: () {
                if (!hasRated) {
                  RatingRoute(swapId: swap.id).push(context);
                }
              },
              onRate: !hasRated
                  ? () => RatingRoute(swapId: swap.id).push(context)
                  : null,
            );
          },
        );
      },
      loading: () => _buildLoading(),
      error: (e, s) => _buildError(e, s),
    );
  }
}

// Helper widgets

Widget _buildSectionHeader(
  String title,
  int count,
  IconData icon, {
  Color? color,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 18,
        color: color ?? AppColors.textSecondary,
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textSecondary,
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: (color ?? AppColors.textSecondary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textSecondary,
          ),
        ),
      ),
    ],
  );
}

Widget _buildEmptyState({
  required IconData icon,
  required String title,
  required String subtitle,
  String? ctaText,
  VoidCallback? onCtaTap,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(Dimensions.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.lg),
            decoration: const BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.gray400,
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.sm),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (ctaText != null && onCtaTap != null) ...[
            const SizedBox(height: Dimensions.lg),
            ElevatedButton(
              onPressed: onCtaTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.xl,
                  vertical: Dimensions.md,
                ),
              ),
              child: Text(ctaText),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Empty state with context for navigation
Widget _buildEmptyStateWithContext(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  String? ctaText,
  VoidCallback? onCtaTap,
}) {
  return _buildEmptyState(
    icon: icon,
    title: title,
    subtitle: subtitle,
    ctaText: ctaText,
    onCtaTap: onCtaTap,
  );
}

Widget _buildLoading() {
  return const Center(
    child: CircularProgressIndicator(color: AppColors.primaryBlue),
  );
}

Widget _buildError([Object? error, StackTrace? stack]) {
  // Print error for debugging
  if (error != null) {
    // ignore: avoid_print
    print('Swaps Error: $error');
    if (stack != null) {
      // ignore: avoid_print
      print('Stack: $stack');
    }
  }
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(Dimensions.lg),
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
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: Dimensions.sm),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    ),
  );
}

Future<bool?> _showConfirmDialog(
  BuildContext context,
  String title,
  String message,
  String confirmText, {
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? AppColors.error : AppColors.primaryBlue,
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

/// Navigate to chat for a given swap
Future<void> _navigateToChat(BuildContext context, WidgetRef ref, String swapId) async {
  // Get the chat by swap ID
  final chatAsync = await ref.read(chatBySwapIdProvider(swapId).future);

  if (chatAsync != null && context.mounted) {
    ChatDetailRoute(chatId: chatAsync.id).push(context);
  } else if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat not found. Please try again.'),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

/// Complete a swap session
Future<void> _completeSwap(BuildContext context, WidgetRef ref, String swapId) async {
  final confirmed = await _showConfirmDialog(
    context,
    'Complete Swap Session',
    'Mark this swap session as complete? Both users will need to rate the session afterward.',
    'Complete',
  );

  if (confirmed == true) {
    final success = await ref.read(swapActionsNotifierProvider.notifier).completeSwap(swapId);
    if (context.mounted) {
      if (success) {
        // Navigate to rating screen
        RatingRoute(swapId: swapId).push(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to complete swap. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}