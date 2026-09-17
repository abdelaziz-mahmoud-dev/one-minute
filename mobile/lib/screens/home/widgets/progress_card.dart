import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dashboard_model.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.dashboard,
  });

  final DashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    final xpTowardsNext = dashboard.nextLevelXp == 0
        ? 0.0
        : (dashboard.totalXp / dashboard.nextLevelXp).clamp(0.0, 1.0);

    final percentage = (xpTowardsNext * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your progress',
                  style: AppTextStyles.titleLarge,
                ),
              ),
              Text(
                '$percentage%',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${dashboard.totalXp} of ${dashboard.nextLevelXp} XP to next level',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpTowardsNext,
              minHeight: 10,
              backgroundColor: AppColors.primaryLight,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.star_rounded,
                  value: '${dashboard.totalXp}',
                  label: 'XP',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.menu_book_rounded,
                  value: '${dashboard.completedMinutes}',
                  label: 'Minutes',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.psychology_rounded,
                  value: '${dashboard.dueRecalls}',
                  label: 'Due recalls',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}