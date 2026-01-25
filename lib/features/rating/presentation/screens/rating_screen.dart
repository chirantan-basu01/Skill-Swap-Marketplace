import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';
import 'package:skill_swap_marketplace/features/rating/presentation/providers/rating_provider.dart';
import 'package:skill_swap_marketplace/features/rating/presentation/widgets/rating_tags.dart';
import 'package:skill_swap_marketplace/features/rating/presentation/widgets/star_rating.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';

/// Rating screen for post-session feedback
class RatingScreen extends ConsumerStatefulWidget {
  final String swapId;

  const RatingScreen({
    super.key,
    required this.swapId,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _reviewController = TextEditingController();
  Future<dynamic>? _swapFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future so it doesn't recreate on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSwap();
    });
  }

  void _loadSwap() {
    final swapRepo = ref.read(swapRepositoryProvider);
    setState(() {
      _swapFuture = swapRepo.getSwapById(widget.swapId);
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_swapFuture == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder(
      future: _swapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        if (result == null) {
          return _buildErrorScreen('Failed to load swap');
        }

        return result.fold(
          (failure) => _buildErrorScreen(failure.message ?? 'An error occurred'),
          (swap) => _buildRatingContent(swap),
        );
      },
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.gray300,
            ),
            const SizedBox(height: Dimensions.md),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingContent(SwapModel swap) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    final ratingState = ref.watch(ratingNotifierProvider(widget.swapId));
    final ratingNotifier = ref.read(ratingNotifierProvider(widget.swapId).notifier);

    if (currentUser == null) {
      return _buildErrorScreen('Not authenticated');
    }

    // Determine partner info
    final isRequester = currentUser.uid == swap.requesterId;
    final partnerName = isRequester ? swap.providerName : swap.requesterName;
    final partnerPhoto = isRequester ? swap.providerPhoto : swap.requesterPhoto;
    final skillName = isRequester
        ? swap.requesterWants.skillName
        : swap.requesterOffers.skillName;

    // Show different states
    if (ratingState.status == RatingSubmitStatus.waitingForPartner) {
      return _buildWaitingState(partnerName, swap);
    }

    if (ratingState.status == RatingSubmitStatus.complete) {
      return _buildCompleteState(ratingState, isRequester);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
        title: const Text('Rate Your Session'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.lg),
        child: Column(
          children: [
            // Partner avatar
            UserAvatar(
              imageUrl: partnerPhoto,
              name: partnerName,
              size: AvatarSize.lg,
            ),
            const SizedBox(height: Dimensions.md),

            // Question
            Text(
              'How was your session with\n$partnerName?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: Dimensions.sm),

            // Session info
            Text(
              '$skillName lesson',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Dimensions.xl),

            // Star rating
            StarRating(
              rating: ratingState.stars,
              size: 44,
              onRatingChanged: (stars) {
                ratingNotifier.setStars(stars);
              },
            ),
            const SizedBox(height: Dimensions.sm),

            // Rating label
            Text(
              getRatingLabel(ratingState.stars),
              style: TextStyle(
                fontSize: 14,
                color: ratingState.stars > 0
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight:
                    ratingState.stars > 0 ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: Dimensions.xl),

            // Tags section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What went well? (Select all that apply)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.md),
            RatingTags(
              selectedTags: ratingState.selectedTags,
              onTagsChanged: (tags) {
                ratingNotifier.setTags(tags);
              },
            ),
            const SizedBox(height: Dimensions.xl),

            // Review section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Write a review (optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 300,
              onChanged: (value) {
                ratingNotifier.setReview(value);
              },
              decoration: InputDecoration(
                hintText: 'Share your experience with other learners...',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
                ),
              ),
            ),

            // Error message
            if (ratingState.errorMessage != null) ...[
              const SizedBox(height: Dimensions.md),
              Text(
                ratingState.errorMessage!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.error,
                ),
              ),
            ],

            const SizedBox(height: Dimensions.xl),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: ratingState.canSubmit &&
                        ratingState.status != RatingSubmitStatus.loading
                    ? () => ratingNotifier.submitRating(swap)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.gray200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: ratingState.status == RatingSubmitStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(
                          fontSize: 16,
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

  Widget _buildWaitingState(String partnerName, SwapModel swap) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: Dimensions.lg),
              const Text(
                'Thanks for your rating!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              Text(
                'Waiting for $partnerName to rate...',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: Dimensions.xl),
              Container(
                padding: const EdgeInsets.all(Dimensions.lg),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.hourglass_empty,
                      size: 32,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: Dimensions.md),
                    const Text(
                      'Credits will transfer once both ratings are in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: Dimensions.sm),
                    Text(
                      'Or automatically in 48 hours',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Set navigation to Home tab (index 0)
                    ref.read(navigationIndexProvider.notifier).state = 0;
                    // Navigate to main shell with bottom nav
                    const HomeRoute().go(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteState(RatingState state, bool isRequester) {
    final creditsChange = state.creditsEarned;
    final hasCreditsInfo = creditsChange != null;
    final isEarned = (creditsChange ?? 0) > 0;
    final displayAmount = (creditsChange ?? 0).abs();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: Dimensions.lg),
              const Text(
                'Swap Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.lg),
                decoration: BoxDecoration(
                  color: isEarned
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.gray100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    if (hasCreditsInfo) ...[
                      Text(
                        '${isEarned ? '+' : '-'}${displayAmount.toStringAsFixed(1)} credits ${isEarned ? 'earned' : 'spent'}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isEarned
                              ? AppColors.success
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (state.newBalance != null) ...[
                        const SizedBox(height: Dimensions.sm),
                        Text(
                          'New balance: ${state.newBalance!.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ] else ...[
                      const Text(
                        'Rating submitted!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.sm),
                      const Text(
                        'Credits will be updated shortly',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.lg),
              Text(
                "Your partner's review will be visible on your profile now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: Dimensions.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Set navigation to Profile tab (index 4)
                    ref.read(navigationIndexProvider.notifier).state = 4;
                    // Navigate to main shell with bottom nav
                    const HomeRoute().go(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Your Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.md),
              TextButton(
                onPressed: () {
                  // Set navigation to Home tab (index 0)
                  ref.read(navigationIndexProvider.notifier).state = 0;
                  // Navigate to main shell with bottom nav
                  const HomeRoute().go(context);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
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

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rating Required'),
        content: const Text(
          'Please rate your session before leaving. This helps maintain community trust.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit Rating'),
          ),
        ],
      ),
    );
  }
}