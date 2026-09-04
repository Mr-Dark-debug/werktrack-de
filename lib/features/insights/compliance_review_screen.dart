import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/student_weekly_hours_calculator.dart';
import '../../domain/calculators/working_time_compliance_calculator.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';

class ComplianceReviewScreen extends ConsumerWidget {
  const ComplianceReviewScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider).value ?? const <WorkEntry>[];
    final employers = {
      for (final e in ref.watch(employersProvider).value ?? const <Employer>[])
        e.id: e,
    };
    final rules = ref.watch(resolvedRulesProvider).value;
    final book = ref.watch(legalRuleBookProvider);
    if (rules == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final location = ref.watch(berlinLocationProvider);
    final weekly = const StudentWeeklyHoursCalculator().calculate(
      entries: entries,
      employers: employers,
      rules: rules,
      location: location,
      ruleResolver: book.forDate,
    );
    final rolling = const WerkstudentRollingWeekTracker().calculate(
      weekly: weekly,
      asOf: DateTime.now(),
      configuredReference: rules.werkstudentExceptionWeeks,
    );
    final issues = const WorkingTimeComplianceCalculator().calculate(
      entries: entries,
      rules: rules,
      location: location,
      ruleResolver: book.forDate,
      sourceUrl: 'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
    );
    final weeks = weekly.minutesByWeek.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return Scaffold(
      appBar: AppBar(title: const Text('Threshold review')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Working-time checks',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text(
            'These are advisory checks, not definitive employment or social-insurance decisions.',
          ),
          const SizedBox(height: 14),
          if (issues.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'No warnings from the completed records and available rule versions.',
                ),
              ),
            ),
          ...issues.map(
            (issue) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('d MMM yyyy').format(issue.affectedDate)} · ${issue.title}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(issue.description),
                    Text(issue.recommendation),
                    TextButton(
                      onPressed: () => launchUrl(
                        Uri.parse(issue.source),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text('Official source'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Rolling 12-month week review',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            '${rolling.numberOfRelevantWeeks} relevant weeks / ${rolling.configuredReference} configured reference',
          ),
          const Text(
            'A week above the reference is not automatically an exception or a loss of Werkstudent status. Lecture timing, duration and individual insurance assessment still matter.',
          ),
          const SizedBox(height: 12),
          if (weeks.isEmpty) const Text('No weekly records yet.'),
          ...weeks.map(
            (week) => ListTile(
              leading: Icon(
                rolling.relevantWeeks.contains(week)
                    ? Icons.flag_outlined
                    : Icons.calendar_view_week_outlined,
              ),
              title: Text(week.toString()),
              subtitle: Text(
                weekly.unresolvedWeeks.contains(week)
                    ? 'Rule coverage unavailable'
                    : '${(weekly.referencesByWeek[week] ?? weekly.referenceMinutes) / 60}h reference · ${weekly.stateFor(week).name}',
              ),
              trailing: Text(
                formatDuration(Duration(minutes: weekly.minutesByWeek[week]!)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
