import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/core/utils/timestamp_converter.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

part 'swap_model.freezed.dart';
part 'swap_model.g.dart';

/// Swap request status
enum SwapStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Extension to get the JSON value for SwapStatus
extension SwapStatusX on SwapStatus {
  /// Returns the JSON string value (matching @JsonValue annotation)
  String get jsonValue {
    return switch (this) {
      SwapStatus.pending => 'pending',
      SwapStatus.accepted => 'accepted',
      SwapStatus.declined => 'declined',
      SwapStatus.scheduled => 'scheduled',
      SwapStatus.inProgress => 'in_progress',
      SwapStatus.completed => 'completed',
      SwapStatus.cancelled => 'cancelled',
    };
  }
}

/// Session details for a scheduled swap
@freezed
class SwapSession with _$SwapSession {
  const factory SwapSession({
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull,
    )
    required DateTime scheduledDate,
    @Default('') String scheduledTime,
    @Default('') String videoLink,
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp,
    )
    DateTime? actualStartTime,
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp,
    )
    DateTime? actualEndTime,
    @Default(false) bool requesterStarted,
    @Default(false) bool providerStarted,
  }) = _SwapSession;

  factory SwapSession.fromJson(Map<String, dynamic> json) =>
      _$SwapSessionFromJson(json);
}

/// Rating given by a user for a swap
@freezed
class SwapRating with _$SwapRating {
  const factory SwapRating({
    required String oderId,
    required int stars,
    @Default([]) List<String> tags,
    @Default('') String review,
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull,
    )
    required DateTime createdAt,
  }) = _SwapRating;

  factory SwapRating.fromJson(Map<String, dynamic> json) =>
      _$SwapRatingFromJson(json);
}

/// Swap model representing a skill exchange request
@freezed
class SwapModel with _$SwapModel {
  const factory SwapModel({
    required String id,

    // Participants
    required String requesterId,
    required String requesterName,
    String? requesterPhoto,
    required String providerId,
    required String providerName,
    String? providerPhoto,

    // Skills being exchanged
    required SkillExchange requesterOffers,
    required SkillExchange requesterWants,

    // Terms
    required double duration, // in hours (0.5, 1, 1.5, 2)
    required double creditAmount,
    @Default('') String message,

    // Status
    @Default(SwapStatus.pending) SwapStatus status,

    // Session (when scheduled)
    SwapSession? session,

    // Ratings (after completion)
    @Default({}) Map<String, SwapRating> ratings,

    // Metadata
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull,
    )
    required DateTime createdAt,
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull,
    )
    required DateTime updatedAt,
    @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp,
    )
    DateTime? completedAt,
    String? cancelledBy,
    String? cancelReason,
  }) = _SwapModel;

  factory SwapModel.fromJson(Map<String, dynamic> json) =>
      _$SwapModelFromJson(json);
}