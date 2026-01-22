// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportRepositoryHash() => r'3a0af6d5aae3ecc6ed91e624e2f4e7895dd66640';

/// Provider for report repository
///
/// Copied from [reportRepository].
@ProviderFor(reportRepository)
final reportRepositoryProvider = AutoDisposeProvider<ReportRepository>.internal(
  reportRepository,
  name: r'reportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportRepositoryRef = AutoDisposeProviderRef<ReportRepository>;
String _$isUserBlockedHash() => r'0d3a9888a6160e7767bf5945fda1cb7d335259b7';

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

/// Provider to check if a specific user is blocked
///
/// Copied from [isUserBlocked].
@ProviderFor(isUserBlocked)
const isUserBlockedProvider = IsUserBlockedFamily();

/// Provider to check if a specific user is blocked
///
/// Copied from [isUserBlocked].
class IsUserBlockedFamily extends Family<bool> {
  /// Provider to check if a specific user is blocked
  ///
  /// Copied from [isUserBlocked].
  const IsUserBlockedFamily();

  /// Provider to check if a specific user is blocked
  ///
  /// Copied from [isUserBlocked].
  IsUserBlockedProvider call(
    String userId,
  ) {
    return IsUserBlockedProvider(
      userId,
    );
  }

  @override
  IsUserBlockedProvider getProviderOverride(
    covariant IsUserBlockedProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'isUserBlockedProvider';
}

/// Provider to check if a specific user is blocked
///
/// Copied from [isUserBlocked].
class IsUserBlockedProvider extends AutoDisposeProvider<bool> {
  /// Provider to check if a specific user is blocked
  ///
  /// Copied from [isUserBlocked].
  IsUserBlockedProvider(
    String userId,
  ) : this._internal(
          (ref) => isUserBlocked(
            ref as IsUserBlockedRef,
            userId,
          ),
          from: isUserBlockedProvider,
          name: r'isUserBlockedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isUserBlockedHash,
          dependencies: IsUserBlockedFamily._dependencies,
          allTransitiveDependencies:
              IsUserBlockedFamily._allTransitiveDependencies,
          userId: userId,
        );

  IsUserBlockedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    bool Function(IsUserBlockedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsUserBlockedProvider._internal(
        (ref) => create(ref as IsUserBlockedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsUserBlockedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsUserBlockedProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsUserBlockedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _IsUserBlockedProviderElement extends AutoDisposeProviderElement<bool>
    with IsUserBlockedRef {
  _IsUserBlockedProviderElement(super.provider);

  @override
  String get userId => (origin as IsUserBlockedProvider).userId;
}

String _$reportNotifierHash() => r'ac6c4ba2c865d985c070aff20119fc4976cfbd91';

/// Notifier for submitting reports
///
/// Copied from [ReportNotifier].
@ProviderFor(ReportNotifier)
final reportNotifierProvider =
    AutoDisposeNotifierProvider<ReportNotifier, ReportState>.internal(
  ReportNotifier.new,
  name: r'reportNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportNotifier = AutoDisposeNotifier<ReportState>;
String _$blockUserNotifierHash() => r'404d8d36c1093993fe1911143130ea11fbe54f2b';

/// Notifier for blocking/unblocking users
///
/// Copied from [BlockUserNotifier].
@ProviderFor(BlockUserNotifier)
final blockUserNotifierProvider =
    AutoDisposeNotifierProvider<BlockUserNotifier, BlockUserState>.internal(
  BlockUserNotifier.new,
  name: r'blockUserNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blockUserNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BlockUserNotifier = AutoDisposeNotifier<BlockUserState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
