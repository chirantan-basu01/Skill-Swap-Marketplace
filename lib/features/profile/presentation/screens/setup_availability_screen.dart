import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/setup_progress_indicator.dart';

/// Availability options enum
enum AvailabilityOption {
  morning,
  afternoon,
  evening,
  flexible,
}

/// Providers for form state
final _selectedTimezoneProvider = StateProvider.autoDispose<String?>((ref) => null);
final _selectedAvailabilityProvider = StateProvider.autoDispose<AvailabilityOption>(
  (ref) => AvailabilityOption.flexible,
);

class SetupAvailabilityScreen extends ConsumerWidget {
  const SetupAvailabilityScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(profileSetupNotifierProvider);
    final selectedTimezone = ref.watch(_selectedTimezoneProvider);
    final selectedAvailability = ref.watch(_selectedAvailabilityProvider);
    final isLoading = setupState.status == ProfileSetupStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Availability'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              const SetupProgressIndicator(currentStep: 3, totalSteps: 4),
              const SizedBox(height: Dimensions.xl),

              // Title
              const Text(
                'When are you available?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.xs),
              const Text(
                'Help others know when to connect with you',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: Dimensions.xl),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timezone dropdown
                      DropdownButtonFormField<String>(
                        value: selectedTimezone,
                        decoration: const InputDecoration(
                          labelText: 'Your Timezone',
                          prefixIcon: Icon(Icons.public),
                        ),
                        items: _timezones.map((tz) {
                          return DropdownMenuItem(
                            value: tz,
                            child: Text(tz),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref.read(_selectedTimezoneProvider.notifier).state = value;
                        },
                      ),
                      const SizedBox(height: Dimensions.xl),

                      // Availability selection
                      const Text(
                        'General Availability',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.sm),
                      const Text(
                        'When do you usually have time for skill swaps?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Availability options
                      ...AvailabilityOption.values.map((option) {
                        final isSelected = selectedAvailability == option;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.sm),
                          child: InkWell(
                            onTap: () {
                              ref.read(_selectedAvailabilityProvider.notifier).state = option;
                            },
                            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.md),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primarySurface
                                    : AppColors.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getAvailabilityIcon(option),
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: Dimensions.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getAvailabilityTitle(option),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.primaryBlue
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _getAvailabilityDescription(option),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryBlue,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Error message
              if (setupState.errorMessage != null) ...[
                const SizedBox(height: Dimensions.sm),
                Text(
                  setupState.errorMessage!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: Dimensions.md),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => const SetupSkillsWantedRoute().go(context),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: Dimensions.md),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isLoading || selectedTimezone == null
                          ? null
                          : () => _onComplete(context, ref, selectedTimezone, selectedAvailability),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textOnPrimary,
                              ),
                            )
                          : const Text('Complete Setup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAvailabilityIcon(AvailabilityOption option) {
    switch (option) {
      case AvailabilityOption.morning:
        return Icons.wb_sunny_outlined;
      case AvailabilityOption.afternoon:
        return Icons.wb_cloudy_outlined;
      case AvailabilityOption.evening:
        return Icons.nights_stay_outlined;
      case AvailabilityOption.flexible:
        return Icons.schedule_outlined;
    }
  }

  String _getAvailabilityTitle(AvailabilityOption option) {
    switch (option) {
      case AvailabilityOption.morning:
        return 'Morning';
      case AvailabilityOption.afternoon:
        return 'Afternoon';
      case AvailabilityOption.evening:
        return 'Evening';
      case AvailabilityOption.flexible:
        return 'Flexible';
    }
  }

  String _getAvailabilityDescription(AvailabilityOption option) {
    switch (option) {
      case AvailabilityOption.morning:
        return '6 AM - 12 PM';
      case AvailabilityOption.afternoon:
        return '12 PM - 6 PM';
      case AvailabilityOption.evening:
        return '6 PM - 12 AM';
      case AvailabilityOption.flexible:
        return 'Available anytime';
    }
  }

  void _onComplete(
    BuildContext context,
    WidgetRef ref,
    String timezone,
    AvailabilityOption availability,
  ) async {
    // Update availability in setup state
    ref.read(profileSetupNotifierProvider.notifier).updateAvailability(
          timezone: timezone,
          availability: availability.name,
        );

    // Save complete profile to Firestore
    final success = await ref.read(profileSetupNotifierProvider.notifier).saveProfile();

    if (success && context.mounted) {
      // Navigate to home screen
      const HomeRoute().go(context);
    }
  }
}
