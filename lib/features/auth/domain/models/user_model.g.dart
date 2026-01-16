// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRatingImpl _$$UserRatingImplFromJson(Map<String, dynamic> json) =>
    _$UserRatingImpl(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$UserRatingImplToJson(_$UserRatingImpl instance) =>
    <String, dynamic>{
      'average': instance.average,
      'count': instance.count,
      'tags': instance.tags,
    };

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String? ?? '',
      skillsOffered: (json['skillsOffered'] as List<dynamic>?)
              ?.map((e) => SkillOffered.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skillsWanted: (json['skillsWanted'] as List<dynamic>?)
              ?.map((e) => SkillWanted.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timezone: json['timezone'] as String? ?? '',
      availability:
          $enumDecodeNullable(_$AvailabilityEnumMap, json['availability']) ??
              Availability.flexible,
      creditBalance: (json['creditBalance'] as num?)?.toDouble() ?? 1.0,
      swapsCompleted: (json['swapsCompleted'] as num?)?.toInt() ?? 0,
      hoursExchanged: (json['hoursExchanged'] as num?)?.toDouble() ?? 0.0,
      rating: json['rating'] == null
          ? const UserRating()
          : UserRating.fromJson(json['rating'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.active,
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
      updatedAt: const TimestampConverterNonNull()
          .fromJson(json['updatedAt'] as Timestamp),
      lastActiveAt: const TimestampConverterNonNull()
          .fromJson(json['lastActiveAt'] as Timestamp),
      firstSwapDate: const TimestampConverter()
          .fromJson(json['firstSwapDate'] as Timestamp?),
      swapsThisWeek: (json['swapsThisWeek'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'skillsOffered': instance.skillsOffered,
      'skillsWanted': instance.skillsWanted,
      'timezone': instance.timezone,
      'availability': _$AvailabilityEnumMap[instance.availability]!,
      'creditBalance': instance.creditBalance,
      'swapsCompleted': instance.swapsCompleted,
      'hoursExchanged': instance.hoursExchanged,
      'rating': instance.rating,
      'status': _$UserStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
      'updatedAt': const TimestampConverterNonNull().toJson(instance.updatedAt),
      'lastActiveAt':
          const TimestampConverterNonNull().toJson(instance.lastActiveAt),
      'firstSwapDate':
          const TimestampConverter().toJson(instance.firstSwapDate),
      'swapsThisWeek': instance.swapsThisWeek,
    };

const _$AvailabilityEnumMap = {
  Availability.morning: 'morning',
  Availability.afternoon: 'afternoon',
  Availability.evening: 'evening',
  Availability.flexible: 'flexible',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.suspended: 'suspended',
};
