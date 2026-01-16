import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/constants/route_constants.dart';

part 'app_router.g.dart';

// =============================================================================
// AUTH ROUTES
// =============================================================================

@TypedGoRoute<SplashRoute>(path: RoutePath.splash, name: RouteName.splash)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Splash');
  }
}

@TypedGoRoute<OnboardingRoute>(path: RoutePath.onboarding, name: RouteName.onboarding)
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Onboarding');
  }
}

@TypedGoRoute<LoginRoute>(path: RoutePath.login, name: RouteName.login)
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Login');
  }
}

@TypedGoRoute<SignupRoute>(path: RoutePath.signup, name: RouteName.signup)
class SignupRoute extends GoRouteData {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Sign Up');
  }
}

// =============================================================================
// PROFILE SETUP ROUTES
// =============================================================================

@TypedGoRoute<SetupBasicInfoRoute>(path: RoutePath.setupBasicInfo, name: RouteName.setupBasicInfo)
class SetupBasicInfoRoute extends GoRouteData {
  const SetupBasicInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Basic Info');
  }
}

@TypedGoRoute<SetupSkillsOfferedRoute>(path: RoutePath.setupSkillsOffered, name: RouteName.setupSkillsOffered)
class SetupSkillsOfferedRoute extends GoRouteData {
  const SetupSkillsOfferedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Skills Offered');
  }
}

@TypedGoRoute<SetupSkillsWantedRoute>(path: RoutePath.setupSkillsWanted, name: RouteName.setupSkillsWanted)
class SetupSkillsWantedRoute extends GoRouteData {
  const SetupSkillsWantedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Skills Wanted');
  }
}

@TypedGoRoute<SetupAvailabilityRoute>(path: RoutePath.setupAvailability, name: RouteName.setupAvailability)
class SetupAvailabilityRoute extends GoRouteData {
  const SetupAvailabilityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Availability');
  }
}

// =============================================================================
// MAIN APP ROUTES
// =============================================================================

@TypedGoRoute<HomeRoute>(path: RoutePath.home, name: RouteName.home)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Home');
  }
}

@TypedGoRoute<SearchRoute>(path: RoutePath.search, name: RouteName.search)
class SearchRoute extends GoRouteData {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Search');
  }
}

@TypedGoRoute<CategoryRoute>(path: RoutePath.category, name: RouteName.category)
class CategoryRoute extends GoRouteData {
  const CategoryRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Category: $id');
  }
}

// =============================================================================
// MATCHES ROUTES
// =============================================================================

@TypedGoRoute<MatchesRoute>(path: RoutePath.matches, name: RouteName.matches)
class MatchesRoute extends GoRouteData {
  const MatchesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Matches');
  }
}

@TypedGoRoute<SwapRequestRoute>(path: RoutePath.swapRequest, name: RouteName.swapRequest)
class SwapRequestRoute extends GoRouteData {
  const SwapRequestRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Swap Request: $userId');
  }
}

@TypedGoRoute<ScheduleSessionRoute>(path: RoutePath.scheduleSession, name: RouteName.scheduleSession)
class ScheduleSessionRoute extends GoRouteData {
  const ScheduleSessionRoute({required this.swapId});

  final String swapId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Schedule Session: $swapId');
  }
}

@TypedGoRoute<ActiveSessionRoute>(path: RoutePath.activeSession, name: RouteName.activeSession)
class ActiveSessionRoute extends GoRouteData {
  const ActiveSessionRoute({required this.swapId});

  final String swapId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Active Session: $swapId');
  }
}

@TypedGoRoute<RatingRoute>(path: RoutePath.rating, name: RouteName.rating)
class RatingRoute extends GoRouteData {
  const RatingRoute({required this.swapId});

  final String swapId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Rating: $swapId');
  }
}

// =============================================================================
// CHAT ROUTES
// =============================================================================

@TypedGoRoute<ChatListRoute>(path: RoutePath.chatList, name: RouteName.chatList)
class ChatListRoute extends GoRouteData {
  const ChatListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Chats');
  }
}

@TypedGoRoute<ChatDetailRoute>(path: RoutePath.chatDetail, name: RouteName.chatDetail)
class ChatDetailRoute extends GoRouteData {
  const ChatDetailRoute({required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Chat: $chatId');
  }
}

// =============================================================================
// WALLET ROUTES
// =============================================================================

@TypedGoRoute<WalletRoute>(path: RoutePath.wallet, name: RouteName.wallet)
class WalletRoute extends GoRouteData {
  const WalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Wallet');
  }
}

// =============================================================================
// PROFILE ROUTES
// =============================================================================

@TypedGoRoute<ProfileRoute>(path: RoutePath.profile, name: RouteName.profile)
class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Profile');
  }
}

@TypedGoRoute<EditProfileRoute>(path: RoutePath.editProfile, name: RouteName.editProfile)
class EditProfileRoute extends GoRouteData {
  const EditProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Edit Profile');
  }
}

@TypedGoRoute<UserProfileRoute>(path: RoutePath.userProfile, name: RouteName.userProfile)
class UserProfileRoute extends GoRouteData {
  const UserProfileRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'User: $userId');
  }
}

@TypedGoRoute<SettingsRoute>(path: RoutePath.settings, name: RouteName.settings)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Settings');
  }
}

// =============================================================================
// UTILITY ROUTES
// =============================================================================

@TypedGoRoute<NotificationsRoute>(path: RoutePath.notifications, name: RouteName.notifications)
class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _PlaceholderScreen(title: 'Notifications');
  }
}

@TypedGoRoute<ReportRoute>(path: RoutePath.report, name: RouteName.report)
class ReportRoute extends GoRouteData {
  const ReportRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(title: 'Report: $userId');
  }
}

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

/// App router configuration
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePath.splash,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

// =============================================================================
// PLACEHOLDER SCREENS (will be replaced with actual screens)
// =============================================================================

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen for navigation errors
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => const HomeRoute().go(context),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}