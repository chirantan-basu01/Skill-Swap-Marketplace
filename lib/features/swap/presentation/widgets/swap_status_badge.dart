import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';

/// A badge widget that displays the swap status with appropriate styling
class SwapStatusBadge extends StatelessWidget {
  final SwapStatus status;
  final bool isCompact;

  const SwapStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.icon != null && !isCompact) ...[
            Icon(
              config.icon,
              size: 14,
              color: config.textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            config.label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return _StatusConfig(
          label: 'Pending',
          icon: Icons.schedule_rounded,
          backgroundColor: AppColors.warningSurface,
          textColor: AppColors.warning,
        );
      case SwapStatus.accepted:
        return _StatusConfig(
          label: 'Accepted',
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: AppColors.successSurface,
          textColor: AppColors.success,
        );
      case SwapStatus.declined:
        return _StatusConfig(
          label: 'Declined',
          icon: Icons.cancel_outlined,
          backgroundColor: AppColors.errorSurface,
          textColor: AppColors.error,
        );
      case SwapStatus.scheduled:
        return _StatusConfig(
          label: 'Scheduled',
          icon: Icons.event_rounded,
          backgroundColor: AppColors.infoSurface,
          textColor: AppColors.info,
        );
      case SwapStatus.inProgress:
        return _StatusConfig(
          label: 'In Progress',
          icon: Icons.play_circle_outline_rounded,
          backgroundColor: AppColors.primarySurface,
          textColor: AppColors.primaryBlue,
        );
      case SwapStatus.completed:
        return _StatusConfig(
          label: 'Completed',
          icon: Icons.check_circle_rounded,
          backgroundColor: AppColors.successSurface,
          textColor: AppColors.success,
        );
      case SwapStatus.cancelled:
        return _StatusConfig(
          label: 'Cancelled',
          icon: Icons.block_rounded,
          backgroundColor: AppColors.gray100,
          textColor: AppColors.gray500,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;

  _StatusConfig({
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
}

/// Extension to get display-friendly status text
extension SwapStatusExtension on SwapStatus {
  String get displayName {
    switch (this) {
      case SwapStatus.pending:
        return 'Pending';
      case SwapStatus.accepted:
        return 'Accepted';
      case SwapStatus.declined:
        return 'Declined';
      case SwapStatus.scheduled:
        return 'Scheduled';
      case SwapStatus.inProgress:
        return 'In Progress';
      case SwapStatus.completed:
        return 'Completed';
      case SwapStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get actionText {
    switch (this) {
      case SwapStatus.pending:
        return 'Awaiting response';
      case SwapStatus.accepted:
        return 'Schedule a session';
      case SwapStatus.declined:
        return 'Request declined';
      case SwapStatus.scheduled:
        return 'Session scheduled';
      case SwapStatus.inProgress:
        return 'Session in progress';
      case SwapStatus.completed:
        return 'Rate your experience';
      case SwapStatus.cancelled:
        return 'Swap cancelled';
    }
  }
}