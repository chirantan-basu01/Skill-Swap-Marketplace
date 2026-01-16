// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SwapSessionImpl _$$SwapSessionImplFromJson(Map<String, dynamic> json) =>
    _$SwapSessionImpl(
      scheduledDate: const TimestampConverterNonNull()
          .fromJson(json['scheduledDate'] as Timestamp),
      scheduledTime: json['scheduledTime'] as String,
      videoLink: json['videoLink'] as String? ?? '',
      actualStartTime: const TimestampConverter()
          .fromJson(json['actualStartTime'] as Timestamp?),
      actualEndTime: const TimestampConverter()
          .fromJson(json['actualEndTime'] as Timestamp?),
      requesterStarted: json['requesterStarted'] as bool? ?? false,
      providerStarted: json['providerStarted'] as bool? ?? false,
    );

Map<String, dynamic> _$$SwapSessionImplToJson(_$SwapSessionImpl instance) =>
    <String, dynamic>{
      'scheduledDate':
          const TimestampConverterNonNull().toJson(instance.scheduledDate),
      'scheduledTime': instance.scheduledTime,
      'videoLink': instance.videoLink,
      'actualStartTime':
          const TimestampConverter().toJson(instance.actualStartTime),
      'actualEndTime':
          const TimestampConverter().toJson(instance.actualEndTime),
      'requesterStarted': instance.requesterStarted,
      'providerStarted': instance.providerStarted,
    };

_$SwapRatingImpl _$$SwapRatingImplFromJson(Map<String, dynamic> json) =>
    _$SwapRatingImpl(
      oderId: json['oderId'] as String,
      stars: (json['stars'] as num).toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      review: json['review'] as String? ?? '',
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$SwapRatingImplToJson(_$SwapRatingImpl instance) =>
    <String, dynamic>{
      'oderId': instance.oderId,
      'stars': instance.stars,
      'tags': instance.tags,
      'review': instance.review,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
    };

_$SwapModelImpl _$$SwapModelImplFromJson(Map<String, dynamic> json) =>
    _$SwapModelImpl(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      requesterName: json['requesterName'] as String,
      requesterPhoto: json['requesterPhoto'] as String?,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerPhoto: json['providerPhoto'] as String?,
      requesterOffers: SkillExchange.fromJson(
          json['requesterOffers'] as Map<String, dynamic>),
      requesterWants: SkillExchange.fromJson(
          json['requesterWants'] as Map<String, dynamic>),
      duration: (json['duration'] as num).toDouble(),
      creditAmount: (json['creditAmount'] as num).toDouble(),
      message: json['message'] as String? ?? '',
      status: $enumDecodeNullable(_$SwapStatusEnumMap, json['status']) ??
          SwapStatus.pending,
      session: json['session'] == null
          ? null
          : SwapSession.fromJson(json['session'] as Map<String, dynamic>),
      ratings: (json['ratings'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, SwapRating.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
      updatedAt: const TimestampConverterNonNull()
          .fromJson(json['updatedAt'] as Timestamp),
      completedAt: const TimestampConverter()
          .fromJson(json['completedAt'] as Timestamp?),
      cancelledBy: json['cancelledBy'] as String?,
      cancelReason: json['cancelReason'] as String?,
    );

Map<String, dynamic> _$$SwapModelImplToJson(_$SwapModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'requesterName': instance.requesterName,
      'requesterPhoto': instance.requesterPhoto,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerPhoto': instance.providerPhoto,
      'requesterOffers': instance.requesterOffers,
      'requesterWants': instance.requesterWants,
      'duration': instance.duration,
      'creditAmount': instance.creditAmount,
      'message': instance.message,
      'status': _$SwapStatusEnumMap[instance.status]!,
      'session': instance.session,
      'ratings': instance.ratings,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
      'updatedAt': const TimestampConverterNonNull().toJson(instance.updatedAt),
      'completedAt': const TimestampConverter().toJson(instance.completedAt),
      'cancelledBy': instance.cancelledBy,
      'cancelReason': instance.cancelReason,
    };

const _$SwapStatusEnumMap = {
  SwapStatus.pending: 'pending',
  SwapStatus.accepted: 'accepted',
  SwapStatus.declined: 'declined',
  SwapStatus.scheduled: 'scheduled',
  SwapStatus.inProgress: 'in_progress',
  SwapStatus.completed: 'completed',
  SwapStatus.cancelled: 'cancelled',
};
