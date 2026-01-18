import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/category/presentation/providers/category_users_provider.dart';

/// Bottom sheet for selecting sort option in category screen
class CategorySortSheet extends StatelessWidget {
  final CategorySortOption currentOption;
  final ValueChanged<CategorySortOption> onSelect;

  const CategorySortSheet({
    super.key,
    required this.currentOption,
    required this.onSelect,
  });

  /// Show the sort sheet as a modal bottom sheet
  static Future<void> show({
    required BuildContext context,
    required CategorySortOption currentOption,
    required ValueChanged<CategorySortOption> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySortSheet(
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
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
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

          // Sort options
          ...CategorySortOption.values.map((option) => _SortOptionTile(
                option: option,
                isSelected: option == currentOption,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              )),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final CategorySortOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        _getIcon(option),
        color: isSelected ? AppColors.primaryBlue : AppColors.gray500,
      ),
      title: Text(
        option.label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_rounded,
              color: AppColors.primaryBlue,
            )
          : null,
    );
  }

  IconData _getIcon(CategorySortOption option) {
    switch (option) {
      case CategorySortOption.bestMatch:
        return Icons.auto_awesome_rounded;
      case CategorySortOption.highestRated:
        return Icons.star_rounded;
      case CategorySortOption.mostExperienced:
        return Icons.workspace_premium_rounded;
      case CategorySortOption.recentlyActive:
        return Icons.schedule_rounded;
    }
  }
}