import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/message_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/repositories/chat_repository.dart';

/// Provider for the chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

/// Provider for current user's chats
final userChatsProvider = StreamProvider<List<ChatModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.valueOrNull?.uid;

  if (userId == null) {
    return Stream.value([]);
  }

  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getUserChats(userId);
});

/// Provider for total unread count across all chats
final totalUnreadCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userId = authState.valueOrNull?.uid;

  if (userId == null) {
    return Stream.value(0);
  }

  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getTotalUnreadCount(userId);
});

/// Provider for a specific chat by ID
final chatByIdProvider = FutureProvider.family<ChatModel?, String>((ref, chatId) async {
  final chatRepo = ref.watch(chatRepositoryProvider);
  final result = await chatRepo.getChatById(chatId);
  return result.fold((_) => null, (chat) => chat);
});

/// Provider for a chat by swap ID
final chatBySwapIdProvider = FutureProvider.family<ChatModel?, String>((ref, swapId) async {
  final chatRepo = ref.watch(chatRepositoryProvider);
  final result = await chatRepo.getChatBySwapId(swapId);
  return result.fold((_) => null, (chat) => chat);
});

/// Provider for messages in a specific chat
final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getChatMessages(chatId);
});

/// Provider for typing status in a chat
final typingStatusProvider = StreamProvider.family<Map<String, bool>, String>((ref, chatId) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getTypingStatus(chatId);
});

/// Notifier for sending messages
class ChatActionsNotifier extends StateNotifier<ChatActionsState> {
  final ChatRepository _chatRepo;
  final String? _currentUserId;
  final String? _currentUserName;

  ChatActionsNotifier(this._chatRepo, this._currentUserId, this._currentUserName)
      : super(const ChatActionsState());

  Future<MessageModel?> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    if (_currentUserId == null || _currentUserName == null) {
      state = state.copyWith(error: 'User not logged in');
      return null;
    }

    if (content.trim().isEmpty && type == MessageType.text) {
      return null;
    }

    state = state.copyWith(isSending: true, error: null);

    final result = await _chatRepo.sendMessage(
      chatId: chatId,
      senderId: _currentUserId,
      senderName: _currentUserName,
      content: content.trim(),
      type: type,
      imageUrl: imageUrl,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isSending: false, error: failure.message);
        return null;
      },
      (message) {
        state = state.copyWith(isSending: false);
        return message;
      },
    );
  }

  Future<void> markAsRead(String chatId) async {
    if (_currentUserId == null) return;
    await _chatRepo.markAsRead(chatId, _currentUserId);
  }

  Future<void> setTyping(String chatId, bool isTyping) async {
    if (_currentUserId == null) return;
    await _chatRepo.setTypingStatus(chatId, _currentUserId, isTyping);
  }

  Future<ChatModel?> getOrCreateChat({
    required String swapId,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhoto,
    String? currentUserPhoto,
  }) async {
    if (_currentUserId == null || _currentUserName == null) {
      state = state.copyWith(error: 'User not logged in');
      return null;
    }

    state = state.copyWith(isCreating: true, error: null);

    final result = await _chatRepo.getOrCreateChat(
      swapId: swapId,
      userId1: _currentUserId,
      userId2: otherUserId,
      user1Name: _currentUserName,
      user2Name: otherUserName,
      user1Photo: currentUserPhoto,
      user2Photo: otherUserPhoto,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isCreating: false, error: failure.message);
        return null;
      },
      (chat) {
        state = state.copyWith(isCreating: false);
        return chat;
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// State for chat actions
class ChatActionsState {
  final bool isSending;
  final bool isCreating;
  final String? error;

  const ChatActionsState({
    this.isSending = false,
    this.isCreating = false,
    this.error,
  });

  ChatActionsState copyWith({
    bool? isSending,
    bool? isCreating,
    String? error,
  }) {
    return ChatActionsState(
      isSending: isSending ?? this.isSending,
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }
}

/// Provider for chat actions notifier
final chatActionsProvider = StateNotifierProvider<ChatActionsNotifier, ChatActionsState>((ref) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  final authState = ref.watch(authStateChangesProvider);
  final currentUser = authState.valueOrNull;

  // Get display name from user profile if available
  String? displayName = currentUser?.displayName;

  return ChatActionsNotifier(
    chatRepo,
    currentUser?.uid,
    displayName ?? 'User',
  );
});

/// Helper provider to get the other participant's info from a chat
ParticipantInfo? getOtherParticipant(ChatModel chat, String currentUserId) {
  final otherUserId = chat.participants.firstWhere(
    (id) => id != currentUserId,
    orElse: () => '',
  );

  if (otherUserId.isEmpty) return null;
  return chat.participantInfo[otherUserId];
}

/// Helper to get formatted time for last message
String formatLastMessageTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 1) {
    return 'Just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  } else if (diff.inDays == 1) {
    return 'Yesterday';
  } else if (diff.inDays < 7) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  } else {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
}

/// Helper to format message time
String formatMessageTime(DateTime dateTime) {
  final hour = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
  return '$displayHour:$minute $period';
}

/// Helper to check if we should show date separator
bool shouldShowDateSeparator(MessageModel current, MessageModel? previous) {
  if (previous == null) return true;

  final currentDate = DateTime(
    current.createdAt.year,
    current.createdAt.month,
    current.createdAt.day,
  );
  final previousDate = DateTime(
    previous.createdAt.year,
    previous.createdAt.month,
    previous.createdAt.day,
  );

  return currentDate != previousDate;
}

/// Helper to format date separator text
String formatDateSeparator(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate == today) {
    return 'Today';
  } else if (messageDate == yesterday) {
    return 'Yesterday';
  } else {
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
}