import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/user_model.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name.trim();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name == null || name.isEmpty
                    ? 'Keep learning'
                    : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 25,
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning ☀️';
    }

    if (hour < 18) {
      return 'Good afternoon 🌤️';
    }

    return 'Good evening 🌙';
  }
}