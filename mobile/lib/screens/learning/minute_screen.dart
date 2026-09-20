import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/learning_provider.dart';
import '../../routes/app_routes.dart';

class MinuteScreen extends StatefulWidget {
  final String minuteId;

  const MinuteScreen({
    super.key,
    required this.minuteId,
  });

  @override
  State<MinuteScreen> createState() => _MinuteScreenState();
}

class _MinuteScreenState extends State<MinuteScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadMinute(widget.minuteId);
    });
  }

  Future<void> _completeMinute() async {
    final provider = context.read<LearningProvider>();
    final minute = provider.currentMinute;

    if (minute == null || minute.question == null) {
      return;
    }

    final quizCompleted = await Navigator.pushNamed(
      context,
      AppRoutes.quiz,
      arguments: widget.minuteId,
    );

    if (!mounted || quizCompleted != true) {
      return;
    }

    final pathId = minute.pathId;

    if (pathId == null || pathId.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    await provider.loadPath(pathId);

    if (!mounted) {
      return;
    }

    final path = provider.currentPath;

    if (path == null) {
      Navigator.of(context).pop();
      return;
    }

    final incompleteMinutes = path.minutes
        .where((item) => !item.isCompleted)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (incompleteMinutes.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.minute,
      arguments: incompleteMinutes.first.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One Minute'),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading &&
              provider.currentMinute == null) {
            return const AppLoading(
              message: 'Loading minute...',
            );
          }

          if (provider.error != null &&
              provider.currentMinute == null) {
            return AppError(
              message: provider.error!,
              onRetry: () => provider.loadMinute(widget.minuteId),
            );
          }

          final minute = provider.currentMinute;

          if (minute == null) {
            return const Center(
              child: Text('Minute not found.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+${minute.xpReward} XP',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  minute.title,
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      minute.content,
                      style: AppTextStyles.bodyLarge.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                if (minute.summary != null &&
                    minute.summary!.trim().isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    'Remember this',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      minute.summary!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: minute.isCompleted
                        ? null
                        : _completeMinute,
                    icon: Icon(
                      minute.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.quiz_rounded,
                    ),
                    label: Text(
                      minute.isCompleted
                          ? 'Completed'
                          : 'Take the quiz',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}