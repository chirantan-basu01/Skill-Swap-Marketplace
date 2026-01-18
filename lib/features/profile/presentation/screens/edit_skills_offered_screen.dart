import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/services/toast_service.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/providers/edit_skills_provider.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/add_skill_dialog.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/skill_chip_list.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

/// Screen for editing skills the user can teach
class EditSkillsOfferedScreen extends ConsumerWidget {
  const EditSkillsOfferedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final editState = ref.watch(editSkillsOfferedNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    // Initialize skills from user data when available
    userAsync.whenData((user) {
      if (user != null && !editState.isInitialized) {
        // Use Future.microtask to avoid modifying state during build
        Future.microtask(() {
          ref
              .read(editSkillsOfferedNotifierProvider.notifier)
              .initialize(user.skillsOffered);
        });
      }
    });

    return PopScope(
      canPop: !editState.hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog(context);
        if (shouldPop && context.mounted) {
          ref.read(editSkillsOfferedNotifierProvider.notifier).reset();
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Edit Skills You Teach',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _handleClose(context, ref, editState.hasChanges),
          ),
          actions: [
            TextButton(
              onPressed: editState.canSave
                  ? () => _saveChanges(context, ref)
                  : null,
              child: editState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryBlue,
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: editState.canSave
                            ? AppColors.primaryBlue
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title section
                const Text(
                  'What can you teach?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: Dimensions.xs),
                Text(
                  'Share your expertise with others. You need at least one skill.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: Dimensions.lg),

                // Skills content area
                Expanded(
                  child: editState.skills.isEmpty
                      ? _buildEmptyState(context, ref, categoriesAsync)
                      : _buildSkillsList(context, ref, editState, categoriesAsync),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleClose(
    BuildContext context,
    WidgetRef ref,
    bool hasChanges,
  ) async {
    if (hasChanges) {
      final shouldPop = await _showDiscardDialog(context);
      if (shouldPop && context.mounted) {
        ref.read(editSkillsOfferedNotifierProvider.notifier).reset();
        context.pop();
      }
    } else {
      ref.read(editSkillsOfferedNotifierProvider.notifier).reset();
      context.pop();
    }
  }

  Future<bool> _showDiscardDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _saveChanges(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(editSkillsOfferedNotifierProvider.notifier)
        .saveChanges();

    if (success) {
      ToastService.success('Skills updated successfully');
      if (context.mounted) {
        ref.read(editSkillsOfferedNotifierProvider.notifier).reset();
        context.pop();
      }
    } else {
      final errorMessage = ref.read(editSkillsOfferedNotifierProvider).errorMessage;
      ToastService.error(errorMessage ?? 'Failed to update skills');
    }
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
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 48,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          const Text(
            'No skills added',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.xs),
          Text(
            'Add at least one skill you can teach',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: Dimensions.xl),
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
    EditSkillsOfferedState editState,
    AsyncValue<List<dynamic>> categoriesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skills count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                '${editState.skills.length} skill${editState.skills.length > 1 ? 's' : ''} added',
                style: const TextStyle(
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
                  skills: editState.skills
                      .map((s) => SkillChipData(
                            id: s.id,
                            name: s.skillName,
                            level: s.level.name,
                          ))
                      .toList(),
                  onRemove: (skillId) {
                    ref
                        .read(editSkillsOfferedNotifierProvider.notifier)
                        .removeSkill(skillId);
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
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryBlue.withOpacity(0.04),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
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
      builder: (context) => AddSkillOfferedDialog(
        categories: categories,
        onAdd: (skill) {
          ref.read(editSkillsOfferedNotifierProvider.notifier).addSkill(skill);
          Navigator.pop(context);
        },
      ),
    );
  }
}