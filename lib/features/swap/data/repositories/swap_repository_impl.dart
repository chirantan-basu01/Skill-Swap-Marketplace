import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';
import 'package:skill_swap_marketplace/features/swap/domain/repositories/swap_repository.dart';

/// Implementation of [SwapRepository] using Cloud Firestore
class SwapRepositoryImpl implements SwapRepository {
  final FirebaseFirestore _firestore;

  SwapRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _swapsCollection =>
      _firestore.collection(FirestoreCollections.swaps);

  @override
  FutureEither<SwapModel> createSwap(SwapModel swap) async {
    try {
      final docRef = _swapsCollection.doc();
      final swapWithId = swap.copyWith(id: docRef.id);
      await docRef.set(swapWithId.toJson());
      return right(swapWithId);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<SwapModel> getSwapById(String swapId) async {
    try {
      final doc = await _swapsCollection.doc(swapId).get();

      if (!doc.exists || doc.data() == null) {
        return left(const Failure(message: 'Swap not found'));
      }

      final swap = SwapModel.fromJson(doc.data()!);
      return right(swap);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Stream<List<SwapModel>> getUserSwaps(String userId) {
    // Simple query without compound index - filter client-side
    return _swapsCollection
        .limit(100)
        .snapshots()
        .map((snapshot) {
          final swaps = snapshot.docs
              .map((doc) => SwapModel.fromJson(doc.data()))
              .where((swap) =>
                  swap.requesterId == userId || swap.providerId == userId)
              .toList();
          // Sort by updatedAt descending
          swaps.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return swaps;
        });
  }

  @override
  Stream<List<SwapModel>> getUserSwapsByStatus(
      String userId, SwapStatus status) {
    return getUserSwaps(userId).map((swaps) =>
        swaps.where((swap) => swap.status == status).toList());
  }

  @override
  Stream<List<SwapModel>> getIncomingRequests(String userId) {
    // Query by providerId only, filter status client-side
    return _swapsCollection
        .where(SwapFields.providerId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final swaps = snapshot.docs
              .map((doc) => SwapModel.fromJson(doc.data()))
              .where((swap) => swap.status == SwapStatus.pending)
              .toList();
          // Sort by createdAt descending
          swaps.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return swaps;
        });
  }

  @override
  Stream<List<SwapModel>> getOutgoingRequests(String userId) {
    // Query by requesterId only, filter status client-side
    return _swapsCollection
        .where(SwapFields.requesterId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final swaps = snapshot.docs
              .map((doc) => SwapModel.fromJson(doc.data()))
              .where((swap) => swap.status == SwapStatus.pending)
              .toList();
          // Sort by createdAt descending
          swaps.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return swaps;
        });
  }

  @override
  Stream<List<SwapModel>> getActiveSwaps(String userId) {
    return getUserSwaps(userId).map((swaps) => swaps
        .where((swap) =>
            swap.status == SwapStatus.accepted ||
            swap.status == SwapStatus.scheduled ||
            swap.status == SwapStatus.inProgress)
        .toList());
  }

  @override
  Stream<List<SwapModel>> getCompletedSwaps(String userId) {
    return getUserSwaps(userId).map((swaps) {
      final completed =
          swaps.where((swap) => swap.status == SwapStatus.completed).toList();
      // Sort by completedAt if available
      completed.sort((a, b) {
        final aTime = a.completedAt ?? a.updatedAt;
        final bTime = b.completedAt ?? b.updatedAt;
        return bTime.compareTo(aTime);
      });
      return completed;
    });
  }

  @override
  FutureVoid updateSwapStatus(String swapId, SwapStatus status) async {
    try {
      await _swapsCollection.doc(swapId).update({
        SwapFields.status: status.jsonValue,
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid acceptSwap(String swapId) async {
    try {
      await _swapsCollection.doc(swapId).update({
        SwapFields.status: SwapStatus.accepted.jsonValue,
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid declineSwap(String swapId) async {
    try {
      await _swapsCollection.doc(swapId).update({
        SwapFields.status: SwapStatus.declined.jsonValue,
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid cancelSwap(
      String swapId, String cancelledBy, String? reason) async {
    try {
      await _swapsCollection.doc(swapId).update({
        SwapFields.status: SwapStatus.cancelled.jsonValue,
        SwapFields.cancelledBy: cancelledBy,
        SwapFields.cancelReason: reason ?? '',
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid scheduleSession({
    required String swapId,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? videoLink,
  }) async {
    try {
      final session = SwapSession(
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        videoLink: videoLink ?? '',
      );

      await _swapsCollection.doc(swapId).update({
        SwapFields.status: SwapStatus.scheduled.jsonValue,
        SwapFields.session: session.toJson(),
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid startSession(String swapId, String oderId) async {
    try {
      final doc = await _swapsCollection.doc(swapId).get();
      if (!doc.exists || doc.data() == null) {
        return left(const Failure(message: 'Swap not found'));
      }

      final swap = SwapModel.fromJson(doc.data()!);
      if (swap.session == null) {
        return left(const Failure(message: 'Session not scheduled'));
      }

      final isRequester = oderId == swap.requesterId;
      final updates = <String, dynamic>{
        SwapFields.updatedAt: Timestamp.now(),
      };

      if (isRequester) {
        updates['${SwapFields.session}.requesterStarted'] = true;
      } else {
        updates['${SwapFields.session}.providerStarted'] = true;
      }

      // If both have started, mark as in progress
      final session = swap.session!;
      final bothStarted = (isRequester && session.providerStarted) ||
          (!isRequester && session.requesterStarted);

      if (bothStarted) {
        updates[SwapFields.status] = SwapStatus.inProgress.jsonValue;
        updates['${SwapFields.session}.actualStartTime'] = Timestamp.now();
      }

      await _swapsCollection.doc(swapId).update(updates);
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid completeSwap(String swapId) async {
    try {
      await _swapsCollection.doc(swapId).update({
        SwapFields.status: SwapStatus.completed.jsonValue,
        SwapFields.completedAt: Timestamp.now(),
        SwapFields.updatedAt: Timestamp.now(),
        '${SwapFields.session}.actualEndTime': Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid addRating({
    required String swapId,
    required String oderId,
    required int stars,
    List<String>? tags,
    String? review,
  }) async {
    try {
      final rating = SwapRating(
        oderId: oderId,
        stars: stars,
        tags: tags ?? [],
        review: review ?? '',
        createdAt: DateTime.now(),
      );

      await _swapsCollection.doc(swapId).update({
        '${SwapFields.ratings}.$oderId': rating.toJson(),
        SwapFields.updatedAt: Timestamp.now(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> hasPendingSwapWith(
      String requesterId, String providerId) async {
    try {
      // Simple query - filter client-side to avoid index requirement
      final snapshot = await _swapsCollection
          .where(SwapFields.requesterId, isEqualTo: requesterId)
          .where(SwapFields.providerId, isEqualTo: providerId)
          .get();

      final hasPending = snapshot.docs.any((doc) {
        final data = doc.data();
        return data[SwapFields.status] == SwapStatus.pending.jsonValue;
      });

      return right(hasPending);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<int> getSwapCount(String userId) async {
    try {
      // Get all swaps for user and count completed ones client-side
      final snapshot = await _swapsCollection
          .limit(200)
          .get();

      final count = snapshot.docs.where((doc) {
        final data = doc.data();
        final isParticipant = data[SwapFields.requesterId] == userId ||
            data[SwapFields.providerId] == userId;
        final isCompleted = data[SwapFields.status] == SwapStatus.completed.jsonValue;
        return isParticipant && isCompleted;
      }).length;

      return right(count);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}