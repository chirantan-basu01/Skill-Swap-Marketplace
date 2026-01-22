import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/empty_state.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/error_widget.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/shimmer_loading.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/notifications/domain/models/notification_model.dart';
import 'package:skill_swap_marketplace/features/notifications/presentation/providers/notification_provider.dart';

/// Screen displaying user's in-app notifications
class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);
    final actionsState = ref.watch(notificationActionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.textPrimary,
            ),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                ref.read(notificationActionsProvider.notifier).markAllAsRead();
              } else if (value == 'delete_all') {
                _showDeleteAllConfirmation(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20, color: AppColors.textSecondary),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    SizedBox(width: 12),
                    Text('Delete all', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(userNotificationsProvider);
                },
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppColors.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(notificationActionsProvider.notifier)
                            .deleteNotification(notification.id);
                      },
                      child: _NotificationItem(
                        notification: notification,
                        onTap: () => _handleNotificationTap(context, ref, notification),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => _buildLoading(),
            error: (_, __) => _buildError(ref),
          ),
          // Loading overlay
          if (actionsState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateNoNotifications();
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const _ShimmerNotificationItem();
      },
    );
  }

  Widget _buildError(WidgetRef ref) {
    return LoadFailureWidget(
      itemType: 'notifications',
      onRetry: () => ref.invalidate(userNotificationsProvider),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) {
    // Mark as read
    if (!notification.isRead) {
      ref.read(notificationActionsProvider.notifier).markAsRead(notification.id);
    }

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.swapRequest:
      case NotificationType.swapAccepted:
      case NotificationType.swapDeclined:
      case NotificationType.swapCancelled:
      case NotificationType.sessionScheduled:
      case NotificationType.sessionReminder:
      case NotificationType.sessionStarted:
      case NotificationType.sessionCompleted:
        // Navigate to matches screen where they can see swap status
        const MatchesRoute().push(context);
        break;

      case NotificationType.newMessage:
        // Navigate to chat if chatId is available
        if (notification.chatId != null) {
          ChatDetailRoute(chatId: notification.chatId!).push(context);
        } else {
          const ChatListRoute().push(context);
        }
        break;

      case NotificationType.newRating:
      case NotificationType.creditsReceived:
        // Navigate to wallet/profile
        const WalletRoute().push(context);
        break;

      case NotificationType.system:
        // System notifications may not navigate anywhere
        break;
    }
  }

  void _showDeleteAllConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(notificationActionsProvider.notifier).deleteAllNotifications();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}

/// Individual notification item
class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.screenPaddingH,
          vertical: Dimensions.md,
        ),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.surface : AppColors.primarySurface,
          border: const Border(
            bottom: BorderSide(color: AppColors.gray100),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon or Avatar
            _buildLeadingWidget(),
            const SizedBox(width: Dimensions.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Body
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Timestamp
                  Text(
                    _formatTime(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingWidget() {
    // Show user avatar if available, otherwise show type icon
    if (notification.fromUserPhoto != null || notification.fromUserName != null) {
      return Stack(
        children: [
          UserAvatar(
            imageUrl: notification.fromUserPhoto,
            name: notification.fromUserName ?? 'User',
            size: AvatarSize.md,
          ),
          // Type icon badge
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getTypeColor(),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                notification.type.icon,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      );
    }

    // Just show the type icon
    final typeColor = _getTypeColor();
    return Container(
      width: Dimensions.avatarMd,
      height: Dimensions.avatarMd,
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          notification.type.icon,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    return switch (notification.type) {
      NotificationType.swapRequest => AppColors.primaryBlue,
      NotificationType.swapAccepted => AppColors.success,
      NotificationType.swapDeclined => AppColors.error,
      NotificationType.swapCancelled => AppColors.error,
      NotificationType.sessionScheduled => AppColors.primaryBlue,
      NotificationType.sessionReminder => AppColors.warning,
      NotificationType.sessionStarted => AppColors.success,
      NotificationType.sessionCompleted => AppColors.success,
      NotificationType.newMessage => AppColors.primaryBlue,
      NotificationType.newRating => AppColors.warning,
      NotificationType.creditsReceived => AppColors.success,
      NotificationType.system => AppColors.gray400,
    };
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      final month = _monthName(dateTime.month);
      return '$month ${dateTime.day}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

/// Shimmer loading placeholder for notification item
class _ShimmerNotificationItem extends StatelessWidget {
  const _ShimmerNotificationItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
        vertical: Dimensions.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.gray100),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerCircle(size: Dimensions.avatarMd),
          const SizedBox(width: Dimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 16,
                ),
                const SizedBox(height: 8),
                const ShimmerBox(height: 14),
                const SizedBox(height: 8),
                const ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}