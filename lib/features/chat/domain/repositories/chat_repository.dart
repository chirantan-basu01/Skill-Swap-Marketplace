import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/message_model.dart';

/// Repository interface for chat operations
abstract class ChatRepository {
  /// Get or create a chat for a swap
  /// Creates the chat if it doesn't exist
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
  });

  /// Get a chat by its ID
  FutureEither<ChatModel> getChatById(String chatId);

  /// Get a chat by swap ID
  FutureEither<ChatModel?> getChatBySwapId(String swapId);

  /// Get a chat by participants (user pair)
  FutureEither<ChatModel?> getChatByParticipants(String userId1, String userId2);

  /// Stream of chats for a user (sorted by last message)
  Stream<List<ChatModel>> getUserChats(String userId);

  /// Stream of messages for a chat
  Stream<List<MessageModel>> getChatMessages(String chatId, {int limit = 50});

  /// Send a text message
  FutureEither<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  });

  /// Send a system message (e.g., "Session scheduled")
  FutureEither<MessageModel> sendSystemMessage({
    required String chatId,
    required String content,
  });

  /// Mark messages as read for a user
  FutureVoid markAsRead(String chatId, String userId);

  /// Get unread message count for a user across all chats
  Stream<int> getTotalUnreadCount(String userId);

  /// Delete a chat (soft delete or archive)
  FutureVoid archiveChat(String chatId, String userId);

  /// Update typing status
  FutureVoid setTypingStatus(String chatId, String userId, bool isTyping);

  /// Stream typing status for a chat
  Stream<Map<String, bool>> getTypingStatus(String chatId);
}