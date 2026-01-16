import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/widgets/setup_progress_indicator.dart';

class SetupBasicInfoScreen extends ConsumerStatefulWidget {
  const SetupBasicInfoScreen({super.key});

  @override
  ConsumerState<SetupBasicInfoScreen> createState() => _SetupBasicInfoScreenState();
}

class _SetupBasicInfoScreenState extends ConsumerState<SetupBasicInfoScreen> {
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from persisted state
    final setupState = ref.read(profileSetupNotifierProvider);
    _displayNameController = TextEditingController(text: setupState.displayName);
    _bioController = TextEditingController(text: setupState.bio);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(profileSetupNotifierProvider);
    final isLoading = setupState.status == ProfileSetupStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Create Profile'),
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
              const SetupProgressIndicator(currentStep: 0, totalSteps: 4),
              const SizedBox(height: Dimensions.xl),

              // Title
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.xs),
              const Text(
                'Tell us a bit about yourself',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: Dimensions.xl),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Display name field
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          hintText: 'How should others call you?',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Bio field
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'Bio (Optional)',
                          hintText: 'Share a bit about yourself...',
                          prefixIcon: Icon(Icons.edit_outlined),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        maxLength: 200,
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Photo placeholder (Firebase Storage not available on Spark)
                      Container(
                        padding: const EdgeInsets.all(Dimensions.md),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.primarySurface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 32,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: Dimensions.md),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile Photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Photo upload coming soon',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Next button
              ListenableBuilder(
                listenable: _displayNameController,
                builder: (context, _) {
                  final canProceed = _displayNameController.text.trim().isNotEmpty;
                  return ElevatedButton(
                    onPressed: isLoading || !canProceed ? null : _onNext,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : const Text('Next'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() {
    // Update the setup notifier with basic info
    ref.read(profileSetupNotifierProvider.notifier).updateBasicInfo(
          displayName: _displayNameController.text.trim(),
          bio: _bioController.text.trim(),
        );

    // Navigate to next screen
    const SetupSkillsOfferedRoute().go(context);
  }
}