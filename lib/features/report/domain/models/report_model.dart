import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// Report reason enum
enum ReportReason {
  @JsonValue('inappropriate')
  inappropriate,
  @JsonValue('spam')
  spam,
  @JsonValue('no_show')
  noShow,
  @JsonValue('fraud')
  fraud,
  @JsonValue('other')
  other,
}

/// Report status enum
enum ReportStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('resolved')
  resolved,
}

/// Report model for reporting users
@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String id,
    required String reporterId,
    required String reporterName,
    required String reportedUserId,
    required String reportedUserName,
    String? swapId,
    String? messageId,
    required ReportReason reason,
    required String description,
    @Default(ReportStatus.pending) ReportStatus status,
    @TimestampConverterNonNull() required DateTime createdAt,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}