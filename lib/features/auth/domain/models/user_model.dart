import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User availability preference
enum Availability {
  @JsonValue('morning')
  morning,
  @JsonValue('afternoon')
  afternoon,
  @JsonValue('evening')
  evening,
  @JsonValue('flexible')
  flexible,
}

/// User account status
enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('suspended')
  suspended,
}

/// User rating statistics
@freezed
class UserRating with _$UserRating {
  const factory UserRating({
    @Default(0.0) double average,
    @Default(0) int count,
    @Default({}) Map<String, int> tags,
  }) = _UserRating;

  factory UserRating.fromJson(Map<String, dynamic> json) =>
      _$UserRatingFromJson(json);
}

/// Timestamp converter for Firestore
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

/// Non-nullable timestamp converter
class TimestampConverterNonNull implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverterNonNull();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// User model representing a user profile
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    @Default(false) bool emailVerified,
    required String displayName,
    String? photoUrl,
    @Default('') String bio,

    // Skills
    @Default([]) List<SkillOffered> skillsOffered,
    @Default([]) List<SkillWanted> skillsWanted,

    // Availability
    @Default('') String timezone,
    @Default(Availability.flexible) Availability availability,

    // Stats
    @Default(1.0) double creditBalance,
    @Default(0) int swapsCompleted,
    @Default(0.0) double hoursExchanged,

    // Rating
    @Default(UserRating()) UserRating rating,

    // Status
    @Default(UserStatus.active) UserStatus status,

    // Timestamps
    @TimestampConverterNonNull() required DateTime createdAt,
    @TimestampConverterNonNull() required DateTime updatedAt,
    @TimestampConverterNonNull() required DateTime lastActiveAt,

    // New user limits
    @TimestampConverter() DateTime? firstSwapDate,
    @Default(0) int swapsThisWeek,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}