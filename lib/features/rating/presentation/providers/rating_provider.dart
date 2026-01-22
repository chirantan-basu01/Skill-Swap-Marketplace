import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/providers/swaps_provider.dart';
import 'package:skill_swap_marketplace/features/wallet/domain/models/transaction_model.dart';

part 'rating_provider.g.dart';

/// Rating submission state
enum RatingSubmitStatus {
  initial,
  loading,
  waitingForPartner,
  complete,
  error,
}

class RatingState {
  final RatingSubmitStatus status;
  final int stars;
  final Set<String> selectedTags;
  final String review;
  final String? errorMessage;
  final double? creditsEarned;
  final double? newBalance;
  final bool partnerHasRated;

  const RatingState({
    this.status = RatingSubmitStatus.initial,
    this.stars = 0,
    this.selectedTags = const {},
    this.review = '',
    this.errorMessage,
    this.creditsEarned,
    this.newBalance,
    this.partnerHasRated = false,
  });

  bool get canSubmit => stars > 0;

  RatingState copyWith({
    RatingSubmitStatus? status,
    int? stars,
    Set<String>? selectedTags,
    String? review,
    String? errorMessage,
    bool clearError = false,
    double? creditsEarned,
    double? newBalance,
    bool? partnerHasRated,
  }) {
    return RatingState(
      status: status ?? this.status,
      stars: stars ?? this.stars,
      selectedTags: selectedTags ?? this.selectedTags,
      review: review ?? this.review,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      creditsEarned: creditsEarned ?? this.creditsEarned,
      newBalance: newBalance ?? this.newBalance,
      partnerHasRated: partnerHasRated ?? this.partnerHasRated,
    );
  }
}

/// Rating notifier for managing rating submission
@riverpod
class RatingNotifier extends _$RatingNotifier {
  @override
  RatingState build(String swapId) {
    return const RatingState();
  }

  void setStars(int stars) {
    state = state.copyWith(stars: stars, clearError: true);
  }

  void setTags(Set<String> tags) {
    state = state.copyWith(selectedTags: tags);
  }

  void setReview(String review) {
    state = state.copyWith(review: review);
  }

  Future<bool> submitRating(SwapModel swap) async {
    if (!state.canSubmit) {
      state = state.copyWith(
        status: RatingSubmitStatus.error,
        errorMessage: 'Please select a rating',
      );
      return false;
    }

    // Capture stars and tags before any state changes
    final starsToSubmit = state.stars;
    final tagsToSubmit = state.selectedTags.toList();
    final reviewToSubmit = state.review;

    state = state.copyWith(status: RatingSubmitStatus.loading, clearError: true);

    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(
        status: RatingSubmitStatus.error,
        errorMessage: 'You must be logged in',
      );
      return false;
    }

    final swapRepo = ref.read(swapRepositoryProvider);

    // Submit the rating to swap document
    print('submitRating: Submitting rating - stars=$starsToSubmit, tags=$tagsToSubmit');
    final result = await swapRepo.addRating(
      swapId: swapId,
      oderId: currentUser.uid,
      stars: starsToSubmit,
      tags: tagsToSubmit,
      review: reviewToSubmit.isNotEmpty ? reviewToSubmit : null,
    );

    // Handle rating submission result
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      state = state.copyWith(
        status: RatingSubmitStatus.error,
        errorMessage: failure.message,
      );
      return false;
    }

    print('submitRating: Rating submitted to swap document successfully');

    // Get updated swap to check if partner has rated
    final swapResult = await swapRepo.getSwapById(swapId);

    if (swapResult.isLeft()) {
      final failure = swapResult.getLeft().toNullable()!;
      state = state.copyWith(
        status: RatingSubmitStatus.error,
        errorMessage: failure.message,
      );
      return false;
    }

    final updatedSwap = swapResult.getRight().toNullable()!;
    final partnerId = currentUser.uid == swap.requesterId
        ? swap.providerId
        : swap.requesterId;
    final partnerHasRated = updatedSwap.ratings.containsKey(partnerId);

    print('submitRating: partnerId=$partnerId, partnerHasRated=$partnerHasRated');

    if (partnerHasRated) {
      // Both have rated - process credit transfer
      print('submitRating: Both users have rated. Processing credits...');
      print('submitRating: Swap creditAmount: ${swap.creditAmount}');
      final creditResult = await _processCredits(swap, currentUser.uid);

      if (creditResult != null) {
        print('submitRating: Credits processed: ${creditResult.credits}, newBalance: ${creditResult.newBalance}');
        state = state.copyWith(
          status: RatingSubmitStatus.complete,
          partnerHasRated: true,
          creditsEarned: creditResult.credits,
          newBalance: creditResult.newBalance,
        );
      } else {
        state = state.copyWith(
          status: RatingSubmitStatus.complete,
          partnerHasRated: true,
        );
      }
    } else {
      // Waiting for partner
      print('submitRating: Waiting for partner to rate');
      state = state.copyWith(
        status: RatingSubmitStatus.waitingForPartner,
        partnerHasRated: false,
      );
    }

    // Update partner's rating stats (when I rate someone, their rating increases)
    print('submitRating: Updating rating stats for partner $partnerId');
    await _updateUserRatingStats(
      ratedUserId: partnerId,
      stars: starsToSubmit,
      tags: tagsToSubmit,
    );

    print('submitRating: Complete!');
    return true;
  }

  Future<({double credits, double newBalance})?> _processCredits(
    SwapModel swap,
    String currentUserId,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final isRequester = currentUserId == swap.requesterId;

      // Requester learns (spends credits), Provider teaches (earns credits)
      final creditsChange = isRequester ? -swap.creditAmount : swap.creditAmount;

      // Get current balance
      final userDoc = await firestore
          .collection(FirestoreCollections.users)
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        print('_processCredits: User doc does not exist');
        return null;
      }

      final rawBalance = userDoc.data()?[UserFields.creditBalance];
      final currentBalance = (rawBalance is num) ? rawBalance.toDouble() : 1.0;
      final newBalance = currentBalance + creditsChange;

      // Update user balance
      await firestore
          .collection(FirestoreCollections.users)
          .doc(currentUserId)
          .update({
        UserFields.creditBalance: newBalance,
        UserFields.swapsCompleted: FieldValue.increment(1),
        UserFields.hoursExchanged: FieldValue.increment(swap.duration),
        UserFields.updatedAt: Timestamp.now(),
      });

      // Create transaction record
      final transaction = TransactionModel(
        id: '',
        userId: currentUserId,
        type: isRequester ? TransactionType.swapSpent : TransactionType.swapEarned,
        amount: creditsChange.abs(),
        balanceAfter: newBalance,
        swapId: swap.id,
        otherUserId: isRequester ? swap.providerId : swap.requesterId,
        otherUserName: isRequester ? swap.providerName : swap.requesterName,
        skillName: isRequester
            ? swap.requesterWants.skillName
            : swap.requesterOffers.skillName,
        createdAt: DateTime.now(),
      );

      // Use subcollection path: /transactions/{userId}/history/{transactionId}
      final transactionRef = firestore
          .collection(FirestoreCollections.transactions)
          .doc(currentUserId)
          .collection('history')
          .doc();
      print('Creating transaction at path: ${transactionRef.path}');
      await transactionRef.set({
        ...transaction.toJson(),
        TransactionFields.id: transactionRef.id,
      });
      print('Transaction created successfully');

      return (credits: creditsChange, newBalance: newBalance);
    } catch (e, stack) {
      print('_processCredits error: $e');
      print('Stack: $stack');
      return null;
    }
  }

  Future<void> _updateUserRatingStats({
    required String ratedUserId,
    required int stars,
    required List<String> tags,
  }) async {
    try {
      print('_updateUserRatingStats: Updating rating for user $ratedUserId');
      print('_updateUserRatingStats: stars=$stars, tags=$tags');

      final firestore = FirebaseFirestore.instance;
      final userRef = firestore.collection(FirestoreCollections.users).doc(ratedUserId);

      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        print('_updateUserRatingStats: User document does not exist!');
        return;
      }

      final userData = userDoc.data()!;
      final currentRating = userData[UserFields.rating] as Map<String, dynamic>? ?? {};
      print('_updateUserRatingStats: Current rating data: $currentRating');

      final rawAverage = currentRating['average'];
      final currentAverage = (rawAverage is num) ? rawAverage.toDouble() : 0.0;
      final rawCount = currentRating['count'];
      final currentCount = (rawCount is num) ? rawCount.toInt() : 0;
      final currentTags = Map<String, int>.from(
        (currentRating['tags'] as Map<String, dynamic>? ?? {}).map(
          (k, v) => MapEntry(k, (v is num) ? v.toInt() : 0),
        ),
      );

      // Calculate new average
      final newCount = currentCount + 1;
      final newAverage = ((currentAverage * currentCount) + stars) / newCount;

      print('_updateUserRatingStats: New average=$newAverage, newCount=$newCount');

      // Update tag counts
      for (final tag in tags) {
        currentTags[tag] = (currentTags[tag] ?? 0) + 1;
      }

      await userRef.update({
        '${UserFields.rating}.average': newAverage,
        '${UserFields.rating}.count': newCount,
        '${UserFields.rating}.tags': currentTags,
        UserFields.updatedAt: Timestamp.now(),
      });

      print('_updateUserRatingStats: Successfully updated rating for $ratedUserId');
    } catch (e, stack) {
      print('_updateUserRatingStats ERROR: $e');
      print('_updateUserRatingStats Stack: $stack');
      // Continue - rating was still submitted to swap document
    }
  }

  void reset() {
    state = const RatingState();
  }
}

/// Check if current user has already rated a swap
@riverpod
Future<bool> hasUserRatedSwap(HasUserRatedSwapRef ref, String swapId) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) return false;

  final swapRepo = ref.watch(swapRepositoryProvider);
  final result = await swapRepo.getSwapById(swapId);

  return result.fold(
    (failure) => false,
    (swap) => swap.ratings.containsKey(currentUser.uid),
  );
}

/// Get swaps that need rating (completed but not yet rated by current user)
@riverpod
List<SwapModel> swapsNeedingRating(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return [];
  }

  final completedSwapsAsync = ref.watch(completedSwapsProvider);

  return completedSwapsAsync.when(
    data: (swaps) {
      return swaps
          .where((swap) => !swap.ratings.containsKey(currentUser.uid))
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}