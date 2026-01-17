import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/constants/route_constants.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/screens/login_screen.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/screens/signup_screen.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/screens/splash_screen.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/setup_availability_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/setup_basic_info_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/setup_skills_offered_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/setup_skills_wanted_screen.dart';
import 'package:skill_swap_marketplace/features/rating/presentation/screens/rating_screen.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/screens/matches_screen.dart';
import 'package:skill_swap_marketplace/features/swap/presentation/screens/swap_request_screen.dart';
import 'package:skill_swap_marketplace/features/user/presentation/screens/user_profile_view_screen.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/settings_screen.dart';
import 'package:skill_swap_marketplace/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:skill_swap_marketplace/features/search/presentation/screens/search_screen.dart';

part 'app_router.g.dart';

// =============================================================================
// AUTH ROUTES
// =============================================================================

@TypedGoRoute<SplashRoute>(path: RoutePath.splash, name: RouteName.splash)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<OnboardingRoute>(path: RoutePath.onboarding, name: RouteName.onboarding)
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: RoutePath.login, name: RouteName.login)
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@TypedGoRoute<SignupRoute>(path: RoutePath.signup, name: RouteName.signup)
class SignupRoute extends GoRouteData {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupScreen();
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
    return const SetupBasicInfoScreen();
  }
}

@TypedGoRoute<SetupSkillsOfferedRoute>(path: RoutePath.setupSkillsOffered, name: RouteName.setupSkillsOffered)
class SetupSkillsOfferedRoute extends GoRouteData {
  const SetupSkillsOfferedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SetupSkillsOfferedScreen();
  }
}

@TypedGoRoute<SetupSkillsWantedRoute>(path: RoutePath.setupSkillsWanted, name: RouteName.setupSkillsWanted)
class SetupSkillsWantedRoute extends GoRouteData {
  const SetupSkillsWantedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SetupSkillsWantedScreen();
  }
}

@TypedGoRoute<SetupAvailabilityRoute>(path: RoutePath.setupAvailability, name: RouteName.setupAvailability)
class SetupAvailabilityRoute extends GoRouteData {
  const SetupAvailabilityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SetupAvailabilityScreen();
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
    return const MainShellScreen();
  }
}

@TypedGoRoute<SearchRoute>(path: RoutePath.search, name: RouteName.search)
class SearchRoute extends GoRouteData {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchScreen();
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
    return const MatchesScreen();
  }
}

@TypedGoRoute<SwapRequestRoute>(path: RoutePath.swapRequest, name: RouteName.swapRequest)
class SwapRequestRoute extends GoRouteData {
  const SwapRequestRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SwapRequestScreen(userId: userId);
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
    return RatingScreen(swapId: swapId);
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
    return const ChatListScreen();
  }
}

@TypedGoRoute<ChatDetailRoute>(path: RoutePath.chatDetail, name: RouteName.chatDetail)
class ChatDetailRoute extends GoRouteData {
  const ChatDetailRoute({required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatDetailScreen(chatId: chatId);
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
    return const WalletScreen();
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
    return const EditProfileScreen();
  }
}

@TypedGoRoute<UserProfileRoute>(path: RoutePath.userProfile, name: RouteName.userProfile)
class UserProfileRoute extends GoRouteData {
  const UserProfileRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserProfileViewScreen(userId: userId);
  }
}

@TypedGoRoute<SettingsRoute>(path: RoutePath.settings, name: RouteName.settings)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
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