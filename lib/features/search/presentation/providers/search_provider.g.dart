// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$popularSearchesHash() => r'e46cb1daee8141b56ad49d73b2a4c6d0bd0f0aaf';

/// Provider for popular search suggestions
///
/// Copied from [popularSearches].
@ProviderFor(popularSearches)
final popularSearchesProvider = AutoDisposeProvider<List<String>>.internal(
  popularSearches,
  name: r'popularSearchesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularSearchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularSearchesRef = AutoDisposeProviderRef<List<String>>;
String _$suggestedUsersHash() => r'e0c4067999083d54cd639425b6a12d4a360631ff';

/// Provider for suggested users based on current user's wanted skills
///
/// Copied from [suggestedUsers].
@ProviderFor(suggestedUsers)
final suggestedUsersProvider =
    AutoDisposeFutureProvider<List<UserModel>>.internal(
  suggestedUsers,
  name: r'suggestedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$suggestedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuggestedUsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$searchNotifierHash() => r'b74034cf13733d4644a0ede0f6e51ac9bc6df543';

/// Search notifier with debounce and pagination
///
/// Copied from [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeNotifierProvider<SearchNotifier, SearchState>.internal(
  SearchNotifier.new,
  name: r'searchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchNotifier = AutoDisposeNotifier<SearchState>;
String _$recentSearchesHash() => r'38abaf74a4fe3196dfbd1bae2e11d666a3b7314f';

/// Provider for recent searches (stored locally)
///
/// Copied from [RecentSearches].
@ProviderFor(RecentSearches)
final recentSearchesProvider =
    AutoDisposeNotifierProvider<RecentSearches, List<String>>.internal(
  RecentSearches.new,
  name: r'recentSearchesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentSearchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentSearches = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
