import 'package:flutter/material.dart';

import '../../core/storage/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../routes/app_routes.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController =
      PageController();

  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      icon: Icons.timer_outlined,
      title: 'Learn in just one minute',
      description:
          'Discover useful knowledge and practical skills '
          'through short, focused learning sessions.',
    ),
    OnboardingPage(
      icon: Icons.psychology_outlined,
      title: 'Build real skills',
      description:
          'Learn programming, AI, languages and more '
          'without overwhelming yourself.',
    ),
    OnboardingPage(
      icon: Icons.trending_up_rounded,
      title: 'Keep growing every day',
      description:
          'Complete your daily minute, build your streak, '
          'earn XP and watch your progress grow.',
      isLast: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await StorageService.instance
        .setOnboardingCompleted(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.login,
    );
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage =
        _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 12,
                ),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (_, index) {
                  return _pages[index];
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                28,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final isActive =
                            index == _currentPage;

                        return AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: isLastPage
                        ? 'Get Started'
                        : 'Continue',
                    icon: isLastPage
                        ? Icons.arrow_forward_rounded
                        : null,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}