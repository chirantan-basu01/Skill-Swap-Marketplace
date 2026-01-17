// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletStatsHash() => r'd50c906f8da29280f2a34723fcff1e6222b2fb43';

/// Provider for user's wallet stats
///
/// Copied from [walletStats].
@ProviderFor(walletStats)
final walletStatsProvider = AutoDisposeStreamProvider<WalletStats>.internal(
  walletStats,
  name: r'walletStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletStatsRef = AutoDisposeStreamProviderRef<WalletStats>;
String _$creditBalanceHash() => r'9383b8a8a0cf26c109e9c334c4ae2818407833a9';

/// Provider for user's credit balance
///
/// Copied from [creditBalance].
@ProviderFor(creditBalance)
final creditBalanceProvider = AutoDisposeStreamProvider<double>.internal(
  creditBalance,
  name: r'creditBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creditBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreditBalanceRef = AutoDisposeStreamProviderRef<double>;
String _$userTransactionsHash() => r'0d2eeb7784f3c546fc99143bc29fbf6cf332850b';

/// Provider for user's transactions
///
/// Copied from [userTransactions].
@ProviderFor(userTransactions)
final userTransactionsProvider =
    AutoDisposeStreamProvider<List<TransactionModel>>.internal(
  userTransactions,
  name: r'userTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserTransactionsRef
    = AutoDisposeStreamProviderRef<List<TransactionModel>>;
String _$groupedTransactionsHash() =>
    r'90e42b1452502345e8c6e390c54b58874d86be6c';

/// Provider for grouped transactions
///
/// Copied from [groupedTransactions].
@ProviderFor(groupedTransactions)
final groupedTransactionsProvider =
    AutoDisposeProvider<List<TransactionGroup>>.internal(
  groupedTransactions,
  name: r'groupedTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupedTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedTransactionsRef = AutoDisposeProviderRef<List<TransactionGroup>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
