import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';

/// Provider for current user's UserModel (convenience wrapper)
/// This watches the currentUserProfileProvider and re-emits its values
final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
  // Create a stream from the AsyncValue updates
  final asyncValue = ref.watch(currentUserProfileProvider);
  return Stream.value(asyncValue.valueOrNull);
});

/// Provider for fetching all users (excluding current user)
/// Note: This query requires a Firestore composite index on:
/// Collection: users, Fields: status (Ascending), lastActiveAt (Descending)
final usersProvider = StreamProvider<List<UserModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final currentAuthUser = authState.valueOrNull;

  if (currentAuthUser == null) {
    return Stream.value([]);
  }

  // Simple query without compound index requirement as fallback
  // If you have the index, use the optimized query below
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.users)
      .limit(50)
      .snapshots()
      .map((snapshot) {
        final users = snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .where((user) =>
                user.uid != currentAuthUser.uid && user.status == 'active')
            .toList();
        // Sort by lastActiveAt client-side
        users.sort((a, b) => b.lastActiveAt.compareTo(a.lastActiveAt));
        return users;
      });
});

/// Provider for perfect matches (bidirectional skill match)
final perfectMatchesProvider = Provider<List<UserModel>>((ref) {
  final currentUserAsync = ref.watch(currentUserProfileProvider);
  final usersAsync = ref.watch(usersProvider);

  final currentUser = currentUserAsync.valueOrNull;
  final users = usersAsync.valueOrNull;

  if (currentUser == null || users == null) {
    return [];
  }

  // Get skill names
  final myOfferedSkills =
      currentUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
  final myWantedSkills =
      currentUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();

  // Find users who want what I offer AND offer what I want
  return users.where((user) {
    final theirOfferedSkills =
        user.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
    final theirWantedSkills =
        user.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();

    final theyWantMySkill =
        myOfferedSkills.intersection(theirWantedSkills).isNotEmpty;
    final theyOfferWhatIWant =
        myWantedSkills.intersection(theirOfferedSkills).isNotEmpty;

    return theyWantMySkill && theyOfferWhatIWant;
  }).toList();
});

/// Provider for recommended users (sorted by match score)
final recommendedUsersProvider = Provider<List<UserWithScore>>((ref) {
  final currentUserAsync = ref.watch(currentUserProfileProvider);
  final usersAsync = ref.watch(usersProvider);

  final currentUser = currentUserAsync.valueOrNull;
  final users = usersAsync.valueOrNull;

  if (currentUser == null || users == null) {
    return [];
  }

  // Calculate match scores for all users
  final scoredUsers = users.map((user) {
    final score = _calculateMatchScore(currentUser, user);
    return UserWithScore(user: user, score: score);
  }).toList();

  // Sort by score descending
  scoredUsers.sort((a, b) => b.score.compareTo(a.score));

  // Return top users with score > 0
  return scoredUsers.where((u) => u.score > 0).take(10).toList();
});

/// Provider for recently active users
final recentlyActiveUsersProvider = Provider<List<UserModel>>((ref) {
  final usersAsync = ref.watch(usersProvider);
  final users = usersAsync.valueOrNull;

  if (users == null) return [];

  final now = DateTime.now();
  final threshold = now.subtract(const Duration(hours: 48));

  return users.where((user) {
    return user.lastActiveAt.isAfter(threshold);
  }).take(5).toList();
});

/// Calculate match score between two users
int _calculateMatchScore(UserModel currentUser, UserModel otherUser) {
  int score = 0;

  // Get skill names
  final myOfferedSkills =
      currentUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
  final myWantedSkills =
      currentUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();
  final theirOfferedSkills =
      otherUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();
  final theirWantedSkills =
      otherUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();

  // Perfect match (bidirectional)
  final theyWantMySkill =
      myOfferedSkills.intersection(theirWantedSkills).isNotEmpty;
  final theyOfferWhatIWant =
      myWantedSkills.intersection(theirOfferedSkills).isNotEmpty;

  if (theyWantMySkill && theyOfferWhatIWant) {
    score += 50;
  } else if (theyWantMySkill || theyOfferWhatIWant) {
    score += 25;
  }

  // Rating factor (0-20 points)
  score += ((otherUser.rating.average / 5) * 20).round();

  // Activity recency (0-15 points)
  final daysSinceActive =
      DateTime.now().difference(otherUser.lastActiveAt).inDays;
  score += max(0, 15 - daysSinceActive);

  // Completed swaps bonus (0-15 points, capped at 15)
  score += min(otherUser.swapsCompleted, 15);

  return score;
}

/// User with calculated match score
class UserWithScore {
  final UserModel user;
  final int score;

  UserWithScore({
    required this.user,
    required this.score,
  });

  /// Get match percentage (normalized to 0-100)
  int get matchPercentage => min(score, 100);
}

/// Provider to check if a user is online (active within last 5 minutes)
bool isUserOnline(UserModel user) {
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(minutes: 5));
  return user.lastActiveAt.isAfter(threshold);
}

/// Provider for matching skills between current user and another user
List<String> getMatchingSkills(UserModel currentUser, UserModel otherUser) {
  final myWantedSkills =
      currentUser.skillsWanted.map((s) => s.skillName.toLowerCase()).toSet();
  final theirOfferedSkills =
      otherUser.skillsOffered.map((s) => s.skillName.toLowerCase()).toSet();

  final matchingSkillsLower = myWantedSkills.intersection(theirOfferedSkills);

  // Return original cased skill names
  return otherUser.skillsOffered
      .where((s) => matchingSkillsLower.contains(s.skillName.toLowerCase()))
      .map((s) => s.skillName)
      .toList();
}