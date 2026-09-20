import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/recall_provider.dart';

class RecallScreen extends StatefulWidget {
  const RecallScreen({
    super.key,
  });

  @override
  State<RecallScreen> createState() =>
      _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {
  final Map<String, int> _selectedScores = {};
  final Set<String> _submitted = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<RecallProvider>().loadRecall();
    });
  }

  Future<void> _submitAnswer({
    required String recallId,
    required int score,
  }) async {
    if (_submitted.contains(recallId)) {
      return;
    }

    final provider = context.read<RecallProvider>();

    final success = await provider.answerRecall(
      recallId: recallId,
      score: score,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ??
                'Unable to update your recall.',
          ),
          backgroundColor: AppColors.error,
        ),
      );

      return;
    }

    setState(() {
      _submitted.add(recallId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recall'),
      ),
      body: Consumer<RecallProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading &&
              provider.items.isEmpty) {
            return const AppLoading(
              message: 'Loading your recall items...',
            );
          }

          if (provider.error != null &&
              provider.items.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadRecall,
            );
          }

          if (provider.items.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadRecall,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height *
                            0.3,
                  ),
                  const Icon(
                    Icons.psychology_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nothing to review right now.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Come back after learning a few minutes.',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadRecall,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Keep it in your memory',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Review what you learned and tell us how well you remembered it.',
                  style:
                      AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ...provider.items.map(
                  (item) {
                    final selectedScore =
                        _selectedScores[item.id];

                    final submitted =
                        _submitted.contains(item.id);

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 18),
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              if (item.minuteTitle != null &&
                                  item.minuteTitle!
                                      .isNotEmpty)
                                Text(
                                  item.minuteTitle!,
                                  style: AppTextStyles
                                      .labelLarge
                                      .copyWith(
                                    color:
                                        AppColors.primary,
                                  ),
                                ),

                              const SizedBox(height: 12),

                              Text(
                                item.question,
                                style:
                                    AppTextStyles.titleMedium,
                              ),

                              const SizedBox(height: 20),

                              Text(
                                submitted
                                    ? 'Reviewed'
                                    : 'How well did you remember?',
                                style: AppTextStyles
                                    .labelLarge,
                              ),

                              const SizedBox(height: 12),

                              _RecallScale(
                                selectedScore:
                                    selectedScore,
                                enabled: !submitted &&
                                    !provider.isSubmitting,
                                onSelected: (score) {
                                  setState(() {
                                    _selectedScores[
                                        item.id] = score;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              if (selectedScore != null &&
                                  !submitted)
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed:
                                        provider.isSubmitting
                                            ? null
                                            : () =>
                                                _submitAnswer(
                                                  recallId:
                                                      item.id,
                                                  score:
                                                      selectedScore,
                                                ),
                                    child:
                                        provider.isSubmitting
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth:
                                                      2,
                                                ),
                                              )
                                            : const Text(
                                                'Save review',
                                              ),
                                  ),
                                ),

                              if (submitted)
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(
                                    12,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: AppColors.success
                                        .withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons
                                            .check_circle_rounded,
                                        color:
                                            AppColors.success,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Review saved. Your next review has been scheduled.',
                                          style: AppTextStyles
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
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

class _RecallScale extends StatelessWidget {
  final int? selectedScore;
  final bool enabled;
  final ValueChanged<int> onSelected;

  const _RecallScale({
    required this.selectedScore,
    required this.enabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            6,
            (index) {
              final selected =
                  selectedScore == index;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 5 ? 0 : 6,
                  ),
                  child: _ScoreButton(
                    score: index,
                    selected: selected,
                    enabled: enabled,
                    onTap: () => onSelected(index),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Forgot it',
              style:
                  AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Perfect recall',
              style:
                  AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScoreButton extends StatelessWidget {
  final int score;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _ScoreButton({
    required this.score,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary
          : AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            '$score',
            style: AppTextStyles.labelLarge.copyWith(
              color: selected
                  ? Colors.white
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}