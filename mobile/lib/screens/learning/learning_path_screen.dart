import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/learning_provider.dart';
import '../../routes/app_routes.dart';

class LearningPathScreen extends StatefulWidget {
  final String pathId;

  const LearningPathScreen({
    super.key,
    required this.pathId,
  });

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadPath(widget.pathId);
    });
  }

  void _continuePath(BuildContext context, LearningProvider provider) {
    final path = provider.currentPath;

    if (path == null || path.minutes.isEmpty) {
      return;
    }

    final incompleteMinutes = path.minutes
        .where((minute) => !minute.isCompleted)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (incompleteMinutes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 You completed this learning path!'),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.minute,
      arguments: incompleteMinutes.first.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Path'),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.currentPath == null) {
            return const AppLoading(
              message: 'Loading path...',
            );
          }

          if (provider.error != null &&
              provider.currentPath == null) {
            return AppError(
              message: provider.error!,
              onRetry: () => provider.loadPath(widget.pathId),
            );
          }

          final path = provider.currentPath;

          if (path == null) {
            return const Center(
              child: Text('Learning path not found.'),
            );
          }

          final progress = path.minuteCount == 0
              ? 0.0
              : (path.completedMinutes / path.minuteCount)
                  .clamp(0.0, 1.0);

          final incompleteMinutes = path.minutes
              .where((minute) => !minute.isCompleted)
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order));

          final isCompleted = incompleteMinutes.isEmpty &&
              path.minutes.isNotEmpty;

          return RefreshIndicator(
            onRefresh: () => provider.loadPath(widget.pathId),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  path.title,
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  path.description ?? '',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Your progress',
                              style: AppTextStyles.titleMedium,
                            ),
                            const Spacer(),
                            Text(
                              '${path.completedMinutes}/${path.minuteCount}',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(progress * 100).round()}% completed',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (isCompleted) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            size: 56,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Path Completed!',
                            style: AppTextStyles.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You completed all ${path.minuteCount} learning minutes.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Start learning',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _continuePath(context, provider);
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        path.completedMinutes > 0
                            ? 'Continue path'
                            : 'Start path',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                Text(
                  '${path.minuteCount} learning minutes',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete each minute to build your progress and earn XP.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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