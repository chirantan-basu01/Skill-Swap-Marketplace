// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'514bed3f78956d49e60dbc3200425abefc0de0e3';

/// Provider for SharedPreferences instance
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$onboardingSeenHash() => r'703e5bb7514b2fb64d0ab3e20d6b2dda066f3d09';

/// Provider for checking if onboarding has been seen
///
/// Copied from [onboardingSeen].
@ProviderFor(onboardingSeen)
final onboardingSeenProvider = AutoDisposeFutureProvider<bool>.internal(
  onboardingSeen,
  name: r'onboardingSeenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingSeenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OnboardingSeenRef = AutoDisposeFutureProviderRef<bool>;
String _$storageServiceHash() => r'ec9c39b67f8be81d9564645a66cae3b0fdccb373';

/// Provider for StorageService
///
/// Copied from [storageService].
@ProviderFor(storageService)
final storageServiceProvider =
    AutoDisposeFutureProvider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = AutoDisposeFutureProviderRef<StorageService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
