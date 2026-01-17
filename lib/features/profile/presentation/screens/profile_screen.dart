import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/providers/wallet_provider.dart';

/// Profile screen showing user's own profile
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final balanceAsync = ref.watch(creditBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => const SettingsRoute().push(context),
          tooltip: 'Settings',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => const EditProfileRoute().push(context),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.screenPaddingH),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.lg),

                // User Avatar
                UserAvatar(
                  imageUrl: user.photoUrl,
                  name: user.displayName,
                  size: AvatarSize.xl,
                ),

                const SizedBox(height: Dimensions.md),

                // User Name
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: Dimensions.xs),

                // User Bio
                if (user.bio.isNotEmpty) ...[
                  Text(
                    user.bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Dimensions.sm),
                ],

                // User Email
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.lg),

                // Stats Row
                Container(
                  padding: const EdgeInsets.all(Dimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Swaps',
                        value: user.swapsCompleted.toString(),
                        icon: Icons.swap_horiz,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.gray200,
                      ),
                      _StatItem(
                        label: 'Rating',
                        value: user.rating.count > 0
                            ? user.rating.average.toStringAsFixed(1)
                            : '-',
                        icon: Icons.star,
                        iconColor: AppColors.warning,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.gray200,
                      ),
                      _StatItem(
                        label: 'Credits',
                        value: balanceAsync.when(
                          data: (balance) => balance.toStringAsFixed(1),
                          loading: () => '...',
                          error: (_, __) => '-',
                        ),
                        icon: Icons.monetization_on,
                        iconColor: AppColors.success,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.lg),

                // Hours Exchanged
                if (user.hoursExchanged > 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue.withOpacity(0.1),
                          AppColors.secondaryTeal.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${user.hoursExchanged.toStringAsFixed(1)} hours of skills exchanged',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: Dimensions.lg),

                // Skills Offered
                _SectionCard(
                  title: 'Skills I Teach',
                  icon: Icons.school_outlined,
                  emptyMessage: 'No teaching skills added yet',
                  child: user.skillsOffered.isNotEmpty
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.skillsOffered.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    skill.skillName,
                                    style: const TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      skill.level.name,
                                      style: const TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : null,
                ),

                const SizedBox(height: Dimensions.md),

                // Skills Wanted
                _SectionCard(
                  title: 'Skills I Want to Learn',
                  icon: Icons.lightbulb_outline,
                  emptyMessage: 'No learning goals added yet',
                  child: user.skillsWanted.isNotEmpty
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.skillsWanted.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondarySurface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                skill.skillName,
                                style: const TextStyle(
                                  color: AppColors.secondaryTeal,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : null,
                ),

                const SizedBox(height: Dimensions.md),

                // Availability
                _SectionCard(
                  title: 'Availability',
                  icon: Icons.access_time_outlined,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAvailabilityIcon(user.availability.name),
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatAvailability(user.availability.name),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user.timezone.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.public,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user.timezone,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.xl),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => const EditProfileRoute().push(context),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: Dimensions.xl),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.gray300,
              ),
              const SizedBox(height: Dimensions.md),
              Text(
                'Error loading profile',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAvailabilityIcon(String availability) {
    switch (availability) {
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'afternoon':
        return Icons.wb_cloudy_outlined;
      case 'evening':
        return Icons.nights_stay_outlined;
      case 'flexible':
      default:
        return Icons.schedule;
    }
  }

  String _formatAvailability(String availability) {
    switch (availability) {
      case 'morning':
        return 'Mornings';
      case 'afternoon':
        return 'Afternoons';
      case 'evening':
        return 'Evenings';
      case 'flexible':
      default:
        return 'Flexible';
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _StatItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: iconColor ?? AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? child;
  final String? emptyMessage;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.child,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.sm),
          child ??
              Text(
                emptyMessage ?? 'None',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
        ],
      ),
    );
  }
}
