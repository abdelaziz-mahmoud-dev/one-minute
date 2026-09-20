import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/progress_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
  });

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState
    extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) return;

        context
            .read<ProgressProvider>()
            .loadProgress();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading &&
              provider.progress.isEmpty) {
            return const AppLoading(
              message:
                  'Loading your progress...',
            );
          }

          if (provider.error != null &&
              provider.progress.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadProgress,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadProgress,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.all(20),
              children: [
                _OverviewCard(
                  summary: provider.summary,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon:
                            Icons.check_circle_rounded,
                        value: provider
                            .summary
                            .completedMinutes
                            .toString(),
                        label: 'Completed',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon:
                            Icons.local_fire_department_rounded,
                        value: provider
                            .summary
                            .streak
                            .toString(),
                        label: 'Day streak',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Text(
                  'Learning history',
                  style:
                      AppTextStyles.headlineMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  '${provider.pagination.total} learning records',
                  style:
                      AppTextStyles.bodyMedium.copyWith(
                    color:
                        AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 14),

                if (provider.progress.isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'You have no progress yet.',
                      ),
                    ),
                  ),

                ...provider.progress.map(
                  (item) => Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading:
                          _ProgressIcon(
                        completed:
                            item.completed,
                        correct:
                            item.correct,
                      ),
                      title: Text(
                        item.minuteTitle ??
                            'Learning minute',
                        style:
                            AppTextStyles.titleMedium,
                      ),
                      subtitle: Text(
                        _subtitleFor(item),
                      ),
                      trailing:
                          item.xpEarned > 0
                              ? Text(
                                  '+${item.xpEarned} XP',
                                  style: AppTextStyles
                                      .labelLarge
                                      .copyWith(
                                    color: AppColors
                                        .primary,
                                  ),
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

  String _subtitleFor(
    dynamic item,
  ) {
    if (item.completed) {
      return 'Completed • ${item.attempts} attempt${item.attempts == 1 ? '' : 's'}';
    }

    if (item.attempts > 0) {
      return '${item.attempts} attempt${item.attempts == 1 ? '' : 's'} • Not completed';
    }

    return 'Not completed';
  }
}

class _OverviewCard extends StatelessWidget {
  final dynamic summary;

  const _OverviewCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final currentXp = summary.xp;
    final nextLevelXp = summary.nextLevelXp;

    final progress = nextLevelXp <= 0
        ? 0.0
        : (currentXp / nextLevelXp)
            .clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppColors.primaryLight,
                  child: Text(
                    'L${summary.level}',
                    style:
                        AppTextStyles.labelLarge
                            .copyWith(
                      color:
                          AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${summary.level}',
                        style:
                            AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${summary.xp} XP',
                        style:
                            AppTextStyles.bodyMedium
                                .copyWith(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 18),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${summary.xp} / ${summary.nextLevelXp} XP to next level',
              style:
                  AppTextStyles.bodySmall.copyWith(
                color:
                    AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIcon extends StatelessWidget {
  final bool completed;
  final bool correct;

  const _ProgressIcon({
    required this.completed,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? AppColors.success
        : AppColors.textSecondary;

    final icon = completed
        ? Icons.check_rounded
        : Icons.menu_book_rounded;

    return CircleAvatar(
      backgroundColor:
          completed
              ? AppColors.success.withValues(
                  alpha: 0.12,
                )
              : AppColors.background,
      child: Icon(
        icon,
        color: color,
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
              style:
                  AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style:
                  AppTextStyles.bodySmall.copyWith(
                color:
                    AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}