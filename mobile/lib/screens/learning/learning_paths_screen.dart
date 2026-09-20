import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/learning_provider.dart';
import '../../routes/app_routes.dart';

class LearningPathsScreen extends StatefulWidget {
  final String? categoryId;

  const LearningPathsScreen({
    super.key,
    this.categoryId,
  });

  @override
  State<LearningPathsScreen> createState() => _LearningPathsScreenState();
}

class _LearningPathsScreenState extends State<LearningPathsScreen> {
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadPaths(
            category: widget.categoryId,
          );
    });
  }

  Future<void> _changeLevel(String? level) async {
    if (_selectedLevel == level) {
      return;
    }

    setState(() {
      _selectedLevel = level;
    });

    await context.read<LearningProvider>().loadPaths(
          category: widget.categoryId,
          level: level,
        );
  }

  Future<void> _refresh() {
    return context.read<LearningProvider>().loadPaths(
          category: widget.categoryId,
          level: _selectedLevel,
        );
  }

  void _openPath(String pathId) {
    if (pathId.isEmpty) return;

    Navigator.pushNamed(
      context,
      AppRoutes.learningPath,
      arguments: pathId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Paths'),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.paths.isEmpty) {
            return const AppLoading(
              message: 'Loading paths...',
            );
          }

          if (provider.error != null && provider.paths.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: _refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: 1,
                  ),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 16 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose your path',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Learn at your own pace, one minute at a time.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _LevelChip(
                        label: 'All',
                        selected: _selectedLevel == null,
                        onSelected: () => _changeLevel(null),
                      ),
                      const SizedBox(width: 8),
                      _LevelChip(
                        label: 'Beginner',
                        selected:
                            _selectedLevel == AppConstants.beginnerLevel,
                        onSelected: () =>
                            _changeLevel(AppConstants.beginnerLevel),
                      ),
                      const SizedBox(width: 8),
                      _LevelChip(
                        label: 'Intermediate',
                        selected:
                            _selectedLevel == AppConstants.intermediateLevel,
                        onSelected: () =>
                            _changeLevel(AppConstants.intermediateLevel),
                      ),
                      const SizedBox(width: 8),
                      _LevelChip(
                        label: 'Advanced',
                        selected:
                            _selectedLevel == AppConstants.advancedLevel,
                        onSelected: () =>
                            _changeLevel(AppConstants.advancedLevel),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (provider.paths.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Center(
                      child: Text(
                        'No learning paths found.',
                      ),
                    ),
                  ),

                ...List.generate(
                  provider.paths.length,
                  (index) {
                    final path = provider.paths[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AnimatedPathCard(
                        index: index,
                        title: path.title,
                        description: path.description,
                        level: path.level ?? '',
                        minuteCount: path.minuteCount,
                        completedMinutes: path.completedMinutes,
                        onTap: () => _openPath(path.id),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedPathCard extends StatelessWidget {
  const _AnimatedPathCard({
    required this.index,
    required this.title,
    required this.description,
    required this.level,
    required this.minuteCount,
    required this.completedMinutes,
    required this.onTap,
  });

  final int index;
  final String title;
  final String? description;
  final String level;
  final int minuteCount;
  final int completedMinutes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = minuteCount == 0
        ? 0.0
        : (completedMinutes / minuteCount).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 400 + (index * 70),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _LevelBadge(
                      level: level,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (description != null &&
                    description!.trim().isNotEmpty)
                  Text(
                    description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$minuteCount minutes',
                      style: AppTextStyles.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      '$completedMinutes/$minuteCount',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: progress,
                  ),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: selected
            ? AppColors.primary
            : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({
    required this.level,
  });

  final String level;

  @override
  Widget build(BuildContext context) {
    final label = level.isEmpty
        ? 'Unknown'
        : '${level[0].toUpperCase()}${level.substring(1)}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}