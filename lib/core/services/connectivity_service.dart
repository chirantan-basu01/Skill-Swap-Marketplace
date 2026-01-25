import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Enum representing the connection status
enum ConnectionStatus {
  online,
  offline,
}

/// Provider for the Connectivity instance
@riverpod
Connectivity connectivity(Ref ref) {
  return Connectivity();
}

/// Stream provider that watches for connectivity changes
@riverpod
Stream<ConnectionStatus> connectivityStream(Ref ref) {
  final connectivity = ref.watch(connectivityProvider);

  return connectivity.onConnectivityChanged.map((results) {
    // Check if any of the results indicate an active connection
    final hasConnection = results.any((result) =>
        result != ConnectivityResult.none && result != ConnectivityResult.other);
    return hasConnection ? ConnectionStatus.online : ConnectionStatus.offline;
  });
}

/// Provider for the current connectivity status
/// Combines initial check with stream updates
@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  ConnectionStatus build() {
    // Start with online assumption while we check
    _checkInitialConnectivity();
    _listenToChanges();

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return ConnectionStatus.online;
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivity = ref.read(connectivityProvider);
    final results = await connectivity.checkConnectivity();
    final hasConnection = results.any((result) =>
        result != ConnectivityResult.none && result != ConnectivityResult.other);
    state = hasConnection ? ConnectionStatus.online : ConnectionStatus.offline;
  }

  void _listenToChanges() {
    final connectivity = ref.read(connectivityProvider);
    _subscription = connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((result) =>
          result != ConnectivityResult.none &&
          result != ConnectivityResult.other);
      state = hasConnection ? ConnectionStatus.online : ConnectionStatus.offline;
    });
  }

  /// Force a manual connectivity check
  Future<void> checkConnectivity() async {
    await _checkInitialConnectivity();
  }
}

/// Simple boolean provider for checking if online
@riverpod
bool isOnline(Ref ref) {
  final status = ref.watch(connectivityNotifierProvider);
  return status == ConnectionStatus.online;
}

/// Simple boolean provider for checking if offline
@riverpod
bool isOffline(Ref ref) {
  final status = ref.watch(connectivityNotifierProvider);
  return status == ConnectionStatus.offline;
}