import 'package:timezone/timezone.dart' as tz;

import '../entities/employer.dart';
import '../entities/work_entry.dart';
import '../rules/resolved_rules.dart';
import 'calendar_segments.dart';

class ResidenceWorkDayResult {
  const ResidenceWorkDayResult({
    required this.usedHalfDayEquivalents,
    required this.allowanceHalfDayEquivalents,
    required this.byDate,
    this.unresolvedDates = const {},
  });

  final int usedHalfDayEquivalents;
  final int allowanceHalfDayEquivalents;
  final Map<DateTime, int> byDate;
  final Set<DateTime> unresolvedDates;
  double get usedFullDayEquivalents => usedHalfDayEquivalents / 2;
  double get remainingFullDayEquivalents =>
      (allowanceHalfDayEquivalents - usedHalfDayEquivalents).clamp(
        0,
        allowanceHalfDayEquivalents,
      ) /
      2;
  int get remainingHalfDayEquivalents =>
      (allowanceHalfDayEquivalents - usedHalfDayEquivalents).clamp(
        0,
        allowanceHalfDayEquivalents,
      );
}

class ResidenceWorkDayCalculator {
  const ResidenceWorkDayCalculator();

  ResidenceWorkDayResult calculate({
    required Iterable<WorkEntry> entries,
    required Map<String, Employer> employers,
    required ResolvedRules rules,
    required tz.Location location,
    int? year,
    ResolvedRules? Function(DateTime)? ruleResolver,
  }) {
    final minutes = <DateTime, int>{};
    for (final entry in entries) {
      final employer = employers[entry.employerId];
      if (employer == null ||
          !employer.countsForResidenceLimit ||
          entry.status != WorkEntryStatus.completed) {
        continue;
      }
      for (final segment in workingMinutesByLocalDay(entry, location).entries) {
        if (year != null && segment.key.year != year) continue;
        minutes.update(
          segment.key,
          (value) => value + segment.value,
          ifAbsent: () => segment.value,
        );
      }
    }
    final byDate = <DateTime, int>{};
    final unresolved = <DateTime>{};
    var used = 0;
    for (final item in minutes.entries) {
      final datedRules = ruleResolver == null ? rules : ruleResolver(item.key);
      if (datedRules == null) {
        unresolved.add(item.key);
        continue;
      }
      final units = item.value <= 0
          ? 0
          : item.value <= datedRules.halfDayMaxMinutes
          ? 1
          : 2;
      byDate[item.key] = units;
      used += units;
    }
    return ResidenceWorkDayResult(
      usedHalfDayEquivalents: used,
      allowanceHalfDayEquivalents: rules.residenceFullDays * 2,
      byDate: byDate,
      unresolvedDates: unresolved,
    );
  }
}
