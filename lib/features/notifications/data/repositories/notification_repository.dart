import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/notifications/domain/models/notification_model.dart';

/// Repository for managing in-app notifications
class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection(FirestoreCollections.notifications);

  /// Get notifications stream for a user
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _notificationsCollection
        .where(NotificationFields.userId, isEqualTo: userId)
        .orderBy(NotificationFields.createdAt, descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()))
            .toList());
  }

  /// Get unread notification count for a user
  Stream<int> getUnreadCount(String userId) {
    return _notificationsCollection
        .where(NotificationFields.userId, isEqualTo: userId)
        .where(NotificationFields.isRead, isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Create a new notification
  FutureEither<NotificationModel> createNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    String? swapId,
    String? chatId,
    String? fromUserId,
    String? fromUserName,
    String? fromUserPhoto,
  }) async {
    try {
      final docRef = _notificationsCollection.doc();
      final notification = NotificationModel(
        id: docRef.id,
        userId: userId,
        type: type,
        title: title,
        body: body,
        swapId: swapId,
        chatId: chatId,
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        fromUserPhoto: fromUserPhoto,
        isRead: false,
        createdAt: DateTime.now(),
      );

      await docRef.set(notification.toJson());
      return right(notification);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// Mark a notification as read
  FutureVoid markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({
        NotificationFields.isRead: true,
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// Mark all notifications as read for a user
  FutureVoid markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final unreadDocs = await _notificationsCollection
          .where(NotificationFields.userId, isEqualTo: userId)
          .where(NotificationFields.isRead, isEqualTo: false)
          .get();

      for (final doc in unreadDocs.docs) {
        batch.update(doc.reference, {NotificationFields.isRead: true});
      }

      await batch.commit();
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// Delete a notification
  FutureVoid deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /// Delete all notifications for a user
  FutureVoid deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final docs = await _notificationsCollection
          .where(NotificationFields.userId, isEqualTo: userId)
          .get();

      for (final doc in docs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}