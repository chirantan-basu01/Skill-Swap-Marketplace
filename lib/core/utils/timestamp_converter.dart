import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Standalone function to convert Timestamp to DateTime (nullable)
DateTime? timestampToDateTime(Object? timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is DateTime) return timestamp;
  return null;
}

/// Standalone function to convert Timestamp to DateTime (non-null with fallback)
DateTime timestampToDateTimeNonNull(Object? timestamp) {
  if (timestamp == null) return DateTime.now();
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is DateTime) return timestamp;
  return DateTime.now();
}

/// Read value helper for @JsonKey - reads field without cast
Object? readTimestampValue(Map<dynamic, dynamic> json, String key) => json[key];

/// Standalone function to convert DateTime to Timestamp (nullable)
Timestamp? dateTimeToTimestamp(DateTime? date) {
  if (date == null) return null;
  return Timestamp.fromDate(date);
}

/// Standalone function to convert DateTime to Timestamp (non-null)
Timestamp dateTimeToTimestampNonNull(DateTime date) {
  return Timestamp.fromDate(date);
}

/// Timestamp converter for nullable DateTime fields
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? timestamp) => timestampToDateTime(timestamp);

  @override
  Timestamp? toJson(DateTime? date) => dateTimeToTimestamp(date);
}

/// Timestamp converter for non-nullable DateTime fields
/// Note: This converter handles the edge case where Firestore might return null
/// for fields that should be non-null, by returning DateTime.now() as a fallback.
class TimestampConverterNonNull implements JsonConverter<DateTime, Object?> {
  const TimestampConverterNonNull();

  @override
  DateTime fromJson(Object? timestamp) => timestampToDateTimeNonNull(timestamp);

  @override
  Timestamp toJson(DateTime date) => dateTimeToTimestampNonNull(date);
}

/// Server timestamp placeholder converter
/// Use this when you want Firestore to set the timestamp on write
class ServerTimestampConverter
    implements JsonConverter<DateTime?, FieldValue?> {
  const ServerTimestampConverter();

  @override
  DateTime? fromJson(FieldValue? value) => null;

  @override
  FieldValue? toJson(DateTime? date) => FieldValue.serverTimestamp();
}