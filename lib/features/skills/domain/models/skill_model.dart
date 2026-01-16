import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

/// Skill level enum
enum SkillLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('expert')
  expert,
}

/// Basic skill reference (used in categories)
@freezed
class SkillRef with _$SkillRef {
  const factory SkillRef({
    required String id,
    required String name,
  }) = _SkillRef;

  factory SkillRef.fromJson(Map<String, dynamic> json) =>
      _$SkillRefFromJson(json);
}

/// Skill that a user offers to teach
@freezed
class SkillOffered with _$SkillOffered {
  const factory SkillOffered({
    required String id,
    required String categoryId,
    required String categoryName,
    required String skillName,
    required SkillLevel level,
    @Default('') String description,
  }) = _SkillOffered;

  factory SkillOffered.fromJson(Map<String, dynamic> json) =>
      _$SkillOfferedFromJson(json);
}

/// Skill that a user wants to learn
@freezed
class SkillWanted with _$SkillWanted {
  const factory SkillWanted({
    required String id,
    required String categoryId,
    required String categoryName,
    required String skillName,
    @Default(SkillLevel.beginner) SkillLevel desiredLevel,
  }) = _SkillWanted;

  factory SkillWanted.fromJson(Map<String, dynamic> json) =>
      _$SkillWantedFromJson(json);
}

/// Skill exchange info (used in swap requests)
@freezed
class SkillExchange with _$SkillExchange {
  const factory SkillExchange({
    required String skillId,
    required String skillName,
    required String categoryName,
  }) = _SkillExchange;

  factory SkillExchange.fromJson(Map<String, dynamic> json) =>
      _$SkillExchangeFromJson(json);
}