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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.categories.isEmpty) {
            return const AppLoading(message: 'Loading categories...');
          }

          if (provider.error != null && provider.categories.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadCategories,
            );
          }

          if (provider.categories.isEmpty) {
            return const Center(
              child: Text('No categories available yet.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadCategories,
            child: ListView(
              padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 24),
                ...provider.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _CategoryCard(
                      name: category.name,
                      description: category.description,
                      icon: category.icon,
                      pathCount: category.pathCount,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.learningPaths,
                          arguments: category.id,
                        );
                      },
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

class _CategoryCard extends StatelessWidget {
  final String name;
  final String? description;
  final String? icon;
  final int pathCount;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.pathCount,
    required this.onTap,
  });

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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}