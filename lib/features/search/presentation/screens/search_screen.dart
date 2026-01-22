import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/home/presentation/providers/users_provider.dart';
import 'package:skill_swap_marketplace/features/search/presentation/providers/search_provider.dart';
import 'package:skill_swap_marketplace/features/search/presentation/widgets/sort_options.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

/// Provider for controlling autocomplete suggestions visibility
final _showSuggestionsProvider = StateProvider.autoDispose<bool>((ref) => false);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialSort});

  /// Optional initial sort option passed from navigation
  final String? initialSort;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Check if we have an initial sort option (from "See All" navigation)
    if (widget.initialSort != null) {
      final sortOption = SearchSortOption.fromString(widget.initialSort);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchNotifierProvider.notifier).initializeWithSort(sortOption);
      });
    } else {
      // Auto-focus the search field only if not in browse mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }

    _searchController.addListener(() {
      ref.read(_showSuggestionsProvider.notifier).state =
          _searchController.text.length >= 2;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final popularSearches = ref.watch(popularSearchesProvider);
    final showSuggestions = ref.watch(_showSuggestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 56,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: _buildSearchField(searchState),
      ),
      // When showing search results, render directly without Stack
      // Stack is only needed for the autocomplete overlay on initial state
      body: searchState.hasSearched
          ? _buildSearchResults(searchState)
          : Stack(
              children: [
                _buildInitialState(recentSearches, popularSearches),
                if (showSuggestions) _buildAutocompleteSuggestions(),
              ],
            ),
    );
  }

  Widget _buildSearchField(SearchState searchState) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: (value) {
          ref.read(searchNotifierProvider.notifier).updateQuery(value);
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            ref.read(recentSearchesProvider.notifier).addSearch(value);
            ref.read(searchNotifierProvider.notifier).search();
            ref.read(_showSuggestionsProvider.notifier).state = false;
          }
        },
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search skills or people...',
          hintStyle: const TextStyle(
            color: AppColors.gray400,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.gray400,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchNotifierProvider.notifier).clearSearch();
                    ref.read(_showSuggestionsProvider.notifier).state = false;
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.gray400,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildAutocompleteSuggestions() {
    final query = _searchController.text.toLowerCase();
    final categoriesAsync = ref.watch(categoriesProvider);
    final usersAsync = ref.watch(usersProvider);

    // Build suggestions list
    final suggestions = <_SearchSuggestion>[];

    // Add skill/category suggestions
    categoriesAsync.whenData((categories) {
      for (final category in categories) {
        if (category.name.toLowerCase().contains(query)) {
          suggestions.add(_SearchSuggestion(
            icon: category.icon,
            text: category.name,
            type: _SuggestionType.skill,
          ));
        }
      }
    });

    // Add user suggestions
    usersAsync.whenData((users) {
      for (final user in users.take(3)) {
        if (user.displayName.toLowerCase().contains(query)) {
          suggestions.add(_SearchSuggestion(
            text: user.displayName,
            type: _SuggestionType.user,
            photoUrl: user.photoUrl,
          ));
        }
      }
    });

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 4,
        color: AppColors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: suggestions.take(5).map((suggestion) {
            return ListTile(
              leading: suggestion.type == _SuggestionType.user
                  ? CircleAvatar(
                      radius: 16,
                      backgroundImage: suggestion.photoUrl != null
                          ? NetworkImage(suggestion.photoUrl!)
                          : null,
                      child: suggestion.photoUrl == null
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    )
                  : Text(suggestion.icon ?? '🔍', style: const TextStyle(fontSize: 20)),
              title: Text(
                suggestion.text,
                style: const TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                suggestion.type == _SuggestionType.user ? 'User' : 'Skill',
                style: const TextStyle(fontSize: 12, color: AppColors.gray500),
              ),
              dense: true,
              onTap: () {
                _searchController.text = suggestion.text;
                ref.read(searchNotifierProvider.notifier).updateQuery(suggestion.text);
                ref.read(recentSearchesProvider.notifier).addSearch(suggestion.text);
                ref.read(searchNotifierProvider.notifier).search();
                ref.read(_showSuggestionsProvider.notifier).state = false;
                _focusNode.unfocus();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInitialState(
    List<String> recentSearches,
    List<String> popularSearches,
  ) {
    final suggestedUsers = ref.watch(suggestedUsersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(recentSearchesProvider.notifier).clearAll();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.sm),
            ...recentSearches.map((search) => _RecentSearchTile(
                  search: search,
                  onTap: () => _performSearch(search),
                  onDelete: () {
                    ref.read(recentSearchesProvider.notifier).removeSearch(search);
                  },
                )),
            const SizedBox(height: Dimensions.lg),
          ],

          // Popular skills
          const Text(
            'Popular Skills',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(height: Dimensions.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return _SkillChip(
                label: search,
                onTap: () => _performSearch(search),
              );
            }).toList(),
          ),

          const SizedBox(height: Dimensions.xl),

          // Suggested for You
          const Text(
            'Suggested for You',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Based on your wanted skills',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: Dimensions.md),
          suggestedUsers.when(
            data: (users) {
              if (users.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(Dimensions.md),
                  child: Text(
                    'No suggestions yet. Complete your profile to see matches!',
                    style: TextStyle(color: AppColors.gray500),
                  ),
                );
              }
              return Column(
                children: users.take(3).map((user) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.sm),
                    child: _SuggestedUserCard(
                      user: user,
                      onTap: () => UserProfileRoute(userId: user.uid).push(context),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.lg),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    _searchController.text = query;
    ref.read(searchNotifierProvider.notifier).updateQuery(query);
    ref.read(recentSearchesProvider.notifier).addSearch(query);
    ref.read(searchNotifierProvider.notifier).search();
    ref.read(_showSuggestionsProvider.notifier).state = false;
    _focusNode.unfocus();
  }

  Widget _buildSearchResults(SearchState searchState) {
    if (searchState.isLoading) {
      return _buildLoadingShimmer();
    }

    if (searchState.error != null) {
      return _buildErrorState(searchState.error!);
    }

    if (searchState.results.isEmpty) {
      return _buildEmptyResults(searchState);
    }

    final currentUser = ref.watch(currentUserProfileProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter bar
        _buildFilterBar(searchState),

        // Results count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.md,
            vertical: Dimensions.sm,
          ),
          child: Text(
            searchState.query.isEmpty
                ? '${searchState.results.length} Users • Sorted by ${searchState.sortOption.label}'
                : '${searchState.results.length} Results for "${searchState.query}"',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray500,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.md),
            itemCount: searchState.results.length,
            itemBuilder: (context, index) {
              final user = searchState.results[index];
              final matchPercentage = currentUser != null
                  ? _calculateMatchPercentage(currentUser, user)
                  : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.sm),
                child: _SearchResultCard(
                  user: user,
                  matchPercentage: matchPercentage,
                  onTap: () => UserProfileRoute(userId: user.uid).push(context),
                  onRequestSwap: () => SwapRequestRoute(userId: user.uid).push(context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(SearchState searchState) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.md),
        child: Row(
          children: [
            // Category filter
            _FilterChip(
              label: searchState.filters.categories.isEmpty
                  ? 'Category'
                  : searchState.filters.categories.first,
              isActive: searchState.filters.categories.isNotEmpty,
              onTap: () => _showCategoryFilter(searchState, categoriesAsync),
            ),
            const SizedBox(width: 8),

            // Availability filter
            _FilterChip(
              label: searchState.filters.availability.isEmpty
                  ? 'Availability'
                  : _getAvailabilityLabel(searchState.filters.availability.first),
              isActive: searchState.filters.availability.isNotEmpty,
              onTap: () => _showAvailabilityFilter(searchState),
            ),
            const SizedBox(width: 8),

            // Rating filter
            _FilterChip(
              label: searchState.filters.minRating == null
                  ? 'Rating'
                  : '${searchState.filters.minRating}+',
              isActive: searchState.filters.minRating != null,
              onTap: () => _showRatingFilter(searchState),
            ),
            const SizedBox(width: 8),

            // Sort option
            _FilterChip(
              label: 'Sort: ${searchState.sortOption.label}',
              isActive: searchState.sortOption != SearchSortOption.relevance,
              onTap: () => _showSortOptions(searchState),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter(SearchState searchState, AsyncValue categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryFilterSheet(
        selectedCategories: searchState.filters.categories,
        categories: categories,
        onApply: (selected) {
          ref.read(searchNotifierProvider.notifier).updateFilters(
                searchState.filters.copyWith(categories: selected),
              );
        },
      ),
    );
  }

  void _showAvailabilityFilter(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AvailabilityFilterSheet(
        selected: searchState.filters.availability,
        onApply: (selected) {
          ref.read(searchNotifierProvider.notifier).updateFilters(
                searchState.filters.copyWith(availability: selected),
              );
        },
      ),
    );
  }

  void _showRatingFilter(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _RatingFilterSheet(
        selectedRating: searchState.filters.minRating,
        onApply: (rating) {
          ref.read(searchNotifierProvider.notifier).updateFilters(
                searchState.filters.copyWith(
                  minRating: rating,
                  clearMinRating: rating == null,
                ),
              );
        },
      ),
    );
  }

  void _showSortOptions(SearchState searchState) {
    SortOptionsSheet.show(
      context: context,
      currentOption: searchState.sortOption,
      onSelect: (option) {
        ref.read(searchNotifierProvider.notifier).updateSortOption(option);
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter bar placeholder
        Container(
          height: 60,
          color: AppColors.surface,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.md),
            itemCount: 4,
            itemBuilder: (context, index) => const _ShimmerCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
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
              'Search failed',
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
                ref.read(searchNotifierProvider.notifier).search();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResults(SearchState searchState) {
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
              'No results for "${searchState.query}"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Try a different search term\nor browse categories',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.lg),
            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to categories
              },
              child: const Text('Browse Categories'),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateMatchPercentage(UserModel currentUser, UserModel otherUser) {
    int score = 0;
    int total = 0;

    // Check if other user offers what current user wants
    for (final wanted in currentUser.skillsWanted) {
      total += 10;
      for (final offered in otherUser.skillsOffered) {
        if (offered.skillName.toLowerCase() == wanted.skillName.toLowerCase() ||
            offered.categoryId == wanted.categoryId) {
          score += 10;
          break;
        }
      }
    }

    // Check if current user offers what other user wants
    for (final wanted in otherUser.skillsWanted) {
      total += 10;
      for (final offered in currentUser.skillsOffered) {
        if (offered.skillName.toLowerCase() == wanted.skillName.toLowerCase() ||
            offered.categoryId == wanted.categoryId) {
          score += 10;
          break;
        }
      }
    }

    if (total == 0) return 0;
    return ((score / total) * 100).round();
  }

  String _getAvailabilityLabel(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return 'Morning';
      case Availability.afternoon:
        return 'Afternoon';
      case Availability.evening:
        return 'Evening';
      case Availability.flexible:
        return 'Flexible';
    }
  }
}

// Helper classes and widgets

enum _SuggestionType { skill, user }

class _SearchSuggestion {
  final String? icon;
  final String text;
  final _SuggestionType type;
  final String? photoUrl;

  _SearchSuggestion({
    this.icon,
    required this.text,
    required this.type,
    this.photoUrl,
  });
}

class _RecentSearchTile extends StatelessWidget {
  final String search;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _RecentSearchTile({
    required this.search,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history_rounded, color: AppColors.gray400),
      title: Text(
        search,
        style: const TextStyle(fontSize: 15, color: AppColors.gray700),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18, color: AppColors.gray400),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SkillChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray700,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue.withValues(alpha: 0.1) : AppColors.surface,
          border: Border.all(
            color: isActive ? AppColors.primaryBlue : AppColors.gray300,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive ? AppColors.primaryBlue : AppColors.gray700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive ? AppColors.primaryBlue : AppColors.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestedUserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _SuggestedUserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.gray200),
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Text(user.displayName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(
                        '${user.rating.average.toStringAsFixed(1)} • ${user.swapsCompleted} swaps',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  if (user.skillsOffered.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.skillsOffered.first.skillName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final UserModel user;
  final int? matchPercentage;
  final VoidCallback onTap;
  final VoidCallback onRequestSwap;

  const _SearchResultCard({
    required this.user,
    this.matchPercentage,
    required this.onTap,
    required this.onRequestSwap,
  });

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the actual available width from ListView
    // This ensures we always have bounded constraints for all children
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width - use constraints if bounded, otherwise use screen width
        final cardWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32; // Fallback with padding

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(Dimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with avatar and user info
                _buildHeaderRow(),

                // Skills offered
                if (user.skillsOffered.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildSkillsRow(),
                ],

                // Bio preview
                if (user.bio.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray600,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Bottom section: match percentage and button
                _buildBottomSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with online indicator
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Text(user.displayName[0].toUpperCase())
                  : null,
            ),
            if (isUserOnline(user))
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        // User info - use Flexible instead of Expanded to avoid intrinsic width issues
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${user.rating.average.toStringAsFixed(1)} ★ • ${user.swapsCompleted} swaps',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsRow() {
    return Row(
      children: [
        Text(
          _getCategoryEmoji(user.skillsOffered.first.categoryId),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '${user.skillsOffered.first.skillName} (${user.skillsOffered.first.level.name})',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    // Use Column layout to avoid Row with Expanded causing infinite width issues
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Match percentage (if present)
        if (matchPercentage != null && matchPercentage! > 0) ...[
          Text(
            'Match: $matchPercentage%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
        ],
        // Button aligned to the right
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onRequestSwap,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: const TextStyle(fontSize: 13),
            ),
            child: const Text('Request Swap'),
          ),
        ),
      ],
    );
  }

  String _getCategoryEmoji(String categoryId) {
    const categoryEmojis = {
      'technology': '💻',
      'music': '🎵',
      'languages': '🌍',
      'creative': '🎨',
      'business': '💼',
      'lifestyle': '🧘',
      'academic': '📚',
    };
    return categoryEmojis[categoryId.toLowerCase()] ?? '✨';
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.sm),
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.gray200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.gray200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 14,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

// Filter sheets
class _CategoryFilterSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final AsyncValue categories;
  final ValueChanged<List<String>> onApply;

  const _CategoryFilterSheet({
    required this.selectedCategories,
    required this.categories,
    required this.onApply,
  });

  @override
  State<_CategoryFilterSheet> createState() => _CategoryFilterSheetState();
}

class _CategoryFilterSheetState extends State<_CategoryFilterSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _selected = []);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: widget.categories.when(
                data: (categories) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String?>(
                      title: const Text('All Categories'),
                      value: null,
                      groupValue: _selected.isEmpty ? null : _selected.first,
                      onChanged: (_) {
                        setState(() => _selected = []);
                      },
                    ),
                    ...categories.map((cat) => RadioListTile<String>(
                          title: Text('${cat.icon} ${cat.name}'),
                          value: cat.id,
                          groupValue: _selected.isEmpty ? null : _selected.first,
                          onChanged: (value) {
                            setState(() {
                              _selected = value != null ? [value] : [];
                            });
                          },
                        )),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(Dimensions.lg),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const Text('Error loading categories'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selected);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filter'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _AvailabilityFilterSheet extends StatefulWidget {
  final List<Availability> selected;
  final ValueChanged<List<Availability>> onApply;

  const _AvailabilityFilterSheet({
    required this.selected,
    required this.onApply,
  });

  @override
  State<_AvailabilityFilterSheet> createState() => _AvailabilityFilterSheetState();
}

class _AvailabilityFilterSheetState extends State<_AvailabilityFilterSheet> {
  late List<Availability> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selected);
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
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Availability',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _selected = []);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          ...Availability.values.map((availability) => CheckboxListTile(
                title: Text(_getAvailabilityLabel(availability)),
                value: _selected.contains(availability),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selected.add(availability);
                    } else {
                      _selected.remove(availability);
                    }
                  });
                },
              )),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selected);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filter'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getAvailabilityLabel(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return 'Morning';
      case Availability.afternoon:
        return 'Afternoon';
      case Availability.evening:
        return 'Evening';
      case Availability.flexible:
        return 'Flexible';
    }
  }
}

class _RatingFilterSheet extends StatefulWidget {
  final double? selectedRating;
  final ValueChanged<double?> onApply;

  const _RatingFilterSheet({
    required this.selectedRating,
    required this.onApply,
  });

  @override
  State<_RatingFilterSheet> createState() => _RatingFilterSheetState();
}

class _RatingFilterSheetState extends State<_RatingFilterSheet> {
  double? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedRating;
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
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minimum Rating',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _selected = null);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          ...[null, 3.0, 4.0, 4.5].map((rating) => RadioListTile<double?>(
                title: Text(rating == null ? 'Any' : '$rating+ stars'),
                secondary: rating != null
                    ? const Icon(Icons.star_rounded, color: AppColors.warning)
                    : null,
                value: rating,
                groupValue: _selected,
                onChanged: (value) {
                  setState(() => _selected = value);
                },
              )),
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_selected);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filter'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
