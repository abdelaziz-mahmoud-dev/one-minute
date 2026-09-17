import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/learning_provider.dart';
import '../../providers/progress_provider.dart';

class QuizScreen extends StatefulWidget {
  final String minuteId;

  const QuizScreen({
    super.key,
    required this.minuteId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedIndex;
  bool _submitted = false;
  bool _isCorrect = false;
  String? _resultMessage;

  Future<void> _submitAnswer() async {
    if (_selectedIndex == null || _submitted) {
      return;
    }

    final learningProvider = context.read<LearningProvider>();
    final progressProvider = context.read<ProgressProvider>();

    final minute = learningProvider.currentMinute;

    if (minute == null || minute.question == null) {
      return;
    }

    setState(() {
      _submitted = true;
    });

    final result = await progressProvider.answerMinute(
      minuteId: widget.minuteId,
      answer: _selectedIndex!,
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        _submitted = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            progressProvider.error ?? 'Something went wrong.',
          ),
        ),
      );

      return;
    }

    final isCorrect = result['correct'] == true;

    setState(() {
      _isCorrect = isCorrect;
      _resultMessage = result['message']?.toString();
    });

    if (isCorrect) {
      final pathId = learningProvider.currentPath?.id;

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (pathId != null) {
        await learningProvider.loadPath(pathId);
      }

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final learningProvider = context.watch<LearningProvider>();
    final progressProvider = context.watch<ProgressProvider>();

    final minute = learningProvider.currentMinute;

    if (minute == null || minute.question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: const Center(
          child: Text('Quiz is not available.'),
        ),
      );
    }

    final question = minute.question!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Quiz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test yourself',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Answer correctly to complete this minute and earn XP.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question,
                  style: AppTextStyles.titleLarge.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...minute.options.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AnswerOption(
                  text: entry.value,
                  selected: _selectedIndex == entry.key,
                  enabled: !_submitted,
                  onTap: () {
                    setState(() {
                      _selectedIndex = entry.key;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_submitted) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _isCorrect
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isCorrect
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: _isCorrect
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _resultMessage ??
                            (_isCorrect
                                ? 'Correct! Great job.'
                                : 'Not quite. Keep learning!'),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _selectedIndex == null ||
                        (_submitted && !_isCorrect) ||
                        progressProvider.isSubmitting
                    ? null
                    : (_submitted ? null : _submitAnswer),
                child: progressProvider.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _submitted
                            ? (_isCorrect
                                ? 'Returning...'
                                : 'Try again')
                            : 'Submit answer',
                      ),
              ),
            ),
            if (_submitted && !_isCorrect) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _submitted = false;
                      _selectedIndex = null;
                    });
                  },
                  child: const Text('Try again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _AnswerOption({
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
          : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
              width: selected ? 1.5 : 1,
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
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}