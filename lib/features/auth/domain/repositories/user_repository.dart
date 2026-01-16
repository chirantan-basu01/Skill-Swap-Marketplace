import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

/// Abstract repository for user operations
abstract class UserRepository {
  /// Get user by ID
  FutureEither<UserModel> getUserById(String uid);

  /// Get user stream by ID
  Stream<UserModel?> getUserStream(String uid);

  /// Create a new user profile
  FutureEither<UserModel> createUser(UserModel user);

  /// Update user profile
  FutureEither<UserModel> updateUser(UserModel user);

  /// Update user's basic info (display name, bio, photo)
  FutureVoid updateBasicInfo({
    required String uid,
    required String displayName,
    String? bio,
    String? photoUrl,
  });

  /// Update user's skills offered
  FutureVoid updateSkillsOffered({
    required String uid,
    required List<SkillOffered> skills,
  });

  /// Update user's skills wanted
  FutureVoid updateSkillsWanted({
    required String uid,
    required List<SkillWanted> skills,
  });

  /// Update user's availability
  FutureVoid updateAvailability({
    required String uid,
    required String timezone,
    required Availability availability,
  });

  /// Update last active timestamp
  FutureVoid updateLastActive(String uid);

  /// Check if user profile exists
  FutureEither<bool> userExists(String uid);

  /// Check if user has completed profile setup
  FutureEither<bool> isProfileComplete(String uid);

  /// Delete user profile
  FutureVoid deleteUser(String uid);
}