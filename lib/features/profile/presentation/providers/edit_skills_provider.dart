import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/user_provider.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

part 'edit_skills_provider.g.dart';

// =============================================================================
// EDIT SKILLS OFFERED
// =============================================================================

/// State for editing skills offered
class EditSkillsOfferedState {
  final List<SkillOffered> skills;
  final List<SkillOffered> originalSkills;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const EditSkillsOfferedState({
    this.skills = const [],
    this.originalSkills = const [],
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  bool get hasChanges {
    if (skills.length != originalSkills.length) return true;
    return !skills.every(
      (skill) => originalSkills.any((original) => original.id == skill.id),
    );
  }

  bool get canSave => hasChanges && skills.isNotEmpty && !isLoading;

  EditSkillsOfferedState copyWith({
    List<SkillOffered>? skills,
    List<SkillOffered>? originalSkills,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditSkillsOfferedState(
      skills: skills ?? this.skills,
      originalSkills: originalSkills ?? this.originalSkills,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier for editing skills offered
@riverpod
class EditSkillsOfferedNotifier extends _$EditSkillsOfferedNotifier {
  @override
  EditSkillsOfferedState build() {
    return const EditSkillsOfferedState();
  }

  /// Initialize with current user's skills
  void initialize(List<SkillOffered> currentSkills) {
    if (state.isInitialized) return;
    state = state.copyWith(
      skills: List.from(currentSkills),
      originalSkills: List.from(currentSkills),
      isInitialized: true,
    );
  }

  /// Add a skill
  void addSkill(SkillOffered skill) {
    final updatedSkills = [...state.skills, skill];
    state = state.copyWith(skills: updatedSkills);
  }

  /// Remove a skill by ID
  void removeSkill(String skillId) {
    final updatedSkills = state.skills.where((s) => s.id != skillId).toList();
    state = state.copyWith(skills: updatedSkills);
  }

  /// Save changes to Firestore
  Future<bool> saveChanges() async {
    if (!state.canSave) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);
      final currentUser = authRepo.currentUser;

      if (currentUser == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Not authenticated',
        );
        return false;
      }

      final result = await userRepo.updateSkillsOffered(
        uid: currentUser.uid,
        skills: state.skills,
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message ?? 'Failed to update skills',
          );
          return false;
        },
        (_) {
          // Update original skills to match current (no more changes)
          state = state.copyWith(
            isLoading: false,
            originalSkills: List.from(state.skills),
          );
          // Refresh user profile
          ref.invalidate(currentUserProfileProvider);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update skills: $e',
      );
      return false;
    }
  }

  /// Reset state
  void reset() {
    state = const EditSkillsOfferedState();
  }
}

// =============================================================================
// EDIT SKILLS WANTED
// =============================================================================

/// State for editing skills wanted
class EditSkillsWantedState {
  final List<SkillWanted> skills;
  final List<SkillWanted> originalSkills;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const EditSkillsWantedState({
    this.skills = const [],
    this.originalSkills = const [],
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  bool get hasChanges {
    if (skills.length != originalSkills.length) return true;
    return !skills.every(
      (skill) => originalSkills.any((original) => original.id == skill.id),
    );
  }

  bool get canSave => hasChanges && skills.isNotEmpty && !isLoading;

  EditSkillsWantedState copyWith({
    List<SkillWanted>? skills,
    List<SkillWanted>? originalSkills,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditSkillsWantedState(
      skills: skills ?? this.skills,
      originalSkills: originalSkills ?? this.originalSkills,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier for editing skills wanted
@riverpod
class EditSkillsWantedNotifier extends _$EditSkillsWantedNotifier {
  @override
  EditSkillsWantedState build() {
    return const EditSkillsWantedState();
  }

  /// Initialize with current user's skills
  void initialize(List<SkillWanted> currentSkills) {
    if (state.isInitialized) return;
    state = state.copyWith(
      skills: List.from(currentSkills),
      originalSkills: List.from(currentSkills),
      isInitialized: true,
    );
  }

  /// Add a skill
  void addSkill(SkillWanted skill) {
    final updatedSkills = [...state.skills, skill];
    state = state.copyWith(skills: updatedSkills);
  }

  /// Remove a skill by ID
  void removeSkill(String skillId) {
    final updatedSkills = state.skills.where((s) => s.id != skillId).toList();
    state = state.copyWith(skills: updatedSkills);
  }

  /// Save changes to Firestore
  Future<bool> saveChanges() async {
    if (!state.canSave) return false;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);
      final currentUser = authRepo.currentUser;

      if (currentUser == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Not authenticated',
        );
        return false;
      }

      final result = await userRepo.updateSkillsWanted(
        uid: currentUser.uid,
        skills: state.skills,
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message ?? 'Failed to update skills',
          );
          return false;
        },
        (_) {
          // Update original skills to match current (no more changes)
          state = state.copyWith(
            isLoading: false,
            originalSkills: List.from(state.skills),
          );
          // Refresh user profile
          ref.invalidate(currentUserProfileProvider);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update skills: $e',
      );
      return false;
    }
  }

  /// Reset state
  void reset() {
    state = const EditSkillsWantedState();
  }
}