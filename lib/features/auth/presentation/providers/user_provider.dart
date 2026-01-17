import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/features/auth/data/repositories/user_repository_impl.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/domain/repositories/user_repository.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

part 'user_provider.g.dart';

/// Provider for the user repository
@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl();
}

/// Extension to add updateProfile method
extension UserRepositoryExtension on UserRepository {
  /// Update profile fields (convenience method)
  Future<void> updateProfile({
    required String displayName,
    String? bio,
    String? timezone,
    Availability? availability,
  }) async {
    final uid = await _getCurrentUserId();
    if (uid == null) throw Exception('No authenticated user');

    // Use Firestore directly for atomic update
    final updates = <String, dynamic>{
      'displayName': displayName,
      'updatedAt': DateTime.now(),
    };

    if (bio != null) updates['bio'] = bio;
    if (timezone != null) updates['timezone'] = timezone;
    if (availability != null) updates['availability'] = availability.name;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(updates);
  }

  Future<String?> _getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}


/// Provider for current user's profile stream
@riverpod
Stream<UserModel?> currentUserProfile(CurrentUserProfileRef ref) {
  final userRepo = ref.watch(userRepositoryProvider);

  // Watch auth state stream to trigger rebuild when user changes
  // This is critical for account switching - without this, the provider
  // won't rebuild because authRepositoryProvider returns the same instance
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }
      return userRepo.getUserStream(user.uid).handleError((error) {
        // Return null on permission errors (e.g., during logout)
        return null;
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
}

/// Provider to check if profile setup is complete
/// Note: This is a FutureProvider, so it should NOT watch StreamProviders
/// to avoid "disposed during loading" errors. Account switching is handled
/// by invalidating this provider in signOut() and signIn() methods.
@riverpod
Future<bool> isProfileComplete(IsProfileCompleteRef ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  final currentUser = authRepo.currentUser;
  if (currentUser == null) {
    return false;
  }

  final result = await userRepo.isProfileComplete(currentUser.uid);
  return result.fold(
    (failure) => false,
    (isComplete) => isComplete,
  );
}

/// Profile setup state
enum ProfileSetupStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileSetupState {
  final ProfileSetupStatus status;
  final Failure? error;
  final String? errorMessage;
  final int currentStep;

  // Form data for profile setup
  final String displayName;
  final String bio;
  final String? photoUrl;
  final List<SkillOffered> skillsOffered;
  final List<SkillWanted> skillsWanted;
  final String timezone;
  final Availability availability;

  const ProfileSetupState({
    this.status = ProfileSetupStatus.initial,
    this.error,
    this.errorMessage,
    this.currentStep = 0,
    this.displayName = '',
    this.bio = '',
    this.photoUrl,
    this.skillsOffered = const [],
    this.skillsWanted = const [],
    this.timezone = '',
    this.availability = Availability.flexible,
  });

  ProfileSetupState copyWith({
    ProfileSetupStatus? status,
    Failure? error,
    String? errorMessage,
    bool clearError = false,
    int? currentStep,
    String? displayName,
    String? bio,
    String? photoUrl,
    List<SkillOffered>? skillsOffered,
    List<SkillWanted>? skillsWanted,
    String? timezone,
    Availability? availability,
  }) {
    return ProfileSetupState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentStep: currentStep ?? this.currentStep,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      skillsOffered: skillsOffered ?? this.skillsOffered,
      skillsWanted: skillsWanted ?? this.skillsWanted,
      timezone: timezone ?? this.timezone,
      availability: availability ?? this.availability,
    );
  }
}

/// Profile setup notifier for managing the setup wizard
@Riverpod(keepAlive: true)
class ProfileSetupNotifier extends _$ProfileSetupNotifier {
  @override
  ProfileSetupState build() {
    return const ProfileSetupState();
  }

  UserRepository get _userRepo => ref.read(userRepositoryProvider);

  void updateBasicInfo({
    required String displayName,
    String? bio,
    String? photoUrl,
  }) {
    state = state.copyWith(
      displayName: displayName,
      bio: bio ?? state.bio,
      photoUrl: photoUrl ?? state.photoUrl,
    );
  }

  void addSkillOffered(SkillOffered skill) {
    final updatedSkills = [...state.skillsOffered, skill];
    state = state.copyWith(skillsOffered: updatedSkills);
  }

  void removeSkillOffered(String skillId) {
    final updatedSkills =
        state.skillsOffered.where((s) => s.id != skillId).toList();
    state = state.copyWith(skillsOffered: updatedSkills);
  }

  void addSkillWanted(SkillWanted skill) {
    final updatedSkills = [...state.skillsWanted, skill];
    state = state.copyWith(skillsWanted: updatedSkills);
  }

  void removeSkillWanted(String skillId) {
    final updatedSkills =
        state.skillsWanted.where((s) => s.id != skillId).toList();
    state = state.copyWith(skillsWanted: updatedSkills);
  }

  void updateAvailability({
    required String timezone,
    required String availability,
  }) {
    final availabilityEnum = Availability.values.firstWhere(
      (a) => a.name == availability,
      orElse: () => Availability.flexible,
    );
    state = state.copyWith(
      timezone: timezone,
      availability: availabilityEnum,
    );
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<bool> saveBasicInfo(String uid) async {
    state = state.copyWith(status: ProfileSetupStatus.loading);

    final result = await _userRepo.updateBasicInfo(
      uid: uid,
      displayName: state.displayName,
      bio: state.bio,
      photoUrl: state.photoUrl,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  Future<bool> saveSkillsOffered(String uid) async {
    state = state.copyWith(status: ProfileSetupStatus.loading);

    final result = await _userRepo.updateSkillsOffered(
      uid: uid,
      skills: state.skillsOffered,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  Future<bool> saveSkillsWanted(String uid) async {
    state = state.copyWith(status: ProfileSetupStatus.loading);

    final result = await _userRepo.updateSkillsWanted(
      uid: uid,
      skills: state.skillsWanted,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  Future<bool> saveAvailability(String uid) async {
    state = state.copyWith(status: ProfileSetupStatus.loading);

    final result = await _userRepo.updateAvailability(
      uid: uid,
      timezone: state.timezone,
      availability: state.availability,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  Future<bool> createInitialProfile(String uid, String email) async {
    state = state.copyWith(status: ProfileSetupStatus.loading);

    final now = DateTime.now();
    final newUser = UserModel(
      uid: uid,
      email: email,
      displayName: state.displayName,
      bio: state.bio,
      photoUrl: state.photoUrl,
      skillsOffered: state.skillsOffered,
      skillsWanted: state.skillsWanted,
      timezone: state.timezone,
      availability: state.availability,
      createdAt: now,
      updatedAt: now,
      lastActiveAt: now,
    );

    final result = await _userRepo.createUser(newUser);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  /// Save the complete profile (creates new user document)
  Future<bool> saveProfile() async {
    state = state.copyWith(status: ProfileSetupStatus.loading, clearError: true);

    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      state = state.copyWith(
        status: ProfileSetupStatus.error,
        errorMessage: 'No authenticated user found',
      );
      return false;
    }

    final now = DateTime.now();
    final newUser = UserModel(
      uid: currentUser.uid,
      email: currentUser.email ?? '',
      displayName: state.displayName,
      bio: state.bio,
      photoUrl: state.photoUrl,
      skillsOffered: state.skillsOffered,
      skillsWanted: state.skillsWanted,
      timezone: state.timezone,
      availability: state.availability,
      createdAt: now,
      updatedAt: now,
      lastActiveAt: now,
    );

    final result = await _userRepo.createUser(newUser);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileSetupStatus.error,
          error: failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ProfileSetupStatus.success);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void reset() {
    state = const ProfileSetupState();
  }
}