import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/recall_provider.dart';

class RecallScreen extends StatefulWidget {
  const RecallScreen({super.key});

  @override
  State<RecallScreen> createState() => _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {
  final Map<String, String> _answers = {};
  final Set<String> _submitted = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecallProvider>().loadRecall();
    });
  }

  Future<void> _submitAnswer(
    String recallId,
    String answer,
  ) async {
    if (_submitted.contains(recallId)) return;

    final provider = context.read<RecallProvider>();

    try {
      await provider.answerRecall(recallId: recallId, answer: answer);

      if (!mounted) return;

      setState(() {
        _submitted.add(recallId);
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Unable to submit answer.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recall'),
      ),
      body: Consumer<RecallProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const AppLoading(
              message: 'Loading your recall items...',
            );
          }

          if (provider.error != null && provider.items.isEmpty) {
            return AppError(
              message: provider.error!,
              onRetry: provider.loadRecall,
            );
          }

          if (provider.items.isEmpty) {
            return const Center(
              child: Text(
                'Nothing to review right now.\nCome back after learning a few minutes.',
                textAlign: TextAlign.center,
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
                  'A quick review helps turn what you learned into long-term memory.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ...provider.items.map(
                  (item) {
                    final selected = _answers[item.id];
                    final submitted = _submitted.contains(item.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.minuteTitle ?? '',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.question,
                                style: AppTextStyles.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              ...item.options.map(
                                (option) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _RecallOption(
                                    text: option,
                                    selected: selected == option,
                                    enabled: !submitted,
                                    onTap: () {
                                      setState(() {
                                        _answers[item.id] = option;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: OutlinedButton(
                                  onPressed: selected == null || submitted
                                      ? null
                                      : () => _submitAnswer(
                                            item.id,
                                            selected,
                                          ),
                                  child: Text(
                                    submitted
                                        ? 'Reviewed'
                                        : 'Check answer',
                                  ),
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

class _RecallOption extends StatelessWidget {
  final String text;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _RecallOption({
    required this.text,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primaryLight
          : AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}