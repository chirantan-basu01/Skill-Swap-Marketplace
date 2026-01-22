// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $splashRoute,
      $onboardingRoute,
      $loginRoute,
      $signupRoute,
      $verifyEmailRoute,
      $setupBasicInfoRoute,
      $setupSkillsOfferedRoute,
      $setupSkillsWantedRoute,
      $setupAvailabilityRoute,
      $homeRoute,
      $searchRoute,
      $categoryRoute,
      $matchesRoute,
      $swapRequestRoute,
      $scheduleSessionRoute,
      $activeSessionRoute,
      $ratingRoute,
      $chatListRoute,
      $chatDetailRoute,
      $walletRoute,
      $profileRoute,
      $editProfileRoute,
      $editSkillsOfferedRoute,
      $editSkillsWantedRoute,
      $userProfileRoute,
      $settingsRoute,
      $notificationsRoute,
      $reportRoute,
    ];

RouteBase get $splashRoute => GoRouteData.$route(
      path: '/',
      name: 'splash',
      factory: $SplashRouteExtension._fromState,
    );

extension $SplashRouteExtension on SplashRoute {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/onboarding',
      name: 'onboarding',
      factory: $OnboardingRouteExtension._fromState,
    );

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signupRoute => GoRouteData.$route(
      path: '/signup',
      name: 'signup',
      factory: $SignupRouteExtension._fromState,
    );

extension $SignupRouteExtension on SignupRoute {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  String get location => GoRouteData.$location(
        '/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verifyEmailRoute => GoRouteData.$route(
      path: '/verify-email',
      name: 'verify-email',
      factory: $VerifyEmailRouteExtension._fromState,
    );

extension $VerifyEmailRouteExtension on VerifyEmailRoute {
  static VerifyEmailRoute _fromState(GoRouterState state) =>
      const VerifyEmailRoute();

  String get location => GoRouteData.$location(
        '/verify-email',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $setupBasicInfoRoute => GoRouteData.$route(
      path: '/setup/basic-info',
      name: 'setup-basic-info',
      factory: $SetupBasicInfoRouteExtension._fromState,
    );

extension $SetupBasicInfoRouteExtension on SetupBasicInfoRoute {
  static SetupBasicInfoRoute _fromState(GoRouterState state) =>
      const SetupBasicInfoRoute();

  String get location => GoRouteData.$location(
        '/setup/basic-info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $setupSkillsOfferedRoute => GoRouteData.$route(
      path: '/setup/skills-offered',
      name: 'setup-skills-offered',
      factory: $SetupSkillsOfferedRouteExtension._fromState,
    );

extension $SetupSkillsOfferedRouteExtension on SetupSkillsOfferedRoute {
  static SetupSkillsOfferedRoute _fromState(GoRouterState state) =>
      const SetupSkillsOfferedRoute();

  String get location => GoRouteData.$location(
        '/setup/skills-offered',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $setupSkillsWantedRoute => GoRouteData.$route(
      path: '/setup/skills-wanted',
      name: 'setup-skills-wanted',
      factory: $SetupSkillsWantedRouteExtension._fromState,
    );

extension $SetupSkillsWantedRouteExtension on SetupSkillsWantedRoute {
  static SetupSkillsWantedRoute _fromState(GoRouterState state) =>
      const SetupSkillsWantedRoute();

  String get location => GoRouteData.$location(
        '/setup/skills-wanted',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $setupAvailabilityRoute => GoRouteData.$route(
      path: '/setup/availability',
      name: 'setup-availability',
      factory: $SetupAvailabilityRouteExtension._fromState,
    );

extension $SetupAvailabilityRouteExtension on SetupAvailabilityRoute {
  static SetupAvailabilityRoute _fromState(GoRouterState state) =>
      const SetupAvailabilityRoute();

  String get location => GoRouteData.$location(
        '/setup/availability',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/home',
      name: 'home',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchRoute => GoRouteData.$route(
      path: '/search',
      name: 'search',
      factory: $SearchRouteExtension._fromState,
    );

extension $SearchRouteExtension on SearchRoute {
  static SearchRoute _fromState(GoRouterState state) => SearchRoute(
        sort: state.uri.queryParameters['sort'],
      );

  String get location => GoRouteData.$location(
        '/search',
        queryParams: {
          if (sort != null) 'sort': sort,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoryRoute => GoRouteData.$route(
      path: '/category/:id',
      name: 'category',
      factory: $CategoryRouteExtension._fromState,
    );

extension $CategoryRouteExtension on CategoryRoute {
  static CategoryRoute _fromState(GoRouterState state) => CategoryRoute(
        id: state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/category/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $matchesRoute => GoRouteData.$route(
      path: '/matches',
      name: 'matches',
      factory: $MatchesRouteExtension._fromState,
    );

extension $MatchesRouteExtension on MatchesRoute {
  static MatchesRoute _fromState(GoRouterState state) => const MatchesRoute();

  String get location => GoRouteData.$location(
        '/matches',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $swapRequestRoute => GoRouteData.$route(
      path: '/swap-request/:userId',
      name: 'swap-request',
      factory: $SwapRequestRouteExtension._fromState,
    );

extension $SwapRequestRouteExtension on SwapRequestRoute {
  static SwapRequestRoute _fromState(GoRouterState state) => SwapRequestRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/swap-request/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scheduleSessionRoute => GoRouteData.$route(
      path: '/schedule-session/:swapId',
      name: 'schedule-session',
      factory: $ScheduleSessionRouteExtension._fromState,
    );

extension $ScheduleSessionRouteExtension on ScheduleSessionRoute {
  static ScheduleSessionRoute _fromState(GoRouterState state) =>
      ScheduleSessionRoute(
        swapId: state.pathParameters['swapId']!,
      );

  String get location => GoRouteData.$location(
        '/schedule-session/${Uri.encodeComponent(swapId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activeSessionRoute => GoRouteData.$route(
      path: '/session/:swapId',
      name: 'active-session',
      factory: $ActiveSessionRouteExtension._fromState,
    );

extension $ActiveSessionRouteExtension on ActiveSessionRoute {
  static ActiveSessionRoute _fromState(GoRouterState state) =>
      ActiveSessionRoute(
        swapId: state.pathParameters['swapId']!,
      );

  String get location => GoRouteData.$location(
        '/session/${Uri.encodeComponent(swapId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $ratingRoute => GoRouteData.$route(
      path: '/rating/:swapId',
      name: 'rating',
      factory: $RatingRouteExtension._fromState,
    );

extension $RatingRouteExtension on RatingRoute {
  static RatingRoute _fromState(GoRouterState state) => RatingRoute(
        swapId: state.pathParameters['swapId']!,
      );

  String get location => GoRouteData.$location(
        '/rating/${Uri.encodeComponent(swapId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatListRoute => GoRouteData.$route(
      path: '/chats',
      name: 'chat-list',
      factory: $ChatListRouteExtension._fromState,
    );

extension $ChatListRouteExtension on ChatListRoute {
  static ChatListRoute _fromState(GoRouterState state) => const ChatListRoute();

  String get location => GoRouteData.$location(
        '/chats',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatDetailRoute => GoRouteData.$route(
      path: '/chat/:chatId',
      name: 'chat-detail',
      factory: $ChatDetailRouteExtension._fromState,
    );

extension $ChatDetailRouteExtension on ChatDetailRoute {
  static ChatDetailRoute _fromState(GoRouterState state) => ChatDetailRoute(
        chatId: state.pathParameters['chatId']!,
      );

  String get location => GoRouteData.$location(
        '/chat/${Uri.encodeComponent(chatId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $walletRoute => GoRouteData.$route(
      path: '/wallet',
      name: 'wallet',
      factory: $WalletRouteExtension._fromState,
    );

extension $WalletRouteExtension on WalletRoute {
  static WalletRoute _fromState(GoRouterState state) => const WalletRoute();

  String get location => GoRouteData.$location(
        '/wallet',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      name: 'profile',
      factory: $ProfileRouteExtension._fromState,
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editProfileRoute => GoRouteData.$route(
      path: '/profile/edit',
      name: 'edit-profile',
      factory: $EditProfileRouteExtension._fromState,
    );

extension $EditProfileRouteExtension on EditProfileRoute {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  String get location => GoRouteData.$location(
        '/profile/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editSkillsOfferedRoute => GoRouteData.$route(
      path: '/profile/edit/skills-offered',
      name: 'edit-skills-offered',
      factory: $EditSkillsOfferedRouteExtension._fromState,
    );

extension $EditSkillsOfferedRouteExtension on EditSkillsOfferedRoute {
  static EditSkillsOfferedRoute _fromState(GoRouterState state) =>
      const EditSkillsOfferedRoute();

  String get location => GoRouteData.$location(
        '/profile/edit/skills-offered',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editSkillsWantedRoute => GoRouteData.$route(
      path: '/profile/edit/skills-wanted',
      name: 'edit-skills-wanted',
      factory: $EditSkillsWantedRouteExtension._fromState,
    );

extension $EditSkillsWantedRouteExtension on EditSkillsWantedRoute {
  static EditSkillsWantedRoute _fromState(GoRouterState state) =>
      const EditSkillsWantedRoute();

  String get location => GoRouteData.$location(
        '/profile/edit/skills-wanted',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userProfileRoute => GoRouteData.$route(
      path: '/user/:userId',
      name: 'user-profile',
      factory: $UserProfileRouteExtension._fromState,
    );

extension $UserProfileRouteExtension on UserProfileRoute {
  static UserProfileRoute _fromState(GoRouterState state) => UserProfileRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/user/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute => GoRouteData.$route(
      path: '/settings',
      name: 'settings',
      factory: $SettingsRouteExtension._fromState,
    );

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $notificationsRoute => GoRouteData.$route(
      path: '/notifications',
      name: 'notifications',
      factory: $NotificationsRouteExtension._fromState,
    );

extension $NotificationsRouteExtension on NotificationsRoute {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  String get location => GoRouteData.$location(
        '/notifications',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $reportRoute => GoRouteData.$route(
      path: '/report/:userId',
      name: 'report',
      factory: $ReportRouteExtension._fromState,
    );

extension $ReportRouteExtension on ReportRoute {
  static ReportRoute _fromState(GoRouterState state) => ReportRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/report/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
