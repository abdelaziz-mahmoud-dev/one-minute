import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/progress_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.progress.isEmpty) {
            return const AppLoading(
              message: 'Loading your progress...',
            );
          }

          if (provider.error != null && provider.progress.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadProgress,
            );
          }

          if (provider.progress.isEmpty) {
            return const Center(
              child: Text('You have no progress yet.'),
            );
          }

          final completed = provider.progress
              .where((item) => item.completed)
              .length;

          final correct = provider.progress
              .where((item) => item.correct)
              .length;

          return RefreshIndicator(
            onRefresh: provider.loadProgress,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        value: '$completed',
                        label: 'Completed',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.emoji_events_rounded,
                        value: '$correct',
                        label: 'Correct',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Learning history',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 14),
                ...provider.progress.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.completed
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.background,
                        child: Icon(
                          item.completed
                              ? Icons.check_rounded
                              : Icons.menu_book_rounded,
                          color: item.completed
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                      title: Text(
                        item.minuteTitle ?? '',
                        style: AppTextStyles.titleMedium,
                      ),
                      subtitle: Text(
                        item.completed
                            ? 'Completed • ${item.xpEarned} XP'
                            : 'Not completed',
                      ),
                      trailing: item.correct
                          ? const Icon(
                              Icons.verified_rounded,
                              color: AppColors.success,
                            )
                          : null,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}