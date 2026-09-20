import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({
    super.key,
  });

  @override
  State<InterestsScreen> createState() =>
      _InterestsScreenState();
}

class _InterestsScreenState
    extends State<InterestsScreen> {
  final Set<String> _selectedInterests = {};

  String _selectedLevel =
      AppConstants.beginnerLevel;

  final List<_InterestOption> _interests = const [
    _InterestOption(
      value: 'programming',
      title: 'Programming',
      icon: Icons.code_rounded,
    ),
    _InterestOption(
      value: 'artificial-intelligence',
      title: 'Artificial Intelligence',
      icon: Icons.psychology_outlined,
    ),
    _InterestOption(
      value: 'english',
      title: 'English',
      icon: Icons.language_rounded,
    ),
    _InterestOption(
      value: 'german',
      title: 'German',
      icon: Icons.translate_rounded,
    ),
    _InterestOption(
      value: 'general-knowledge',
      title: 'General Knowledge',
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  final List<_LevelOption> _levels = const [
    _LevelOption(
      value: AppConstants.beginnerLevel,
      title: 'Beginner',
      description: 'I am starting from the basics.',
    ),
    _LevelOption(
      value: AppConstants.intermediateLevel,
      title: 'Intermediate',
      description: 'I already know the fundamentals.',
    ),
    _LevelOption(
      value: AppConstants.advancedLevel,
      title: 'Advanced',
      description: 'I want to challenge myself.',
    ),
  ];

  Future<void> _continue() async {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose at least one interest to continue.',
          ),
        ),
      );
      return;
    }

    final authProvider =
        context.read<AuthProvider>();

    final success =
        await authProvider.updateInterests(
      interests: _selectedInterests.toList(),
      level: _selectedLevel,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ??
                'Unable to save your preferences.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            32,
            24,
            28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Make it yours',
                    style:
                        AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose what you want to learn. '
                    'You can change these preferences later.',
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Your interests',
                    style:
                        AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: _interests.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final interest =
                          _interests[index];

                      final selected =
                          _selectedInterests
                              .contains(
                        interest.value,
                      );

                      return _InterestCard(
                        option: interest,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedInterests
                                  .remove(
                                interest.value,
                              );
                            } else {
                              _selectedInterests
                                  .add(
                                interest.value,
                              );
                            }
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'Your level',
                    style:
                        AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  ..._levels.map(
                    (level) {
                      final selected =
                          _selectedLevel ==
                              level.value;

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: _LevelCard(
                          option: level,
                          selected: selected,
                          onTap: () {
                            setState(() {
                              _selectedLevel =
                                  level.value;
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Consumer<AuthProvider>(
                    builder: (
                      context,
                      auth,
                      _,
                    ) {
                      return AppButton(
                        label: 'Continue',
                        icon: Icons
                            .arrow_forward_rounded,
                        isLoading:
                            auth.isLoading,
                        onPressed: _continue,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InterestOption {
  const _InterestOption({
    required this.value,
    required this.title,
    required this.icon,
  });

  final String value;
  final String title;
  final IconData icon;
}

class _LevelOption {
  const _LevelOption({
    required this.value,
    required this.title,
    required this.description,
  });

  final String value;
  final String title;
  final String description;
}

class _InterestCard extends StatelessWidget {
  const _InterestCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _InterestOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryLight
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  option.icon,
                  size: 28,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
              ],
            ),
            Text(
              option.title,
              style: AppTextStyles.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _LevelOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryLight
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style:
                        AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    option.description,
                    style:
                        AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}