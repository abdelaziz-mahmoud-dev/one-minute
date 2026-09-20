import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/profile_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();

    final success = await provider.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully.'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.error ?? 'Unable to change password.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Secure your account',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a strong password that you do not use elsewhere.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            AppTextField(
              controller: _currentPasswordController,
              label: 'Current password',
              hint: 'Enter your current password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _newPasswordController,
              label: 'New password',
              hint: 'Enter your new password',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _confirmPasswordController,
              label: 'Confirm new password',
              hint: 'Repeat your new password',
              prefixIcon: Icons.verified_user_outlined,
              obscureText: true,
              validator: (value) => Validators.confirmPassword(
                value,
                _newPasswordController.text,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Change password',
              isLoading: provider.isLoading,
              onPressed: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}