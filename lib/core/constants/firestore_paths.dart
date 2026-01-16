/// Centralized Firestore collection and document paths
class FirestorePaths {
  FirestorePaths._();

  // Collections
  static const String users = 'users';
  static const String swaps = 'swaps';
  static const String chats = 'chats';
  static const String categories = 'categories';
  static const String transactions = 'transactions';
  static const String reports = 'reports';

  // Subcollections
  static String messages(String chatId) => 'chats/$chatId/messages';
  static String userTransactions(String userId) =>
      'transactions/$userId/history';

  // Document references
  static String userDoc(String userId) => 'users/$userId';
  static String swapDoc(String swapId) => 'swaps/$swapId';
  static String chatDoc(String chatId) => 'chats/$chatId';
}