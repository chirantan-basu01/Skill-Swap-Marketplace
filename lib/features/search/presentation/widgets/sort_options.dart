import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/search/presentation/providers/search_provider.dart';

/// Sort options bottom sheet
class SortOptionsSheet extends StatelessWidget {
  final SearchSortOption currentOption;
  final ValueChanged<SearchSortOption> onSelect;

  const SortOptionsSheet({
    super.key,
    required this.currentOption,
    required this.onSelect,
  });

  /// Show the sort options sheet
  static Future<void> show({
    required BuildContext context,
    required SearchSortOption currentOption,
    required ValueChanged<SearchSortOption> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsSheet(
        currentOption: currentOption,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.all(Dimensions.md),
            child: Text(
              'Sort By',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const Divider(height: 1),

          // Options
          ...SearchSortOption.values.map((option) {
            final isSelected = option == currentOption;
            return ListTile(
              leading: Icon(
                _getOptionIcon(option),
                color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              ),
              title: Text(
                option.label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_rounded, color: AppColors.primaryBlue)
                  : null,
              onTap: () {
                onSelect(option);
                Navigator.of(context).pop();
              },
            );
          }),

          SizedBox(height: MediaQuery.of(context).padding.bottom + Dimensions.md),
        ],
      ),
    );
  }

  IconData _getOptionIcon(SearchSortOption option) {
    switch (option) {
      case SearchSortOption.relevance:
        return Icons.auto_awesome_rounded;
      case SearchSortOption.matchScore:
        return Icons.favorite_rounded;
      case SearchSortOption.rating:
        return Icons.star_rounded;
      case SearchSortOption.recentlyActive:
        return Icons.access_time_rounded;
      case SearchSortOption.mostSwaps:
        return Icons.swap_horiz_rounded;
    }
  }
}

/// Compact sort button for inline use
class SortButton extends StatelessWidget {
  final SearchSortOption currentOption;
  final VoidCallback onTap;

  const SortButton({
    super.key,
    required this.currentOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sort_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              currentOption.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}