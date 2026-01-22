import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/report/domain/models/report_model.dart';
import 'package:skill_swap_marketplace/features/report/domain/repositories/report_repository.dart';

/// Implementation of [ReportRepository] using Cloud Firestore
class ReportRepositoryImpl implements ReportRepository {
  final FirebaseFirestore _firestore;

  ReportRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reportsCollection =>
      _firestore.collection(FirestoreCollections.reports);

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(FirestoreCollections.users);

  @override
  FutureEither<ReportModel> submitReport({
    required String reporterId,
    required String reporterName,
    required String reportedUserId,
    required String reportedUserName,
    required ReportReason reason,
    required String description,
    String? swapId,
    String? messageId,
  }) async {
    try {
      final docRef = _reportsCollection.doc();
      final report = ReportModel(
        id: docRef.id,
        reporterId: reporterId,
        reporterName: reporterName,
        reportedUserId: reportedUserId,
        reportedUserName: reportedUserName,
        reason: reason,
        description: description,
        swapId: swapId,
        messageId: messageId,
        status: ReportStatus.pending,
        createdAt: DateTime.now(),
      );

      await docRef.set(report.toJson());
      return right(report);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<List<ReportModel>> getReportsByReporter(String reporterId) async {
    try {
      final snapshot = await _reportsCollection
          .where(ReportFields.reporterId, isEqualTo: reporterId)
          .orderBy(ReportFields.createdAt, descending: true)
          .get();

      final reports = snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data()))
          .toList();

      return right(reports);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<List<ReportModel>> getReportsAgainstUser(String userId) async {
    try {
      final snapshot = await _reportsCollection
          .where(ReportFields.reportedUserId, isEqualTo: userId)
          .orderBy(ReportFields.createdAt, descending: true)
          .get();

      final reports = snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data()))
          .toList();

      return right(reports);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> hasReportedUser({
    required String reporterId,
    required String reportedUserId,
  }) async {
    try {
      final snapshot = await _reportsCollection
          .where(ReportFields.reporterId, isEqualTo: reporterId)
          .where(ReportFields.reportedUserId, isEqualTo: reportedUserId)
          .limit(1)
          .get();

      return right(snapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid unblockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<List<String>> getBlockedUsers(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) {
        return right([]);
      }

      final data = doc.data();
      final blockedUsers = data?['blockedUsers'] as List<dynamic>?;

      if (blockedUsers == null) {
        return right([]);
      }

      return right(blockedUsers.cast<String>());
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> isUserBlocked({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      final doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) {
        return right(false);
      }

      final data = doc.data();
      final blockedUsers = data?['blockedUsers'] as List<dynamic>?;

      if (blockedUsers == null) {
        return right(false);
      }

      return right(blockedUsers.contains(otherUserId));
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}