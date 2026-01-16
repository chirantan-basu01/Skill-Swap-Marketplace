// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportModelImpl _$$ReportModelImplFromJson(Map<String, dynamic> json) =>
    _$ReportModelImpl(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      reporterName: json['reporterName'] as String,
      reportedUserId: json['reportedUserId'] as String,
      reportedUserName: json['reportedUserName'] as String,
      swapId: json['swapId'] as String?,
      messageId: json['messageId'] as String?,
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String,
      status: $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.pending,
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$ReportModelImplToJson(_$ReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reporterName': instance.reporterName,
      'reportedUserId': instance.reportedUserId,
      'reportedUserName': instance.reportedUserName,
      'swapId': instance.swapId,
      'messageId': instance.messageId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'description': instance.description,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
    };

const _$ReportReasonEnumMap = {
  ReportReason.inappropriate: 'inappropriate',
  ReportReason.spam: 'spam',
  ReportReason.noShow: 'no_show',
  ReportReason.fraud: 'fraud',
  ReportReason.other: 'other',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.resolved: 'resolved',
};
