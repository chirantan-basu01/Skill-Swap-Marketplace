import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';

/// A widget that gates content behind email verification.
///
/// If the user's email is not verified, it either:
/// - Shows the [unverifiedFallback] widget if provided
/// - Redirects to the VerifyEmailScreen
///
/// Usage:
/// ```dart
/// VerificationGate(
///   child: MyProtectedContent(),
/// )
/// ```
class VerificationGate extends ConsumerWidget {
  /// The content to show when the user is verified
  final Widget child;

  /// Optional widget to show when user is not verified
  /// If null, redirects to VerifyEmailScreen
  final Widget? unverifiedFallback;

  /// If true, allows Google-signed users through without verification
  /// (Google already verifies emails)
  final bool allowGoogleUsers;

  const VerificationGate({
    super.key,
    required this.child,
    this.unverifiedFallback,
    this.allowGoogleUsers = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      // Not authenticated - redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        const LoginRoute().go(context);
      });
      return const SizedBox.shrink();
    }

    // Check if user is verified
    final isEmailVerified = currentUser.emailVerified;

    // Check if user signed in with Google (provider data contains google.com)
    final isGoogleUser = currentUser.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );

    // Allow through if verified OR if Google user and allowGoogleUsers is true
    if (isEmailVerified || (isGoogleUser && allowGoogleUsers)) {
      return child;
    }

    // User not verified
    if (unverifiedFallback != null) {
      return unverifiedFallback!;
    }

    // Redirect to verification screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const VerifyEmailRoute().go(context);
    });

    return const SizedBox.shrink();
  }
}

/// A simpler version that just checks verification status without redirecting
class VerificationCheck extends ConsumerWidget {
  /// Widget to show when verified
  final Widget verified;

  /// Widget to show when not verified
  final Widget unverified;

  const VerificationCheck({
    super.key,
    required this.verified,
    required this.unverified,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      return unverified;
    }

    final isEmailVerified = currentUser.emailVerified;
    final isGoogleUser = currentUser.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );

    if (isEmailVerified || isGoogleUser) {
      return verified;
    }

    return unverified;
  }
}