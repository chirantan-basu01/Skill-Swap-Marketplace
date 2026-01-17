import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:skill_swap_marketplace/features/auth/domain/repositories/auth_repository.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/providers/wallet_provider.dart';

part 'auth_provider.g.dart';

/// Provider for the auth repository
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl();
}

/// Provider for auth state changes stream
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
}

/// Provider for current user
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUser;
}

/// Auth state enum for UI state management
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final Failure? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Failure? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// Auth notifier for managing auth operations
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Listen to auth state changes
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
            );
          } else {
            state = const AuthState(status: AuthStatus.unauthenticated);
          }
        },
        loading: () {
          state = const AuthState(status: AuthStatus.loading);
        },
        error: (error, stack) {
          state = AuthState(
            status: AuthStatus.error,
            error: Failure(message: error.toString()),
          );
        },
      );
    });

    return const AuthState();
  }

  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState(status: AuthStatus.loading);

    final result = await _authRepo.signUpWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = AuthState(
        status: AuthStatus.error,
        error: failure,
      ),
      (user) => state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState(status: AuthStatus.loading);

    final result = await _authRepo.signInWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = AuthState(
        status: AuthStatus.error,
        error: failure,
      ),
      (user) {
        // Invalidate user-dependent providers on sign-in for account switching
        ref.invalidate(isProfileCompleteProvider);
        ref.invalidate(currentUserProfileProvider);
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState(status: AuthStatus.loading);

    final result = await _authRepo.signInWithGoogle();

    result.fold(
      (failure) => state = AuthState(
        status: AuthStatus.error,
        error: failure,
      ),
      (user) {
        // Invalidate user-dependent providers on sign-in for account switching
        ref.invalidate(isProfileCompleteProvider);
        ref.invalidate(currentUserProfileProvider);
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final result = await _authRepo.sendPasswordResetEmail(email);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        error: failure,
      ),
      (_) => null,
    );
  }

  Future<void> signOut() async {
    // Invalidate user-dependent providers BEFORE signing out
    // This ensures streams are cancelled before auth context changes
    ref.invalidate(currentUserProfileProvider);
    ref.invalidate(isProfileCompleteProvider);
    ref.invalidate(userSwapsProvider);
    ref.invalidate(walletStatsProvider);
    ref.invalidate(creditBalanceProvider);
    ref.invalidate(userTransactionsProvider);
    ref.read(profileSetupNotifierProvider.notifier).reset();

    final result = await _authRepo.signOut();

    result.fold(
      (failure) => state = AuthState(
        status: AuthStatus.error,
        error: failure,
      ),
      (_) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}