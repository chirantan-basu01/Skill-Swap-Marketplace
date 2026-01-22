// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$swapByIdHash() => r'd74fe1a9e9ea45a71e2a16eac382f6f3c44eb31d';

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

/// Provider to fetch a single swap by ID
///
/// Copied from [swapById].
@ProviderFor(swapById)
const swapByIdProvider = SwapByIdFamily();

/// Provider to fetch a single swap by ID
///
/// Copied from [swapById].
class SwapByIdFamily extends Family<AsyncValue<SwapModel?>> {
  /// Provider to fetch a single swap by ID
  ///
  /// Copied from [swapById].
  const SwapByIdFamily();

  /// Provider to fetch a single swap by ID
  ///
  /// Copied from [swapById].
  SwapByIdProvider call(
    String swapId,
  ) {
    return SwapByIdProvider(
      swapId,
    );
  }

  @override
  SwapByIdProvider getProviderOverride(
    covariant SwapByIdProvider provider,
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
  String? get name => r'swapByIdProvider';
}

/// Provider to fetch a single swap by ID
///
/// Copied from [swapById].
class SwapByIdProvider extends AutoDisposeFutureProvider<SwapModel?> {
  /// Provider to fetch a single swap by ID
  ///
  /// Copied from [swapById].
  SwapByIdProvider(
    String swapId,
  ) : this._internal(
          (ref) => swapById(
            ref as SwapByIdRef,
            swapId,
          ),
          from: swapByIdProvider,
          name: r'swapByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$swapByIdHash,
          dependencies: SwapByIdFamily._dependencies,
          allTransitiveDependencies: SwapByIdFamily._allTransitiveDependencies,
          swapId: swapId,
        );

  SwapByIdProvider._internal(
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
    FutureOr<SwapModel?> Function(SwapByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SwapByIdProvider._internal(
        (ref) => create(ref as SwapByIdRef),
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
  AutoDisposeFutureProviderElement<SwapModel?> createElement() {
    return _SwapByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SwapByIdProvider && other.swapId == swapId;
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
mixin SwapByIdRef on AutoDisposeFutureProviderRef<SwapModel?> {
  /// The parameter `swapId` of this provider.
  String get swapId;
}

class _SwapByIdProviderElement
    extends AutoDisposeFutureProviderElement<SwapModel?> with SwapByIdRef {
  _SwapByIdProviderElement(super.provider);

  @override
  String get swapId => (origin as SwapByIdProvider).swapId;
}

String _$swapStreamHash() => r'718ca9b0c8485850b587f1cd9263e030c878045a';

/// Stream provider for real-time swap updates
///
/// Copied from [swapStream].
@ProviderFor(swapStream)
const swapStreamProvider = SwapStreamFamily();

/// Stream provider for real-time swap updates
///
/// Copied from [swapStream].
class SwapStreamFamily extends Family<AsyncValue<SwapModel?>> {
  /// Stream provider for real-time swap updates
  ///
  /// Copied from [swapStream].
  const SwapStreamFamily();

  /// Stream provider for real-time swap updates
  ///
  /// Copied from [swapStream].
  SwapStreamProvider call(
    String swapId,
  ) {
    return SwapStreamProvider(
      swapId,
    );
  }

  @override
  SwapStreamProvider getProviderOverride(
    covariant SwapStreamProvider provider,
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
  String? get name => r'swapStreamProvider';
}

/// Stream provider for real-time swap updates
///
/// Copied from [swapStream].
class SwapStreamProvider extends AutoDisposeStreamProvider<SwapModel?> {
  /// Stream provider for real-time swap updates
  ///
  /// Copied from [swapStream].
  SwapStreamProvider(
    String swapId,
  ) : this._internal(
          (ref) => swapStream(
            ref as SwapStreamRef,
            swapId,
          ),
          from: swapStreamProvider,
          name: r'swapStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$swapStreamHash,
          dependencies: SwapStreamFamily._dependencies,
          allTransitiveDependencies:
              SwapStreamFamily._allTransitiveDependencies,
          swapId: swapId,
        );

  SwapStreamProvider._internal(
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
    Stream<SwapModel?> Function(SwapStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SwapStreamProvider._internal(
        (ref) => create(ref as SwapStreamRef),
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
  AutoDisposeStreamProviderElement<SwapModel?> createElement() {
    return _SwapStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SwapStreamProvider && other.swapId == swapId;
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
mixin SwapStreamRef on AutoDisposeStreamProviderRef<SwapModel?> {
  /// The parameter `swapId` of this provider.
  String get swapId;
}

class _SwapStreamProviderElement
    extends AutoDisposeStreamProviderElement<SwapModel?> with SwapStreamRef {
  _SwapStreamProviderElement(super.provider);

  @override
  String get swapId => (origin as SwapStreamProvider).swapId;
}

String _$scheduleSessionNotifierHash() =>
    r'94512561f0f2780a0a4a804b759d78354f32ad65';

abstract class _$ScheduleSessionNotifier
    extends BuildlessAutoDisposeNotifier<ScheduleSessionState> {
  late final String swapId;

  ScheduleSessionState build(
    String swapId,
  );
}

/// Notifier for scheduling sessions
///
/// Copied from [ScheduleSessionNotifier].
@ProviderFor(ScheduleSessionNotifier)
const scheduleSessionNotifierProvider = ScheduleSessionNotifierFamily();

/// Notifier for scheduling sessions
///
/// Copied from [ScheduleSessionNotifier].
class ScheduleSessionNotifierFamily extends Family<ScheduleSessionState> {
  /// Notifier for scheduling sessions
  ///
  /// Copied from [ScheduleSessionNotifier].
  const ScheduleSessionNotifierFamily();

  /// Notifier for scheduling sessions
  ///
  /// Copied from [ScheduleSessionNotifier].
  ScheduleSessionNotifierProvider call(
    String swapId,
  ) {
    return ScheduleSessionNotifierProvider(
      swapId,
    );
  }

  @override
  ScheduleSessionNotifierProvider getProviderOverride(
    covariant ScheduleSessionNotifierProvider provider,
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
  String? get name => r'scheduleSessionNotifierProvider';
}

/// Notifier for scheduling sessions
///
/// Copied from [ScheduleSessionNotifier].
class ScheduleSessionNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ScheduleSessionNotifier, ScheduleSessionState> {
  /// Notifier for scheduling sessions
  ///
  /// Copied from [ScheduleSessionNotifier].
  ScheduleSessionNotifierProvider(
    String swapId,
  ) : this._internal(
          () => ScheduleSessionNotifier()..swapId = swapId,
          from: scheduleSessionNotifierProvider,
          name: r'scheduleSessionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scheduleSessionNotifierHash,
          dependencies: ScheduleSessionNotifierFamily._dependencies,
          allTransitiveDependencies:
              ScheduleSessionNotifierFamily._allTransitiveDependencies,
          swapId: swapId,
        );

  ScheduleSessionNotifierProvider._internal(
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
  ScheduleSessionState runNotifierBuild(
    covariant ScheduleSessionNotifier notifier,
  ) {
    return notifier.build(
      swapId,
    );
  }

  @override
  Override overrideWith(ScheduleSessionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScheduleSessionNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ScheduleSessionNotifier,
      ScheduleSessionState> createElement() {
    return _ScheduleSessionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleSessionNotifierProvider && other.swapId == swapId;
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
mixin ScheduleSessionNotifierRef
    on AutoDisposeNotifierProviderRef<ScheduleSessionState> {
  /// The parameter `swapId` of this provider.
  String get swapId;
}

class _ScheduleSessionNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ScheduleSessionNotifier,
        ScheduleSessionState> with ScheduleSessionNotifierRef {
  _ScheduleSessionNotifierProviderElement(super.provider);

  @override
  String get swapId => (origin as ScheduleSessionNotifierProvider).swapId;
}

String _$activeSessionNotifierHash() =>
    r'7443972b5088e1a0a47ce542a1be103404b9cd39';

abstract class _$ActiveSessionNotifier
    extends BuildlessAutoDisposeNotifier<ActiveSessionState> {
  late final String swapId;
  late final String currentUserId;

  ActiveSessionState build(
    String swapId,
    String currentUserId,
  );
}

/// Notifier for active session management
///
/// Copied from [ActiveSessionNotifier].
@ProviderFor(ActiveSessionNotifier)
const activeSessionNotifierProvider = ActiveSessionNotifierFamily();

/// Notifier for active session management
///
/// Copied from [ActiveSessionNotifier].
class ActiveSessionNotifierFamily extends Family<ActiveSessionState> {
  /// Notifier for active session management
  ///
  /// Copied from [ActiveSessionNotifier].
  const ActiveSessionNotifierFamily();

  /// Notifier for active session management
  ///
  /// Copied from [ActiveSessionNotifier].
  ActiveSessionNotifierProvider call(
    String swapId,
    String currentUserId,
  ) {
    return ActiveSessionNotifierProvider(
      swapId,
      currentUserId,
    );
  }

  @override
  ActiveSessionNotifierProvider getProviderOverride(
    covariant ActiveSessionNotifierProvider provider,
  ) {
    return call(
      provider.swapId,
      provider.currentUserId,
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
  String? get name => r'activeSessionNotifierProvider';
}

/// Notifier for active session management
///
/// Copied from [ActiveSessionNotifier].
class ActiveSessionNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ActiveSessionNotifier, ActiveSessionState> {
  /// Notifier for active session management
  ///
  /// Copied from [ActiveSessionNotifier].
  ActiveSessionNotifierProvider(
    String swapId,
    String currentUserId,
  ) : this._internal(
          () => ActiveSessionNotifier()
            ..swapId = swapId
            ..currentUserId = currentUserId,
          from: activeSessionNotifierProvider,
          name: r'activeSessionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeSessionNotifierHash,
          dependencies: ActiveSessionNotifierFamily._dependencies,
          allTransitiveDependencies:
              ActiveSessionNotifierFamily._allTransitiveDependencies,
          swapId: swapId,
          currentUserId: currentUserId,
        );

  ActiveSessionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.swapId,
    required this.currentUserId,
  }) : super.internal();

  final String swapId;
  final String currentUserId;

  @override
  ActiveSessionState runNotifierBuild(
    covariant ActiveSessionNotifier notifier,
  ) {
    return notifier.build(
      swapId,
      currentUserId,
    );
  }

  @override
  Override overrideWith(ActiveSessionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActiveSessionNotifierProvider._internal(
        () => create()
          ..swapId = swapId
          ..currentUserId = currentUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        swapId: swapId,
        currentUserId: currentUserId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ActiveSessionNotifier, ActiveSessionState>
      createElement() {
    return _ActiveSessionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveSessionNotifierProvider &&
        other.swapId == swapId &&
        other.currentUserId == currentUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, swapId.hashCode);
    hash = _SystemHash.combine(hash, currentUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveSessionNotifierRef
    on AutoDisposeNotifierProviderRef<ActiveSessionState> {
  /// The parameter `swapId` of this provider.
  String get swapId;

  /// The parameter `currentUserId` of this provider.
  String get currentUserId;
}

class _ActiveSessionNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ActiveSessionNotifier,
        ActiveSessionState> with ActiveSessionNotifierRef {
  _ActiveSessionNotifierProviderElement(super.provider);

  @override
  String get swapId => (origin as ActiveSessionNotifierProvider).swapId;
  @override
  String get currentUserId =>
      (origin as ActiveSessionNotifierProvider).currentUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
