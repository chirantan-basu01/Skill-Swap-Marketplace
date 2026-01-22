import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';

/// Review model with additional context
class UserReview {
  final String swapId;
  final String reviewerId;
  final String reviewerName;
  final String? reviewerPhoto;
  final int stars;
  final List<String> tags;
  final String review;
  final DateTime createdAt;
  final String skillName;

  const UserReview({
    required this.swapId,
    required this.reviewerId,
    required this.reviewerName,
    this.reviewerPhoto,
    required this.stars,
    required this.tags,
    required this.review,
    required this.createdAt,
    required this.skillName,
  });
}

/// Provider to fetch reviews for a specific user
final userReviewsProvider =
    FutureProvider.family<List<UserReview>, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;

  // Get all completed swaps where the user was a participant
  final swapsSnapshot = await firestore
      .collection(FirestoreCollections.swaps)
      .where(SwapFields.status, isEqualTo: SwapStatus.completed.jsonValue)
      .get();

  final reviews = <UserReview>[];

  for (final doc in swapsSnapshot.docs) {
    final data = doc.data();
    final requesterId = data[SwapFields.requesterId] as String?;
    final providerId = data[SwapFields.providerId] as String?;

    // Check if user is a participant
    if (requesterId != userId && providerId != userId) continue;

    // Get the ratings map
    final ratingsData = data[SwapFields.ratings] as Map<String, dynamic>?;
    if (ratingsData == null) continue;

    // Find the rating given TO this user (from the partner)
    final partnerId = userId == requesterId ? providerId : requesterId;
    final partnerRating = ratingsData[partnerId];

    if (partnerRating == null) continue;

    // Parse the rating
    try {
      final rating = SwapRating.fromJson(
        partnerRating is Map<String, dynamic>
            ? partnerRating
            : Map<String, dynamic>.from(partnerRating as Map),
      );

      // Get partner info for the review
      final partnerName = userId == requesterId
          ? data[SwapFields.providerName] as String? ?? 'Unknown'
          : data[SwapFields.requesterName] as String? ?? 'Unknown';
      final partnerPhoto = userId == requesterId
          ? data[SwapFields.providerPhoto] as String?
          : data[SwapFields.requesterPhoto] as String?;

      // Get skill name - the skill this user taught
      final requesterOffers = data[SwapFields.requesterOffers] as Map<String, dynamic>?;
      final requesterWants = data[SwapFields.requesterWants] as Map<String, dynamic>?;

      String skillName = 'Skill Exchange';
      if (userId == requesterId && requesterOffers != null) {
        skillName = requesterOffers['skillName'] as String? ?? skillName;
      } else if (userId == providerId && requesterWants != null) {
        skillName = requesterWants['skillName'] as String? ?? skillName;
      }

      reviews.add(UserReview(
        swapId: doc.id,
        reviewerId: partnerId ?? '',
        reviewerName: partnerName,
        reviewerPhoto: partnerPhoto,
        stars: rating.stars,
        tags: rating.tags,
        review: rating.review,
        createdAt: rating.createdAt,
        skillName: skillName,
      ));
    } catch (e) {
      // Skip malformed ratings
      continue;
    }
  }

  // Sort by date descending
  reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return reviews;
});