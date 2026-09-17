import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You can log back in anytime with your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<AuthProvider>().logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                user?.name.isNotEmpty == true
                    ? user!.name[0].toUpperCase()
                    : '?',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              user?.name ?? 'User',
              style: AppTextStyles.headlineMedium,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              user?.email ?? '',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit profile',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editProfile,
                    );
                  },
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change password',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.changePassword,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.streak ?? 0} day streak',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user?.xp ?? 0} XP earned',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.titleMedium,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
      ),
      onTap: onTap,
    );
  }
}