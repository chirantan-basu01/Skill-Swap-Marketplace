import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/home/presentation/providers/users_provider.dart';
import 'package:skill_swap_marketplace/features/skills/presentation/providers/category_provider.dart';

part 'category_users_provider.g.dart';

/// Sort options for category screen
enum CategorySortOption {
  bestMatch('Best Match'),
  highestRated('Highest Rated'),
  mostExperienced('Most Experienced'),
  recentlyActive('Recently Active');

  final String label;
  const CategorySortOption(this.label);
}

/// State for category screen
class CategoryState {
  final String categoryId;
  final String? selectedSkill; // null means "All"
  final CategorySortOption sortOption;

  const CategoryState({
    required this.categoryId,
    this.selectedSkill,
    this.sortOption = CategorySortOption.bestMatch,
  });

  CategoryState copyWith({
    String? categoryId,
    String? selectedSkill,
    bool clearSelectedSkill = false,
    CategorySortOption? sortOption,
  }) {
    return CategoryState(
      categoryId: categoryId ?? this.categoryId,
      selectedSkill: clearSelectedSkill ? null : (selectedSkill ?? this.selectedSkill),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

/// Notifier for category screen state
@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  CategoryState build(String categoryId) {
    return CategoryState(categoryId: categoryId);
  }

  void selectSkill(String? skillName) {
    if (skillName == null) {
      state = state.copyWith(clearSelectedSkill: true);
    } else {
      state = state.copyWith(selectedSkill: skillName);
    }
  }

  void setSortOption(CategorySortOption option) {
    state = state.copyWith(sortOption: option);
  }
}

/// Provider for users who teach skills in a specific category
@riverpod
Future<List<UserModel>> categoryUsers(CategoryUsersRef ref, String categoryId) async {
  final usersAsync = ref.watch(usersProvider);
  final users = usersAsync.valueOrNull ?? [];

  // Filter users who have skills offered in this category
  return users.where((user) {
    return user.skillsOffered.any((skill) =>
      skill.categoryId.toLowerCase() == categoryId.toLowerCase()
    );
  }).toList();
}

/// Provider for filtered and sorted users based on category state
@riverpod
List<UserModel> filteredCategoryUsers(FilteredCategoryUsersRef ref, String categoryId) {
  final categoryState = ref.watch(categoryNotifierProvider(categoryId));
  final categoryUsersAsync = ref.watch(categoryUsersProvider(categoryId));
  final currentUserAsync = ref.watch(currentUserProfileProvider);

  final users = categoryUsersAsync.valueOrNull ?? [];
  final currentUser = currentUserAsync.valueOrNull;

  // Filter by selected skill if any
  var filteredUsers = users;
  if (categoryState.selectedSkill != null) {
    filteredUsers = users.where((user) {
      return user.skillsOffered.any((skill) =>
        skill.skillName.toLowerCase() == categoryState.selectedSkill!.toLowerCase()
      );
    }).toList();
  }

  // Sort users
  switch (categoryState.sortOption) {
    case CategorySortOption.bestMatch:
      if (currentUser != null) {
        filteredUsers.sort((a, b) {
          final scoreA = _calculateMatchScore(currentUser, a);
          final scoreB = _calculateMatchScore(currentUser, b);
          return scoreB.compareTo(scoreA);
        });
      }
      break;
    case CategorySortOption.highestRated:
      filteredUsers.sort((a, b) => b.rating.average.compareTo(a.rating.average));
      break;
    case CategorySortOption.mostExperienced:
      filteredUsers.sort((a, b) => b.swapsCompleted.compareTo(a.swapsCompleted));
      break;
    case CategorySortOption.recentlyActive:
      filteredUsers.sort((a, b) => b.lastActiveAt.compareTo(a.lastActiveAt));
      break;
  }

  return filteredUsers;
}

/// Provider for skills available in a category
@riverpod
Future<List<String>> categorySkills(CategorySkillsRef ref, String categoryId) async {
  final categoryAsync = ref.watch(categoryByIdProvider(categoryId));
  final category = categoryAsync.valueOrNull;

  if (category != null && category.skills.isNotEmpty) {
    // Use skills from category definition
    return category.skills.map((s) => s.name).toList();
  }

  // Fallback: extract skills from users
  final usersAsync = ref.watch(categoryUsersProvider(categoryId));
  final users = usersAsync.valueOrNull ?? [];

  final skills = <String>{};
  for (final user in users) {
    for (final skill in user.skillsOffered) {
      if (skill.categoryId.toLowerCase() == categoryId.toLowerCase()) {
        skills.add(skill.skillName);
      }
    }
  }

  return skills.toList()..sort();
}

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
