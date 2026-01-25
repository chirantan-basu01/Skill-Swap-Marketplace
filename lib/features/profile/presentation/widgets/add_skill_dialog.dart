import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/category_model.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';
import 'package:uuid/uuid.dart';

/// Providers for dialog state
final _selectedCategoryProvider = StateProvider.autoDispose<Category?>((ref) => null);
final _selectedSkillProvider = StateProvider.autoDispose<SkillRef?>((ref) => null);
final _selectedLevelProvider = StateProvider.autoDispose<SkillLevel>((ref) => SkillLevel.beginner);
final _descriptionProvider = StateProvider.autoDispose<String>((ref) => '');

class AddSkillOfferedDialog extends ConsumerWidget {
  final List<dynamic> categories;
  final void Function(SkillOffered skill) onAdd;

  const AddSkillOfferedDialog({
    super.key,
    required this.categories,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(_selectedCategoryProvider);
    final selectedSkill = ref.watch(_selectedSkillProvider);
    final selectedLevel = ref.watch(_selectedLevelProvider);
    final description = ref.watch(_descriptionProvider);

    final typedCategories = categories.cast<Category>();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: Dimensions.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.md),
                child: Text(
                  'Add Skill You Can Teach',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(Dimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Category dropdown
                      DropdownButtonFormField<Category>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: typedCategories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref.read(_selectedCategoryProvider.notifier).state = value;
                          ref.read(_selectedSkillProvider.notifier).state = null;
                        },
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Skill dropdown
                      DropdownButtonFormField<SkillRef>(
                        value: selectedSkill,
                        decoration: const InputDecoration(
                          labelText: 'Skill',
                          prefixIcon: Icon(Icons.lightbulb_outlined),
                        ),
                        items: selectedCategory?.skills.map((skill) {
                              return DropdownMenuItem(
                                value: skill,
                                child: Text(skill.name),
                              );
                            }).toList() ??
                            [],
                        onChanged: selectedCategory == null
                            ? null
                            : (value) {
                                ref.read(_selectedSkillProvider.notifier).state = value;
                              },
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Level selection
                      const Text(
                        'Your Experience Level',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.sm),
                      Wrap(
                        spacing: Dimensions.sm,
                        runSpacing: Dimensions.sm,
                        children: SkillLevel.values.map((level) {
                          final isSelected = selectedLevel == level;
                          return ChoiceChip(
                            label: Text(_formatLevel(level)),
                            selected: isSelected,
                            showCheckmark: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                ref.read(_selectedLevelProvider.notifier).state = level;
                              }
                            },
                            selectedColor: AppColors.primaryBlue,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.sm,
                              vertical: Dimensions.xs,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Description
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Briefly describe your experience...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        maxLength: 150,
                        onChanged: (value) {
                          ref.read(_descriptionProvider.notifier).state = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Add button
              Padding(
                padding: const EdgeInsets.all(Dimensions.md),
                child: ElevatedButton(
                  onPressed: selectedCategory != null && selectedSkill != null
                      ? () => _onAdd(ref, selectedCategory, selectedSkill, selectedLevel, description)
                      : null,
                  child: const Text('Add Skill'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAdd(
    WidgetRef ref,
    Category category,
    SkillRef skill,
    SkillLevel level,
    String description,
  ) {
    final skillOffered = SkillOffered(
      id: const Uuid().v4(),
      categoryId: category.id,
      categoryName: category.name,
      skillName: skill.name,
      level: level,
      description: description,
    );

    onAdd(skillOffered);
  }

  String _formatLevel(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.expert:
        return 'Expert';
    }
  }
}

class AddSkillWantedDialog extends ConsumerWidget {
  final List<dynamic> categories;
  final void Function(SkillWanted skill) onAdd;

  const AddSkillWantedDialog({
    super.key,
    required this.categories,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(_selectedCategoryProvider);
    final selectedSkill = ref.watch(_selectedSkillProvider);
    final selectedLevel = ref.watch(_selectedLevelProvider);

    final typedCategories = categories.cast<Category>();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: Dimensions.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.md),
                child: Text(
                  'Add Skill You Want to Learn',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.md),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(Dimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Category dropdown
                      DropdownButtonFormField<Category>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: typedCategories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref.read(_selectedCategoryProvider.notifier).state = value;
                          ref.read(_selectedSkillProvider.notifier).state = null;
                        },
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Skill dropdown
                      DropdownButtonFormField<SkillRef>(
                        value: selectedSkill,
                        decoration: const InputDecoration(
                          labelText: 'Skill',
                          prefixIcon: Icon(Icons.lightbulb_outlined),
                        ),
                        items: selectedCategory?.skills.map((skill) {
                              return DropdownMenuItem(
                                value: skill,
                                child: Text(skill.name),
                              );
                            }).toList() ??
                            [],
                        onChanged: selectedCategory == null
                            ? null
                            : (value) {
                                ref.read(_selectedSkillProvider.notifier).state = value;
                              },
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Desired level selection
                      const Text(
                        'Desired Learning Level',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.sm),
                      Wrap(
                        spacing: Dimensions.sm,
                        runSpacing: Dimensions.sm,
                        children: SkillLevel.values.map((level) {
                          final isSelected = selectedLevel == level;
                          return ChoiceChip(
                            label: Text(_formatLevel(level)),
                            selected: isSelected,
                            showCheckmark: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                ref.read(_selectedLevelProvider.notifier).state = level;
                              }
                            },
                            selectedColor: AppColors.primaryBlue,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.sm,
                              vertical: Dimensions.xs,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Add button
              Padding(
                padding: const EdgeInsets.all(Dimensions.md),
                child: ElevatedButton(
                  onPressed: selectedCategory != null && selectedSkill != null
                      ? () => _onAdd(ref, selectedCategory, selectedSkill, selectedLevel)
                      : null,
                  child: const Text('Add Skill'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAdd(
    WidgetRef ref,
    Category category,
    SkillRef skill,
    SkillLevel level,
  ) {
    final skillWanted = SkillWanted(
      id: const Uuid().v4(),
      categoryId: category.id,
      categoryName: category.name,
      skillName: skill.name,
      desiredLevel: level,
    );

    onAdd(skillWanted);
  }

  String _formatLevel(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.expert:
        return 'Expert';
    }
  }
}