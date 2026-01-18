// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryUsersHash() => r'b90c22bac54420cda0cdeb18c46c4a58c4d972fb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for users who teach skills in a specific category
///
/// Copied from [categoryUsers].
@ProviderFor(categoryUsers)
const categoryUsersProvider = CategoryUsersFamily();

/// Provider for users who teach skills in a specific category
///
/// Copied from [categoryUsers].
class CategoryUsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Provider for users who teach skills in a specific category
  ///
  /// Copied from [categoryUsers].
  const CategoryUsersFamily();

  /// Provider for users who teach skills in a specific category
  ///
  /// Copied from [categoryUsers].
  CategoryUsersProvider call(
    String categoryId,
  ) {
    return CategoryUsersProvider(
      categoryId,
    );
  }

  @override
  CategoryUsersProvider getProviderOverride(
    covariant CategoryUsersProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryUsersProvider';
}

/// Provider for users who teach skills in a specific category
///
/// Copied from [categoryUsers].
class CategoryUsersProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// Provider for users who teach skills in a specific category
  ///
  /// Copied from [categoryUsers].
  CategoryUsersProvider(
    String categoryId,
  ) : this._internal(
          (ref) => categoryUsers(
            ref as CategoryUsersRef,
            categoryId,
          ),
          from: categoryUsersProvider,
          name: r'categoryUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryUsersHash,
          dependencies: CategoryUsersFamily._dependencies,
          allTransitiveDependencies:
              CategoryUsersFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  CategoryUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(CategoryUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryUsersProvider._internal(
        (ref) => create(ref as CategoryUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _CategoryUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryUsersProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with CategoryUsersRef {
  _CategoryUsersProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryUsersProvider).categoryId;
}

String _$filteredCategoryUsersHash() =>
    r'7b83d2bd44e03c0a1456cb5b0ec55dd44eb5f3e5';

/// Provider for filtered and sorted users based on category state
///
/// Copied from [filteredCategoryUsers].
@ProviderFor(filteredCategoryUsers)
const filteredCategoryUsersProvider = FilteredCategoryUsersFamily();

/// Provider for filtered and sorted users based on category state
///
/// Copied from [filteredCategoryUsers].
class FilteredCategoryUsersFamily extends Family<List<UserModel>> {
  /// Provider for filtered and sorted users based on category state
  ///
  /// Copied from [filteredCategoryUsers].
  const FilteredCategoryUsersFamily();

  /// Provider for filtered and sorted users based on category state
  ///
  /// Copied from [filteredCategoryUsers].
  FilteredCategoryUsersProvider call(
    String categoryId,
  ) {
    return FilteredCategoryUsersProvider(
      categoryId,
    );
  }

  @override
  FilteredCategoryUsersProvider getProviderOverride(
    covariant FilteredCategoryUsersProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredCategoryUsersProvider';
}

/// Provider for filtered and sorted users based on category state
///
/// Copied from [filteredCategoryUsers].
class FilteredCategoryUsersProvider
    extends AutoDisposeProvider<List<UserModel>> {
  /// Provider for filtered and sorted users based on category state
  ///
  /// Copied from [filteredCategoryUsers].
  FilteredCategoryUsersProvider(
    String categoryId,
  ) : this._internal(
          (ref) => filteredCategoryUsers(
            ref as FilteredCategoryUsersRef,
            categoryId,
          ),
          from: filteredCategoryUsersProvider,
          name: r'filteredCategoryUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredCategoryUsersHash,
          dependencies: FilteredCategoryUsersFamily._dependencies,
          allTransitiveDependencies:
              FilteredCategoryUsersFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  FilteredCategoryUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    List<UserModel> Function(FilteredCategoryUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredCategoryUsersProvider._internal(
        (ref) => create(ref as FilteredCategoryUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<UserModel>> createElement() {
    return _FilteredCategoryUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredCategoryUsersProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredCategoryUsersRef on AutoDisposeProviderRef<List<UserModel>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _FilteredCategoryUsersProviderElement
    extends AutoDisposeProviderElement<List<UserModel>>
    with FilteredCategoryUsersRef {
  _FilteredCategoryUsersProviderElement(super.provider);

  @override
  String get categoryId => (origin as FilteredCategoryUsersProvider).categoryId;
}

String _$categorySkillsHash() => r'f736472788a52e373ef9e63cb0c958863f59dc50';

/// Provider for skills available in a category
///
/// Copied from [categorySkills].
@ProviderFor(categorySkills)
const categorySkillsProvider = CategorySkillsFamily();

/// Provider for skills available in a category
///
/// Copied from [categorySkills].
class CategorySkillsFamily extends Family<AsyncValue<List<String>>> {
  /// Provider for skills available in a category
  ///
  /// Copied from [categorySkills].
  const CategorySkillsFamily();

  /// Provider for skills available in a category
  ///
  /// Copied from [categorySkills].
  CategorySkillsProvider call(
    String categoryId,
  ) {
    return CategorySkillsProvider(
      categoryId,
    );
  }

  @override
  CategorySkillsProvider getProviderOverride(
    covariant CategorySkillsProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categorySkillsProvider';
}

/// Provider for skills available in a category
///
/// Copied from [categorySkills].
class CategorySkillsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// Provider for skills available in a category
  ///
  /// Copied from [categorySkills].
  CategorySkillsProvider(
    String categoryId,
  ) : this._internal(
          (ref) => categorySkills(
            ref as CategorySkillsRef,
            categoryId,
          ),
          from: categorySkillsProvider,
          name: r'categorySkillsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categorySkillsHash,
          dependencies: CategorySkillsFamily._dependencies,
          allTransitiveDependencies:
              CategorySkillsFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  CategorySkillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(CategorySkillsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategorySkillsProvider._internal(
        (ref) => create(ref as CategorySkillsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _CategorySkillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategorySkillsProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategorySkillsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategorySkillsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with CategorySkillsRef {
  _CategorySkillsProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategorySkillsProvider).categoryId;
}

String _$categoryNotifierHash() => r'026640a89de76b911ff2f7043dad6d26d2ffd50c';

abstract class _$CategoryNotifier
    extends BuildlessAutoDisposeNotifier<CategoryState> {
  late final String categoryId;

  CategoryState build(
    String categoryId,
  );
}

/// Notifier for category screen state
///
/// Copied from [CategoryNotifier].
@ProviderFor(CategoryNotifier)
const categoryNotifierProvider = CategoryNotifierFamily();

/// Notifier for category screen state
///
/// Copied from [CategoryNotifier].
class CategoryNotifierFamily extends Family<CategoryState> {
  /// Notifier for category screen state
  ///
  /// Copied from [CategoryNotifier].
  const CategoryNotifierFamily();

  /// Notifier for category screen state
  ///
  /// Copied from [CategoryNotifier].
  CategoryNotifierProvider call(
    String categoryId,
  ) {
    return CategoryNotifierProvider(
      categoryId,
    );
  }

  @override
  CategoryNotifierProvider getProviderOverride(
    covariant CategoryNotifierProvider provider,
  ) {
    return call(
      provider.categoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryNotifierProvider';
}

/// Notifier for category screen state
///
/// Copied from [CategoryNotifier].
class CategoryNotifierProvider
    extends AutoDisposeNotifierProviderImpl<CategoryNotifier, CategoryState> {
  /// Notifier for category screen state
  ///
  /// Copied from [CategoryNotifier].
  CategoryNotifierProvider(
    String categoryId,
  ) : this._internal(
          () => CategoryNotifier()..categoryId = categoryId,
          from: categoryNotifierProvider,
          name: r'categoryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryNotifierHash,
          dependencies: CategoryNotifierFamily._dependencies,
          allTransitiveDependencies:
              CategoryNotifierFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  CategoryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  CategoryState runNotifierBuild(
    covariant CategoryNotifier notifier,
  ) {
    return notifier.build(
      categoryId,
    );
  }

  @override
  Override overrideWith(CategoryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryNotifierProvider._internal(
        () => create()..categoryId = categoryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CategoryNotifier, CategoryState>
      createElement() {
    return _CategoryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryNotifierProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryNotifierRef on AutoDisposeNotifierProviderRef<CategoryState> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CategoryNotifier, CategoryState>
    with CategoryNotifierRef {
  _CategoryNotifierProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryNotifierProvider).categoryId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
