import 'package:riverpod_annotation/riverpod_annotation.dart';
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