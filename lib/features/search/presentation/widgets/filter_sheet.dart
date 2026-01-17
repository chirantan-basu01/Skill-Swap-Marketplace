import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/search/presentation/providers/search_provider.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

/// Filter bottom sheet for search
class FilterSheet extends ConsumerStatefulWidget {
  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onApply;

  const FilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();

  /// Show the filter sheet
  static Future<void> show({
    required BuildContext context,
    required SearchFilters initialFilters,
    required ValueChanged<SearchFilters> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        initialFilters: initialFilters,
        onApply: onApply,
      ),
    );
  }
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late SearchFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(Dimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = const SearchFilters();
                    });
                  },
                  child: const Text('Reset'),
                ),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onApply(_filters);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                Dimensions.md,
                Dimensions.md,
                Dimensions.md,
                Dimensions.md + bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories section
                  _buildSectionTitle('Categories'),
                  const SizedBox(height: Dimensions.sm),
                  categoriesAsync.when(
                    data: (categories) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = _filters.categories.contains(category.id);
                        return FilterChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final newCategories = List<String>.from(_filters.categories);
                              if (selected) {
                                newCategories.add(category.id);
                              } else {
                                newCategories.remove(category.id);
                              }
                              _filters = _filters.copyWith(categories: newCategories);
                            });
                          },
                          avatar: Text(category.icon, style: const TextStyle(fontSize: 14)),
                          selectedColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                          checkmarkColor: AppColors.primaryBlue,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => _buildDefaultCategories(),
                  ),

                  const SizedBox(height: Dimensions.lg),

                  // Availability section
                  _buildSectionTitle('Availability'),
                  const SizedBox(height: Dimensions.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Availability.values.map((availability) {
                      final isSelected = _filters.availability.contains(availability);
                      return FilterChip(
                        label: Text(_getAvailabilityLabel(availability)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            final newAvailability = List<Availability>.from(_filters.availability);
                            if (selected) {
                              newAvailability.add(availability);
                            } else {
                              newAvailability.remove(availability);
                            }
                            _filters = _filters.copyWith(availability: newAvailability);
                          });
                        },
                        avatar: Icon(
                          _getAvailabilityIcon(availability),
                          size: 16,
                          color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                        ),
                        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                        checkmarkColor: AppColors.primaryBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: Dimensions.lg),

                  // Rating section
                  _buildSectionTitle('Minimum Rating'),
                  const SizedBox(height: Dimensions.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [null, 3.0, 4.0, 4.5].map((rating) {
                      final isSelected = _filters.minRating == rating;
                      return FilterChip(
                        label: Text(
                          rating == null ? 'Any' : '$rating+ stars',
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _filters = _filters.copyWith(minRating: rating, clearMinRating: rating == null);
                            }
                          });
                        },
                        avatar: rating != null
                            ? Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: isSelected ? AppColors.warning : AppColors.textSecondary,
                              )
                            : null,
                        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                        checkmarkColor: AppColors.primaryBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: Dimensions.lg),

                  // Other options
                  _buildSectionTitle('Other Options'),
                  const SizedBox(height: Dimensions.sm),

                  // Online now toggle
                  _buildToggleOption(
                    icon: Icons.circle,
                    iconColor: AppColors.success,
                    title: 'Online Now',
                    subtitle: 'Show only users who are currently active',
                    value: _filters.onlyOnline,
                    onChanged: (value) {
                      setState(() {
                        _filters = _filters.copyWith(onlyOnline: value);
                      });
                    },
                  ),

                  const SizedBox(height: Dimensions.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCategories() {
    const defaultCategories = [
      {'id': 'technology', 'name': 'Technology', 'icon': '💻'},
      {'id': 'creative', 'name': 'Creative', 'icon': '🎨'},
      {'id': 'music', 'name': 'Music', 'icon': '🎵'},
      {'id': 'languages', 'name': 'Languages', 'icon': '🌍'},
      {'id': 'business', 'name': 'Business', 'icon': '💼'},
      {'id': 'lifestyle', 'name': 'Lifestyle', 'icon': '🧘'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: defaultCategories.map((category) {
        final isSelected = _filters.categories.contains(category['id']);
        return FilterChip(
          label: Text(category['name']!),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final newCategories = List<String>.from(_filters.categories);
              if (selected) {
                newCategories.add(category['id']!);
              } else {
                newCategories.remove(category['id']);
              }
              _filters = _filters.copyWith(categories: newCategories);
            });
          },
          avatar: Text(category['icon']!, style: const TextStyle(fontSize: 14)),
          selectedColor: AppColors.primaryBlue.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primaryBlue,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  String _getAvailabilityLabel(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return 'Morning';
      case Availability.afternoon:
        return 'Afternoon';
      case Availability.evening:
        return 'Evening';
      case Availability.flexible:
        return 'Flexible';
    }
  }

  IconData _getAvailabilityIcon(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return Icons.wb_sunny_outlined;
      case Availability.afternoon:
        return Icons.wb_cloudy_outlined;
      case Availability.evening:
        return Icons.nights_stay_outlined;
      case Availability.flexible:
        return Icons.schedule_outlined;
    }
  }
}