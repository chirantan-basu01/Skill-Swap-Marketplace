import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';

/// Provider for tracking resend cooldown
final _resendCooldownProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Provider for tracking verification check loading state
final _isCheckingProvider = StateProvider.autoDispose<bool>((ref) => false);

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen>
    with WidgetsBindingObserver {
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Auto-check verification when app resumes
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  void _startCooldownTimer() {
    ref.read(_resendCooldownProvider.notifier).state = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = ref.read(_resendCooldownProvider);
      if (current <= 1) {
        timer.cancel();
        ref.read(_resendCooldownProvider.notifier).state = 0;
      } else {
        ref.read(_resendCooldownProvider.notifier).state = current - 1;
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    final cooldown = ref.read(_resendCooldownProvider);
    if (cooldown > 0) return;

    final result = await ref
        .read(authNotifierProvider.notifier)
        .sendVerificationEmail();

    if (!mounted) return;

    if (result) {
      _startCooldownTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent! Check your inbox.'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send verification email. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _checkVerification() async {
    ref.read(_isCheckingProvider.notifier).state = true;

    final isVerified = await ref
        .read(authNotifierProvider.notifier)
        .reloadAndCheckVerification();

    if (!mounted) return;

    ref.read(_isCheckingProvider.notifier).state = false;

    if (isVerified) {
      // Email verified - proceed to profile setup
      const SetupBasicInfoRoute().go(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your inbox.'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  Future<void> _useDifferentEmail() async {
    // Sign out and go back to signup
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!mounted) return;
    const SignupRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    final email = currentUser?.email ?? 'your email';
    final cooldown = ref.watch(_resendCooldownProvider);
    final isChecking = ref.watch(_isCheckingProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          child: Column(
            children: [
              const Spacer(),

              // Email icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 64,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: Dimensions.xl),

              // Title
              const Text(
                'Verify your email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Subtitle with email
              Text(
                'We sent a verification link to',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.xs),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.md),

              // Instructions
              Text(
                'Click the link in your email to verify your account. '
                'If you don\'t see the email, check your spam folder.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // I've verified button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isChecking ? null : _checkVerification,
                  child: isChecking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : const Text('I\'ve verified my email'),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Resend email button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: cooldown > 0 ? null : _resendVerificationEmail,
                  child: Text(
                    cooldown > 0
                        ? 'Resend email (${cooldown}s)'
                        : 'Resend verification email',
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Use different email link
              TextButton(
                onPressed: _useDifferentEmail,
                child: const Text(
                  'Use a different email',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.lg),
            ],
          ),
        ),
      ),
    );
  }
}