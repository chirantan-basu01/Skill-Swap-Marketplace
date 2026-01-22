import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/notifications/data/repositories/notification_repository.dart';
import 'package:skill_swap_marketplace/features/notifications/domain/models/notification_model.dart';

/// Provider for the notification repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

/// Provider for user's notifications stream
final userNotificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.valueOrNull?.uid;

  if (userId == null) {
    return Stream.value([]);
  }

  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUserNotifications(userId);
});

/// Provider for unread notification count
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.valueOrNull?.uid;

  if (userId == null) {
    return Stream.value(0);
  }

  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount(userId);
});

/// Notifier for notification actions
class NotificationActionsNotifier extends StateNotifier<NotificationActionsState> {
  final NotificationRepository _repo;
  final String? _userId;

  NotificationActionsNotifier(this._repo, this._userId)
      : super(const NotificationActionsState());

  Future<void> markAsRead(String notificationId) async {
    await _repo.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    if (_userId == null) return;

    state = state.copyWith(isLoading: true);
    final result = await _repo.markAllAsRead(_userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repo.deleteNotification(notificationId);
  }

  Future<void> deleteAllNotifications() async {
    if (_userId == null) return;

    state = state.copyWith(isLoading: true);
    final result = await _repo.deleteAllNotifications(_userId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (_) => state = state.copyWith(isLoading: false),
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// State for notification actions
class NotificationActionsState {
  final bool isLoading;
  final String? error;

  const NotificationActionsState({
    this.isLoading = false,
    this.error,
  });

  NotificationActionsState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return NotificationActionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider for notification actions
final notificationActionsProvider =
    StateNotifierProvider<NotificationActionsNotifier, NotificationActionsState>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.valueOrNull?.uid;

  return NotificationActionsNotifier(repo, userId);
});

/// Helper to create notifications from various events
class NotificationHelper {
  final NotificationRepository _repo;

  NotificationHelper(this._repo);

  /// Create swap request notification
  Future<void> onSwapRequest({
    required String toUserId,
    required String fromUserId,
    required String fromUserName,
    String? fromUserPhoto,
    required String swapId,
    required String skillName,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.swapRequest,
      title: 'New Swap Request',
      body: '$fromUserName wants to learn $skillName from you',
      swapId: swapId,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserPhoto: fromUserPhoto,
    );
  }

  /// Create swap accepted notification
  Future<void> onSwapAccepted({
    required String toUserId,
    required String fromUserId,
    required String fromUserName,
    String? fromUserPhoto,
    required String swapId,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.swapAccepted,
      title: 'Swap Accepted!',
      body: '$fromUserName accepted your swap request',
      swapId: swapId,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserPhoto: fromUserPhoto,
    );
  }

  /// Create swap declined notification
  Future<void> onSwapDeclined({
    required String toUserId,
    required String fromUserName,
    required String swapId,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.swapDeclined,
      title: 'Swap Declined',
      body: '$fromUserName declined your swap request',
      swapId: swapId,
      fromUserName: fromUserName,
    );
  }

  /// Create session scheduled notification
  Future<void> onSessionScheduled({
    required String toUserId,
    required String fromUserName,
    required String swapId,
    required String dateTime,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.sessionScheduled,
      title: 'Session Scheduled',
      body: 'Your session with $fromUserName is set for $dateTime',
      swapId: swapId,
      fromUserName: fromUserName,
    );
  }

  /// Create session completed notification
  Future<void> onSessionCompleted({
    required String toUserId,
    required String fromUserName,
    required String swapId,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.sessionCompleted,
      title: 'Session Completed!',
      body: 'Your session with $fromUserName has ended. Rate your experience!',
      swapId: swapId,
      fromUserName: fromUserName,
    );
  }

  /// Create new rating notification
  Future<void> onNewRating({
    required String toUserId,
    required String fromUserName,
    required int stars,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.newRating,
      title: 'New Rating Received',
      body: '$fromUserName gave you $stars stars!',
      fromUserName: fromUserName,
    );
  }

  /// Create credits received notification
  Future<void> onCreditsReceived({
    required String toUserId,
    required double credits,
    required String fromUserName,
  }) async {
    await _repo.createNotification(
      userId: toUserId,
      type: NotificationType.creditsReceived,
      title: 'Credits Received',
      body: 'You earned ${credits.toStringAsFixed(1)} credits from your session with $fromUserName',
      fromUserName: fromUserName,
    );
  }
}

/// Provider for notification helper
final notificationHelperProvider = Provider<NotificationHelper>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationHelper(repo);
});