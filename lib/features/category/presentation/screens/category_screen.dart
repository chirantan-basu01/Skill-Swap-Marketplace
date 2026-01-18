import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/category/presentation/providers/category_users_provider.dart';
import 'package:skill_swap_marketplace/features/category/presentation/widgets/category_header.dart';
import 'package:skill_swap_marketplace/features/category/presentation/widgets/category_sort_sheet.dart';
import 'package:skill_swap_marketplace/features/category/presentation/widgets/skill_filter_chips.dart';
import 'package:skill_swap_marketplace/features/category/presentation/widgets/teacher_card.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

/// Screen displaying all users who teach skills in a specific category
class CategoryScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryByIdProvider(categoryId));
    final categoryState = ref.watch(categoryNotifierProvider(categoryId));
    final filteredUsers = ref.watch(filteredCategoryUsersProvider(categoryId));
    final skillsAsync = ref.watch(categorySkillsProvider(categoryId));
    final categoryUsersAsync = ref.watch(categoryUsersProvider(categoryId));

    // Get category name
    final categoryName = categoryAsync.when(
      data: (category) => category?.name ?? _formatCategoryName(categoryId),
      loading: () => _formatCategoryName(categoryId),
      error: (_, __) => _formatCategoryName(categoryId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => const SearchRoute().push(context),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryUsersProvider(categoryId));
          ref.invalidate(categorySkillsProvider(categoryId));
        },
        color: AppColors.primaryBlue,
        child: CustomScrollView(
          slivers: [
            // Category Header
            SliverToBoxAdapter(
              child: CategoryHeader(
                categoryId: categoryId,
                categoryName: categoryName,
              ),
            ),

            // Skill Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.md),
                child: skillsAsync.when(
                  data: (skills) => SkillFilterChips(
                    skills: skills,
                    selectedSkill: categoryState.selectedSkill,
                    onSkillSelected: (skill) {
                      ref
                          .read(categoryNotifierProvider(categoryId).notifier)
                          .selectSkill(skill);
                    },
                  ),
                  loading: () => const SkillFilterChips(
                    skills: [],
                    selectedSkill: null,
                    onSkillSelected: _noOp,
                    isLoading: true,
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Results Header (count + sort)
            SliverToBoxAdapter(
              child: _ResultsHeader(
                categoryId: categoryId,
                count: filteredUsers.length,
                sortOption: categoryState.sortOption,
                isLoading: categoryUsersAsync.isLoading,
                onSortTap: () => _showSortSheet(context, ref, categoryState),
              ),
            ),

            // Teachers List
            categoryUsersAsync.when(
              data: (_) {
                if (filteredUsers.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(
                      context,
                      categoryState.selectedSkill,
                      ref,
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final user = filteredUsers[index];
                      return TeacherCard(
                        user: user,
                        categoryId: categoryId,
                        onTap: () =>
                            UserProfileRoute(userId: user.uid).push(context),
                        onViewProfile: () =>
                            UserProfileRoute(userId: user.uid).push(context),
                      );
                    },
                    childCount: filteredUsers.length,
                  ),
                );
              },
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const TeacherCardShimmer(),
                  childCount: 4,
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: _buildErrorState(context, ref, error),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(
    BuildContext context,
    WidgetRef ref,
    CategoryState categoryState,
  ) {
    CategorySortSheet.show(
      context: context,
      currentOption: categoryState.sortOption,
      onSelect: (option) {
        ref
            .read(categoryNotifierProvider(categoryId).notifier)
            .setSortOption(option);
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String? selectedSkill,
    WidgetRef ref,
  ) {
    if (selectedSkill != null) {
      // Empty filter state
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: Dimensions.md),
              Text(
                'No $selectedSkill teachers found',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.sm),
              const Text(
                'Try selecting a different skill\nor view all teachers',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.lg),
              OutlinedButton(
                onPressed: () {
                  ref
                      .read(categoryNotifierProvider(categoryId).notifier)
                      .selectSkill(null);
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty category state
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getCategoryEmoji(categoryId),
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: Dimensions.md),
            Text(
              'No teachers yet in ${_formatCategoryName(categoryId)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Be the first to offer your\nskills to the community!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.lg),
            ElevatedButton(
              onPressed: () => const EditProfileRoute().push(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Add ${_formatCategoryName(categoryId)} Skills'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: AppColors.warning,
            ),
            const SizedBox(height: Dimensions.md),
            const Text(
              'Failed to load teachers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Please try again',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Dimensions.lg),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(categoryUsersProvider(categoryId));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String categoryId) {
    return categoryId[0].toUpperCase() + categoryId.substring(1);
  }

  String _getCategoryEmoji(String categoryId) {
    const categoryEmojis = {
      'technology': '\ud83d\udcbb',
      'music': '\ud83c\udfb5',
      'languages': '\ud83c\udf0d',
      'creative': '\ud83c\udfa8',
      'business': '\ud83d\udcbc',
      'lifestyle': '\ud83e\uddd8',
      'academic': '\ud83d\udcda',
    };
    return categoryEmojis[categoryId.toLowerCase()] ?? '\u2728';
  }
}

// No-op callback for loading state
void _noOp(String? _) {}

/// Results header showing count and sort option
class _ResultsHeader extends StatelessWidget {
  final String categoryId;
  final int count;
  final CategorySortOption sortOption;
  final bool isLoading;
  final VoidCallback onSortTap;

  const _ResultsHeader({
    required this.categoryId,
    required this.count,
    required this.sortOption,
    required this.isLoading,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Count
          isLoading
              ? Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              : Text(
                  '$count Teacher${count == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.gray500,
                  ),
                ),

          // Sort button
          GestureDetector(
            onTap: onSortTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sortOption.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
