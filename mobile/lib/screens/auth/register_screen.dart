import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.interests,
        (route) => false,
      );
      return;
    }

    final error = authProvider.error ?? 'Registration failed.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create your account',
                      style: AppTextStyles.headlineMedium,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Start building real skills, one minute '
                      'at a time.',
                      style: AppTextStyles.bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Name',
                      style: AppTextStyles.labelLarge,
                    ),

                    const SizedBox(height: 8),

                    AppTextField(
                      controller: _nameController,
                      label: 'Full name',
                      hint: 'Your name',
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: Validators.name,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Email',
                      style: AppTextStyles.labelLarge,
                    ),

                    const SizedBox(height: 8),

                    AppTextField(
                      controller: _emailController,
                      label: 'Email address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Password',
                      style: AppTextStyles.labelLarge,
                    ),

                    const SizedBox(height: 8),

                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: Validators.password,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Confirm password',
                      style: AppTextStyles.labelLarge,
                    ),

                    const SizedBox(height: 8),

                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm password',
                      hint: 'Repeat your password',
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return AppButton(
                          label: 'Create Account',
                          isLoading: auth.isLoading,
                          onPressed: _register,
                          icon: Icons.arrow_forward_rounded,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: AppTextStyles.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutes.login,
                            );
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}