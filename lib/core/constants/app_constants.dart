/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Skill Swap';
  static const String appVersion = '1.0.0';

  // Credit System
  static const double welcomeBonus = 1.0;
  static const double minSessionDuration = 0.5; // 30 minutes
  static const double maxSessionDuration = 2.0; // 2 hours
  static const double minBalanceToRequest = 0.5;

  // Anti-Abuse Limits
  static const int maxPendingRequests = 3;
  static const int sameUserCooldownDays = 7;
  static const int newUserSwapLimitFirstWeek = 2;

  // Session Reminders (in minutes)
  static const int reminder24Hours = 1440;
  static const int reminder1Hour = 60;
  static const int reminder15Minutes = 15;

  // Grace Period (in minutes)
  static const int sessionGracePeriod = 15;

  // Review Constraints
  static const int minReviewLength = 20;
  static const int maxReviewLength = 300;

  // Rating Tags
  static const List<String> ratingTags = [
    'Great Teacher',
    'Patient',
    'Knowledgeable',
    'Good Communicator',
    'Punctual',
    'Well Prepared',
  ];

  // Session Durations (in hours)
  static const List<double> sessionDurations = [0.5, 1.0, 1.5, 2.0];

  // Skill Levels
  static const List<String> skillLevels = ['beginner', 'intermediate', 'expert'];

  // Availability Options
  static const List<String> availabilityOptions = [
    'morning',
    'afternoon',
    'evening',
    'flexible',
  ];
}