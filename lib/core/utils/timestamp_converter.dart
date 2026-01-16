import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Timestamp converter for nullable DateTime fields
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

/// Timestamp converter for non-nullable DateTime fields
class TimestampConverterNonNull implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverterNonNull();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
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