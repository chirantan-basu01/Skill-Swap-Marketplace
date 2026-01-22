import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/services/notification_service.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';

part 'session_provider.g.dart';

/// Schedule session state
enum ScheduleSessionStatus {
  initial,
  loading,
  success,
  error,
}

/// State for scheduling a session
class ScheduleSessionState {
  final ScheduleSessionStatus status;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String videoLink;
  final String? errorMessage;

  const ScheduleSessionState({
    this.status = ScheduleSessionStatus.initial,
    this.selectedDate,
    this.selectedTime,
    this.videoLink = '',
    this.errorMessage,
  });

  bool get canSubmit =>
      selectedDate != null &&
      selectedTime != null &&
      selectedTime!.isNotEmpty;

  bool get hasVideoLink => videoLink.isNotEmpty;

  ScheduleSessionState copyWith({
    ScheduleSessionStatus? status,
    DateTime? selectedDate,
    String? selectedTime,
    String? videoLink,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScheduleSessionState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      videoLink: videoLink ?? this.videoLink,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier for scheduling sessions
@riverpod
class ScheduleSessionNotifier extends _$ScheduleSessionNotifier {
  @override
  ScheduleSessionState build(String swapId) {
    // Initialize with tomorrow's date as default
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return ScheduleSessionState(
      selectedDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, clearError: true);
  }

  void selectTime(String time) {
    state = state.copyWith(selectedTime: time, clearError: true);
  }

  void updateVideoLink(String link) {
    state = state.copyWith(videoLink: link, clearError: true);
  }

  /// Validate video link format
  bool isValidVideoLink(String link) {
    if (link.isEmpty) return true; // Empty is OK (optional)

    final uri = Uri.tryParse(link);
    if (uri == null || !uri.hasScheme) return false;

    // Accept common video call providers or any HTTPS link
    final host = uri.host.toLowerCase();
    return uri.scheme == 'https' ||
        host.contains('meet.google.com') ||
        host.contains('zoom.us') ||
        host.contains('teams.microsoft.com') ||
        host.contains('whereby.com') ||
        host.contains('discord.com');
  }

  /// Schedule the session
  Future<bool> scheduleSession() async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: ScheduleSessionStatus.error,
        errorMessage: 'Please select date and time',
      );
      return false;
    }

    // Validate video link if provided
    if (state.videoLink.isNotEmpty && !isValidVideoLink(state.videoLink)) {
      state = state.copyWith(
        status: ScheduleSessionStatus.error,
        errorMessage: 'Please enter a valid video call link',
      );
      return false;
    }

    state = state.copyWith(status: ScheduleSessionStatus.loading, clearError: true);

    final swapActionsNotifier = ref.read(swapActionsNotifierProvider.notifier);
    final result = await swapActionsNotifier.scheduleSession(
      swapId: swapId,
      date: state.selectedDate!,
      time: state.selectedTime!,
      videoLink: state.videoLink.isNotEmpty ? state.videoLink : null,
    );

    if (result) {
      // Schedule session reminders
      await _scheduleSessionReminders();

      state = state.copyWith(status: ScheduleSessionStatus.success);
      return true;
    } else {
      state = state.copyWith(
        status: ScheduleSessionStatus.error,
        errorMessage: 'Failed to schedule session. Please try again.',
      );
      return false;
    }
  }

  /// Schedule local notification reminders for the session
  Future<void> _scheduleSessionReminders() async {
    try {
      // Get swap details for notification content
      final swapRepo = ref.read(swapRepositoryProvider);
      final swapResult = await swapRepo.getSwapById(swapId);

      await swapResult.fold(
        (failure) async {
          debugPrint('Failed to get swap for notifications: ${failure.message}');
        },
        (swap) async {
          // Calculate session DateTime from selected date and time
          final (hour, minute) = parseTimeString(state.selectedTime!);
          final sessionDateTime = DateTime(
            state.selectedDate!.year,
            state.selectedDate!.month,
            state.selectedDate!.day,
            hour,
            minute,
          );

          // Get notification service
          final notificationService = ref.read(notificationServiceProvider);

          // Determine partner name and skill name for notification
          // Note: We don't know who the current user is here, so we'll use both names
          final partnerName = swap.providerName; // The person they're meeting
          final skillName = swap.requesterOffers.skillName; // The skill being taught

          // Schedule reminders
          await notificationService.scheduleSessionReminders(
            swapId: swapId,
            partnerName: partnerName,
            skillName: skillName,
            sessionDateTime: sessionDateTime,
          );

          debugPrint('Session reminders scheduled for $sessionDateTime');
        },
      );
    } catch (e) {
      debugPrint('Error scheduling session reminders: $e');
      // Don't fail the session scheduling if notifications fail
    }
  }

  void reset() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    state = ScheduleSessionState(
      selectedDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
    );
  }
}

/// Provider to fetch a single swap by ID
@riverpod
Future<SwapModel?> swapById(SwapByIdRef ref, String swapId) async {
  final swapRepo = ref.watch(swapRepositoryProvider);
  final result = await swapRepo.getSwapById(swapId);
  return result.fold(
    (failure) => null,
    (swap) => swap,
  );
}

/// Generate time slots for selection (every 15 minutes)
List<String> generateTimeSlots() {
  final slots = <String>[];
  for (int hour = 6; hour < 23; hour++) {
    for (int minute = 0; minute < 60; minute += 15) {
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final displayMinute = minute.toString().padLeft(2, '0');
      slots.add('$displayHour:$displayMinute $period');
    }
  }
  return slots;
}

/// Parse time string to hour and minute
(int hour, int minute) parseTimeString(String time) {
  final parts = time.split(' ');
  final timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);
  final period = parts[1];

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return (hour, minute);
}

/// Format DateTime for display
String formatScheduledDateTime(DateTime date, String time) {
  final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  final weekday = weekdays[date.weekday - 1];
  final month = months[date.month - 1];
  final day = date.day;

  return '$weekday, $month $day at $time';
}

// =============================================================================
// ACTIVE SESSION MANAGEMENT
// =============================================================================

/// Active session state enum
enum ActiveSessionStatus {
  /// Initial loading state
  loading,

  /// Waiting for partner to start
  waitingForPartner,

  /// Both users have started, session is active
  active,

  /// Session ended, navigating to rating
  ended,

  /// Session was cancelled or no-show
  cancelled,

  /// Error state
  error,
}

/// State for active session screen
class ActiveSessionState {
  final ActiveSessionStatus status;
  final SwapModel? swap;
  final DateTime? sessionStartTime;
  final bool currentUserStarted;
  final bool partnerStarted;
  final bool isEndingSession;
  final bool isMarkingNoShow;
  final bool showFiveMinuteWarning;
  final bool showTimeUpModal;
  final String? errorMessage;

  const ActiveSessionState({
    this.status = ActiveSessionStatus.loading,
    this.swap,
    this.sessionStartTime,
    this.currentUserStarted = false,
    this.partnerStarted = false,
    this.isEndingSession = false,
    this.isMarkingNoShow = false,
    this.showFiveMinuteWarning = false,
    this.showTimeUpModal = false,
    this.errorMessage,
  });

  bool get isSessionActive =>
      status == ActiveSessionStatus.active && sessionStartTime != null;

  bool get bothStarted => currentUserStarted && partnerStarted;

  int get sessionDurationMinutes => ((swap?.duration ?? 1.0) * 60).toInt();

  ActiveSessionState copyWith({
    ActiveSessionStatus? status,
    SwapModel? swap,
    DateTime? sessionStartTime,
    bool? currentUserStarted,
    bool? partnerStarted,
    bool? isEndingSession,
    bool? isMarkingNoShow,
    bool? showFiveMinuteWarning,
    bool? showTimeUpModal,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ActiveSessionState(
      status: status ?? this.status,
      swap: swap ?? this.swap,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      currentUserStarted: currentUserStarted ?? this.currentUserStarted,
      partnerStarted: partnerStarted ?? this.partnerStarted,
      isEndingSession: isEndingSession ?? this.isEndingSession,
      isMarkingNoShow: isMarkingNoShow ?? this.isMarkingNoShow,
      showFiveMinuteWarning: showFiveMinuteWarning ?? this.showFiveMinuteWarning,
      showTimeUpModal: showTimeUpModal ?? this.showTimeUpModal,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier for active session management
@riverpod
class ActiveSessionNotifier extends _$ActiveSessionNotifier {
  @override
  ActiveSessionState build(String swapId, String currentUserId) {
    // Load swap data
    _loadSwap();
    return const ActiveSessionState();
  }

  Future<void> _loadSwap() async {
    final swapRepo = ref.read(swapRepositoryProvider);
    final result = await swapRepo.getSwapById(swapId);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ActiveSessionStatus.error,
          errorMessage: failure.message ?? 'Failed to load session',
        );
      },
      (swap) {
        _updateStateFromSwap(swap);
      },
    );
  }

  void _updateStateFromSwap(SwapModel swap) {
    final session = swap.session;
    final isRequester = currentUserId == swap.requesterId;

    final currentUserStarted =
        isRequester ? (session?.requesterStarted ?? false) : (session?.providerStarted ?? false);
    final partnerStarted =
        isRequester ? (session?.providerStarted ?? false) : (session?.requesterStarted ?? false);

    ActiveSessionStatus newStatus;

    if (swap.status == SwapStatus.completed) {
      newStatus = ActiveSessionStatus.ended;
    } else if (swap.status == SwapStatus.cancelled) {
      newStatus = ActiveSessionStatus.cancelled;
    } else if (swap.status == SwapStatus.inProgress && session?.actualStartTime != null) {
      newStatus = ActiveSessionStatus.active;
    } else if (swap.status == SwapStatus.scheduled) {
      newStatus = ActiveSessionStatus.waitingForPartner;
    } else {
      newStatus = ActiveSessionStatus.loading;
    }

    state = state.copyWith(
      status: newStatus,
      swap: swap,
      sessionStartTime: session?.actualStartTime,
      currentUserStarted: currentUserStarted,
      partnerStarted: partnerStarted,
    );
  }

  /// Called when user taps "Start Session"
  Future<bool> startSession() async {
    if (state.currentUserStarted) return true;

    final swapRepo = ref.read(swapRepositoryProvider);
    final result = await swapRepo.startSession(swapId, currentUserId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message ?? 'Failed to start session',
        );
        return false;
      },
      (_) {
        state = state.copyWith(currentUserStarted: true, clearError: true);
        // Reload to check if both started
        _loadSwap();
        return true;
      },
    );
  }

  /// Called when user taps "End Session"
  Future<bool> endSession() async {
    state = state.copyWith(isEndingSession: true);

    final swapRepo = ref.read(swapRepositoryProvider);
    final result = await swapRepo.completeSwap(swapId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isEndingSession: false,
          errorMessage: failure.message ?? 'Failed to end session',
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          status: ActiveSessionStatus.ended,
          isEndingSession: false,
        );
        return true;
      },
    );
  }

  /// Called when user marks partner as no-show
  Future<bool> markAsNoShow() async {
    state = state.copyWith(isMarkingNoShow: true);

    final swapRepo = ref.read(swapRepositoryProvider);
    final result = await swapRepo.cancelSwap(
      swapId,
      currentUserId,
      'Partner did not show up',
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isMarkingNoShow: false,
          errorMessage: failure.message ?? 'Failed to mark as no-show',
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          status: ActiveSessionStatus.cancelled,
          isMarkingNoShow: false,
        );
        return true;
      },
    );
  }

  /// Called when 5 minutes remaining
  void showFiveMinuteWarning() {
    if (!state.showFiveMinuteWarning) {
      state = state.copyWith(showFiveMinuteWarning: true);
    }
  }

  /// Dismiss 5 minute warning
  void dismissFiveMinuteWarning() {
    state = state.copyWith(showFiveMinuteWarning: false);
  }

  /// Called when session time is complete
  void showTimeUpModal() {
    if (!state.showTimeUpModal) {
      state = state.copyWith(showTimeUpModal: true);
    }
  }

  /// Dismiss time up modal (continue session)
  void dismissTimeUpModal() {
    state = state.copyWith(showTimeUpModal: false);
  }

  /// Refresh swap data
  Future<void> refresh() async {
    await _loadSwap();
  }
}

/// Stream provider for real-time swap updates
@riverpod
Stream<SwapModel?> swapStream(SwapStreamRef ref, String swapId) {
  final swapRepo = ref.watch(swapRepositoryProvider);

  // Use the getUserSwaps stream and filter for our swap
  // This is a workaround since we don't have a single-document stream
  return swapRepo.getUserSwaps('').map((swaps) {
    try {
      return swaps.firstWhere((s) => s.id == swapId);
    } catch (_) {
      return null;
    }
  });
}

/// Get partner info from swap
({String name, String? photo, String skillName}) getPartnerInfo(
  SwapModel swap,
  String currentUserId,
) {
  final isRequester = currentUserId == swap.requesterId;

  return (
    name: isRequester ? swap.providerName : swap.requesterName,
    photo: isRequester ? swap.providerPhoto : swap.requesterPhoto,
    skillName: isRequester
        ? swap.requesterWants.skillName
        : swap.requesterOffers.skillName,
  );
}

/// Get current user's skill (what they're teaching)
String getCurrentUserSkill(SwapModel swap, String currentUserId) {
  final isRequester = currentUserId == swap.requesterId;
  return isRequester
      ? swap.requesterOffers.skillName
      : swap.requesterWants.skillName;
}

/// Format duration for display
String formatDurationDisplay(double hours) {
  if (hours == 1.0) return '1 hour';
  if (hours == 0.5) return '30 minutes';
  if (hours < 1) return '${(hours * 60).toInt()} minutes';
  return '${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)} hours';
}