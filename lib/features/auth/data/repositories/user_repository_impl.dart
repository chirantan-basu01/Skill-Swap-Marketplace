import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/auth/domain/repositories/user_repository.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/skill_model.dart';

/// Implementation of [UserRepository] using Cloud Firestore
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(FirestoreCollections.users);

  @override
  FutureEither<UserModel> getUserById(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return left(const Failure(message: 'User not found'));
      }

      final user = UserModel.fromJson(doc.data()!);
      return right(user);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Stream<UserModel?> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromJson(doc.data()!);
    });
  }

  @override
  FutureEither<UserModel> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toJson());
      return right(user);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<UserModel> updateUser(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await _usersCollection.doc(user.uid).update(updatedUser.toJson());
      return right(updatedUser);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid updateBasicInfo({
    required String uid,
    required String displayName,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        UserFields.displayName: displayName,
        UserFields.bio: bio ?? '',
        UserFields.updatedAt: Timestamp.now(),
      };

      if (photoUrl != null) {
        updates[UserFields.photoUrl] = photoUrl;
      }

      await _usersCollection.doc(uid).update(updates);
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid updateSkillsOffered({
    required String uid,
    required List<SkillOffered> skills,
  }) async {
    try {
      await _usersCollection.doc(uid).update({
        UserFields.skillsOffered: skills.map((s) => s.toJson()).toList(),
        UserFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid updateSkillsWanted({
    required String uid,
    required List<SkillWanted> skills,
  }) async {
    try {
      await _usersCollection.doc(uid).update({
        UserFields.skillsWanted: skills.map((s) => s.toJson()).toList(),
        UserFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid updateAvailability({
    required String uid,
    required String timezone,
    required Availability availability,
  }) async {
    try {
      await _usersCollection.doc(uid).update({
        UserFields.timezone: timezone,
        UserFields.availability: availability.name,
        UserFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid updateLastActive(String uid) async {
    try {
      await _usersCollection.doc(uid).update({
        UserFields.lastActiveAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> userExists(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      return right(doc.exists);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> isProfileComplete(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return right(false);
      }

      final data = doc.data()!;
      final displayName = data[UserFields.displayName] as String? ?? '';
      final skillsOffered = data[UserFields.skillsOffered] as List? ?? [];
      final skillsWanted = data[UserFields.skillsWanted] as List? ?? [];

      // Profile is complete if user has display name and at least one skill offered/wanted
      final isComplete = displayName.isNotEmpty &&
          skillsOffered.isNotEmpty &&
          skillsWanted.isNotEmpty;

      return right(isComplete);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}