import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] using Firebase Auth
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  FutureEither<User> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return left(const Failure(message: 'Failed to create account'));
      }

      return right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return left(const Failure(message: 'Failed to sign in'));
      }

      return right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return left(const Failure(message: 'Google sign in cancelled'));
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return left(const Failure(message: 'Failed to sign in with Google'));
      }

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}