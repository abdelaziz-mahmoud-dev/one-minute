import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHome();
    });
  }

  Future<void> _openDailyMinute() async {
    final minute = context.read<HomeProvider>().dailyMinute;

    if (minute == null || minute.id.isEmpty) {
      return;
    }

    final result = await Navigator.of(context).pushNamed(
      AppRoutes.minute,
      arguments: minute.id,
    );

    if (!mounted) return;

    if (result == true) {
      await context.read<HomeProvider>().refresh();
    }
  }

  Future<void> _refresh() async {
    await context.read<HomeProvider>().refresh();
  }

  void _onNavigationChanged(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('One Minute'),
        actions: [
          IconButton(
            tooltip: 'Recall',
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.recall,
              );
            },
            icon: const Icon(
              Icons.psychology_rounded,
            ),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, home, _) {
          if (home.isLoading && home.dashboard == null) {
            return const AppLoading(
              message: 'Loading your day...',
            );
          }

          if (home.error != null && home.dashboard == null) {
            return AppError(
              message: home.error!,
              onRetry: home.loadHome,
            );
          }

          final dashboard = home.dashboard;

          if (dashboard == null) {
            return const Center(
              child: Text(
                'Unable to load your dashboard.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                32,
              ),
              children: [
                _AnimatedSection(
                  delay: 0,
                  child: WelcomeHeader(
                    user: user,
                  ),
                ),

                const SizedBox(height: 18),

                _AnimatedSection(
                  delay: 60,
                  child: StreakCard(
                    dashboard: dashboard,
                  ),
                ),

                const SizedBox(height: 22),

                const _SectionHeader(
                  title: 'Today',
                  icon: Icons.today_rounded,
                ),

                const SizedBox(height: 12),

                _AnimatedSection(
                  delay: 120,
                  child: DailyMinuteCard(
                    minute: home.dailyMinute,
                    onPressed: _openDailyMinute,
                  ),
                ),

                if (home.dailyError != null) ...[
                  const SizedBox(height: 10),
                  _InlineError(
                    message: home.dailyError!,
                    onRetry: _refresh,
                  ),
                ],

                const SizedBox(height: 24),

                const _SectionHeader(
                  title: 'Your progress',
                  icon: Icons.trending_up_rounded,
                ),

                const SizedBox(height: 12),

                _AnimatedSection(
                  delay: 180,
                  child: ProgressCard(
                    dashboard: dashboard,
                  ),
                ),

                const SizedBox(height: 24),

                const _SectionHeader(
                  title: 'Quick actions',
                  icon: Icons.bolt_rounded,
                ),

                const SizedBox(height: 12),

                _AnimatedSection(
                  delay: 240,
                  child: _QuickActions(
                    onExplore: () {
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
                  const SizedBox(height: 16),
                  _InlineError(
                    message: home.error!,
                    onRetry: _refresh,
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavigationChanged,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
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
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
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
        milliseconds: 450 + delay,
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onExplore,
    required this.onRecall,
  });

  final VoidCallback onExplore;
  final VoidCallback onRecall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.explore_rounded,
            title: 'Explore',
            subtitle: 'Find something new',
            onTap: onExplore,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.psychology_rounded,
            title: 'Recall',
            subtitle: 'Review what you learned',
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
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
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}