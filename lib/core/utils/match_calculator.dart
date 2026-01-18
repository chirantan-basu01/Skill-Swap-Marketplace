import 'dart:math';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';

/// Result of match calculation between two users
class MatchResult {
  /// Overall match percentage (0-100)
  final int percentage;

  /// Whether this is a perfect match (bidirectional skill exchange)
  final bool isPerfectMatch;

  /// Skills the other user teaches that match what current user wants
  final List<String> matchingSkillsTheyTeach;

  /// Skills the other user wants that match what current user teaches
  final List<String> matchingSkillsTheyWant;

  /// Breakdown of the match score components
  final MatchScoreBreakdown breakdown;

  const MatchResult({
    required this.percentage,
    required this.isPerfectMatch,
    required this.matchingSkillsTheyTeach,
    required this.matchingSkillsTheyWant,
    required this.breakdown,
  });

  /// Empty result for when there's no match
  static const empty = MatchResult(
    percentage: 0,
    isPerfectMatch: false,
    matchingSkillsTheyTeach: [],
    matchingSkillsTheyWant: [],
    breakdown: MatchScoreBreakdown.empty,
  );
}

/// Breakdown of match score components for transparency
class MatchScoreBreakdown {
  final int skillMatchScore; // 0-50 points
  final int ratingScore; // 0-20 points
  final int activityScore; // 0-15 points
  final int experienceScore; // 0-15 points

  const MatchScoreBreakdown({
    required this.skillMatchScore,
    required this.ratingScore,
    required this.activityScore,
    required this.experienceScore,
  });

  static const empty = MatchScoreBreakdown(
    skillMatchScore: 0,
    ratingScore: 0,
    activityScore: 0,
    experienceScore: 0,
  );

  int get total => skillMatchScore + ratingScore + activityScore + experienceScore;
}

/// Utility class for calculating match scores between users
class MatchCalculator {
  MatchCalculator._();

  /// Calculate match result between current user and another user
  ///
  /// The match score is based on:
  /// - Skill overlap (50 points max)
  ///   - Perfect match (bidirectional): 50 points
  ///   - One-way match: 25 points
  /// - Rating (20 points max)
  /// - Recent activity (15 points max)
  /// - Experience/completed swaps (15 points max)
  static MatchResult calculateMatch(UserModel currentUser, UserModel otherUser) {
    // Get skill names for comparison (case-insensitive)
    final myOfferedSkills = currentUser.skillsOffered
        .map((s) => s.skillName.toLowerCase())
        .toSet();
    final myWantedSkills = currentUser.skillsWanted
        .map((s) => s.skillName.toLowerCase())
        .toSet();
    final theirOfferedSkills = otherUser.skillsOffered
        .map((s) => s.skillName.toLowerCase())
        .toSet();
    final theirWantedSkills = otherUser.skillsWanted
        .map((s) => s.skillName.toLowerCase())
        .toSet();

    // Find matching skills
    final theyTeachWhatIWant = myWantedSkills.intersection(theirOfferedSkills);
    final theyWantWhatITeach = myOfferedSkills.intersection(theirWantedSkills);

    // Get original case skill names for display
    final matchingSkillsTheyTeach = otherUser.skillsOffered
        .where((s) => theyTeachWhatIWant.contains(s.skillName.toLowerCase()))
        .map((s) => s.skillName)
        .toList();
    final matchingSkillsTheyWant = otherUser.skillsWanted
        .where((s) => theyWantWhatITeach.contains(s.skillName.toLowerCase()))
        .map((s) => s.skillName)
        .toList();

    // Calculate skill match score (0-50)
    final isPerfectMatch = theyTeachWhatIWant.isNotEmpty && theyWantWhatITeach.isNotEmpty;
    int skillMatchScore = 0;

    if (isPerfectMatch) {
      // Perfect match: base 40 + bonus for each additional matching skill
      skillMatchScore = 40;
      final additionalMatches = (theyTeachWhatIWant.length - 1) + (theyWantWhatITeach.length - 1);
      skillMatchScore += min(additionalMatches * 2, 10); // Max 10 bonus points
    } else if (theyTeachWhatIWant.isNotEmpty || theyWantWhatITeach.isNotEmpty) {
      // One-way match: base 20 + bonus for multiple matches
      skillMatchScore = 20;
      final totalMatches = theyTeachWhatIWant.length + theyWantWhatITeach.length;
      skillMatchScore += min((totalMatches - 1) * 3, 10); // Max 10 bonus points
    }

    // Calculate rating score (0-20)
    // Scale 0-5 rating to 0-20 points
    final ratingScore = ((otherUser.rating.average / 5) * 20).round();

    // Calculate activity score (0-15)
    // More points for more recent activity
    final daysSinceActive = DateTime.now().difference(otherUser.lastActiveAt).inDays;
    int activityScore;
    if (daysSinceActive == 0) {
      activityScore = 15; // Active today
    } else if (daysSinceActive <= 1) {
      activityScore = 12; // Active yesterday
    } else if (daysSinceActive <= 3) {
      activityScore = 9; // Active within 3 days
    } else if (daysSinceActive <= 7) {
      activityScore = 6; // Active within a week
    } else if (daysSinceActive <= 14) {
      activityScore = 3; // Active within 2 weeks
    } else {
      activityScore = 0; // Inactive
    }

    // Calculate experience score (0-15)
    // Based on completed swaps
    final experienceScore = min(otherUser.swapsCompleted, 15);

    final breakdown = MatchScoreBreakdown(
      skillMatchScore: skillMatchScore,
      ratingScore: ratingScore,
      activityScore: activityScore,
      experienceScore: experienceScore,
    );

    // Total percentage (capped at 100)
    final percentage = min(breakdown.total, 100);

    return MatchResult(
      percentage: percentage,
      isPerfectMatch: isPerfectMatch,
      matchingSkillsTheyTeach: matchingSkillsTheyTeach,
      matchingSkillsTheyWant: matchingSkillsTheyWant,
      breakdown: breakdown,
    );
  }

  /// Get perfect matches for a user
  /// Returns users who both teach what the user wants AND want what the user teaches
  static List<UserWithMatch> getPerfectMatches(
    UserModel currentUser,
    List<UserModel> allUsers,
  ) {
    final results = <UserWithMatch>[];

    for (final user in allUsers) {
      if (user.uid == currentUser.uid) continue;

      final matchResult = calculateMatch(currentUser, user);
      if (matchResult.isPerfectMatch) {
        results.add(UserWithMatch(user: user, match: matchResult));
      }
    }

    // Sort by match percentage (highest first)
    results.sort((a, b) => b.match.percentage.compareTo(a.match.percentage));

    return results;
  }

  /// Get recommended users sorted by match score
  /// Excludes perfect matches (use getPerfectMatches for those)
  static List<UserWithMatch> getRecommendedUsers(
    UserModel currentUser,
    List<UserModel> allUsers, {
    int limit = 10,
    bool excludePerfectMatches = false,
  }) {
    final results = <UserWithMatch>[];

    for (final user in allUsers) {
      if (user.uid == currentUser.uid) continue;

      final matchResult = calculateMatch(currentUser, user);

      // Optionally exclude perfect matches
      if (excludePerfectMatches && matchResult.isPerfectMatch) continue;

      // Only include users with some match score
      if (matchResult.percentage > 0) {
        results.add(UserWithMatch(user: user, match: matchResult));
      }
    }

    // Sort by match percentage (highest first)
    results.sort((a, b) => b.match.percentage.compareTo(a.match.percentage));

    return results.take(limit).toList();
  }

  /// Get recently active users with match info
  static List<UserWithMatch> getRecentlyActiveUsers(
    UserModel currentUser,
    List<UserModel> allUsers, {
    int limit = 10,
    Duration maxInactiveDuration = const Duration(hours: 48),
  }) {
    final cutoff = DateTime.now().subtract(maxInactiveDuration);
    final results = <UserWithMatch>[];

    for (final user in allUsers) {
      if (user.uid == currentUser.uid) continue;
      if (user.lastActiveAt.isBefore(cutoff)) continue;

      final matchResult = calculateMatch(currentUser, user);
      results.add(UserWithMatch(user: user, match: matchResult));
    }

    // Sort by last active time (most recent first), then by match score
    results.sort((a, b) {
      final activeCompare = b.user.lastActiveAt.compareTo(a.user.lastActiveAt);
      if (activeCompare != 0) return activeCompare;
      return b.match.percentage.compareTo(a.match.percentage);
    });

    return results.take(limit).toList();
  }
}

/// User paired with their match result
class UserWithMatch {
  final UserModel user;
  final MatchResult match;

  const UserWithMatch({
    required this.user,
    required this.match,
  });
}