/// Firestore collection names and path helpers
class FirestoreCollections {
  FirestoreCollections._();

  // Collection names
  static const String users = 'users';
  static const String categories = 'categories';
  static const String swaps = 'swaps';
  static const String chats = 'chats';
  static const String messages = 'messages';
  static const String transactions = 'transactions';
  static const String reports = 'reports';

  // Document path helpers
  static String userDoc(String userId) => '$users/$userId';
  static String swapDoc(String swapId) => '$swaps/$swapId';
  static String chatDoc(String chatId) => '$chats/$chatId';
  static String categoryDoc(String categoryId) => '$categories/$categoryId';

  // Subcollection path helpers
  static String chatMessages(String chatId) => '$chats/$chatId/$messages';
  static String userTransactions(String userId) => '$transactions/$userId/history';
}

/// Firestore field name constants for Users collection
class UserFields {
  UserFields._();

  static const String uid = 'uid';
  static const String email = 'email';
  static const String emailVerified = 'emailVerified';
  static const String displayName = 'displayName';
  static const String photoUrl = 'photoUrl';
  static const String bio = 'bio';
  static const String skillsOffered = 'skillsOffered';
  static const String skillsWanted = 'skillsWanted';
  static const String timezone = 'timezone';
  static const String availability = 'availability';
  static const String creditBalance = 'creditBalance';
  static const String swapsCompleted = 'swapsCompleted';
  static const String hoursExchanged = 'hoursExchanged';
  static const String rating = 'rating';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String lastActiveAt = 'lastActiveAt';
  static const String firstSwapDate = 'firstSwapDate';
  static const String swapsThisWeek = 'swapsThisWeek';
}

/// Firestore field name constants for Categories collection
class CategoryFields {
  CategoryFields._();

  static const String id = 'id';
  static const String name = 'name';
  static const String icon = 'icon';
  static const String order = 'order';
  static const String skills = 'skills';
}

/// Firestore field name constants for Swaps collection
class SwapFields {
  SwapFields._();

  static const String id = 'id';
  static const String requesterId = 'requesterId';
  static const String requesterName = 'requesterName';
  static const String requesterPhoto = 'requesterPhoto';
  static const String providerId = 'providerId';
  static const String providerName = 'providerName';
  static const String providerPhoto = 'providerPhoto';
  static const String requesterOffers = 'requesterOffers';
  static const String requesterWants = 'requesterWants';
  static const String duration = 'duration';
  static const String creditAmount = 'creditAmount';
  static const String message = 'message';
  static const String status = 'status';
  static const String session = 'session';
  static const String ratings = 'ratings';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String completedAt = 'completedAt';
  static const String cancelledBy = 'cancelledBy';
  static const String cancelReason = 'cancelReason';
}

/// Firestore field name constants for Chats collection
class ChatFields {
  ChatFields._();

  static const String id = 'id';
  static const String participants = 'participants';
  static const String participantInfo = 'participantInfo';
  static const String swapId = 'swapId';
  static const String lastMessage = 'lastMessage';
  static const String unreadCount = 'unreadCount';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

/// Firestore field name constants for Messages subcollection
class MessageFields {
  MessageFields._();

  static const String id = 'id';
  static const String senderId = 'senderId';
  static const String senderName = 'senderName';
  static const String type = 'type';
  static const String content = 'content';
  static const String imageUrl = 'imageUrl';
  static const String readBy = 'readBy';
  static const String createdAt = 'createdAt';
}

/// Firestore field name constants for Transactions collection
class TransactionFields {
  TransactionFields._();

  static const String id = 'id';
  static const String oderId = 'userId';
  static const String type = 'type';
  static const String amount = 'amount';
  static const String balanceAfter = 'balanceAfter';
  static const String swapId = 'swapId';
  static const String otherUserId = 'otherUserId';
  static const String otherUserName = 'otherUserName';
  static const String skillName = 'skillName';
  static const String createdAt = 'createdAt';
}

/// Firestore field name constants for Reports collection
class ReportFields {
  ReportFields._();

  static const String id = 'id';
  static const String reporterId = 'reporterId';
  static const String reporterName = 'reporterName';
  static const String reportedUserId = 'reportedUserId';
  static const String reportedUserName = 'reportedUserName';
  static const String swapId = 'swapId';
  static const String messageId = 'messageId';
  static const String reason = 'reason';
  static const String description = 'description';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
}