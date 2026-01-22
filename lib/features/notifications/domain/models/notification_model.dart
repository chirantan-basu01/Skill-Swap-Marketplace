import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/core/utils/timestamp_converter.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Types of in-app notifications
enum NotificationType {
  @JsonValue('swap_request')
  swapRequest,
  @JsonValue('swap_accepted')
  swapAccepted,
  @JsonValue('swap_declined')
  swapDeclined,
  @JsonValue('swap_cancelled')
  swapCancelled,
  @JsonValue('session_scheduled')
  sessionScheduled,
  @JsonValue('session_reminder')
  sessionReminder,
  @JsonValue('session_started')
  sessionStarted,
  @JsonValue('session_completed')
  sessionCompleted,
  @JsonValue('new_message')
  newMessage,
  @JsonValue('new_rating')
  newRating,
  @JsonValue('credits_received')
  creditsReceived,
  @JsonValue('system')
  system,
}

/// In-app notification model
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,

    // Optional reference IDs for navigation
    String? swapId,
    String? chatId,
    String? fromUserId,
    String? fromUserName,
    String? fromUserPhoto,

    // Status
    @Default(false) bool isRead,

    // Metadata
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull,
    )
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// Extension for notification type display
extension NotificationTypeX on NotificationType {
  String get jsonValue {
    return switch (this) {
      NotificationType.swapRequest => 'swap_request',
      NotificationType.swapAccepted => 'swap_accepted',
      NotificationType.swapDeclined => 'swap_declined',
      NotificationType.swapCancelled => 'swap_cancelled',
      NotificationType.sessionScheduled => 'session_scheduled',
      NotificationType.sessionReminder => 'session_reminder',
      NotificationType.sessionStarted => 'session_started',
      NotificationType.sessionCompleted => 'session_completed',
      NotificationType.newMessage => 'new_message',
      NotificationType.newRating => 'new_rating',
      NotificationType.creditsReceived => 'credits_received',
      NotificationType.system => 'system',
    };
  }

  String get icon {
    return switch (this) {
      NotificationType.swapRequest => '🔄',
      NotificationType.swapAccepted => '✅',
      NotificationType.swapDeclined => '❌',
      NotificationType.swapCancelled => '🚫',
      NotificationType.sessionScheduled => '📅',
      NotificationType.sessionReminder => '⏰',
      NotificationType.sessionStarted => '▶️',
      NotificationType.sessionCompleted => '🎉',
      NotificationType.newMessage => '💬',
      NotificationType.newRating => '⭐',
      NotificationType.creditsReceived => '💰',
      NotificationType.system => 'ℹ️',
    };
  }
}