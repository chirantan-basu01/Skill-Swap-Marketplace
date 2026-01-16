import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/skill_chip.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';

/// Compact user card for horizontal scroll (Perfect Matches section)
class UserCardCompact extends StatelessWidget {
  final UserModel user;
  final bool isPerfectMatch;
  final VoidCallback? onTap;

  const UserCardCompact({
    super.key,
    required this.user,
    this.isPerfectMatch = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(Dimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.gray200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            UserAvatar(
              imageUrl: user.photoUrl,
              name: user.displayName,
              size: AvatarSize.md,
            ),
            const SizedBox(height: 8),

            // Perfect match badge
            if (isPerfectMatch)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, Color(0xFF7C3AED)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Perfect',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Name
            Text(
              user.displayName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 2),
                Text(
                  user.rating.average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (user.rating.count > 0) ...[
                  const SizedBox(width: 2),
                  Text(
                    '(${user.rating.count})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Skills preview
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user.skillsOffered.isNotEmpty)
                  Flexible(
                    child: _MiniSkillChip(
                      label: user.skillsOffered.first.skillName,
                      variant: SkillChipVariant.teach,
                    ),
                  ),
                if (user.skillsOffered.isNotEmpty &&
                    user.skillsWanted.isNotEmpty)
                  const SizedBox(width: 4),
                if (user.skillsWanted.isNotEmpty)
                  Flexible(
                    child: _MiniSkillChip(
                      label: user.skillsWanted.first.skillName,
                      variant: SkillChipVariant.want,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full width user card for vertical lists (Recommended section)
class UserCardFull extends StatelessWidget {
  final UserModel user;
  final int? matchPercentage;
  final bool isOnline;
  final List<String>? matchingSkills;
  final VoidCallback? onTap;

  const UserCardFull({
    super.key,
    required this.user,
    this.matchPercentage,
    this.isOnline = false,
    this.matchingSkills,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: AppColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            UserAvatar(
              imageUrl: user.photoUrl,
              name: user.displayName,
              size: AvatarSize.sm,
              showOnlineIndicator: true,
              isOnline: isOnline,
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.displayName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildRating(),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Teaches
                  if (user.skillsOffered.isNotEmpty)
                    _buildSkillLine(
                      label: 'Teaches:',
                      skills:
                          user.skillsOffered.map((s) => s.skillName).toList(),
                    ),

                  const SizedBox(height: 2),

                  // Wants
                  if (user.skillsWanted.isNotEmpty)
                    _buildSkillLine(
                      label: 'Wants:',
                      skills:
                          user.skillsWanted.map((s) => s.skillName).toList(),
                    ),

                  const SizedBox(height: 12),

                  // Bottom row with chips and match percentage
                  Row(
                    children: [
                      // Skill chips
                      Expanded(
                        child: _buildSkillChips(),
                      ),

                      // Match percentage
                      if (matchPercentage != null) ...[
                        const SizedBox(width: 8),
                        _buildMatchBadge(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star_rounded,
          size: 14,
          color: AppColors.warning,
        ),
        const SizedBox(width: 2),
        Text(
          user.rating.average.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        if (user.rating.count > 0) ...[
          Text(
            ' (${user.rating.count})',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkillLine({required String label, required List<String> skills}) {
    final displaySkills = skills.take(2).join(', ');
    final remaining = skills.length - 2;

    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            remaining > 0 ? '$displaySkills +$remaining' : displaySkills,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChips() {
    final skills = matchingSkills ?? user.skillsOffered.map((s) => s.skillName).toList();
    final displaySkills = skills.take(3).toList();
    final remaining = skills.length - 3;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displaySkills.map(
          (skill) => SkillChip(
            label: skill,
            variant: matchingSkills != null
                ? SkillChipVariant.highlighted
                : SkillChipVariant.teach,
          ),
        ),
        if (remaining > 0)
          MoreChip(count: remaining),
      ],
    );
  }

  Widget _buildMatchBadge() {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$matchPercentage%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Match',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Mini skill chip for compact user cards
class _MiniSkillChip extends StatelessWidget {
  final String label;
  final SkillChipVariant variant;

  const _MiniSkillChip({
    required this.label,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final isTeach = variant == SkillChipVariant.teach;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isTeach ? AppColors.primarySurface : AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isTeach ? AppColors.primaryBlue : AppColors.secondaryTeal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}