import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';
import 'monthly_budget_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(berlinLocationProvider);
    final now = tz.TZDateTime.now(location);
    final profile = ref.watch(userProfileProvider).value;
    final entries = ref.watch(entriesProvider).value ?? const <WorkEntry>[];
    final recent =
        entries.where((e) => e.status == WorkEntryStatus.completed).toList()
          ..sort((a, b) => b.startTimeUtc.compareTo(a.startTimeUtc));
    final next =
        entries
            .where(
              (e) =>
                  e.status == WorkEntryStatus.planned &&
                  e.startTimeUtc.isAfter(now),
            )
            .toList()
          ..sort((a, b) => a.startTimeUtc.compareTo(b.startTimeUtc));
    final employers = {
      for (final e in ref.watch(employersProvider).value ?? const []) e.id: e,
    };
    return SafeArea(
      bottom: false,
      child: ref
          .watch(dashboardProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Dashboard unavailable: $error')),
            data: (summary) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 180),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello${profile?.displayName.isNotEmpty == true ? ', ${profile!.displayName}' : ''}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Your month.',
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(fontSize: 44),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => context.push('/can-i-work'),
                      tooltip: 'Can I Work?',
                      icon: const Icon(Icons.calculate_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(color: AppColors.ink),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('MMMM').format(now)} earnings',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatMoney(summary.monthGrossCents),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${formatDuration(Duration(minutes: summary.monthMinutes))} worked · Gross',
                              ),
                            ),
                            IconButton(
                              tooltip: 'Income details',
                              onPressed: () => context.push('/income'),
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const MonthlyBudgetCard(),
                const SizedBox(height: 14),
                Card(
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: const Text(
                      'References & checks',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      summary.issueCount == 0
                          ? 'Weekly, residence & Minijob'
                          : '${summary.issueCount} working-time items to review',
                    ),
                    leading: Icon(
                      summary.issueCount > 0
                          ? Icons.warning_amber_rounded
                          : Icons.fact_check_outlined,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    children: [
                      if (profile?.isStudent != false)
                        _Reference(
                          label: 'This week',
                          value:
                              '${formatDuration(Duration(minutes: summary.weekMinutes))} / ${formatDuration(Duration(minutes: summary.weekReferenceMinutes))}',
                          fraction:
                              summary.weekMinutes /
                              summary.weekReferenceMinutes,
                        ),
                      if (profile?.tracksResidenceAllowance != false)
                        _Reference(
                          label: 'Residence-day equivalents',
                          value:
                              '${summary.residence.usedFullDayEquivalents.toStringAsFixed(1)} / ${summary.residenceAllowanceFullDays}',
                          fraction:
                              summary.residence.usedFullDayEquivalents /
                              summary.residenceAllowanceFullDays,
                        ),
                      _Reference(
                        label: 'Minijob monthly earnings',
                        value:
                            '${formatMoney(summary.minijob.monthlyEarningsCents)} / ${formatMoney(summary.minijob.monthlyReferenceCents)}',
                        fraction:
                            summary.minijob.monthlyEarningsCents /
                            summary.minijob.monthlyReferenceCents,
                      ),
                      const Text(
                        'Tracking references, not automatic legal permission.',
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () => context.push('/review'),
                        child: const Text('Review warnings & weekly history'),
                      ),
                    ],
                  ),
                ),
                if (next.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    'Up next',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => context.push('/work/add', extra: next.first),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.pink,
                      child: Icon(Icons.event_available, color: AppColors.ink),
                    ),
                    title: Text(
                      employers[next.first.employerId]?.name ?? 'Employer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('EEE, d MMM · HH:mm').format(
                        tz.TZDateTime.from(next.first.startTimeUtc, location),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent work',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/work'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
                if (recent.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text('Your first saved shift will appear here.'),
                  ),
                for (final entry in recent.take(3))
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () => context.push('/work/add', extra: entry),
                      title: Text(
                        employers[entry.employerId]?.name ?? 'Employer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        DateFormat('EEE, d MMM').format(
                          tz.TZDateTime.from(entry.startTimeUtc, location),
                        ),
                      ),
                      trailing: Text(
                        formatDuration(entry.workingDuration),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}

class _Reference extends StatelessWidget {
  const _Reference({
    required this.label,
    required this.value,
    required this.fraction,
  });
  final String label, value;
  final double fraction;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(value),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fraction.clamp(0, 1),
          minHeight: 6,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    ),
  );
}
