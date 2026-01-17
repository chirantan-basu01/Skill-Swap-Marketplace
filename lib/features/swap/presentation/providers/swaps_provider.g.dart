// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swaps_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$swapRepositoryHash() => r'77abf03ec9164fd84cee06f5614dcba7bc9d88da';

/// Provider for the swap repository
///
/// Copied from [swapRepository].
@ProviderFor(swapRepository)
final swapRepositoryProvider = Provider<SwapRepository>.internal(
  swapRepository,
  name: r'swapRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$swapRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SwapRepositoryRef = ProviderRef<SwapRepository>;
String _$userSwapsHash() => r'c3d6a474cfc3e02f12d049569439b000ed663c6d';

/// Provider for all user swaps stream
///
/// Copied from [userSwaps].
@ProviderFor(userSwaps)
final userSwapsProvider = AutoDisposeStreamProvider<List<SwapModel>>.internal(
  userSwaps,
  name: r'userSwapsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSwapsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSwapsRef = AutoDisposeStreamProviderRef<List<SwapModel>>;
String _$incomingSwapRequestsHash() =>
    r'747be26d86bb5edac73449b933bd1d574f5dff51';

/// Provider for incoming swap requests (where user is provider)
///
/// Copied from [incomingSwapRequests].
@ProviderFor(incomingSwapRequests)
final incomingSwapRequestsProvider =
    AutoDisposeStreamProvider<List<SwapModel>>.internal(
  incomingSwapRequests,
  name: r'incomingSwapRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incomingSwapRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncomingSwapRequestsRef = AutoDisposeStreamProviderRef<List<SwapModel>>;
String _$outgoingSwapRequestsHash() =>
    r'1d7fad6501727cf574b5a9fd651eaa3dd69bb85b';

/// Provider for outgoing swap requests (where user is requester)
///
/// Copied from [outgoingSwapRequests].
@ProviderFor(outgoingSwapRequests)
final outgoingSwapRequestsProvider =
    AutoDisposeStreamProvider<List<SwapModel>>.internal(
  outgoingSwapRequests,
  name: r'outgoingSwapRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outgoingSwapRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OutgoingSwapRequestsRef = AutoDisposeStreamProviderRef<List<SwapModel>>;
String _$activeSwapsHash() => r'7a9d82180dcc14cf275e2361c58bcb24c637afc3';

/// Provider for active swaps
///
/// Copied from [activeSwaps].
@ProviderFor(activeSwaps)
final activeSwapsProvider = AutoDisposeStreamProvider<List<SwapModel>>.internal(
  activeSwaps,
  name: r'activeSwapsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeSwapsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveSwapsRef = AutoDisposeStreamProviderRef<List<SwapModel>>;
String _$completedSwapsHash() => r'13e19de62c4c52782e2a062f25e422f5a74f587b';

/// Provider for completed swaps
///
/// Copied from [completedSwaps].
@ProviderFor(completedSwaps)
final completedSwapsProvider =
    AutoDisposeStreamProvider<List<SwapModel>>.internal(
  completedSwaps,
  name: r'completedSwapsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedSwapsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedSwapsRef = AutoDisposeStreamProviderRef<List<SwapModel>>;
String _$swapRequestNotifierHash() =>
    r'cd3fe7c57cbedd9dfdcf6831ec0f6eeb0590d429';

/// Swap request notifier for creating new swap requests
///
/// Copied from [SwapRequestNotifier].
@ProviderFor(SwapRequestNotifier)
final swapRequestNotifierProvider =
    AutoDisposeNotifierProvider<SwapRequestNotifier, SwapRequestState>.internal(
  SwapRequestNotifier.new,
  name: r'swapRequestNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$swapRequestNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SwapRequestNotifier = AutoDisposeNotifier<SwapRequestState>;
String _$swapActionsNotifierHash() =>
    r'cff0918ea9dc6a544ac8e6179a2b839138f9ec2b';

/// Swap actions notifier for managing swap status changes
///
/// Copied from [SwapActionsNotifier].
@ProviderFor(SwapActionsNotifier)
final swapActionsNotifierProvider =
    AutoDisposeNotifierProvider<SwapActionsNotifier, AsyncValue<void>>.internal(
  SwapActionsNotifier.new,
  name: r'swapActionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$swapActionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SwapActionsNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
