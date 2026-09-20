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
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case AppRoutes.interests:
        return MaterialPageRoute(
          builder: (_) => const InterestsScreen(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case AppRoutes.categories:
        return MaterialPageRoute(
          builder: (_) => const CategoriesScreen(),
        );

      case AppRoutes.learningPaths:
        return MaterialPageRoute(
          builder: (_) => const LearningPathsScreen(),
        );

      case AppRoutes.learningPath:
        return MaterialPageRoute(
          builder: (_) => LearningPathScreen(
            pathId: settings.arguments as String,
          ),
        );

      case AppRoutes.minute:
        return MaterialPageRoute(
          builder: (_) => MinuteScreen(
            minuteId: settings.arguments as String,
          ),
        );

      case AppRoutes.quiz:
        return MaterialPageRoute(
          builder: (_) => QuizScreen(
            minuteId: settings.arguments as String,
          ),
        );

      case AppRoutes.recall:
        return MaterialPageRoute(
          builder: (_) => const RecallScreen(),
        );

      case AppRoutes.progress:
        return MaterialPageRoute(
          builder: (_) => const ProgressScreen(),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );

      case AppRoutes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}