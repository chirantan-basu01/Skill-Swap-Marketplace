// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillRefImpl _$$SkillRefImplFromJson(Map<String, dynamic> json) =>
    _$SkillRefImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$SkillRefImplToJson(_$SkillRefImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$SkillOfferedImpl _$$SkillOfferedImplFromJson(Map<String, dynamic> json) =>
    _$SkillOfferedImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      skillName: json['skillName'] as String,
      level: $enumDecode(_$SkillLevelEnumMap, json['level']),
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$SkillOfferedImplToJson(_$SkillOfferedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'skillName': instance.skillName,
      'level': _$SkillLevelEnumMap[instance.level]!,
      'description': instance.description,
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'beginner',
  SkillLevel.intermediate: 'intermediate',
  SkillLevel.expert: 'expert',
};

_$SkillWantedImpl _$$SkillWantedImplFromJson(Map<String, dynamic> json) =>
    _$SkillWantedImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      skillName: json['skillName'] as String,
      desiredLevel:
          $enumDecodeNullable(_$SkillLevelEnumMap, json['desiredLevel']) ??
              SkillLevel.beginner,
    );

Map<String, dynamic> _$$SkillWantedImplToJson(_$SkillWantedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'skillName': instance.skillName,
      'desiredLevel': _$SkillLevelEnumMap[instance.desiredLevel]!,
    };

_$SkillExchangeImpl _$$SkillExchangeImplFromJson(Map<String, dynamic> json) =>
    _$SkillExchangeImpl(
      skillId: json['skillId'] as String,
      skillName: json['skillName'] as String,
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$$SkillExchangeImplToJson(_$SkillExchangeImpl instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'skillName': instance.skillName,
      'categoryName': instance.categoryName,
    };
