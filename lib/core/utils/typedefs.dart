import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';

/// Type alias for async operations that can fail.
/// Returns [Either] where Left is [Failure] and Right is the success value.
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Type alias for async operations that return void on success
typedef FutureVoid = FutureEither<void>;

/// Type alias for Firestore document data
typedef JsonMap = Map<String, dynamic>;