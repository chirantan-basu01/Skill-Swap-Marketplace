import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/add_skill_dialog.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/setup_progress_indicator.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/skill_chip_list.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

class SetupSkillsWantedScreen extends ConsumerWidget {
  const SetupSkillsWantedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(profileSetupNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final isLoading = setupState.status == ProfileSetupStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Skills to Learn'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              const SetupProgressIndicator(currentStep: 2, totalSteps: 4),
              const SizedBox(height: Dimensions.xl),

              // Title section
              const Text(
                'What do you want to learn?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: Dimensions.xs),
              Text(
                'Discover skills from the community',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: Dimensions.lg),

              // Skills content area
              Expanded(
                child: setupState.skillsWanted.isEmpty
                    ? _buildEmptyState(context, ref, categoriesAsync)
                    : _buildSkillsList(context, ref, setupState, categoriesAsync),
              ),

              // Navigation buttons
              const SizedBox(height: Dimensions.md),
              Row(
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => const SetupSkillsOfferedRoute().go(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: Dimensions.md),
                  // Next button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading || setupState.skillsWanted.isEmpty
                          ? null
                          : () => const SetupAvailabilityRoute().go(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textOnPrimary,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> categoriesAsync,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7), // Warm amber background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              size: 56,
              color: Color(0xFFF59E0B), // Amber
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          const Text(
            'What would you like to learn?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.xs),
          Text(
            'Add skills you want to explore\nand grow in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: Dimensions.xl),

          // Add skill button
          categoriesAsync.when(
            data: (categories) => _buildAddSkillButton(
              context,
              ref,
              categories,
              isPrimary: true,
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text(
              'Failed to load categories',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsList(
    BuildContext context,
    WidgetRef ref,
    ProfileSetupState setupState,
    AsyncValue<List<dynamic>> categoriesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skills count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                '${setupState.skillsWanted.length} skill${setupState.skillsWanted.length > 1 ? 's' : ''} added',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.md),

        // Skills list
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkillChipList(
                  skills: setupState.skillsWanted
                      .map((s) => SkillChipData(
                            id: s.id,
                            name: s.skillName,
                            level: s.desiredLevel.name,
                          ))
                      .toList(),
                  onRemove: (skillId) {
                    ref
                        .read(profileSetupNotifierProvider.notifier)
                        .removeSkillWanted(skillId);
                  },
                ),
                const SizedBox(height: Dimensions.lg),

                // Add more skills button
                categoriesAsync.when(
                  data: (categories) => _buildAddSkillButton(
                    context,
                    ref,
                    categories,
                    isPrimary: false,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddSkillButton(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> categories, {
    required bool isPrimary,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: () => _showAddSkillDialog(context, ref, categories),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Skill'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _showAddSkillDialog(context, ref, categories),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryBlue.withValues(alpha: 0.04),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add another skill',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSkillDialog(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> categories,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radiusXl),
        ),
      ),
      builder: (context) => AddSkillWantedDialog(
        categories: categories,
        onAdd: (skill) {
          ref.read(profileSetupNotifierProvider.notifier).addSkillWanted(skill);
          Navigator.pop(context);
        },
      ),
    );
  }
}