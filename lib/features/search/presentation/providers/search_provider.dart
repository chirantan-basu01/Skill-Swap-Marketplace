import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';

part 'search_provider.g.dart';

/// Search filter options
class SearchFilters {
  final List<String> categories;
  final List<Availability> availability;
  final double? minRating;
  final bool onlyPerfectMatches;
  final bool onlyOnline;

  const SearchFilters({
    this.categories = const [],
    this.availability = const [],
    this.minRating,
    this.onlyPerfectMatches = false,
    this.onlyOnline = false,
  });

  SearchFilters copyWith({
    List<String>? categories,
    List<Availability>? availability,
    double? minRating,
    bool? clearMinRating,
    bool? onlyPerfectMatches,
    bool? onlyOnline,
  }) {
    return SearchFilters(
      categories: categories ?? this.categories,
      availability: availability ?? this.availability,
      minRating: clearMinRating == true ? null : (minRating ?? this.minRating),
      onlyPerfectMatches: onlyPerfectMatches ?? this.onlyPerfectMatches,
      onlyOnline: onlyOnline ?? this.onlyOnline,
    );
  }

  bool get hasActiveFilters =>
      categories.isNotEmpty ||
      availability.isNotEmpty ||
      minRating != null ||
      onlyPerfectMatches ||
      onlyOnline;

  int get activeFilterCount {
    int count = 0;
    if (categories.isNotEmpty) count++;
    if (availability.isNotEmpty) count++;
    if (minRating != null) count++;
    if (onlyPerfectMatches) count++;
    if (onlyOnline) count++;
    return count;
  }
}

/// Sort options for search results
enum SearchSortOption {
  relevance('Relevance'),
  rating('Highest Rated'),
  recentlyActive('Recently Active'),
  mostSwaps('Most Swaps');

  final String label;
  const SearchSortOption(this.label);
}

/// Search state
class SearchState {
  final String query;
  final SearchFilters filters;
  final SearchSortOption sortOption;
  final List<UserModel> results;
  final bool isLoading;
  final String? error;
  final bool hasSearched;

  const SearchState({
    this.query = '',
    this.filters = const SearchFilters(),
    this.sortOption = SearchSortOption.relevance,
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.hasSearched = false,
  });

  SearchState copyWith({
    String? query,
    SearchFilters? filters,
    SearchSortOption? sortOption,
    List<UserModel>? results,
    bool? isLoading,
    String? error,
    bool? clearError,
    bool? hasSearched,
  }) {
    return SearchState(
      query: query ?? this.query,
      filters: filters ?? this.filters,
      sortOption: sortOption ?? this.sortOption,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: clearError == true ? null : (error ?? this.error),
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }
}

/// Search notifier with debounce
@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const SearchState();
  }

  /// Update search query with debounce
  void updateQuery(String query) {
    state = state.copyWith(query: query, clearError: true);

    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], hasSearched: false);
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch();
    });
  }

  /// Update filters and re-search
  void updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
    if (state.query.isNotEmpty || filters.hasActiveFilters) {
      _performSearch();
    }
  }

  /// Update sort option and re-sort results
  void updateSortOption(SearchSortOption option) {
    state = state.copyWith(sortOption: option);
    if (state.results.isNotEmpty) {
      final sortedResults = _sortResults(state.results, option);
      state = state.copyWith(results: sortedResults);
    }
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(filters: const SearchFilters());
    if (state.query.isNotEmpty) {
      _performSearch();
    }
  }

  /// Clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }

  /// Perform search with current query and filters
  Future<void> _performSearch() async {
    final query = state.query.trim().toLowerCase();
    final filters = state.filters;

    state = state.copyWith(isLoading: true, clearError: true, hasSearched: true);

    try {
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Please log in to search',
        );
        return;
      }

      // Fetch users from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .where('status', isEqualTo: 'active')
          .limit(100)
          .get();

      var users = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.uid != currentUser.uid)
          .toList();

      // Apply text search filter
      if (query.isNotEmpty) {
        users = users.where((user) {
          // Search in display name
          if (user.displayName.toLowerCase().contains(query)) return true;

          // Search in bio
          if (user.bio.toLowerCase().contains(query)) return true;

          // Search in skills offered
          for (final skill in user.skillsOffered) {
            if (skill.skillName.toLowerCase().contains(query)) return true;
            if (skill.categoryId.toLowerCase().contains(query)) return true;
          }

          // Search in skills wanted
          for (final skill in user.skillsWanted) {
            if (skill.skillName.toLowerCase().contains(query)) return true;
            if (skill.categoryId.toLowerCase().contains(query)) return true;
          }

          return false;
        }).toList();
      }

      // Apply filters
      users = _applyFilters(users, filters, currentUser.uid);

      // Sort results
      users = _sortResults(users, state.sortOption);

      state = state.copyWith(
        results: users,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed. Please try again.',
      );
    }
  }

  List<UserModel> _applyFilters(
    List<UserModel> users,
    SearchFilters filters,
    String currentUserId,
  ) {
    var filtered = users;

    // Filter by categories
    if (filters.categories.isNotEmpty) {
      filtered = filtered.where((user) {
        final userCategories = {
          ...user.skillsOffered.map((s) => s.categoryId.toLowerCase()),
          ...user.skillsWanted.map((s) => s.categoryId.toLowerCase()),
        };

        return filters.categories.any(
          (cat) => userCategories.contains(cat.toLowerCase()),
        );
      }).toList();
    }

    // Filter by availability
    if (filters.availability.isNotEmpty) {
      filtered = filtered.where((user) {
        return filters.availability.contains(user.availability) ||
            user.availability == Availability.flexible;
      }).toList();
    }

    // Filter by minimum rating
    if (filters.minRating != null) {
      filtered = filtered.where((user) {
        return user.rating.average >= filters.minRating!;
      }).toList();
    }

    // Filter by online status
    if (filters.onlyOnline) {
      final threshold = DateTime.now().subtract(const Duration(minutes: 5));
      filtered = filtered.where((user) {
        return user.lastActiveAt.isAfter(threshold);
      }).toList();
    }

    return filtered;
  }

  List<UserModel> _sortResults(List<UserModel> users, SearchSortOption option) {
    final sorted = List<UserModel>.from(users);

    switch (option) {
      case SearchSortOption.relevance:
        // Keep original order (search relevance)
        break;
      case SearchSortOption.rating:
        sorted.sort((a, b) => b.rating.average.compareTo(a.rating.average));
        break;
      case SearchSortOption.recentlyActive:
        sorted.sort((a, b) => b.lastActiveAt.compareTo(a.lastActiveAt));
        break;
      case SearchSortOption.mostSwaps:
        sorted.sort((a, b) => b.swapsCompleted.compareTo(a.swapsCompleted));
        break;
    }

    return sorted;
  }

  /// Trigger immediate search (for filter apply)
  void search() {
    _debounceTimer?.cancel();
    _performSearch();
  }
}

/// Provider for recent searches (stored locally)
@riverpod
class RecentSearches extends _$RecentSearches {
  static const _maxRecentSearches = 10;

  @override
  List<String> build() {
    return [];
  }

  void addSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final current = List<String>.from(state);
    current.remove(trimmed);
    current.insert(0, trimmed);

    if (current.length > _maxRecentSearches) {
      current.removeLast();
    }

    state = current;
  }

  void removeSearch(String query) {
    state = state.where((s) => s != query).toList();
  }

  void clearAll() {
    state = [];
  }
}

/// Provider for popular search suggestions
@riverpod
List<String> popularSearches(PopularSearchesRef ref) {
  return [
    'Python',
    'JavaScript',
    'Guitar',
    'Spanish',
    'Photography',
    'Cooking',
    'Yoga',
    'UI Design',
  ];
}

/// Provider for suggested users based on current user's wanted skills
@riverpod
Future<List<UserModel>> suggestedUsers(SuggestedUsersRef ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return [];
  }

  try {
    // Get current user's profile
    final currentUserDoc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(currentUser.uid)
        .get();

    if (!currentUserDoc.exists) {
      return [];
    }

    final currentUserModel = UserModel.fromJson(currentUserDoc.data()!);
    final wantedCategories = currentUserModel.skillsWanted
        .map((s) => s.categoryId.toLowerCase())
        .toSet();

    if (wantedCategories.isEmpty) {
      return [];
    }

    // Fetch all active users
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .where('status', isEqualTo: 'active')
        .limit(50)
        .get();

    final users = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .where((user) => user.uid != currentUser.uid)
        .toList();

    // Filter users who offer skills in categories the current user wants
    final suggestedUsers = users.where((user) {
      final offeredCategories = user.skillsOffered
          .map((s) => s.categoryId.toLowerCase())
          .toSet();
      return offeredCategories.intersection(wantedCategories).isNotEmpty;
    }).toList();

    // Sort by rating
    suggestedUsers.sort((a, b) => b.rating.average.compareTo(a.rating.average));

    return suggestedUsers.take(5).toList();
  } catch (e) {
    return [];
  }
}