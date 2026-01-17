import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/widgets/swap_status_badge.dart';

/// A card widget that displays swap information
class SwapCard extends StatelessWidget {
  final SwapModel swap;
  final String currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onSchedule;
  final VoidCallback? onChat;
  final VoidCallback? onComplete;
  final VoidCallback? onRate;
  final bool showNewBadge;

  const SwapCard({
    super.key,
    required this.swap,
    required this.currentUserId,
    this.onTap,
    this.onAccept,
    this.onDecline,
    this.onSchedule,
    this.onChat,
    this.onComplete,
    this.onRate,
    this.showNewBadge = true,
  });

  bool get isRequester => swap.requesterId == currentUserId;
  bool get isProvider => swap.providerId == currentUserId;

  /// Check if this is a new incoming request (within 24 hours)
  bool get isNewIncoming {
    if (!isProvider || swap.status != SwapStatus.pending) return false;
    final hoursSinceCreated = DateTime.now().difference(swap.createdAt).inHours;
    return hoursSinceCreated < 24 && showNewBadge;
  }

  /// Get border color based on swap status and type
  Color get borderColor {
    if (swap.status == SwapStatus.pending && isProvider) {
      return AppColors.primaryBlue; // Incoming request - highlight
    } else if (swap.status == SwapStatus.accepted ||
        swap.status == SwapStatus.scheduled ||
        swap.status == SwapStatus.inProgress) {
      return AppColors.success; // Active swap - green
    } else if (swap.status == SwapStatus.completed) {
      return AppColors.gray200; // Completed - subtle
    }
    return AppColors.gray200; // Default/outgoing
  }

  String get otherUserName => isRequester ? swap.providerName : swap.requesterName;
  String? get otherUserPhoto => isRequester ? swap.providerPhoto : swap.requesterPhoto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.md),
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray900.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info, status, and NEW badge
            _buildHeader(),

            const SizedBox(height: Dimensions.md),

            // Skills exchange
            _buildSkillsExchange(),

            // Duration and credits
            const SizedBox(height: Dimensions.sm),
            _buildDetails(),

            // Message if present
            if (swap.message.isNotEmpty) ...[
              const SizedBox(height: Dimensions.sm),
              _buildMessage(),
            ],

            // Session info if scheduled
            if (swap.session != null &&
                (swap.status == SwapStatus.scheduled ||
                    swap.status == SwapStatus.inProgress)) ...[
              const SizedBox(height: Dimensions.sm),
              _buildSessionInfo(),
            ],

            // Action buttons based on status
            if (_shouldShowActions()) ...[
              const SizedBox(height: Dimensions.md),
              _buildActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        UserAvatar(
          imageUrl: otherUserPhoto,
          name: otherUserName,
          size: AvatarSize.sm,
        ),
        const SizedBox(width: Dimensions.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      otherUserName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isNewIncoming) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _getHeaderSubtitle(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SwapStatusBadge(status: swap.status),
      ],
    );
  }

  String _getHeaderSubtitle() {
    if (swap.status == SwapStatus.pending) {
      return isRequester ? 'Waiting for response' : '${swap.requesterName} wants to swap';
    } else if (swap.status == SwapStatus.accepted ||
        swap.status == SwapStatus.scheduled ||
        swap.status == SwapStatus.inProgress) {
      return 'Swap with $otherUserName';
    } else if (swap.status == SwapStatus.completed) {
      return 'Completed swap';
    }
    return isRequester ? 'You requested' : 'Requested to swap';
  }

  Widget _buildSkillsExchange() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(Dimensions.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SkillColumn(
              label: isRequester ? 'You offer' : 'They offer',
              skillName: swap.requesterOffers.skillName,
              categoryName: swap.requesterOffers.categoryName,
              isHighlighted: !isRequester,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.sm),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          Expanded(
            child: _SkillColumn(
              label: isRequester ? 'You want' : 'They want',
              skillName: swap.requesterWants.skillName,
              categoryName: swap.requesterWants.categoryName,
              isHighlighted: isRequester,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Row(
      children: [
        _DetailChip(
          icon: Icons.schedule_rounded,
          label: '${swap.duration}h',
        ),
        const SizedBox(width: Dimensions.sm),
        _DetailChip(
          icon: Icons.monetization_on_outlined,
          label: '${swap.creditAmount.toStringAsFixed(1)} credits',
        ),
        const Spacer(),
        Text(
          _getTimeAgo(swap.createdAt),
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(Dimensions.radiusSm),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 16,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: Dimensions.xs),
          Expanded(
            child: Text(
              swap.message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    final session = swap.session!;
    return Container(
      padding: const EdgeInsets.all(Dimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_rounded,
            size: 18,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: Dimensions.xs),
          Text(
            _formatDate(session.scheduledDate),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: Dimensions.sm),
          const Icon(
            Icons.access_time_rounded,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: Dimensions.xs),
          Text(
            session.scheduledTime,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowActions() {
    if (swap.status == SwapStatus.pending && isProvider) return true;
    if (swap.status == SwapStatus.accepted) return true;
    if (swap.status == SwapStatus.scheduled) return true;
    if (swap.status == SwapStatus.inProgress) return true;
    if (swap.status == SwapStatus.completed) return true;
    return false;
  }

  Widget _buildActions() {
    if (swap.status == SwapStatus.pending && isProvider) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDecline,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: Dimensions.sm),
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Accept'),
            ),
          ),
        ],
      );
    }

    if (swap.status == SwapStatus.accepted) {
      return Row(
        children: [
          if (onChat != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onChat,
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          if (onChat != null) const SizedBox(width: Dimensions.sm),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onSchedule,
              icon: const Icon(Icons.event_rounded, size: 18),
              label: const Text('Schedule'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      );
    }

    // Scheduled or In Progress - show Complete button
    if (swap.status == SwapStatus.scheduled ||
        swap.status == SwapStatus.inProgress) {
      return Row(
        children: [
          if (onChat != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onChat,
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          if (onChat != null) const SizedBox(width: Dimensions.sm),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onComplete,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      );
    }

    // Completed - show Rate button (if not yet rated by current user)
    if (swap.status == SwapStatus.completed) {
      // Check if current user has already rated
      final hasRated = swap.ratings.containsKey(currentUserId);

      if (hasRated) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(Dimensions.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 18,
                color: AppColors.success,
              ),
              const SizedBox(width: Dimensions.xs),
              const Text(
                'You rated this swap',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onRate,
          icon: const Icon(Icons.star_outline, size: 18),
          label: const Text('Rate Session'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

/// Column widget for skill display
class _SkillColumn extends StatelessWidget {
  final String label;
  final String skillName;
  final String categoryName;
  final bool isHighlighted;

  const _SkillColumn({
    required this.label,
    required this.skillName,
    required this.categoryName,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          skillName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? AppColors.primaryBlue : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          categoryName,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Chip widget for detail items
class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}