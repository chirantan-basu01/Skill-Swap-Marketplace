import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

class SkillChipData {
  final String id;
  final String name;
  final String? level;

  const SkillChipData({
    required this.id,
    required this.name,
    this.level,
  });
}

class SkillChipList extends StatelessWidget {
  final List<SkillChipData> skills;
  final void Function(String skillId)? onRemove;

  const SkillChipList({
    super.key,
    required this.skills,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.sm,
      runSpacing: Dimensions.sm,
      children: skills.map((skill) => _SkillChip(
        skill: skill,
        onRemove: onRemove != null ? () => onRemove!(skill.id) : null,
      )).toList(),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final SkillChipData skill;
  final VoidCallback? onRemove;

  const _SkillChip({
    required this.skill,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onRemove,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Skill icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 10),

                // Skill name and level
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (skill.level != null) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelColor(skill.level!).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatLevel(skill.level!),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getLevelColor(skill.level!),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Remove button
                if (onRemove != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF10B981); // Green
      case 'intermediate':
        return const Color(0xFFF59E0B); // Amber
      case 'expert':
        return const Color(0xFFEF4444); // Red
      default:
        return AppColors.gray400;
    }
  }

  String _formatLevel(String level) {
    return level[0].toUpperCase() + level.substring(1);
  }
}