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
String _$userSwapsHash() => r'35640dd7642a0839d10a00e06c23b38e9a223fa2';

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
    r'80798f57c9c50142e844f1b2989a3b32757fd5a9';

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
    r'd80f022ef8c3230d1179e71a29b046bc420991d8';

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
String _$activeSwapsHash() => r'8231d9075f0a436e5f3e4b783add0f0fa1bcb59c';

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
String _$completedSwapsHash() => r'00948277f065a527db8369e11ab554d3f1adb558';

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
