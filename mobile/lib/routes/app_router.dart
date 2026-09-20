import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/interests/interests_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/learning/categories_screen.dart';
import '../screens/learning/learning_paths_screen.dart';
import '../screens/learning/learning_path_screen.dart';
import '../screens/learning/minute_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/recall/recall_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/change_password_screen.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    late final Widget page;

    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
        break;

      case AppRoutes.onboarding:
        page = const OnboardingScreen();
        break;

      case AppRoutes.login:
        page = const LoginScreen();
        break;

      case AppRoutes.register:
        page = const RegisterScreen();
        break;

      case AppRoutes.interests:
        page = const InterestsScreen();
        break;

      case AppRoutes.home:
        page = const HomeScreen();
        break;

      case AppRoutes.categories:
        page = const CategoriesScreen();
        break;

      case AppRoutes.learningPaths:
        page = LearningPathsScreen(
          categoryId: settings.arguments as String?,
        );
        break;

      case AppRoutes.learningPath:
        page = LearningPathScreen(
          pathId: settings.arguments as String,
        );
        break;

      case AppRoutes.minute:
        page = MinuteScreen(
          minuteId: settings.arguments as String,
        );
        break;

      case AppRoutes.quiz:
        page = QuizScreen(
          minuteId: settings.arguments as String,
        );
        break;

      case AppRoutes.recall:
        page = const RecallScreen();
        break;

      case AppRoutes.progress:
        page = const ProgressScreen();
        break;

      case AppRoutes.profile:
        page = const ProfileScreen();
        break;

      case AppRoutes.editProfile:
        page = const EditProfileScreen();
        break;

      case AppRoutes.changePassword:
        page = const ChangePasswordScreen();
        break;

      default:
        page = const SplashScreen();
    }

    return _buildRoute(
      page,
      settings,
    );
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return page;
      },
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.035, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(
        milliseconds: 280,
      ),
      reverseTransitionDuration: const Duration(
        milliseconds: 220,
      ),
    );
  }
}