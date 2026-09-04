import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../localization/app_localizations.dart';
import '../../theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = switch (path) {
      '/calendar' => 1,
      '/work' => 2,
      '/insights' => 3,
      '/settings' => 4,
      _ => 0,
    };
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add work, timer, plan or payslip',
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => context.go(
              const [
                '/home',
                '/calendar',
                '/work',
                '/insights',
                '/settings',
              ][value],
            ),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: l10n.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_rounded),
                label: l10n.calendar,
              ),
              NavigationDestination(
                icon: const Icon(Icons.work_rounded),
                label: l10n.work,
              ),
              NavigationDestination(
                icon: const Icon(Icons.auto_graph_rounded),
                label: l10n.insights,
              ),
              NavigationDestination(
                icon: const Icon(Icons.tune_rounded),
                label: l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add something',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              _ActionTile(
                color: AppColors.yellow,
                icon: Icons.add_task_rounded,
                label: l10n.addWork,
                onTap: () => _go(sheetContext, context, '/work/add'),
              ),
              _ActionTile(
                color: AppColors.aqua,
                icon: Icons.timer_rounded,
                label: l10n.startTimer,
                onTap: () => _go(sheetContext, context, '/work?timer=true'),
              ),
              _ActionTile(
                color: AppColors.pink,
                icon: Icons.event_available_rounded,
                label: l10n.planShift,
                onTap: () =>
                    _go(sheetContext, context, '/work/add?planned=true'),
              ),
              _ActionTile(
                color: AppColors.periwinkle,
                icon: Icons.receipt_long_rounded,
                label: l10n.addPayslip,
                onTap: () => _go(sheetContext, context, '/payslips/add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext sheet, BuildContext root, String path) {
    Navigator.pop(sheet);
    root.push(path);
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      onTap: onTap,
      tileColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      leading: CircleAvatar(
        backgroundColor: Colors.white.withValues(alpha: .7),
        child: Icon(icon, color: AppColors.ink),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_rounded, color: AppColors.ink),
    ),
  );
}
