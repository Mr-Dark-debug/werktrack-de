import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../localization/app_localizations.dart';
import '../../theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = ref.watch(themeModeProvider);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 180),
        children: [
          Text(
            l10n.settings,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 50),
          ),
          const SizedBox(height: 22),
          _SettingsTile(
            color: AppColors.periwinkle,
            icon: Icons.person_outline,
            title: 'Your profile',
            subtitle: 'Student and residence-tracking preferences',
            onTap: () => context.push('/profile'),
          ),
          _SettingsTile(
            color: AppColors.yellow,
            icon: Icons.apartment_rounded,
            title: l10n.employers,
            subtitle: 'Rates, employment types and compliance switches',
            onTap: () => context.push('/employers'),
          ),
          _SettingsTile(
            color: AppColors.sage,
            icon: Icons.school_rounded,
            title: l10n.academicPeriods,
            subtitle: 'Lecture and lecture-free context',
            onTap: () => context.push('/periods'),
          ),
          _SettingsTile(
            color: AppColors.pink,
            icon: Icons.gavel_rounded,
            title: l10n.rulesAndSources,
            subtitle: 'Effective dates and official sources',
            onTap: () => context.push('/rules'),
          ),
          _SettingsTile(
            color: AppColors.aqua,
            icon: Icons.ios_share_rounded,
            title: l10n.exportAndBackup,
            subtitle: 'CSV, TXT, JSON, employer imports and backups',
            onTap: () => context.push('/export'),
          ),
          const SizedBox(height: 18),
          _SettingsTile(
            color: AppColors.coral,
            icon: Icons.receipt_long_outlined,
            title: 'Income & payslips',
            subtitle: 'Tracked gross, actual payroll and tax reference',
            onTap: () => context.push('/income'),
          ),
          const SizedBox(height: 8),
          Text(l10n.appearance, style: Theme.of(context).textTheme.titleLarge),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
            ],
            selected: {theme},
            onSelectionChanged: (value) =>
                ref.read(themeModeProvider.notifier).setMode(value.first),
          ),
          const SizedBox(height: 24),
          const _NotificationSettings(),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.periwinkle,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.disclaimerTitle,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.disclaimer,
                  style: const TextStyle(color: AppColors.ink, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            onTap: () => context.push('/sync'),
            leading: Icon(Icons.cloud_off_rounded),
            title: Text('Optional cloud sync'),
            subtitle: Text(
              'Local-first storage, sign-in and explicit cloud reconciliation',
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettings extends ConsumerStatefulWidget {
  const _NotificationSettings();
  @override
  ConsumerState<_NotificationSettings> createState() =>
      _NotificationSettingsState();
}

class _NotificationSettingsState extends ConsumerState<_NotificationSettings> {
  bool _enabled = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    ref.read(workRepositoryProvider).readSetting('notificationsEnabled').then((
      value,
    ) {
      if (mounted) {
        setState(() {
          _enabled = value == 'true';
          _loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => SwitchListTile(
    tileColor: Theme.of(context).cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    secondary: const Icon(Icons.notifications_active_outlined),
    title: const Text('Advisory notifications'),
    subtitle: const Text(
      'Weekly, Minijob, residence and long-running timer milestones. At most once per advisory per day.',
    ),
    value: _enabled,
    onChanged: !_loaded ? null : _setEnabled,
  );

  Future<void> _setEnabled(bool value) async {
    if (value) {
      final granted = await ref
          .read(localNotificationServiceProvider)
          .requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notifications are disabled in system settings. Work tracking still works.',
              ),
            ),
          );
        }
        return;
      }
    }
    await ref
        .read(workRepositoryProvider)
        .writeSetting('notificationsEnabled', value.toString());
    if (!value) {
      await ref.read(localNotificationServiceProvider).cancelAll();
    } else {
      final entries = await ref
          .read(workRepositoryProvider)
          .watchEntries()
          .first;
      final active = entries
          .where((entry) => entry.status.name == 'active')
          .firstOrNull;
      if (active != null) {
        await ref
            .read(localNotificationServiceProvider)
            .scheduleTimerReminder(active.startTimeUtc);
      }
    }
    if (mounted) setState(() => _enabled = value);
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTap,
      tileColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Icon(icon, color: AppColors.ink),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.ink)),
      trailing: const Icon(Icons.arrow_forward_rounded, color: AppColors.ink),
    ),
  );
}
