import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route names
class AppRoutes {
  AppRoutes._();

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

/// App router configuration
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen (temporary placeholder)
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash'),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Onboarding'),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
      ),

      // Sign Up
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const _PlaceholderScreen(title: 'Sign Up'),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),

      // Matches
      GoRoute(
        path: AppRoutes.matches,
        name: 'matches',
        builder: (context, state) => const _PlaceholderScreen(title: 'Matches'),
      ),

      // Chat List
      GoRoute(
        path: AppRoutes.chatList,
        name: 'chatList',
        builder: (context, state) => const _PlaceholderScreen(title: 'Chats'),
      ),

      // Wallet
      GoRoute(
        path: AppRoutes.wallet,
        name: 'wallet',
        builder: (context, state) => const _PlaceholderScreen(title: 'Wallet'),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

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
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}