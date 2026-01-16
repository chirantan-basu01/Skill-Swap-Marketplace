import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';

/// Wrapper for handling async operations with error handling.
/// Converts exceptions to [Either] with [Failure] on the left side.
Future<Either<Failure, T>> apiHandler<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return right(result);
  } on FirebaseAuthException catch (e) {
    return left(Failure.fromFirebase(e.code, e.message));
  } on FirebaseException catch (e) {
    return left(Failure.fromFirebase(e.code, e.message));
  } catch (e) {
    return left(Failure(message: e.toString()));
  }
}

/// Extension on Either for easier error handling in UI
extension EitherX<L, R> on Either<L, R> {
  /// Get the right value or null
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// Get the left value or null
  L? get leftOrNull => fold((l) => l, (_) => null);
}