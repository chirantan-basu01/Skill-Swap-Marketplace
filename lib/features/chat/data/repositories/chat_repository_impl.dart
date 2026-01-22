import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/core/shared/models/failure.dart';
import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/message_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/repositories/chat_repository.dart';

/// Implementation of [ChatRepository] using Cloud Firestore
class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chatsCollection =>
      _firestore.collection(FirestoreCollections.chats);

  CollectionReference<Map<String, dynamic>> _messagesCollection(String chatId) =>
      _chatsCollection.doc(chatId).collection(FirestoreCollections.messages);

  @override
  FutureEither<ChatModel> getOrCreateChat({
    required String swapId,
    required String userId1,
    required String userId2,
    required String user1Name,
    required String user2Name,
    String? user1Photo,
    String? user2Photo,
    String? offeredSkillName,
    String? wantedSkillName,
  }) async {
    try {
      // Check if chat already exists between these two users
      final existingChat = await getChatByParticipants(userId1, userId2);

      return existingChat.fold(
        (failure) => left(failure),
        (chat) async {
          // Create swap context if skills are provided
          SwapContext? swapContext;
          if (offeredSkillName != null && wantedSkillName != null) {
            swapContext = SwapContext(
              offeredSkillName: offeredSkillName,
              wantedSkillName: wantedSkillName,
              status: 'accepted',
            );
          }

          if (chat != null) {
            // Update existing chat with new swap context
            await _chatsCollection.doc(chat.id).update({
              ChatFields.swapId: swapId,
              if (swapContext != null) ChatFields.swapContext: swapContext.toJson(),
              ChatFields.updatedAt: Timestamp.fromDate(DateTime.now()),
            });
            // Return updated chat
            return right(chat.copyWith(
              swapId: swapId,
              swapContext: swapContext ?? chat.swapContext,
              updatedAt: DateTime.now(),
            ));
          }

          // Create new chat
          return _createChat(
            swapId: swapId,
            userId1: userId1,
            userId2: userId2,
            user1Name: user1Name,
            user2Name: user2Name,
            user1Photo: user1Photo,
            user2Photo: user2Photo,
            swapContext: swapContext,
          );
        },
      );
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, ChatModel>> _createChat({
    required String swapId,
    required String userId1,
    required String userId2,
    required String user1Name,
    required String user2Name,
    String? user1Photo,
    String? user2Photo,
    SwapContext? swapContext,
  }) async {
    try {
      final docRef = _chatsCollection.doc();
      final now = DateTime.now();

      final chat = ChatModel(
        id: docRef.id,
        participants: [userId1, userId2],
        participantInfo: {
          userId1: ParticipantInfo(name: user1Name, photoUrl: user1Photo),
          userId2: ParticipantInfo(name: user2Name, photoUrl: user2Photo),
        },
        swapId: swapId,
        swapContext: swapContext,
        unreadCount: {userId1: 0, userId2: 0},
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(chat.toJson());
      return right(chat);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<ChatModel> getChatById(String chatId) async {
    try {
      final doc = await _chatsCollection.doc(chatId).get();

      if (!doc.exists || doc.data() == null) {
        return left(const Failure(message: 'Chat not found'));
      }

      return right(ChatModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<ChatModel?> getChatBySwapId(String swapId) async {
    try {
      final snapshot = await _chatsCollection
          .where(ChatFields.swapId, isEqualTo: swapId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return right(null);
      }

      return right(ChatModel.fromJson(snapshot.docs.first.data()));
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<ChatModel?> getChatByParticipants(String userId1, String userId2) async {
    try {
      // Query for chats where both users are participants
      // Firestore arrayContains only supports single value, so we query for one
      // and filter in-memory for the other
      final snapshot = await _chatsCollection
          .where(ChatFields.participants, arrayContains: userId1)
          .get();

      for (final doc in snapshot.docs) {
        final participants = List<String>.from(doc.data()[ChatFields.participants] ?? []);
        if (participants.contains(userId2)) {
          return right(ChatModel.fromJson(doc.data()));
        }
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _chatsCollection
        .where(ChatFields.participants, arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final chats = snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList();
          // Sort by updatedAt descending (most recent first)
          chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return chats;
        });
  }

  @override
  Stream<List<MessageModel>> getChatMessages(String chatId, {int limit = 50}) {
    return _messagesCollection(chatId)
        .orderBy(MessageFields.createdAt, descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList();
          // Reverse to get chronological order (oldest first)
          return messages.reversed.toList();
        });
  }

  @override
  FutureEither<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    try {
      final docRef = _messagesCollection(chatId).doc();
      final now = DateTime.now();

      final message = MessageModel(
        id: docRef.id,
        senderId: senderId,
        senderName: senderName,
        type: type,
        content: content,
        imageUrl: imageUrl,
        readBy: [senderId],
        createdAt: now,
      );

      // Use batch write for atomicity
      final batch = _firestore.batch();

      // Add message
      batch.set(docRef, message.toJson());

      // Update chat's last message and unread counts
      final chatRef = _chatsCollection.doc(chatId);
      final chatDoc = await chatRef.get();

      if (chatDoc.exists) {
        final chat = ChatModel.fromJson(chatDoc.data()!);
        final updatedUnread = Map<String, int>.from(chat.unreadCount);

        // Increment unread for other participants
        for (final participantId in chat.participants) {
          if (participantId != senderId) {
            updatedUnread[participantId] = (updatedUnread[participantId] ?? 0) + 1;
          }
        }

        batch.update(chatRef, {
          ChatFields.lastMessage: LastMessage(
            text: type == MessageType.image ? 'Sent a photo' : content,
            senderId: senderId,
            type: type,
            createdAt: now,
          ).toJson(),
          ChatFields.unreadCount: updatedUnread,
          ChatFields.updatedAt: Timestamp.fromDate(now),
        });
      }

      await batch.commit();
      return right(message);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureEither<MessageModel> sendSystemMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      final docRef = _messagesCollection(chatId).doc();
      final now = DateTime.now();

      final message = MessageModel(
        id: docRef.id,
        senderId: 'system',
        senderName: 'System',
        type: MessageType.system,
        content: content,
        readBy: [],
        createdAt: now,
      );

      // Use batch write for atomicity
      final batch = _firestore.batch();

      // Add message
      batch.set(docRef, message.toJson());

      // Update chat's last message
      batch.update(_chatsCollection.doc(chatId), {
        ChatFields.lastMessage: LastMessage(
          text: content,
          senderId: 'system',
          type: MessageType.system,
          createdAt: now,
        ).toJson(),
        ChatFields.updatedAt: Timestamp.fromDate(now),
      });

      await batch.commit();
      return right(message);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid markAsRead(String chatId, String userId) async {
    try {
      // Update unread count for this user to 0
      await _chatsCollection.doc(chatId).update({
        '${ChatFields.unreadCount}.$userId': 0,
      });

      // Mark all messages as read by this user
      final unreadMessages = await _messagesCollection(chatId)
          .where(MessageFields.senderId, isNotEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (final doc in unreadMessages.docs) {
        final readBy = List<String>.from(doc.data()[MessageFields.readBy] ?? []);
        if (!readBy.contains(userId)) {
          batch.update(doc.reference, {
            MessageFields.readBy: FieldValue.arrayUnion([userId]),
          });
        }
      }
      await batch.commit();

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Stream<int> getTotalUnreadCount(String userId) {
    return _chatsCollection
        .where(ChatFields.participants, arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          int total = 0;
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final unreadCount = data[ChatFields.unreadCount] as Map<String, dynamic>?;
            if (unreadCount != null) {
              total += (unreadCount[userId] as int?) ?? 0;
            }
          }
          return total;
        });
  }

  @override
  FutureVoid archiveChat(String chatId, String userId) async {
    try {
      // For now, we'll just mark the chat as archived for this user
      // You could add an 'archivedBy' array field to the chat document
      await _chatsCollection.doc(chatId).update({
        'archivedBy': FieldValue.arrayUnion([userId]),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  FutureVoid setTypingStatus(String chatId, String userId, bool isTyping) async {
    try {
      await _chatsCollection.doc(chatId).update({
        'typing.$userId': isTyping ? FieldValue.serverTimestamp() : FieldValue.delete(),
      });
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure.fromFirebase(e.code, e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Stream<Map<String, bool>> getTypingStatus(String chatId) {
    return _chatsCollection.doc(chatId).snapshots().map((snapshot) {
      if (!snapshot.exists) return {};

      final data = snapshot.data();
      final typing = data?['typing'] as Map<String, dynamic>?;
      if (typing == null) return {};

      final result = <String, bool>{};
      final now = DateTime.now();

      for (final entry in typing.entries) {
        final timestamp = entry.value as Timestamp?;
        if (timestamp != null) {
          // Consider typing if timestamp is within last 3 seconds
          final isRecent = now.difference(timestamp.toDate()).inSeconds < 3;
          result[entry.key] = isRecent;
        }
      }

      return result;
    });
  }
}