import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Badge indicating a perfect match (bidirectional skill exchange)
///
/// A perfect match means:
/// - They teach something you want to learn
/// - They want to learn something you can teach
class PerfectMatchBadge extends StatelessWidget {
  final PerfectMatchBadgeSize size;
  final bool showIcon;

  const PerfectMatchBadge({
    super.key,
    this.size = PerfectMatchBadgeSize.medium,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(size);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: config.horizontalPadding,
        vertical: config.verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF7C3AED)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.bolt_rounded,
              size: config.iconSize,
              color: Colors.white,
            ),
            SizedBox(width: config.gap),
          ],
          Text(
            'Perfect',
            style: TextStyle(
              fontSize: config.fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig(PerfectMatchBadgeSize size) {
    switch (size) {
      case PerfectMatchBadgeSize.small:
        return const _BadgeConfig(
          horizontalPadding: 6,
          verticalPadding: 3,
          iconSize: 10,
          fontSize: 9,
          gap: 2,
        );
      case PerfectMatchBadgeSize.medium:
        return const _BadgeConfig(
          horizontalPadding: 8,
          verticalPadding: 4,
          iconSize: 12,
          fontSize: 10,
          gap: 2,
        );
      case PerfectMatchBadgeSize.large:
        return const _BadgeConfig(
          horizontalPadding: 12,
          verticalPadding: 6,
          iconSize: 16,
          fontSize: 12,
          gap: 4,
        );
    }
  }
}

enum PerfectMatchBadgeSize { small, medium, large }

class _BadgeConfig {
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double fontSize;
  final double gap;

  const _BadgeConfig({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.fontSize,
    required this.gap,
  });
}

/// Match percentage badge showing compatibility score
class MatchPercentageBadge extends StatelessWidget {
  final int percentage;
  final MatchPercentageBadgeSize size;

  const MatchPercentageBadge({
    super.key,
    required this.percentage,
    this.size = MatchPercentageBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(size);
    final color = _getColorForPercentage(percentage);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: config.circleSize,
          height: config.circleSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: config.percentFontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: config.labelGap),
        Text(
          'Match',
          style: TextStyle(
            fontSize: config.labelFontSize,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Color _getColorForPercentage(int percentage) {
    if (percentage >= 80) {
      return AppColors.success; // High match - green
    } else if (percentage >= 60) {
      return AppColors.primaryBlue; // Good match - blue
    } else if (percentage >= 40) {
      return AppColors.warning; // Moderate match - amber
    } else {
      return AppColors.gray400; // Low match - gray
    }
  }

  _PercentageConfig _getConfig(MatchPercentageBadgeSize size) {
    switch (size) {
      case MatchPercentageBadgeSize.small:
        return const _PercentageConfig(
          circleSize: 36,
          percentFontSize: 10,
          labelFontSize: 9,
          labelGap: 2,
        );
      case MatchPercentageBadgeSize.medium:
        return const _PercentageConfig(
          circleSize: 44,
          percentFontSize: 12,
          labelFontSize: 10,
          labelGap: 2,
        );
      case MatchPercentageBadgeSize.large:
        return const _PercentageConfig(
          circleSize: 56,
          percentFontSize: 14,
          labelFontSize: 11,
          labelGap: 4,
        );
    }
  }
}

enum MatchPercentageBadgeSize { small, medium, large }

class _PercentageConfig {
  final double circleSize;
  final double percentFontSize;
  final double labelFontSize;
  final double labelGap;

  const _PercentageConfig({
    required this.circleSize,
    required this.percentFontSize,
    required this.labelFontSize,
    required this.labelGap,
  });
}