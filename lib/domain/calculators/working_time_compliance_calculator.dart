import 'package:timezone/timezone.dart' as tz;

import '../entities/compliance_issue.dart';
import '../entities/work_entry.dart';
import '../rules/resolved_rules.dart';
import 'calendar_segments.dart';

class WorkingTimeComplianceCalculator {
  const WorkingTimeComplianceCalculator();

  List<ComplianceIssue> calculate({
    required Iterable<WorkEntry> entries,
    required ResolvedRules rules,
    required tz.Location location,
    required String sourceUrl,
    ResolvedRules? Function(DateTime)? ruleResolver,
  }) {
    final complete =
        entries
            .where(
              (e) =>
                  e.status == WorkEntryStatus.completed && e.endTimeUtc != null,
            )
            .toList()
          ..sort((a, b) => a.startTimeUtc.compareTo(b.startTimeUtc));
    final issues = <ComplianceIssue>[];
    final minutesByDay = <DateTime, int>{};
    final breaksByDay = <DateTime, int>{};
    for (final entry in complete) {
      final segments = workingMinutesByLocalDay(entry, location);
      final elapsedSegments = workingMinutesByLocalDay(
        entry.copyWith(breakMinutes: 0),
        location,
      );
      for (final segment in segments.entries) {
        minutesByDay.update(
          segment.key,
          (v) => v + segment.value,
          ifAbsent: () => segment.value,
        );
        final allocatedBreak =
            (elapsedSegments[segment.key] ?? 0) - segment.value;
        breaksByDay.update(
          segment.key,
          (value) => value + allocatedBreak,
          ifAbsent: () => allocatedBreak,
        );
      }
    }
    for (final day in minutesByDay.keys) {
      final datedRules = ruleResolver == null ? rules : ruleResolver(day);
      if (datedRules == null) {
        issues.add(
          _issue(
            ComplianceSeverity.warning,
            'unverified_rules',
            'Rule coverage unavailable',
            'No complete verified rule version applies to this work date. Hours and earnings remain recorded.',
            day,
            sourceUrl,
          ),
        );
        continue;
      }
      final worked = minutesByDay[day]!;
      final breaks = breaksByDay[day] ?? 0;
      if (worked > datedRules.extendedDailyMinutes) {
        issues.add(
          _issue(
            ComplianceSeverity.critical,
            'extended_daily_hours',
            'Daily work exceeds the extended reference',
            'More than ${datedRules.extendedDailyMinutes / 60} hours were tracked across employers on this calendar day.',
            day,
            sourceUrl,
          ),
        );
      } else if (worked > datedRules.standardDailyMinutes) {
        issues.add(
          _issue(
            ComplianceSeverity.warning,
            'standard_daily_hours',
            'Extended working day',
            'More than ${datedRules.standardDailyMinutes / 60} hours were tracked. Statutory averaging provisions may apply.',
            day,
            sourceUrl,
          ),
        );
      }
      final requiredBreak = worked > datedRules.breakNineHourTriggerMinutes
          ? datedRules.breakAboveNineMinutes
          : worked > datedRules.breakSixHourTriggerMinutes
          ? datedRules.breakAfterSixMinutes
          : 0;
      if (breaks < requiredBreak) {
        issues.add(
          _issue(
            ComplianceSeverity.warning,
            'minimum_break',
            'Tracked break is below the reference',
            'At least $requiredBreak minutes are expected for the tracked duration.',
            day,
            sourceUrl,
          ),
        );
      }
    }
    var latestEnd = complete.firstOrNull?.endTimeUtc;
    for (var i = 1; i < complete.length; i++) {
      final local = tz.TZDateTime.from(complete[i].startTimeUtc, location);
      final datedRules = ruleResolver == null ? rules : ruleResolver(local);
      final rest = complete[i].startTimeUtc.difference(latestEnd!);
      if (complete[i].endTimeUtc!.isAfter(latestEnd)) {
        latestEnd = complete[i].endTimeUtc;
      }
      if (datedRules == null) continue;
      if (rest.inMinutes < datedRules.minimumRestMinutes) {
        issues.add(
          _issue(
            ComplianceSeverity.warning,
            'minimum_daily_rest',
            rest.isNegative
                ? 'Overlapping work records'
                : 'Rest period below the base reference',
            rest.isNegative
                ? 'These records overlap. Review their timestamps before relying on totals.'
                : '${rest.inHours}h ${rest.inMinutes.remainder(60)}m were tracked between shifts.',
            DateTime(local.year, local.month, local.day),
            sourceUrl,
          ),
        );
      }
    }
    return issues;
  }

  ComplianceIssue _issue(
    ComplianceSeverity severity,
    String ruleId,
    String title,
    String description,
    DateTime date,
    String source,
  ) => ComplianceIssue(
    severity: severity,
    ruleId: ruleId,
    title: title,
    description: description,
    affectedDate: date,
    source: source,
    recommendation: 'Threshold exceeded — review may be required.',
  );
}
