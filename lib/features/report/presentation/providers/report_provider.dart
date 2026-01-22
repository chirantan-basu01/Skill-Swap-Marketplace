import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/utils/rate_limiter.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/report/data/repositories/report_repository_impl.dart';
import 'package:skill_swap_marketplace/features/report/domain/models/report_model.dart';
import 'package:skill_swap_marketplace/features/report/domain/repositories/report_repository.dart';

part 'report_provider.g.dart';

/// Provider for report repository
@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) {
  return ReportRepositoryImpl();
}

/// State for report submission
class ReportState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ReportState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ReportState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool clearError = false,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for submitting reports
@riverpod
class ReportNotifier extends _$ReportNotifier {
  @override
  ReportState build() {
    return const ReportState();
  }

  Future<bool> submitReport({
    required String reportedUserId,
    required String reportedUserName,
    required ReportReason reason,
    required String description,
    String? swapId,
    String? messageId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Check rate limit
    final rateLimitResult = await ref.read(rateLimiterProvider).checkAndRecord(
      RateLimitAction.submitReport,
    );

    if (!rateLimitResult.isAllowed) {
      state = state.copyWith(
        isLoading: false,
        error: rateLimitResult.message,
      );
      return false;
    }

    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'You must be logged in to submit a report',
      );
      return false;
    }

    final reportRepo = ref.read(reportRepositoryProvider);

    // Check if already reported
    final hasReported = await reportRepo.hasReportedUser(
      reporterId: currentUser.uid,
      reportedUserId: reportedUserId,
    );

    final alreadyReported = hasReported.fold(
      (failure) => false,
      (reported) => reported,
    );

    if (alreadyReported) {
      state = state.copyWith(
        isLoading: false,
        error: 'You have already reported this user',
      );
      return false;
    }

    final result = await reportRepo.submitReport(
      reporterId: currentUser.uid,
      reporterName: currentUser.displayName ?? 'Anonymous',
      reportedUserId: reportedUserId,
      reportedUserName: reportedUserName,
      reason: reason,
      description: description,
      swapId: swapId,
      messageId: messageId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to submit report',
        );
        return false;
      },
      (report) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        return true;
      },
    );
  }

  void reset() {
    state = const ReportState();
  }
}

/// State for block user functionality
class BlockUserState {
  final bool isLoading;
  final Set<String> blockedUsers;
  final String? error;

  const BlockUserState({
    this.isLoading = false,
    this.blockedUsers = const {},
    this.error,
  });

  BlockUserState copyWith({
    bool? isLoading,
    Set<String>? blockedUsers,
    String? error,
    bool clearError = false,
  }) {
    return BlockUserState(
      isLoading: isLoading ?? this.isLoading,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for blocking/unblocking users
@riverpod
class BlockUserNotifier extends _$BlockUserNotifier {
  @override
  BlockUserState build() {
    _loadBlockedUsers();
    return const BlockUserState(isLoading: true);
  }

  Future<void> _loadBlockedUsers() async {
    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final reportRepo = ref.read(reportRepositoryProvider);
    final result = await reportRepo.getBlockedUsers(currentUser.uid);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (blockedUsers) {
        state = state.copyWith(
          isLoading: false,
          blockedUsers: blockedUsers.toSet(),
        );
      },
    );
  }

  bool isBlocked(String userId) {
    return state.blockedUsers.contains(userId);
  }

  Future<bool> blockUser(String blockedUserId) async {
    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(error: 'You must be logged in to block users');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final reportRepo = ref.read(reportRepositoryProvider);
    final result = await reportRepo.blockUser(
      userId: currentUser.uid,
      blockedUserId: blockedUserId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to block user',
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          blockedUsers: {...state.blockedUsers, blockedUserId},
        );
        return true;
      },
    );
  }

  Future<bool> unblockUser(String blockedUserId) async {
    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(error: 'You must be logged in to unblock users');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final reportRepo = ref.read(reportRepositoryProvider);
    final result = await reportRepo.unblockUser(
      userId: currentUser.uid,
      blockedUserId: blockedUserId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message ?? 'Failed to unblock user',
        );
        return false;
      },
      (_) {
        final newBlocked = Set<String>.from(state.blockedUsers);
        newBlocked.remove(blockedUserId);
        state = state.copyWith(
          isLoading: false,
          blockedUsers: newBlocked,
        );
        return true;
      },
    );
  }
}

/// Provider to check if a specific user is blocked
@riverpod
bool isUserBlocked(IsUserBlockedRef ref, String userId) {
  final blockState = ref.watch(blockUserNotifierProvider);
  return blockState.blockedUsers.contains(userId);
}