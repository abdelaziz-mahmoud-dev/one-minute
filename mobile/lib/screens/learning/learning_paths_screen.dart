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
    setState(() {
      _selectedLevel = level;
    });

    await context.read<LearningProvider>().loadPaths(
          category: widget.categoryId,
          level: level,
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
            return const AppLoading(message: 'Loading paths...');
          }

          if (provider.error != null && provider.paths.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: () => provider.loadPaths(
                category: widget.categoryId,
                level: _selectedLevel,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPaths(
              category: widget.categoryId,
              level: _selectedLevel,
            ),
            child: ListView(
              padding: const EdgeInsets.all(20),
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
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text('No learning paths found.'),
                    ),
                  ),

                ...provider.paths.map(
                  (path) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.learningPath,
                            arguments: path.id,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      path.title,
                                      style: AppTextStyles.titleLarge,
                                    ),
                                  ),
                                  _LevelBadge(level: path.level ?? ''),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                path.description ?? '',
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
                                    '${path.minuteCount} minutes',
                                    style: AppTextStyles.bodySmall,
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
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: path.minuteCount == 0
                                    ? 0
                                    : (path.completedMinutes /
                                            path.minuteCount)
                                        .clamp(0.0, 1.0),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ),
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

class _LevelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;

  const _LevelBadge({
    required this.level,
  });

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