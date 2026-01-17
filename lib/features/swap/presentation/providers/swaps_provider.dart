import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';
import 'package:skill_swap_marketplace/features/swap/data/repositories/swap_repository_impl.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/domain/repositories/swap_repository.dart';

part 'swaps_provider.g.dart';

/// Provider for the swap repository
@Riverpod(keepAlive: true)
SwapRepository swapRepository(SwapRepositoryRef ref) {
  return SwapRepositoryImpl();
}

/// Provider for all user swaps stream
@riverpod
Stream<List<SwapModel>> userSwaps(UserSwapsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final swapRepo = ref.watch(swapRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return swapRepo.getUserSwaps(currentUser.uid);
}

/// Provider for incoming swap requests (where user is provider)
@riverpod
Stream<List<SwapModel>> incomingSwapRequests(IncomingSwapRequestsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final swapRepo = ref.watch(swapRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return swapRepo.getIncomingRequests(currentUser.uid);
}

/// Provider for outgoing swap requests (where user is requester)
@riverpod
Stream<List<SwapModel>> outgoingSwapRequests(OutgoingSwapRequestsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final swapRepo = ref.watch(swapRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return swapRepo.getOutgoingRequests(currentUser.uid);
}

/// Provider for active swaps
@riverpod
Stream<List<SwapModel>> activeSwaps(ActiveSwapsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final swapRepo = ref.watch(swapRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return swapRepo.getActiveSwaps(currentUser.uid);
}

/// Provider for completed swaps
@riverpod
Stream<List<SwapModel>> completedSwaps(CompletedSwapsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final swapRepo = ref.watch(swapRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return Stream.value([]);
  }

  return swapRepo.getCompletedSwaps(currentUser.uid);
}

/// Swap request state
enum SwapRequestStatus {
  initial,
  loading,
  success,
  error,
}

class SwapRequestState {
  final SwapRequestStatus status;
  final Failure? error;
  final String? errorMessage;

  // Form data
  final SkillExchange? selectedSkillOffered;
  final SkillExchange? selectedSkillWanted;
  final double duration;
  final String message;

  const SwapRequestState({
    this.status = SwapRequestStatus.initial,
    this.error,
    this.errorMessage,
    this.selectedSkillOffered,
    this.selectedSkillWanted,
    this.duration = 1.0,
    this.message = '',
  });

  double get creditAmount => duration; // 1 credit per hour

  bool get canSubmit =>
      selectedSkillOffered != null &&
      selectedSkillWanted != null &&
      duration > 0;

  SwapRequestState copyWith({
    SwapRequestStatus? status,
    Failure? error,
    String? errorMessage,
    bool clearError = false,
    SkillExchange? selectedSkillOffered,
    SkillExchange? selectedSkillWanted,
    double? duration,
    String? message,
  }) {
    return SwapRequestState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedSkillOffered: selectedSkillOffered ?? this.selectedSkillOffered,
      selectedSkillWanted: selectedSkillWanted ?? this.selectedSkillWanted,
      duration: duration ?? this.duration,
      message: message ?? this.message,
    );
  }
}

/// Swap request notifier for creating new swap requests
@riverpod
class SwapRequestNotifier extends _$SwapRequestNotifier {
  @override
  SwapRequestState build() {
    return const SwapRequestState();
  }

  SwapRepository get _swapRepo => ref.read(swapRepositoryProvider);

  void selectSkillOffered(SkillExchange skill) {
    state = state.copyWith(selectedSkillOffered: skill);
  }

  void selectSkillWanted(SkillExchange skill) {
    state = state.copyWith(selectedSkillWanted: skill);
  }

  void updateDuration(double duration) {
    state = state.copyWith(duration: duration);
  }

  void updateMessage(String message) {
    state = state.copyWith(message: message);
  }

  Future<SwapModel?> submitRequest({
    required UserModel provider,
  }) async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: SwapRequestStatus.error,
        errorMessage: 'Please select skills and duration',
      );
      return null;
    }

    state = state.copyWith(status: SwapRequestStatus.loading, clearError: true);

    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    final userProfile = ref.read(currentUserProfileProvider).valueOrNull;

    if (currentUser == null || userProfile == null) {
      state = state.copyWith(
        status: SwapRequestStatus.error,
        errorMessage: 'You must be logged in to request a swap',
      );
      return null;
    }

    // Check for existing pending swap
    final hasPending = await _swapRepo.hasPendingSwapWith(
      currentUser.uid,
      provider.uid,
    );

    final hasPendingResult = hasPending.fold(
      (failure) => false,
      (value) => value,
    );

    if (hasPendingResult) {
      state = state.copyWith(
        status: SwapRequestStatus.error,
        errorMessage: 'You already have a pending request with this user',
      );
      return null;
    }

    final now = DateTime.now();
    final swap = SwapModel(
      id: '', // Will be set by repository
      requesterId: currentUser.uid,
      requesterName: userProfile.displayName,
      requesterPhoto: userProfile.photoUrl,
      providerId: provider.uid,
      providerName: provider.displayName,
      providerPhoto: provider.photoUrl,
      requesterOffers: state.selectedSkillOffered!,
      requesterWants: state.selectedSkillWanted!,
      duration: state.duration,
      creditAmount: state.creditAmount,
      message: state.message,
      status: SwapStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _swapRepo.createSwap(swap);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: SwapRequestStatus.error,
          error: failure,
          errorMessage: failure.message,
        );
        return null;
      },
      (createdSwap) {
        state = state.copyWith(status: SwapRequestStatus.success);
        return createdSwap;
      },
    );
  }

  void reset() {
    state = const SwapRequestState();
  }
}

/// Swap actions notifier for managing swap status changes
@riverpod
class SwapActionsNotifier extends _$SwapActionsNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  SwapRepository get _swapRepo => ref.read(swapRepositoryProvider);

  Future<bool> acceptSwap(String swapId) async {
    state = const AsyncValue.loading();

    final result = await _swapRepo.acceptSwap(swapId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> declineSwap(String swapId) async {
    state = const AsyncValue.loading();

    final result = await _swapRepo.declineSwap(swapId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> cancelSwap(String swapId, String reason) async {
    state = const AsyncValue.loading();

    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = AsyncValue.error(
        const Failure(message: 'Not authenticated'),
        StackTrace.current,
      );
      return false;
    }

    final result = await _swapRepo.cancelSwap(
      swapId,
      currentUser.uid,
      reason.isNotEmpty ? reason : null,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> scheduleSession({
    required String swapId,
    required DateTime date,
    required String time,
    String? videoLink,
  }) async {
    state = const AsyncValue.loading();

    final result = await _swapRepo.scheduleSession(
      swapId: swapId,
      scheduledDate: date,
      scheduledTime: time,
      videoLink: videoLink,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> completeSwap(String swapId) async {
    state = const AsyncValue.loading();

    final result = await _swapRepo.completeSwap(swapId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}