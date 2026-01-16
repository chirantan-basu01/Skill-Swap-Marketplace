import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/app_constants.dart';
import 'package:skill_swap_marketplace/core/constants/asset_constants.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/widgets/social_button.dart';

/// Providers for signup form state
final _obscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);
final _obscureConfirmPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final _acceptedTermsProvider = StateProvider.autoDispose<bool>((ref) => false);

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final obscurePassword = ref.watch(_obscurePasswordProvider);
    final obscureConfirmPassword = ref.watch(_obscureConfirmPasswordProvider);
    final acceptedTerms = ref.watch(_acceptedTermsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          child: _SignupForm(
            isLoading: isLoading,
            obscurePassword: obscurePassword,
            obscureConfirmPassword: obscureConfirmPassword,
            acceptedTerms: acceptedTerms,
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends ConsumerStatefulWidget {
  final bool isLoading;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptedTerms;

  const _SignupForm({
    required this.isLoading,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.acceptedTerms,
  });

  @override
  ConsumerState<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    if (!widget.acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await ref.read(authNotifierProvider.notifier).signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    _handleAuthResult();
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    _handleAuthResult();
  }

  void _handleAuthResult() {
    final authState = ref.read(authNotifierProvider);

    if (authState.status == AuthStatus.authenticated) {
      // New user - go to profile setup
      const SetupBasicInfoRoute().go(context);
    } else if (authState.status == AuthStatus.error && authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error!.message ?? 'An error occurred'),
          backgroundColor: AppColors.error,
        ),
      );
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  void _navigateToLogin() {
    const LoginRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Dimensions.xl),

          // Logo and title
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(Dimensions.radiusLg),
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    size: 48,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: Dimensions.md),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.xl),

          // Create account text
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.xs),
          const Text(
            'Start exchanging skills today',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Dimensions.lg),

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: Dimensions.md),

          // Password field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  ref.read(_obscurePasswordProvider.notifier).state =
                      !widget.obscurePassword;
                },
              ),
            ),
            obscureText: widget.obscurePassword,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: Dimensions.md),

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  ref.read(_obscureConfirmPasswordProvider.notifier).state =
                      !widget.obscureConfirmPassword;
                },
              ),
            ),
            obscureText: widget.obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _signUpWithEmail(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: Dimensions.md),

          // Terms checkbox
          Row(
            children: [
              Checkbox(
                value: widget.acceptedTerms,
                onChanged: (value) {
                  ref.read(_acceptedTermsProvider.notifier).state =
                      value ?? false;
                },
                activeColor: AppColors.primaryBlue,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(_acceptedTermsProvider.notifier).state =
                        !widget.acceptedTerms;
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.lg),

          // Sign up button
          ElevatedButton(
            onPressed: widget.isLoading ? null : _signUpWithEmail,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textOnPrimary,
                    ),
                  )
                : const Text('Create Account'),
          ),
          const SizedBox(height: Dimensions.lg),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.md,
                ),
                child: Text(
                  'or',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: Dimensions.lg),

          // Google sign in
          SocialButton(
            onPressed: widget.isLoading ? null : _signInWithGoogle,
            svgPath: AssetPaths.googleLogo,
            label: 'Continue with Google',
          ),
          const SizedBox(height: Dimensions.lg),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: _navigateToLogin,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}