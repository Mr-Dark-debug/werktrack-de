import 'package:timezone/timezone.dart' as tz;

import '../entities/employer.dart';
import '../entities/work_entry.dart';
import '../rules/resolved_rules.dart';
import 'calendar_segments.dart';

enum WeeklyHourState { normal, approaching, nearLimit, reviewRequired }

class IsoWeekKey implements Comparable<IsoWeekKey> {
  const IsoWeekKey(this.year, this.week);
  final int year;
  final int week;

  static IsoWeekKey fromDate(DateTime date) {
    final normalized = DateTime.utc(date.year, date.month, date.day);
    final thursday = normalized.add(Duration(days: 4 - normalized.weekday));
    final firstThursday = DateTime.utc(thursday.year, 1, 4);
    final firstWeekThursday = firstThursday.add(
      Duration(days: 4 - firstThursday.weekday),
    );
    final week = 1 + thursday.difference(firstWeekThursday).inDays ~/ 7;
    return IsoWeekKey(thursday.year, week);
  }

  @override
  int compareTo(IsoWeekKey other) => year == other.year
      ? week.compareTo(other.week)
      : year.compareTo(other.year);

  @override
  bool operator ==(Object other) =>
      other is IsoWeekKey && other.year == year && other.week == week;

  @override
  int get hashCode => Object.hash(year, week);

  @override
  String toString() => '$year-W${week.toString().padLeft(2, '0')}';
}

class WeeklyHoursResult {
  const WeeklyHoursResult(
    this.minutesByWeek,
    this.referenceMinutes, {
    this.referencesByWeek = const {},
    this.unresolvedWeeks = const {},
  });
  final Map<IsoWeekKey, int> minutesByWeek;
  final int referenceMinutes;
  final Map<IsoWeekKey, int> referencesByWeek;
  final Set<IsoWeekKey> unresolvedWeeks;

  WeeklyHourState stateFor(IsoWeekKey key) {
    final minutes = minutesByWeek[key] ?? 0;
    final reference = referencesByWeek[key] ?? referenceMinutes;
    if (minutes > reference) return WeeklyHourState.reviewRequired;
    if (minutes >= reference * .9) return WeeklyHourState.nearLimit;
    if (minutes >= reference * .75) return WeeklyHourState.approaching;
    return WeeklyHourState.normal;
  }

  int get numberOfRelevantWeeks =>
      minutesByWeek.values.where((m) => m > referenceMinutes).length;
}

class RollingWeekResult {
  const RollingWeekResult({
    required this.relevantWeeks,
    required this.configuredReference,
  });
  final List<IsoWeekKey> relevantWeeks;
  final int configuredReference;
  int get numberOfRelevantWeeks => relevantWeeks.length;
}

class WerkstudentRollingWeekTracker {
  const WerkstudentRollingWeekTracker();

  RollingWeekResult calculate({
    required WeeklyHoursResult weekly,
    required DateTime asOf,
    required int configuredReference,
  }) {
    final end = DateTime(asOf.year, asOf.month, asOf.day);
    final lastDay = DateTime(end.year - 1, end.month + 1, 0).day;
    final start = DateTime(
      end.year - 1,
      end.month,
      end.day > lastDay ? lastDay : end.day,
    );
    final relevant =
        weekly.minutesByWeek.entries
            .where((entry) {
              final monday = _mondayOf(entry.key);
              return !weekly.unresolvedWeeks.contains(entry.key) &&
                  entry.value >
                      (weekly.referencesByWeek[entry.key] ??
                          weekly.referenceMinutes) &&
                  !monday.add(const Duration(days: 6)).isBefore(start) &&
                  !monday.isAfter(end);
            })
            .map((entry) => entry.key)
            .toList()
          ..sort();
    return RollingWeekResult(
      relevantWeeks: relevant,
      configuredReference: configuredReference,
    );
  }

  DateTime _mondayOf(IsoWeekKey key) {
    final januaryFourth = DateTime(key.year, 1, 4);
    final firstMonday = januaryFourth.subtract(
      Duration(days: januaryFourth.weekday - 1),
    );
    return firstMonday.add(Duration(days: (key.week - 1) * 7));
  }
}

class StudentWeeklyHoursCalculator {
  const StudentWeeklyHoursCalculator();

  WeeklyHoursResult calculate({
    required Iterable<WorkEntry> entries,
    required Map<String, Employer> employers,
    required ResolvedRules rules,
    required tz.Location location,
    ResolvedRules? Function(DateTime)? ruleResolver,
  }) {
    final totals = <IsoWeekKey, int>{};
    final references = <IsoWeekKey, int>{};
    final unresolved = <IsoWeekKey>{};
    for (final entry in entries) {
      final employer = employers[entry.employerId];
      if (employer == null ||
          !employer.countsForStudentHourRule ||
          entry.status == WorkEntryStatus.cancelled ||
          entry.status == WorkEntryStatus.planned) {
        continue;
      }
      for (final segment in workingMinutesByLocalDay(entry, location).entries) {
        final key = IsoWeekKey.fromDate(segment.key);
        final datedRules = ruleResolver == null
            ? rules
            : ruleResolver(segment.key);
        if (datedRules == null) {
          unresolved.add(key);
        } else {
          references[key] = datedRules.studentWeeklyMinutes;
        }
        totals.update(
          key,
          (value) => value + segment.value,
          ifAbsent: () => segment.value,
        );
      }
    }
    return WeeklyHoursResult(
      totals,
      rules.studentWeeklyMinutes,
      referencesByWeek: references,
      unresolvedWeeks: unresolved,
    );
  }
}
