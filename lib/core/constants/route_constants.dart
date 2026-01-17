/// Centralized route path constants
class RoutePath {
  RoutePath._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  // Profile Setup
  static const String setupBasicInfo = '/setup/basic-info';
  static const String setupSkillsOffered = '/setup/skills-offered';
  static const String setupSkillsWanted = '/setup/skills-wanted';
  static const String setupAvailability = '/setup/availability';

  // Main App
  static const String home = '/home';
  static const String search = '/search';
  static const String category = '/category/:id';

  // Matches
  static const String matches = '/matches';
  static const String swapRequest = '/swap-request/:userId';
  static const String scheduleSession = '/schedule-session/:swapId';
  static const String activeSession = '/session/:swapId';
  static const String rating = '/rating/:swapId';

  // Chat
  static const String chatList = '/chats';
  static const String chatDetail = '/chat/:chatId';

  // Wallet
  static const String wallet = '/wallet';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String userProfile = '/user/:userId';
  static const String settings = '/settings';

  // Utility
  static const String notifications = '/notifications';
  static const String report = '/report/:userId';
}

/// Centralized route name constants
class RouteName {
  RouteName._();

  // Auth
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';

  // Profile Setup
  static const String setupBasicInfo = 'setup-basic-info';
  static const String setupSkillsOffered = 'setup-skills-offered';
  static const String setupSkillsWanted = 'setup-skills-wanted';
  static const String setupAvailability = 'setup-availability';

  // Main App
  static const String home = 'home';
  static const String search = 'search';
  static const String category = 'category';

  // Matches
  static const String matches = 'matches';
  static const String swapRequest = 'swap-request';
  static const String scheduleSession = 'schedule-session';
  static const String activeSession = 'active-session';
  static const String rating = 'rating';

  // Chat
  static const String chatList = 'chat-list';
  static const String chatDetail = 'chat-detail';

  // Wallet
  static const String wallet = 'wallet';

  // Profile
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';
  static const String userProfile = 'user-profile';
  static const String settings = 'settings';

  // Utility
  static const String notifications = 'notifications';
  static const String report = 'report';
}

/// Route paths for navigation (use with context.go())
class RouteNames {
  RouteNames._();

  // Main tabs
  static const String home = '/home';
  static const String matches = '/matches';
  static const String chatList = '/chats';
  static const String wallet = '/wallet';
  static const String profile = '/profile';

  // Auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';

  // Other screens
  static String chatDetail(String chatId) => '/chat/$chatId';
  static String swapRequest(String userId) => '/swap-request/$userId';
  static String rating(String swapId) => '/rating/$swapId';
  static String userProfile(String userId) => '/user/$userId';
}