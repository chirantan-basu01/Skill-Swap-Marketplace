import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Available rating tags
const List<String> ratingTags = [
  'Great Teacher',
  'Patient',
  'Knowledgeable',
  'Good Communicator',
  'Punctual',
  'Well Prepared',
];

/// Selectable rating tags widget
class RatingTags extends StatelessWidget {
  final Set<String> selectedTags;
  final ValueChanged<Set<String>>? onTagsChanged;
  final bool readOnly;

  const RatingTags({
    super.key,
    required this.selectedTags,
    this.onTagsChanged,
    this.readOnly = false,
  });

  void _toggleTag(String tag) {
    if (readOnly) return;

    final newTags = Set<String>.from(selectedTags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    onTagsChanged?.call(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.sm,
      runSpacing: Dimensions.sm,
      children: ratingTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return _RatingTagChip(
          label: tag,
          isSelected: isSelected,
          onTap: () => _toggleTag(tag),
        );
      }).toList(),
    );
  }
}

class _RatingTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _RatingTagChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.gray100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check,
                size: 16,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryBlue : AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Display-only rating tags for showing user's tags
class RatingTagsDisplay extends StatelessWidget {
  final List<String> tags;
  final double fontSize;

  const RatingTagsDisplay({
    super.key,
    required this.tags,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        );
      }).toList(),
    );
  }
}