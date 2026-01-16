import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Skill chip variant
enum SkillChipVariant {
  /// Primary style - for skills user teaches
  teach,

  /// Secondary style - for skills user wants to learn
  want,

  /// Highlighted style - for matching skills
  highlighted,

  /// Muted style - for non-matching skills
  muted,
}

/// Reusable skill chip widget for displaying skill tags
class SkillChip extends StatelessWidget {
  final String label;
  final SkillChipVariant variant;
  final String? emoji;
  final bool showRemove;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.label,
    this.variant = SkillChipVariant.teach,
    this.emoji,
    this.showRemove = false,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
          border: colors.borderColor != null
              ? Border.all(color: colors.borderColor!, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(
                emoji!,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showRemove) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: colors.textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ChipColors _getColors() {
    switch (variant) {
      case SkillChipVariant.teach:
        return _ChipColors(
          background: AppColors.primarySurface,
          textColor: AppColors.primaryBlue,
          borderColor: null,
        );
      case SkillChipVariant.want:
        return _ChipColors(
          background: AppColors.secondarySurface,
          textColor: AppColors.secondaryTeal,
          borderColor: null,
        );
      case SkillChipVariant.highlighted:
        return _ChipColors(
          background: AppColors.primaryBlue.withValues(alpha: 0.1),
          textColor: AppColors.primaryBlue,
          borderColor: AppColors.primaryBlue,
        );
      case SkillChipVariant.muted:
        return _ChipColors(
          background: AppColors.gray100,
          textColor: AppColors.gray600,
          borderColor: null,
        );
    }
  }
}

class _ChipColors {
  final Color background;
  final Color textColor;
  final Color? borderColor;

  _ChipColors({
    required this.background,
    required this.textColor,
    this.borderColor,
  });
}

/// A +N chip to show additional count
class MoreChip extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const MoreChip({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        child: Text(
          '+$count',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.gray600,
          ),
        ),
      ),
    );
  }
}