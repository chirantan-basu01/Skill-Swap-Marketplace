import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/utils/match_calculator.dart';
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
                user.uid != currentAuthUser.uid && user.status == UserStatus.active)
            .toList();
        // Sort by lastActiveAt client-side
        users.sort((a, b) => b.lastActiveAt.compareTo(a.lastActiveAt));
        return users;
      });
});

/// Provider for perfect matches (bidirectional skill match)
/// Uses MatchCalculator for sophisticated match scoring
final perfectMatchesProvider = Provider<List<UserModel>>((ref) {
  final currentUserAsync = ref.watch(currentUserProfileProvider);
  final usersAsync = ref.watch(usersProvider);

  final currentUser = currentUserAsync.valueOrNull;
  final users = usersAsync.valueOrNull;

  if (currentUser == null || users == null) {
    return [];
  }

  // Use MatchCalculator for perfect matches
  final perfectMatches = MatchCalculator.getPerfectMatches(currentUser, users);
  return perfectMatches.map((m) => m.user).toList();
});

/// Provider for recommended users (sorted by match score)
/// Uses MatchCalculator for sophisticated match scoring
final recommendedUsersProvider = Provider<List<UserWithScore>>((ref) {
  final currentUserAsync = ref.watch(currentUserProfileProvider);
  final usersAsync = ref.watch(usersProvider);

  final currentUser = currentUserAsync.valueOrNull;
  final users = usersAsync.valueOrNull;

  if (currentUser == null || users == null) {
    return [];
  }

  // Use MatchCalculator for recommended users (excludes perfect matches)
  final recommended = MatchCalculator.getRecommendedUsers(
    currentUser,
    users,
    limit: 20,
    excludePerfectMatches: true,
  );

  return recommended.map((m) => UserWithScore(
    user: m.user,
    matchResult: m.match,
  )).toList();
});

/// Provider for recently active users
final recentlyActiveUsersProvider = Provider<List<UserModel>>((ref) {
  final currentUserAsync = ref.watch(currentUserProfileProvider);
  final usersAsync = ref.watch(usersProvider);

  final currentUser = currentUserAsync.valueOrNull;
  final users = usersAsync.valueOrNull;

  if (currentUser == null || users == null) return [];

  // Use MatchCalculator for recently active users
  final recentlyActive = MatchCalculator.getRecentlyActiveUsers(
    currentUser,
    users,
    limit: 10,
    maxInactiveDuration: const Duration(hours: 48),
  );

  return recentlyActive.map((m) => m.user).toList();
});

/// User with calculated match result
class UserWithScore {
  final UserModel user;
  final MatchResult matchResult;

  UserWithScore({
    required this.user,
    required this.matchResult,
  });

  /// Get match percentage (0-100)
  int get matchPercentage => matchResult.percentage;

  /// Whether this is a perfect match
  bool get isPerfectMatch => matchResult.isPerfectMatch;

  /// Skills they teach that match what current user wants
  List<String> get matchingSkillsTheyTeach => matchResult.matchingSkillsTheyTeach;

  /// Skills they want that match what current user teaches
  List<String> get matchingSkillsTheyWant => matchResult.matchingSkillsTheyWant;
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