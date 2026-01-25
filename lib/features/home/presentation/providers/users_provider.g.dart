// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paginatedUsersNotifierHash() =>
    r'ddf1db1b8490dbf9226af67cb7d673ab2dde7e2b';

/// Paginated users notifier for infinite scroll lists
///
/// Copied from [PaginatedUsersNotifier].
@ProviderFor(PaginatedUsersNotifier)
final paginatedUsersNotifierProvider = AutoDisposeNotifierProvider<
    PaginatedUsersNotifier, PaginatedState<UserModel>>.internal(
  PaginatedUsersNotifier.new,
  name: r'paginatedUsersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paginatedUsersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaginatedUsersNotifier
    = AutoDisposeNotifier<PaginatedState<UserModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
