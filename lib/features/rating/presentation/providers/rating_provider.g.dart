// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasUserRatedSwapHash() => r'2420b222f4619863a98352b88cb8ef8ecb3dd3e2';

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

/// Check if current user has already rated a swap
///
/// Copied from [hasUserRatedSwap].
@ProviderFor(hasUserRatedSwap)
const hasUserRatedSwapProvider = HasUserRatedSwapFamily();

/// Check if current user has already rated a swap
///
/// Copied from [hasUserRatedSwap].
class HasUserRatedSwapFamily extends Family<AsyncValue<bool>> {
  /// Check if current user has already rated a swap
  ///
  /// Copied from [hasUserRatedSwap].
  const HasUserRatedSwapFamily();

  /// Check if current user has already rated a swap
  ///
  /// Copied from [hasUserRatedSwap].
  HasUserRatedSwapProvider call(
    String swapId,
  ) {
    return HasUserRatedSwapProvider(
      swapId,
    );
  }

  @override
  HasUserRatedSwapProvider getProviderOverride(
    covariant HasUserRatedSwapProvider provider,
  ) {
    return call(
      provider.swapId,
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
  String? get name => r'hasUserRatedSwapProvider';
}

/// Check if current user has already rated a swap
///
/// Copied from [hasUserRatedSwap].
class HasUserRatedSwapProvider extends AutoDisposeFutureProvider<bool> {
  /// Check if current user has already rated a swap
  ///
  /// Copied from [hasUserRatedSwap].
  HasUserRatedSwapProvider(
    String swapId,
  ) : this._internal(
          (ref) => hasUserRatedSwap(
            ref as HasUserRatedSwapRef,
            swapId,
          ),
          from: hasUserRatedSwapProvider,
          name: r'hasUserRatedSwapProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasUserRatedSwapHash,
          dependencies: HasUserRatedSwapFamily._dependencies,
          allTransitiveDependencies:
              HasUserRatedSwapFamily._allTransitiveDependencies,
          swapId: swapId,
        );

  HasUserRatedSwapProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.swapId,
  }) : super.internal();

  final String swapId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasUserRatedSwapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasUserRatedSwapProvider._internal(
        (ref) => create(ref as HasUserRatedSwapRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        swapId: swapId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasUserRatedSwapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasUserRatedSwapProvider && other.swapId == swapId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, swapId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasUserRatedSwapRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `swapId` of this provider.
  String get swapId;
}

class _HasUserRatedSwapProviderElement
    extends AutoDisposeFutureProviderElement<bool> with HasUserRatedSwapRef {
  _HasUserRatedSwapProviderElement(super.provider);

  @override
  String get swapId => (origin as HasUserRatedSwapProvider).swapId;
}

String _$swapsNeedingRatingHash() =>
    r'edee113db7c67c12833aa3ebcab47425f0d5a790';

/// Get swaps that need rating (completed but not yet rated by current user)
///
/// Copied from [swapsNeedingRating].
@ProviderFor(swapsNeedingRating)
final swapsNeedingRatingProvider =
    AutoDisposeProvider<List<SwapModel>>.internal(
  swapsNeedingRating,
  name: r'swapsNeedingRatingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$swapsNeedingRatingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SwapsNeedingRatingRef = AutoDisposeProviderRef<List<SwapModel>>;
String _$ratingNotifierHash() => r'2f8afe65cbb4eb0ab846b980b90a9fe07631dd9e';

abstract class _$RatingNotifier
    extends BuildlessAutoDisposeNotifier<RatingState> {
  late final String swapId;

  RatingState build(
    String swapId,
  );
}

/// Rating notifier for managing rating submission
///
/// Copied from [RatingNotifier].
@ProviderFor(RatingNotifier)
const ratingNotifierProvider = RatingNotifierFamily();

/// Rating notifier for managing rating submission
///
/// Copied from [RatingNotifier].
class RatingNotifierFamily extends Family<RatingState> {
  /// Rating notifier for managing rating submission
  ///
  /// Copied from [RatingNotifier].
  const RatingNotifierFamily();

  /// Rating notifier for managing rating submission
  ///
  /// Copied from [RatingNotifier].
  RatingNotifierProvider call(
    String swapId,
  ) {
    return RatingNotifierProvider(
      swapId,
    );
  }

  @override
  RatingNotifierProvider getProviderOverride(
    covariant RatingNotifierProvider provider,
  ) {
    return call(
      provider.swapId,
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
  String? get name => r'ratingNotifierProvider';
}

/// Rating notifier for managing rating submission
///
/// Copied from [RatingNotifier].
class RatingNotifierProvider
    extends AutoDisposeNotifierProviderImpl<RatingNotifier, RatingState> {
  /// Rating notifier for managing rating submission
  ///
  /// Copied from [RatingNotifier].
  RatingNotifierProvider(
    String swapId,
  ) : this._internal(
          () => RatingNotifier()..swapId = swapId,
          from: ratingNotifierProvider,
          name: r'ratingNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ratingNotifierHash,
          dependencies: RatingNotifierFamily._dependencies,
          allTransitiveDependencies:
              RatingNotifierFamily._allTransitiveDependencies,
          swapId: swapId,
        );

  RatingNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.swapId,
  }) : super.internal();

  final String swapId;

  @override
  RatingState runNotifierBuild(
    covariant RatingNotifier notifier,
  ) {
    return notifier.build(
      swapId,
    );
  }

  @override
  Override overrideWith(RatingNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RatingNotifierProvider._internal(
        () => create()..swapId = swapId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        swapId: swapId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RatingNotifier, RatingState>
      createElement() {
    return _RatingNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RatingNotifierProvider && other.swapId == swapId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, swapId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RatingNotifierRef on AutoDisposeNotifierProviderRef<RatingState> {
  /// The parameter `swapId` of this provider.
  String get swapId;
}

class _RatingNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<RatingNotifier, RatingState>
    with RatingNotifierRef {
  _RatingNotifierProviderElement(super.provider);

  @override
  String get swapId => (origin as RatingNotifierProvider).swapId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
