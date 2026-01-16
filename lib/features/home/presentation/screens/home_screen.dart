import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_card.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/home/presentation/providers/users_provider.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(usersProvider);
          },
          color: AppColors.primaryBlue,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, ref, currentUserAsync),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: _buildSearchBar(context),
              ),

              // Perfect Matches section
              SliverToBoxAdapter(
                child: _buildPerfectMatchesSection(context, ref),
              ),

              // Recommended section
              SliverToBoxAdapter(
                child: _buildRecommendedSection(context, ref),
              ),

              // Categories section
              SliverToBoxAdapter(
                child: _buildCategoriesSection(context, ref),
              ),

              // Recently Active section
              SliverToBoxAdapter(
                child: _buildRecentlyActiveSection(context, ref),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<UserModel?> currentUserAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.screenPaddingH,
        Dimensions.md,
        Dimensions.screenPaddingH,
        0,
      ),
      child: Row(
        children: [
          // Avatar
          currentUserAsync.when(
            data: (user) => UserAvatar(
              imageUrl: user?.photoUrl,
              name: user?.displayName,
              size: AvatarSize.sm,
              onTap: () {
                // Navigate to profile
              },
            ),
            loading: () => const _ShimmerCircle(size: Dimensions.avatarSm),
            error: (_, __) => const UserAvatar(size: AvatarSize.sm),
          ),
          const SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentUserAsync.when(
                  data: (user) => Text(
                    'Hi, ${user?.displayName.split(' ').first ?? 'there'}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  loading: () => const _ShimmerBox(width: 100, height: 20),
                  error: (_, __) => const Text('Hi there!'),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ready to swap?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Notification bell
          IconButton(
            onPressed: () => const NotificationsRoute().push(context),
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gray100,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.screenPaddingH,
        Dimensions.md,
        Dimensions.screenPaddingH,
        0,
      ),
      child: GestureDetector(
        onTap: () => const SearchRoute().push(context),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(Dimensions.radiusFull),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: AppColors.gray400,
                size: 22,
              ),
              SizedBox(width: 12),
              Text(
                'Search skills or people...',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfectMatchesSection(BuildContext context, WidgetRef ref) {
    final perfectMatches = ref.watch(perfectMatchesProvider);
    final usersAsync = ref.watch(usersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: '⚡',
          title: 'Perfect Matches',
          onSeeAll: perfectMatches.isNotEmpty
              ? () {
                  // Navigate to all perfect matches
                }
              : null,
        ),
        SizedBox(
          height: 220,
          child: usersAsync.when(
            data: (_) {
              if (perfectMatches.isEmpty) {
                return _buildEmptyMatchesCard(context);
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenPaddingH,
                ),
                itemCount: perfectMatches.length,
                itemBuilder: (context, index) {
                  final user = perfectMatches[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          index < perfectMatches.length - 1 ? Dimensions.md : 0,
                    ),
                    child: UserCardCompact(
                      user: user,
                      isPerfectMatch: true,
                      onTap: () =>
                          UserProfileRoute(userId: user.uid).push(context),
                    ),
                  );
                },
              );
            },
            loading: () => _buildHorizontalShimmer(),
            error: (_, __) => _buildErrorCard('Failed to load matches'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMatchesCard(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Constrain emoji to prevent iOS overflow
            const SizedBox(
              height: 40,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text('😔', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No perfect matches yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try adding more skills',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Navigate to edit profile
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Update Your Skills'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final recommendedUsers = ref.watch(recommendedUsersProvider);
    final usersAsync = ref.watch(usersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: '🎯',
          title: 'Recommended for You',
          onSeeAll: recommendedUsers.isNotEmpty
              ? () {
                  // Navigate to all recommendations
                }
              : null,
        ),
        usersAsync.when(
          data: (_) {
            if (recommendedUsers.isEmpty) {
              return _buildEmptyRecommendations();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.screenPaddingH,
              ),
              itemCount: recommendedUsers.take(3).length,
              itemBuilder: (context, index) {
                final userWithScore = recommendedUsers[index];
                final currentUser = currentUserAsync.valueOrNull;
                final matchingSkills = currentUser != null
                    ? getMatchingSkills(currentUser, userWithScore.user)
                    : <String>[];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCardFull(
                    user: userWithScore.user,
                    matchPercentage: userWithScore.matchPercentage,
                    isOnline: isUserOnline(userWithScore.user),
                    matchingSkills:
                        matchingSkills.isNotEmpty ? matchingSkills : null,
                    onTap: () => UserProfileRoute(userId: userWithScore.user.uid)
                        .push(context),
                  ),
                );
              },
            );
          },
          loading: () => _buildVerticalShimmer(),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.screenPaddingH,
            ),
            child: _buildErrorCard('Failed to load recommendations'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRecommendations() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
        padding: const EdgeInsets.all(Dimensions.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
          border: Border.all(color: AppColors.gray200),
        ),
        child: const Column(
          children: [
            Text(
              '🌟',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 12),
            Text(
              'Welcome to Skill Swap!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'We\'re finding the best matches for you.\nCheck back soon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          icon: '📚',
          title: 'Browse by Category',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.23 * 0.95 + 4, // Match tile height + buffer
          child: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return _buildDefaultCategories(context);
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenPaddingH,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < categories.length - 1 ? 12 : 0,
                    ),
                    child: _CategoryTile(
                      icon: category.icon,
                      label: category.name,
                      onTap: () =>
                          CategoryRoute(id: category.id).push(context),
                    ),
                  );
                },
              );
            },
            loading: () => _buildCategoryShimmer(),
            error: (_, __) => _buildDefaultCategories(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultCategories(BuildContext context) {
    const defaultCategories = [
      {'icon': '💻', 'label': 'Technology', 'id': 'technology'},
      {'icon': '🎨', 'label': 'Creative', 'id': 'creative'},
      {'icon': '🎵', 'label': 'Music', 'id': 'music'},
      {'icon': '🌍', 'label': 'Languages', 'id': 'languages'},
      {'icon': '💼', 'label': 'Business', 'id': 'business'},
      {'icon': '🧘', 'label': 'Lifestyle', 'id': 'lifestyle'},
      {'icon': '📚', 'label': 'Academic', 'id': 'academic'},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
      ),
      itemCount: defaultCategories.length,
      itemBuilder: (context, index) {
        final category = defaultCategories[index];
        return Padding(
          padding: EdgeInsets.only(
            right: index < defaultCategories.length - 1 ? 12 : 0,
          ),
          child: _CategoryTile(
            icon: category['icon']!,
            label: category['label']!,
            onTap: () => CategoryRoute(id: category['id']!).push(context),
          ),
        );
      },
    );
  }

  Widget _buildRecentlyActiveSection(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final recentlyActiveUsers = ref.watch(recentlyActiveUsersProvider);
    final usersAsync = ref.watch(usersProvider);

    if (recentlyActiveUsers.isEmpty && usersAsync.hasValue) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: '🕐',
          title: 'Recently Active',
          onSeeAll: recentlyActiveUsers.isNotEmpty
              ? () {
                  // Navigate to all active users
                }
              : null,
        ),
        usersAsync.when(
          data: (_) {
            if (recentlyActiveUsers.isEmpty) {
              return const SizedBox.shrink();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.screenPaddingH,
              ),
              itemCount: recentlyActiveUsers.take(3).length,
              itemBuilder: (context, index) {
                final user = recentlyActiveUsers[index];
                final currentUser = currentUserAsync.valueOrNull;
                final matchingSkills = currentUser != null
                    ? getMatchingSkills(currentUser, user)
                    : <String>[];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCardFull(
                    user: user,
                    isOnline: isUserOnline(user),
                    matchingSkills:
                        matchingSkills.isNotEmpty ? matchingSkills : null,
                    onTap: () =>
                        UserProfileRoute(userId: user.uid).push(context),
                  ),
                );
              },
            );
          },
          loading: () => _buildVerticalShimmer(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildHorizontalShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.screenPaddingH,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? Dimensions.md : 0),
          child: const _ShimmerCard(width: 160, height: 200),
        );
      },
    );
  }

  Widget _buildVerticalShimmer() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.screenPaddingH),
      child: Column(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _ShimmerCard(height: 120),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final tileWidth = screenWidth * 0.185;
        final tileHeight = tileWidth * 1.17;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.screenPaddingH,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: index < 4 ? 12 : 0),
              child: _ShimmerCard(width: tileWidth, height: tileHeight),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.errorSurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '😕',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with icon, title and optional "See All" button
class _SectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.screenPaddingH,
        Dimensions.lg,
        Dimensions.screenPaddingH,
        Dimensions.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Maps icon names from Firestore to actual emojis
/// Falls back to the original value if it's already an emoji or unknown
String _mapIconToEmoji(String icon) {
  const iconMap = {
    // Technology
    'computer': '💻',
    'laptop': '💻',
    'code': '💻',
    'technology': '💻',
    // Creative
    'brush': '🎨',
    'palette': '🎨',
    'art': '🎨',
    'creative': '🎨',
    'design': '🎨',
    // Music
    'music': '🎵',
    'music_note': '🎵',
    'musical_note': '🎵',
    // Languages
    'translate': '🌍',
    'language': '🌍',
    'globe': '🌍',
    'languages': '🌍',
    // Business
    'business': '💼',
    'briefcase': '💼',
    'work': '💼',
    // Lifestyle
    'lifestyle': '🧘',
    'yoga': '🧘',
    'spa': '🧘',
    'self_improvement': '🧘',
    // Academic
    'academic': '📚',
    'book': '📚',
    'school': '📚',
    'education': '📚',
    'menu_book': '📚',
  };

  return iconMap[icon.toLowerCase()] ?? icon;
}

/// Category tile widget - Responsive version
/// Adapts to screen size while maintaining aspect ratio
class _CategoryTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive sizing: ~23% of screen width for tile width (fits "Technology")
    final tileWidth = screenWidth * 0.23;
    // Maintain aspect ratio
    final tileHeight = tileWidth * 0.95;
    // Small padding
    final paddingH = screenWidth * 0.015;
    final paddingV = screenWidth * 0.02;
    // Icon takes ~55% of content height
    final iconHeight = (tileHeight - paddingV * 2) * 0.55;

    // Map icon name to emoji if needed
    final displayIcon = _mapIconToEmoji(icon);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileWidth,
        height: tileHeight,
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Constrain emoji with FittedBox to handle iOS rendering
            SizedBox(
              height: iconHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  displayIcon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.028,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading placeholders
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;

  const _ShimmerCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.gray200,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double? width;
  final double height;

  const _ShimmerCard({this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(Dimensions.radiusLg),
      ),
    );
  }
}