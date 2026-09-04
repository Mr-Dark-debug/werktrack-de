import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/student_weekly_hours_calculator.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = (ref.watch(entriesProvider).value ?? const <WorkEntry>[])
        .where((e) => e.status == WorkEntryStatus.completed)
        .toList();
    final employers = {
      for (final e in ref.watch(employersProvider).value ?? const <Employer>[])
        e.id: e,
    };
    final resolved = ref.watch(resolvedRulesProvider).value;
    final weekly = resolved == null
        ? null
        : const StudentWeeklyHoursCalculator().calculate(
            entries: entries,
            employers: employers,
            rules: resolved,
            location: ref.watch(berlinLocationProvider),
            ruleResolver: ref.watch(legalRuleBookProvider).forDate,
          );
    final rolling = weekly == null || resolved == null
        ? null
        : const WerkstudentRollingWeekTracker().calculate(
            weekly: weekly,
            asOf: DateTime.now(),
            configuredReference: resolved.werkstudentExceptionWeeks,
          );
    final now = DateTime.now();
    final months = List.generate(
      6,
      (i) => DateTime(now.year, now.month - 5 + i),
    );
    final grossByMonth = [
      for (final month in months)
        entries
            .where(
              (e) =>
                  e.startTimeUtc.toLocal().year == month.year &&
                  e.startTimeUtc.toLocal().month == month.month,
            )
            .fold<int>(0, (sum, e) => sum + e.grossCents),
    ];
    final hoursByEmployer = <String, int>{};
    for (final entry in entries) {
      hoursByEmployer.update(
        entry.employerId,
        (v) => v + entry.workingDuration.inMinutes,
        ifAbsent: () => entry.workingDuration.inMinutes,
      );
    }
    final totalMinutes = entries.fold<int>(
      0,
      (sum, e) => sum + e.workingDuration.inMinutes,
    );
    final totalGross = entries.fold<int>(0, (sum, e) => sum + e.grossCents);
    final averageRate = totalMinutes == 0
        ? 0
        : (totalGross * 60 / totalMinutes).round();
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: [
          Text(
            'Insights',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 50),
          ),
          const Text('Useful trends from your real records.'),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  color: AppColors.periwinkle,
                  label: 'AVERAGE RATE',
                  value: '${formatMoney(averageRate)}/h',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  color: AppColors.sage,
                  label: 'TOTAL HOURS',
                  value: formatDuration(Duration(minutes: totalMinutes)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 260,
            padding: const EdgeInsets.fromLTRB(16, 20, 20, 14),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INCOME BY MONTH',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= months.length) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat('MMM').format(months[index]),
                                  style: const TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (var i = 0; i < grossByMonth.length; i++)
                              FlSpot(i.toDouble(), grossByMonth[i] / 100),
                          ],
                          isCurved: true,
                          color: AppColors.ink,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.white.withValues(alpha: .35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Hours by employer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          if (hoursByEmployer.isEmpty)
            const Text('Charts appear after completed work is recorded.')
          else
            ...hoursByEmployer.entries.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  title: Text(employers[item.key]?.name ?? 'Unknown employer'),
                  trailing: Text(
                    formatDuration(Duration(minutes: item.value)),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          _StatCard(
            color: AppColors.aqua,
            label: 'ROLLING 12-MONTH >20H WEEKS',
            value: rolling == null
                ? '—'
                : '${rolling.numberOfRelevantWeeks} / ${rolling.configuredReference} reference',
          ),
          TextButton.icon(
            onPressed: () => context.push('/review'),
            icon: const Icon(Icons.calendar_view_week),
            label: const Text('Open week-by-week review'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.color,
    required this.label,
    required this.value,
  });
  final Color color;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ],
    ),
  );
}
