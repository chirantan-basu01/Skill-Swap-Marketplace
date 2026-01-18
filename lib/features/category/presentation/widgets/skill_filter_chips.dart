import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Horizontal scrollable skill filter chips for category screen
class SkillFilterChips extends StatelessWidget {
  final List<String> skills;
  final String? selectedSkill;
  final ValueChanged<String?> onSkillSelected;
  final bool isLoading;

  const SkillFilterChips({
    super.key,
    required this.skills,
    required this.selectedSkill,
    required this.onSkillSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.screenPaddingH,
          ),
          child: Text(
            'Filter by Skill',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.screenPaddingH,
            ),
            itemCount: skills.length + 1, // +1 for "All" chip
            itemBuilder: (context, index) {
              if (index == 0) {
                return _SkillChip(
                  label: 'All',
                  isSelected: selectedSkill == null,
                  onTap: () => onSkillSelected(null),
                );
              }

              final skill = skills[index - 1];
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _SkillChip(
                  label: skill,
                  isSelected: selectedSkill == skill,
                  onTap: () => onSkillSelected(skill),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.screenPaddingH,
          ),
          child: Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.screenPaddingH,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SkillChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.gray100,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}