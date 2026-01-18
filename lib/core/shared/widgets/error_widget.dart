import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Generic error widget for displaying error states
class AppErrorWidget extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Optional error details (for debugging)
  final String? details;

  /// Optional retry callback
  final VoidCallback? onRetry;

  /// Optional secondary action
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  /// Icon to display
  final IconData icon;

  /// Size variant
  final ErrorWidgetSize size;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.icon = Icons.error_outline,
    this.size = ErrorWidgetSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(size);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(config.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: config.iconContainerSize,
              height: config.iconContainerSize,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: config.iconSize,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: config.spacing),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: config.messageSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Details (if provided)
            if (details != null) ...[
              SizedBox(height: config.spacing / 2),
              Text(
                details!,
                style: TextStyle(
                  fontSize: config.detailsSize,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Retry button
            if (onRetry != null) ...[
              SizedBox(height: config.spacing * 1.5),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: config.buttonPaddingH,
                    vertical: config.buttonPaddingV,
                  ),
                ),
              ),
            ],

            // Secondary action
            if (secondaryActionLabel != null && onSecondaryAction != null) ...[
              SizedBox(height: config.spacing / 2),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(secondaryActionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ErrorWidgetConfig _getConfig(ErrorWidgetSize size) {
    switch (size) {
      case ErrorWidgetSize.small:
        return const _ErrorWidgetConfig(
          padding: Dimensions.md,
          iconContainerSize: 48,
          iconSize: 24,
          messageSize: 14,
          detailsSize: 12,
          spacing: 8,
          buttonPaddingH: 16,
          buttonPaddingV: 8,
        );
      case ErrorWidgetSize.medium:
        return const _ErrorWidgetConfig(
          padding: Dimensions.xl,
          iconContainerSize: 64,
          iconSize: 32,
          messageSize: 16,
          detailsSize: 13,
          spacing: 12,
          buttonPaddingH: 24,
          buttonPaddingV: 12,
        );
      case ErrorWidgetSize.large:
        return const _ErrorWidgetConfig(
          padding: Dimensions.xxl,
          iconContainerSize: 80,
          iconSize: 40,
          messageSize: 18,
          detailsSize: 14,
          spacing: 16,
          buttonPaddingH: 32,
          buttonPaddingV: 14,
        );
    }
  }
}

enum ErrorWidgetSize { small, medium, large }

class _ErrorWidgetConfig {
  final double padding;
  final double iconContainerSize;
  final double iconSize;
  final double messageSize;
  final double detailsSize;
  final double spacing;
  final double buttonPaddingH;
  final double buttonPaddingV;

  const _ErrorWidgetConfig({
    required this.padding,
    required this.iconContainerSize,
    required this.iconSize,
    required this.messageSize,
    required this.detailsSize,
    required this.spacing,
    required this.buttonPaddingH,
    required this.buttonPaddingV,
  });
}

// Pre-built error widgets for common scenarios

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.wifi_off,
      message: 'No internet connection',
      details: 'Please check your connection and try again',
      onRetry: onRetry,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? errorCode;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.cloud_off,
      message: 'Something went wrong',
      details: errorCode != null
          ? 'Error code: $errorCode\nPlease try again later'
          : 'Our servers are having issues.\nPlease try again later',
      onRetry: onRetry,
    );
  }
}

/// Authentication error widget
class AuthErrorWidget extends StatelessWidget {
  final VoidCallback? onSignIn;

  const AuthErrorWidget({
    super.key,
    this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.lock_outline,
      message: 'Session expired',
      details: 'Please sign in again to continue',
      onRetry: onSignIn,
    );
  }
}

/// Permission denied error widget
class PermissionErrorWidget extends StatelessWidget {
  final String? permissionType;
  final VoidCallback? onSettings;

  const PermissionErrorWidget({
    super.key,
    this.permissionType,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.block,
      message: 'Permission required',
      details: permissionType != null
          ? '$permissionType access is needed for this feature'
          : 'This feature requires additional permissions',
      onRetry: onSettings,
      secondaryActionLabel: onSettings != null ? 'Open Settings' : null,
      onSecondaryAction: onSettings,
    );
  }
}

/// Generic load failure widget
class LoadFailureWidget extends StatelessWidget {
  final String? itemType;
  final VoidCallback? onRetry;

  const LoadFailureWidget({
    super.key,
    this.itemType,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      icon: Icons.error_outline,
      message: 'Failed to load ${itemType ?? 'data'}',
      details: 'Something went wrong while loading.\nTap to try again',
      onRetry: onRetry,
    );
  }
}

/// Inline error widget (smaller, for use within cards/sections)
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }
}

/// Error banner (for top of screen notifications)
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.screenPaddingH,
            vertical: 12,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
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
              if (onAction != null && actionLabel != null) ...[
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 20),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
