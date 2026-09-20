import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_error.dart';
import '../../core/widgets/app_loading.dart';
import '../../providers/auth_provider.dart';
import '../../providers/home_provider.dart';
import '../../routes/app_routes.dart';
import 'widgets/daily_minute_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/streak_card.dart';
import 'widgets/welcome_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeProvider>().loadHome();
    });
  }

  void _onNavigationTap(int index) {
    if (index == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.of(context).pushNamed(
          AppRoutes.categories,
        );
        break;

      case 2:
        Navigator.of(context).pushNamed(
          AppRoutes.progress,
        );
        break;

      case 3:
        Navigator.of(context).pushNamed(
          AppRoutes.profile,
        );
        break;
    }
  }

  Future<void> _refresh() async {
    await context.read<HomeProvider>().refresh();
  }

  void _openDailyMinute() {
    final minute = context.read<HomeProvider>().dailyMinute;

    if (minute == null || minute.id.isEmpty) {
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.minute,
      arguments: minute.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('One Minute'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Recall',
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.recall,
              );
            },
            icon: const Icon(
              Icons.psychology_alt_outlined,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, home, _) {
          if (home.isLoading && home.dashboard == null) {
            return const AppLoading();
          }

          if (home.error != null && home.dashboard == null) {
            return AppError(
              message: home.error!,
              onRetry: _refresh,
            );
          }

          final dashboard = home.dashboard;

          if (dashboard == null) {
            return AppError(
              message: 'Unable to load your dashboard.',
              onRetry: _refresh,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    32,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _AnimatedSection(
                          delay: 0,
                          child: WelcomeHeader(
                            user: auth.user,
                          ),
                        ),

                        const SizedBox(height: 22),

                        _AnimatedSection(
                          delay: 60,
                          child: StreakCard(
                            dashboard: dashboard,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _SectionHeader(
                          title: 'Today',
                          subtitle: 'Make your minute count',
                        ),

                        const SizedBox(height: 12),

                        _AnimatedSection(
                          delay: 120,
                          child: DailyMinuteCard(
                            minute: home.dailyMinute,
                            onPressed: _openDailyMinute,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _SectionHeader(
                          title: 'Your progress',
                          subtitle: 'Keep building momentum',
                        ),

                        const SizedBox(height: 12),

                        _AnimatedSection(
                          delay: 180,
                          child: ProgressCard(
                            dashboard: dashboard,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _SectionHeader(
                          title: 'Quick actions',
                          subtitle: 'Jump back into learning',
                        ),

                        const SizedBox(height: 12),

                        _AnimatedSection(
                          delay: 240,
                          child: _QuickActions(
                            onLearning: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.categories,
                              );
                            },
                            onRecall: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.recall,
                              );
                            },
                          ),
                        ),

                        if (home.error != null) ...[
                          const SizedBox(height: 14),
                          _InlineError(
                            message: home.error!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavigationTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onLearning,
    required this.onRecall,
  });

  final VoidCallback onLearning;
  final VoidCallback onRecall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.explore_rounded,
            title: 'Explore',
            subtitle: 'Find a learning path',
            onTap: onLearning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.psychology_rounded,
            title: 'Recall',
            subtitle: 'Test your memory',
            onTap: onRecall,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({
    required this.child,
    required this.delay,
  });

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 350 + delay,
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}