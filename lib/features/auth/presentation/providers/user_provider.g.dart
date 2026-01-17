// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'a908f5ef06d5284e9e4eb8d4528f86bf1275c22a';

/// Provider for the user repository
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$currentUserProfileHash() =>
    r'f9408e2bc974280329a5e26704e4a3488e040daa';

/// Provider for current user's profile stream
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider =
    AutoDisposeStreamProvider<UserModel?>.internal(
  currentUserProfile,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$isProfileCompleteHash() => r'62f6d05a03ea645fe41e831e91422542bfec3cf5';

/// Provider to check if profile setup is complete
/// Note: This is a FutureProvider, so it should NOT watch StreamProviders
/// to avoid "disposed during loading" errors. Account switching is handled
/// by invalidating this provider in signOut() and signIn() methods.
///
/// Copied from [isProfileComplete].
@ProviderFor(isProfileComplete)
final isProfileCompleteProvider = AutoDisposeFutureProvider<bool>.internal(
  isProfileComplete,
  name: r'isProfileCompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProfileCompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProfileCompleteRef = AutoDisposeFutureProviderRef<bool>;
String _$profileSetupNotifierHash() =>
    r'018649bc105991b15aae931eea99cf6f73ef5c65';

/// Profile setup notifier for managing the setup wizard
///
/// Copied from [ProfileSetupNotifier].
@ProviderFor(ProfileSetupNotifier)
final profileSetupNotifierProvider =
    NotifierProvider<ProfileSetupNotifier, ProfileSetupState>.internal(
  ProfileSetupNotifier.new,
  name: r'profileSetupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileSetupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileSetupNotifier = Notifier<ProfileSetupState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
