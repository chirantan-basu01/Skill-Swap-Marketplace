import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';
import 'package:skill_swap_marketplace/features/user/presentation/screens/user_profile_view_screen.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';

class SwapRequestScreen extends ConsumerStatefulWidget {
  final String userId;

  const SwapRequestScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<SwapRequestScreen> createState() => _SwapRequestScreenState();
}

class _SwapRequestScreenState extends ConsumerState<SwapRequestScreen> {
  final _messageController = TextEditingController();
  double _selectedDuration = 1.0;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerAsync = ref.watch(userByIdProvider(widget.userId));
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final requestState = ref.watch(swapRequestNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Request Swap',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
      ),
      body: providerAsync.when(
        data: (provider) {
          if (provider == null) {
            return _buildUserNotFound();
          }
          return currentUserAsync.when(
            data: (currentUser) {
              if (currentUser == null) {
                return _buildNotLoggedIn();
              }
              return _buildContent(context, provider, currentUser, requestState);
            },
            loading: () => _buildLoading(),
            error: (_, __) => _buildError(),
          );
        },
        loading: () => _buildLoading(),
        error: (_, __) => _buildError(),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UserModel provider,
    UserModel currentUser,
    SwapRequestState requestState,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider info card
                _buildProviderCard(provider),

                const SizedBox(height: Dimensions.lg),

                // Skill you want (from provider)
                _buildSectionTitle('Skill you want to learn'),
                const SizedBox(height: Dimensions.sm),
                _buildSkillSelector(
                  skills: provider.skillsOffered,
                  selectedSkillId: requestState.selectedSkillWanted?.skillId,
                  onSelect: (skill) {
                    ref.read(swapRequestNotifierProvider.notifier).selectSkillWanted(
                      SkillExchange(
                        skillId: skill.id,
                        skillName: skill.skillName,
                        categoryName: skill.categoryName,
                      ),
                    );
                  },
                  emptyMessage: 'This user has no skills to teach',
                ),

                const SizedBox(height: Dimensions.lg),

                // Skill you offer
                _buildSectionTitle('Skill you offer in exchange'),
                const SizedBox(height: Dimensions.sm),
                _buildSkillSelector(
                  skills: currentUser.skillsOffered,
                  selectedSkillId: requestState.selectedSkillOffered?.skillId,
                  onSelect: (skill) {
                    ref.read(swapRequestNotifierProvider.notifier).selectSkillOffered(
                      SkillExchange(
                        skillId: skill.id,
                        skillName: skill.skillName,
                        categoryName: skill.categoryName,
                      ),
                    );
                  },
                  emptyMessage: 'You have no skills to offer. Add some in your profile.',
                ),

                const SizedBox(height: Dimensions.lg),

                // Exchange visualization (when both skills selected)
                if (requestState.selectedSkillWanted != null &&
                    requestState.selectedSkillOffered != null)
                  _buildExchangeVisualization(requestState),

                if (requestState.selectedSkillWanted != null &&
                    requestState.selectedSkillOffered != null)
                  const SizedBox(height: Dimensions.lg),

                // Duration selector
                _buildSectionTitle('Session Duration'),
                const SizedBox(height: Dimensions.sm),
                _buildDurationSelector(),

                const SizedBox(height: Dimensions.lg),

                // Credits info
                _buildCreditsInfo(),

                const SizedBox(height: Dimensions.lg),

                // Message
                _buildSectionTitle('Add a message (optional)'),
                const SizedBox(height: Dimensions.sm),
                _buildMessageInput(),

                const SizedBox(height: Dimensions.xl),
              ],
            ),
          ),
        ),

        // Submit button
        _buildSubmitButton(provider, requestState),
      ],
    );
  }

  Widget _buildProviderCard(UserModel provider) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          UserAvatar(
            imageUrl: provider.photoUrl,
            name: provider.displayName,
            size: AvatarSize.md,
          ),
          const SizedBox(width: Dimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.rating.average.toStringAsFixed(1)} (${provider.rating.count})',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${provider.swapsCompleted} swaps',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildSkillSelector({
    required List<SkillOffered> skills,
    required String? selectedSkillId,
    required Function(SkillOffered) onSelect,
    required String emptyMessage,
  }) {
    if (skills.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: Dimensions.sm),
            Expanded(
              child: Text(
                emptyMessage,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: Dimensions.sm,
      runSpacing: Dimensions.sm,
      children: skills.map((skill) {
        final isSelected = selectedSkillId == skill.id;
        return GestureDetector(
          onTap: () => onSelect(skill),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.md,
              vertical: Dimensions.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : AppColors.surface,
              borderRadius: BorderRadius.circular(Dimensions.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : AppColors.gray300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  skill.skillName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill.categoryName,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _buildLevelDot(skill.level, isSelected),
                    const SizedBox(width: 4),
                    Text(
                      skill.level.name,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLevelDot(SkillLevel level, bool isSelected) {
    Color color;
    switch (level) {
      case SkillLevel.beginner:
        color = isSelected ? Colors.white : AppColors.success;
        break;
      case SkillLevel.intermediate:
        color = isSelected ? Colors.white : AppColors.warning;
        break;
      case SkillLevel.expert:
        color = isSelected ? Colors.white : AppColors.error;
        break;
    }

    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDurationSelector() {
    final durations = [0.5, 1.0, 1.5, 2.0];

    return Row(
      children: durations.map((duration) {
        final isSelected = _selectedDuration == duration;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedDuration = duration);
              ref.read(swapRequestNotifierProvider.notifier).updateDuration(duration);
            },
            child: Container(
              margin: EdgeInsets.only(
                right: duration != durations.last ? Dimensions.sm : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.md),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : AppColors.surface,
                borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.gray300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    duration == 0.5 ? '30' : (duration == duration.toInt() ? '${duration.toInt()}' : duration.toStringAsFixed(1)),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    duration == 0.5 ? 'min' : (duration <= 1.0 ? 'hour' : 'hours'),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCreditsInfo() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: Dimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Credit Exchange',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This swap will cost ${_selectedDuration.toStringAsFixed(1)} credits (1 credit per hour)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeVisualization(SwapRequestState requestState) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(Dimensions.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skill you're learning (left side)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 28,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  requestState.selectedSkillWanted?.skillName ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Learning',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Swap icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.md),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          // Skill you're teaching (right side)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    size: 28,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  requestState.selectedSkillOffered?.skillName ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Teaching',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return TextField(
      controller: _messageController,
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
        hintText: 'Introduce yourself and explain what you hope to learn...',
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.all(Dimensions.md),
      ),
      onChanged: (value) {
        ref.read(swapRequestNotifierProvider.notifier).updateMessage(value);
      },
    );
  }

  Widget _buildSubmitButton(UserModel provider, SwapRequestState requestState) {
    final canSubmit = requestState.canSubmit;
    final isLoading = requestState.status == SwapRequestStatus.loading;

    return Container(
      padding: const EdgeInsets.all(Dimensions.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (requestState.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(Dimensions.sm),
                margin: const EdgeInsets.only(bottom: Dimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: Dimensions.xs),
                    Expanded(
                      child: Text(
                        requestState.errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit && !isLoading
                    ? () => _submitRequest(provider)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Send Swap Request',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRequest(UserModel provider) async {
    final notifier = ref.read(swapRequestNotifierProvider.notifier);
    final result = await notifier.submitRequest(provider: provider);

    if (result != null && mounted) {
      notifier.reset();
      // Show success modal
      _showSuccessModal(provider);
    }
  }

  void _showSuccessModal(UserModel provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success checkmark
              Container(
                padding: const EdgeInsets.all(Dimensions.lg),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: Dimensions.lg),

              // Title
              const Text(
                'Request Sent!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.sm),

              // Description
              Text(
                'We\'ll notify you when ${provider.displayName} responds to your request.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.xl),

              // View pending requests button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Set navigation to Matches tab (index 1)
                    ref.read(navigationIndexProvider.notifier).state = 1;
                    Navigator.of(context).pop(); // Close dialog
                    // Navigate back to main shell with bottom nav
                    const HomeRoute().go(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                    ),
                  ),
                  child: const Text(
                    'View Pending Requests',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.sm),

              // Back to home link
              TextButton(
                onPressed: () {
                  // Set navigation to Home tab (index 0)
                  ref.read(navigationIndexProvider.notifier).state = 0;
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate back to main shell with bottom nav
                  const HomeRoute().go(context);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryBlue),
    );
  }

  Widget _buildUserNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 64,
            color: AppColors.gray300,
          ),
          const SizedBox(height: Dimensions.md),
          const Text(
            'User not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.login_rounded,
            size: 64,
            color: AppColors.gray300,
          ),
          const SizedBox(height: Dimensions.md),
          const Text(
            'Please log in to request a swap',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: Dimensions.md),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.lg),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}