import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Stream of auth state changes
  Stream<User?> get authStateChanges;

  /// Get the current user
  User? get currentUser;

  /// Sign up with email and password
  FutureEither<User> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with email and password
  FutureEither<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  FutureEither<User> signInWithGoogle();

  /// Send password reset email
  FutureVoid sendPasswordResetEmail(String email);

  /// Send email verification
  FutureVoid sendEmailVerification();

  /// Reload current user (to check email verification status)
  FutureVoid reloadUser();

  /// Sign out
  FutureVoid signOut();

  /// Delete account
  FutureVoid deleteAccount();
}