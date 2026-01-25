import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/services/connectivity_service.dart';

/// A banner widget that shows when the device is offline
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isOffline ? 32 : 0,
      color: AppColors.warning,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isOffline ? 1.0 : 0.0,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'You are offline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that shows an offline banner at the top of the screen
class OfflineAwareScaffold extends ConsumerWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;

  const OfflineAwareScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// A small dot indicator for showing connection status
class ConnectionStatusDot extends ConsumerWidget {
  final double size;

  const ConnectionStatusDot({
    super.key,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityNotifierProvider);
    final isOnline = status == ConnectionStatus.online;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? AppColors.success : AppColors.error,
      ),
    );
  }
}

/// A widget that shows different content based on connection status
class OfflineAwareWidget extends ConsumerWidget {
  final Widget onlineChild;
  final Widget? offlineChild;
  final bool showOfflineBanner;

  const OfflineAwareWidget({
    super.key,
    required this.onlineChild,
    this.offlineChild,
    this.showOfflineBanner = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);

    if (isOffline && offlineChild != null) {
      return offlineChild!;
    }

    return onlineChild;
  }
}

/// A widget that wraps content and shows a snackbar when connectivity changes
class ConnectivityListener extends ConsumerStatefulWidget {
  final Widget child;
  final bool showSnackbar;

  const ConnectivityListener({
    super.key,
    required this.child,
    this.showSnackbar = true,
  });

  @override
  ConsumerState<ConnectivityListener> createState() =>
      _ConnectivityListenerState();
}

class _ConnectivityListenerState extends ConsumerState<ConnectivityListener> {
  ConnectionStatus? _previousStatus;

  @override
  Widget build(BuildContext context) {
    ref.listen<ConnectionStatus>(
      connectivityNotifierProvider,
      (previous, current) {
        // Only show snackbar if status actually changed and we have a previous state
        if (widget.showSnackbar &&
            _previousStatus != null &&
            _previousStatus != current) {
          _showConnectivitySnackbar(context, current);
        }
        _previousStatus = current;
      },
    );

    return widget.child;
  }

  void _showConnectivitySnackbar(BuildContext context, ConnectionStatus status) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (status == ConnectionStatus.offline) {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_off_outlined, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('You are offline. Some features may be limited.'),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cloud_done_outlined, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Back online'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}