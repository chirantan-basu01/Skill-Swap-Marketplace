import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Skill category with list of available skills
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String icon,
    required int order,
    @Default([]) List<SkillRef> skills,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}