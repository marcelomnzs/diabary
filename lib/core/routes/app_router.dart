import 'package:diabary/core/widgets/splash_screen.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/features/auth/presentation/screens/login_screen.dart';
import 'package:diabary/features/auth/presentation/screens/register_screen.dart';
import 'package:diabary/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:diabary/features/home/presentation/screens/home_screen.dart';
import 'package:diabary/features/meal_tracker/presentation/screens/meal_tracker_screen.dart';
import 'package:diabary/features/meal_tracker/presentation/screens/metrics_screen.dart';
import 'package:diabary/features/medications/presentation/screens/medications_screen.dart';
import 'package:diabary/features/medications/presentation/screens/reminder_alarm_screen.dart';
import 'package:diabary/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:diabary/features/settings/presentation/screens/account_screen.dart';
import 'package:diabary/features/settings/presentation/screens/change_password_screen.dart';
import 'package:diabary/features/settings/presentation/screens/settings_screen.dart';
import 'package:diabary/features/settings/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

late GoRouter appRouter;

enum AppRoutes {
  splash,
  login,
  signup,
  chatbot,
  home,
  mealTracker,
  medications,
  settings,
  profilePage,
  changePassword,
  editAccount,
  onboarding,
  alarm,
  metrics,
}

bool _isPublicRoute(String route) {
  const publicRoutes = {'/login', '/signup'};
  return publicRoutes.contains(route);
}

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final currentRoute = state.uri.path;

      if (authProvider.isLoading) {
        return '/splash';
      }

      final isLoggedIn = authProvider.isAuthenticated;
      final completedOnboarding = authProvider.onboardingCompleted;

      if (!isLoggedIn && !_isPublicRoute(currentRoute)) {
        return '/login';
      }

      if (isLoggedIn && _isPublicRoute(currentRoute)) {
        return '/home';
      }

      if (isLoggedIn && !completedOnboarding && currentRoute != '/onboarding') {
        return '/onboarding';
      }

      if (isLoggedIn && completedOnboarding && currentRoute == '/onboarding') {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoutes.signup.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/chatbot',
        name: AppRoutes.chatbot.name,
        builder: (context, state) => ChatbotScreen(),
      ),
      GoRoute(
        path: '/mealTracker',
        name: AppRoutes.mealTracker.name,
        builder: (context, state) => MealTracker(),
      ),
      GoRoute(
        path: '/metrics',
        name: AppRoutes.metrics.name,
        builder: (context, state) => Metrics(),
      ),
      GoRoute(
        path: '/medications',
        name: AppRoutes.medications.name,
        pageBuilder:
            (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: MedicationsScreen(),
            ),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profilePage.name,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings.name,
        builder: (context, state) => SettingsScreen(),
        routes: [
          GoRoute(
            path: 'change-password',
            name: AppRoutes.changePassword.name,
            pageBuilder:
                (context, state) => MaterialPage(child: ChangePasswordScreen()),
          ),
          GoRoute(
            path: 'edit-account',
            name: AppRoutes.editAccount.name,
            pageBuilder:
                (context, state) => MaterialPage(child: EditAccountScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding.name,
        builder: (context, state) => const OnboardingFlow(),
      ),
      GoRoute(
        path: '/alarm/:medId',
        name: AppRoutes.alarm.name,
        builder: (context, state) {
          final medId = state.pathParameters['medId']!;
          return ReminderAlarmScreen(medicationId: medId);
        },
      ),
    ],
  );
}
