import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/learning_provider.dart';
import '../../routes/app_routes.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadCategories();
    });
  }

  Future<void> _openCategory(String categoryId) async {
    if (categoryId.isEmpty) return;

    await Navigator.pushNamed(
      context,
      AppRoutes.learningPaths,
      arguments: categoryId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.categories.isEmpty) {
            return const AppLoading(
              message: 'Loading categories...',
            );
          }

          if (provider.error != null && provider.categories.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadCategories,
            );
          }

          if (provider.categories.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadCategories,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Text('No categories available yet.'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadCategories,
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
                        'What do you want to learn?',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose a topic and start building your skills.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(
                  provider.categories.length,
                  (index) {
                    final category = provider.categories[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _AnimatedCategoryCard(
                        index: index,
                        name: category.name,
                        description: category.description,
                        icon: category.icon,
                        pathCount: category.pathCount,
                        onTap: () => _openCategory(category.id),
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

class _AnimatedCategoryCard extends StatelessWidget {
  const _AnimatedCategoryCard({
    required this.index,
    required this.name,
    required this.description,
    required this.icon,
    required this.pathCount,
    required this.onTap,
  });

  final int index;
  final String name;
  final String? description;
  final String? icon;
  final int pathCount;
  final VoidCallback onTap;

  IconData _getIcon() {
    switch (icon?.toLowerCase()) {
      case 'code':
      case 'programming':
        return Icons.code_rounded;
      case 'ai':
      case 'artificial-intelligence':
        return Icons.psychology_rounded;
      case 'english':
        return Icons.translate_rounded;
      case 'german':
        return Icons.language_rounded;
      case 'general':
      case 'general-knowledge':
        return Icons.public_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.titleMedium,
                      ),
                      if (description != null &&
                          description!.trim().isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '$pathCount learning paths',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}