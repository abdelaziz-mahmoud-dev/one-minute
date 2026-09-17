import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/minute_model.dart';

class DailyMinuteCard extends StatelessWidget {
  const DailyMinuteCard({
    super.key,
    required this.minute,
    required this.onPressed,
  });

  final MinuteModel? minute;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final completed = minute?.isCompleted ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Minute',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'One useful thing today',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (minute != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.success.withValues(alpha: 0.10)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: completed
                          ? AppColors.success.withValues(alpha: 0.18)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    completed
                        ? 'Done'
                        : '+${minute!.xpReward} XP',
                    style: TextStyle(
                      color: completed
                          ? AppColors.success
                          : AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            minute?.title ?? 'Your next useful minute is waiting.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 21,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            completed
                ? 'You already completed today’s minute. Review it whenever you want.'
                : 'Learn something useful in about one minute.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: minute == null ? null : onPressed,
              icon: Icon(
                completed
                    ? Icons.refresh_rounded
                    : Icons.play_arrow_rounded,
              ),
              label: Text(
                completed ? 'Review Minute' : 'Start Minute',
              ),
            ),
          ),
        ],
      ),
    );
  }
}