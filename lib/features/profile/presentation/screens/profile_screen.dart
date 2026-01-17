import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';

/// Profile screen with logout for testing
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final authState = ref.watch(authNotifierProvider);

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

                // User Email
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
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
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.gray200,
                      ),
                      _StatItem(
                        label: 'Rating',
                        value: user.rating.average.toStringAsFixed(1),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.gray200,
                      ),
                      _StatItem(
                        label: 'Credits',
                        value: '10.0', // TODO: Get from wallet
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.lg),

                // Skills Offered
                _SectionCard(
                  title: 'Skills I Teach',
                  icon: Icons.school_outlined,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.skillsOffered.map((skill) {
                      return Chip(
                        label: Text(skill.skillName),
                        backgroundColor: AppColors.primarySurface,
                        labelStyle: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: Dimensions.md),

                // Skills Wanted
                _SectionCard(
                  title: 'Skills I Want to Learn',
                  icon: Icons.lightbulb_outline,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.skillsWanted.map((skill) {
                      return Chip(
                        label: Text(skill.skillName),
                        backgroundColor: AppColors.secondarySurface,
                        labelStyle: const TextStyle(
                          color: AppColors.secondaryTeal,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: Dimensions.xl),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : () => _handleLogout(context, ref),
                    icon: authState.status == AuthStatus.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout_rounded),
                    label: Text(authState.status == AuthStatus.loading ? 'Signing out...' : 'Sign Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: Dimensions.md),

                // Dev info
                Text(
                  'User ID: ${user.uid}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
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
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (context.mounted) {
        const LoginRoute().go(context);
      }
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
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
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
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
          child,
        ],
      ),
    );
  }
}