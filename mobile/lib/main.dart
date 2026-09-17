import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/learning_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/recall_provider.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.instance.init();

  runApp(const OneMinuteApp());
}

class OneMinuteApp extends StatelessWidget {
  const OneMinuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LearningProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecallProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}