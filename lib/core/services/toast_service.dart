import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';

/// Toast types for different message categories
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Global toast/snackbar service for showing notifications
class ToastService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Show a toast message
  static void show({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    // Clear any existing snackbars
    messenger.hideCurrentSnackBar();

    final config = _getToastConfig(type);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              config.icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        dismissDirection:
            dismissible ? DismissDirection.horizontal : DismissDirection.none,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Show a success toast
  static void success(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(
      message: message,
      type: ToastType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show an error toast
  static void error(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(
      message: message,
      type: ToastType.error,
      duration: const Duration(seconds: 4),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show a warning toast
  static void warning(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(
      message: message,
      type: ToastType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show an info toast
  static void info(String message, {String? actionLabel, VoidCallback? onAction}) {
    show(
      message: message,
      type: ToastType.info,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show a loading toast (persistent until dismissed)
  static void loading(String message) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.textSecondary,
        duration: const Duration(days: 1), // Persistent
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        dismissDirection: DismissDirection.none,
      ),
    );
  }

  /// Hide current toast
  static void hide() {
    messengerKey.currentState?.hideCurrentSnackBar();
  }

  /// Show a network error toast with retry action
  static void networkError({VoidCallback? onRetry}) {
    show(
      message: 'No internet connection',
      type: ToastType.error,
      duration: const Duration(seconds: 5),
      actionLabel: onRetry != null ? 'RETRY' : null,
      onAction: onRetry,
    );
  }

  /// Show a generic error toast with retry action
  static void genericError({VoidCallback? onRetry}) {
    show(
      message: 'Something went wrong',
      type: ToastType.error,
      duration: const Duration(seconds: 4),
      actionLabel: onRetry != null ? 'RETRY' : null,
      onAction: onRetry,
    );
  }

  static _ToastConfig _getToastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          icon: Icons.check_circle_outline,
          backgroundColor: AppColors.success,
        );
      case ToastType.error:
        return _ToastConfig(
          icon: Icons.error_outline,
          backgroundColor: AppColors.error,
        );
      case ToastType.warning:
        return _ToastConfig(
          icon: Icons.warning_amber_outlined,
          backgroundColor: AppColors.warning,
        );
      case ToastType.info:
        return _ToastConfig(
          icon: Icons.info_outline,
          backgroundColor: AppColors.primaryBlue,
        );
    }
  }
}

class _ToastConfig {
  final IconData icon;
  final Color backgroundColor;

  const _ToastConfig({
    required this.icon,
    required this.backgroundColor,
  });
}

/// Extension to easily show toasts from BuildContext
extension ToastExtension on BuildContext {
  void showSuccessToast(String message) => ToastService.success(message);
  void showErrorToast(String message) => ToastService.error(message);
  void showWarningToast(String message) => ToastService.warning(message);
  void showInfoToast(String message) => ToastService.info(message);
}

/// Mixin for StatefulWidget to easily show toasts
mixin ToastMixin<T extends StatefulWidget> on State<T> {
  void showSuccessToast(String message) => ToastService.success(message);
  void showErrorToast(String message) => ToastService.error(message);
  void showWarningToast(String message) => ToastService.warning(message);
  void showInfoToast(String message) => ToastService.info(message);
  void showLoadingToast(String message) => ToastService.loading(message);
  void hideToast() => ToastService.hide();
}
