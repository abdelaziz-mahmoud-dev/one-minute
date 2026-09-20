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

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;

  bool _submitted = false;
  bool _isCorrect = false;
  String? _resultMessage;

  late final AnimationController _resultController;
  late final Animation<double> _resultScale;
  late final Animation<double> _resultFade;

  @override
  void initState() {
    super.initState();

    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _resultScale = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutBack,
    );

    _resultFade = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

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

    _resultController.forward(from: 0);

    if (!isCorrect) {
      return;
    }

    await Future.delayed(
      const Duration(milliseconds: 1400),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  void _tryAgain() {
    if (_isCorrect) {
      return;
    }

    _resultController.reset();

    setState(() {
      _submitted = false;
      _selectedIndex = null;
      _resultMessage = null;
    });
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            32,
          ),
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

              // Question
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

              // Answers
              ...minute.options.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AnswerOption(
                    text: entry.value,
                    selected: _selectedIndex == entry.key,
                    enabled: !_submitted,
                    onTap: () {
                      if (_submitted) {
                        return;
                      }

                      setState(() {
                        _selectedIndex = entry.key;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Result
              if (_submitted)
                FadeTransition(
                  opacity: _resultFade,
                  child: ScaleTransition(
                    scale: _resultScale,
                    child: _ResultCard(
                      isCorrect: _isCorrect,
                      message: _resultMessage ??
                          (_isCorrect
                              ? 'Correct! Great job.'
                              : 'Not quite. Keep learning!'),
                    ),
                  ),
                ),

              if (_submitted)
                const SizedBox(height: 20),

              // Main action
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedIndex == null ||
                          progressProvider.isSubmitting ||
                          (_submitted && _isCorrect)
                      ? null
                      : (_submitted
                          ? _tryAgain
                          : _submitAnswer),
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
                                  ? 'Completed'
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
                    onPressed: _tryAgain,
                    child: const Text('Choose another answer'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.isCorrect,
    required this.message,
  });

  final bool isCorrect;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color =
        isCorrect ? AppColors.success : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.text,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Material(
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
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
      ),
    );
  }
}