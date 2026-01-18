import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/constants/route_constants.dart';
import 'package:skill_swap_marketplace/core/services/toast_service.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';

/// Edit profile screen for updating user information
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedTimezone;
  Availability _selectedAvailability = Availability.flexible;
  bool _isLoading = false;
  bool _hasChanges = false;
  UserModel? _originalUser;

  static const List<String> _timezones = [
    'UTC-12:00',
    'UTC-11:00',
    'UTC-10:00',
    'UTC-09:00',
    'UTC-08:00 (PST)',
    'UTC-07:00 (MST)',
    'UTC-06:00 (CST)',
    'UTC-05:00 (EST)',
    'UTC-04:00',
    'UTC-03:00',
    'UTC-02:00',
    'UTC-01:00',
    'UTC+00:00 (GMT)',
    'UTC+01:00 (CET)',
    'UTC+02:00 (EET)',
    'UTC+03:00',
    'UTC+04:00',
    'UTC+05:00',
    'UTC+05:30 (IST)',
    'UTC+06:00',
    'UTC+07:00',
    'UTC+08:00',
    'UTC+09:00 (JST)',
    'UTC+10:00',
    'UTC+11:00',
    'UTC+12:00',
  ];

  @override
  void initState() {
    super.initState();
    // Load user data after the first frame to ensure provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final userAsync = ref.read(currentUserProfileProvider);
    userAsync.whenData((user) {
      if (user != null && mounted) {
        setState(() {
          _originalUser = user;
          _displayNameController.text = user.displayName;
          _bioController.text = user.bio;
          // Try to match the user's timezone with the dropdown options
          _selectedTimezone = _timezones.contains(user.timezone)
              ? user.timezone
              : _findClosestTimezone(user.timezone);
          _selectedAvailability = user.availability;
        });
      }
    });
  }

  void _initializeFromUser(UserModel user) {
    if (_originalUser != null) return; // Already initialized

    _originalUser = user;
    _displayNameController.text = user.displayName;
    _bioController.text = user.bio;
    _selectedTimezone = _timezones.contains(user.timezone)
        ? user.timezone
        : _findClosestTimezone(user.timezone);
    _selectedAvailability = user.availability;
  }

  String? _findClosestTimezone(String timezone) {
    // Try to find a matching timezone in the list
    for (final tz in _timezones) {
      if (tz.contains(timezone) || timezone.contains(tz.split(' ')[0])) {
        return tz;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    if (_originalUser == null) return;

    final originalTimezone = _timezones.contains(_originalUser!.timezone)
        ? _originalUser!.timezone
        : _findClosestTimezone(_originalUser!.timezone);

    final hasChanges = _displayNameController.text != _originalUser!.displayName ||
        _bioController.text != _originalUser!.bio ||
        _selectedTimezone != originalTimezone ||
        _selectedAvailability != _originalUser!.availability;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userRepo = ref.read(userRepositoryProvider);

      await userRepo.updateProfile(
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        timezone: _selectedTimezone ?? '',
        availability: _selectedAvailability,
      );

      // Refresh user data
      ref.invalidate(currentUserProfileProvider);

      ToastService.success('Profile updated successfully');
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ToastService.error('Failed to update profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileProvider);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (_hasChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && context.mounted) {
                  context.pop();
                }
              } else {
                context.pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: _hasChanges && !_isLoading ? _saveChanges : null,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryBlue,
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: _hasChanges
                            ? AppColors.primaryBlue
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not logged in'));
            }

            // Initialize form fields from user data if not already done
            _initializeFromUser(user);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.md),
              child: Form(
                key: _formKey,
                onChanged: _checkForChanges,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    Center(
                      child: Column(
                        children: [
                          UserAvatar(
                            imageUrl: user.photoUrl,
                            name: user.displayName,
                            size: AvatarSize.xl,
                          ),
                          const SizedBox(height: Dimensions.sm),
                          TextButton.icon(
                            onPressed: () {
                              ToastService.info('Photo upload coming soon');
                            },
                            icon: const Icon(Icons.camera_alt_outlined, size: 18),
                            label: const Text('Change Photo'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.lg),

                    // Display Name
                    _SectionLabel(label: 'Display Name'),
                    const SizedBox(height: Dimensions.xs),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: _inputDecoration(
                        hintText: 'Enter your display name',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Display name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Display name must be at least 2 characters';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                    ),

                    const SizedBox(height: Dimensions.lg),

                    // Bio
                    _SectionLabel(label: 'Bio'),
                    const SizedBox(height: Dimensions.xs),
                    TextFormField(
                      controller: _bioController,
                      decoration: _inputDecoration(
                        hintText: 'Tell others about yourself...',
                        prefixIcon: Icons.info_outline,
                      ),
                      maxLines: 3,
                      maxLength: 200,
                    ),

                    const SizedBox(height: Dimensions.lg),

                    // Timezone
                    _SectionLabel(label: 'Timezone'),
                    const SizedBox(height: Dimensions.xs),
                    DropdownButtonFormField<String>(
                      value: _selectedTimezone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.public, color: AppColors.textTertiary),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                          borderSide: const BorderSide(color: AppColors.gray200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                          borderSide: const BorderSide(color: AppColors.gray200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                        ),
                      ),
                      hint: const Text('Select your timezone'),
                      isExpanded: true,
                      items: _timezones.map((tz) {
                        return DropdownMenuItem(
                          value: tz,
                          child: Text(tz),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTimezone = value;
                          _checkForChanges();
                        });
                      },
                    ),

                    const SizedBox(height: Dimensions.lg),

                    // Availability
                    _SectionLabel(label: 'Availability'),
                    const SizedBox(height: Dimensions.sm),
                    _AvailabilitySelector(
                      selectedAvailability: _selectedAvailability,
                      onChanged: (availability) {
                        setState(() {
                          _selectedAvailability = availability;
                          _checkForChanges();
                        });
                      },
                    ),

                    const SizedBox(height: Dimensions.xl),

                    // Edit Skills Section
                    _SectionLabel(label: 'Skills'),
                    const SizedBox(height: Dimensions.sm),

                    // Skills You Teach
                    _SkillEditButton(
                      title: 'Skills You Teach',
                      subtitle: '${user.skillsOffered.length} skill${user.skillsOffered.length != 1 ? 's' : ''}',
                      icon: Icons.school_rounded,
                      iconColor: AppColors.primaryBlue,
                      backgroundColor: AppColors.primarySurface,
                      onTap: () => context.push(RoutePath.editSkillsOffered),
                    ),

                    const SizedBox(height: Dimensions.sm),

                    // Skills You Want to Learn
                    _SkillEditButton(
                      title: 'Skills to Learn',
                      subtitle: '${user.skillsWanted.length} skill${user.skillsWanted.length != 1 ? 's' : ''}',
                      icon: Icons.auto_stories_rounded,
                      iconColor: AppColors.secondaryTeal,
                      backgroundColor: AppColors.secondarySurface,
                      onTap: () => context.push(RoutePath.editSkillsWanted),
                    ),

                    const SizedBox(height: Dimensions.xl),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: AppColors.textTertiary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _AvailabilitySelector extends StatelessWidget {
  final Availability selectedAvailability;
  final ValueChanged<Availability> onChanged;

  const _AvailabilitySelector({
    required this.selectedAvailability,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Availability.values.map((availability) {
        final isSelected = availability == selectedAvailability;
        return GestureDetector(
          onTap: () => onChanged(availability),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : AppColors.gray200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getAvailabilityIcon(availability),
                  size: 18,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  _getAvailabilityLabel(availability),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
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
        return Icons.schedule;
    }
  }

  String _getAvailabilityLabel(Availability availability) {
    switch (availability) {
      case Availability.morning:
        return 'Mornings';
      case Availability.afternoon:
        return 'Afternoons';
      case Availability.evening:
        return 'Evenings';
      case Availability.flexible:
        return 'Flexible';
    }
  }
}

class _SkillEditButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _SkillEditButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: Dimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}