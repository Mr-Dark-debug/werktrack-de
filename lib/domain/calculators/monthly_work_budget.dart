import 'dart:convert';

import 'package:timezone/timezone.dart' as tz;

import '../entities/academic_period.dart';
import '../entities/work_entry.dart';
import 'academic_context_calculator.dart';
import 'calendar_segments.dart';

/// A personal planning budget, never a monthly legal-hours allowance.
class MonthlyBudgetSettings {
  const MonthlyBudgetSettings({
    this.lectureWeeklyMinutes = 1200,
    this.freeWeeklyMinutes = 2400,
    this.overrides = const {},
  });
  final int lectureWeeklyMinutes;
  final int freeWeeklyMinutes;
  final Map<String, int> overrides;

  static String monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  factory MonthlyBudgetSettings.fromJson(String? raw) {
    if (raw == null) return const MonthlyBudgetSettings();
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      int minutes(Object? v) {
        if (v is! int || v < 0 || v > 44640) throw const FormatException();
        return v;
      }

      return MonthlyBudgetSettings(
        lectureWeeklyMinutes: minutes(data['lecture']),
        freeWeeklyMinutes: minutes(data['free']),
        overrides: (data['overrides'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, minutes(v)),
        ),
      );
    } catch (_) {
      return const MonthlyBudgetSettings();
    }
  }

  String toJson() => jsonEncode({
    'lecture': lectureWeeklyMinutes,
    'free': freeWeeklyMinutes,
    'overrides': overrides,
  });
}

enum MonthlyBudgetLevel { empty, inProgress, nearlyFull, full, over }

class MonthlyWorkBudget {
  const MonthlyWorkBudget({
    required this.completedMinutes,
    required this.plannedMinutes,
    required this.targetMinutes,
    required this.lectureDays,
    required this.freeDays,
    required this.unknownDays,
    required this.isOverride,
  });
  final int completedMinutes, plannedMinutes, targetMinutes;
  final int lectureDays, freeDays, unknownDays;
  final bool isOverride;

  double get progress => targetMinutes == 0
      ? (completedMinutes == 0 ? 0 : 1)
      : (completedMinutes / targetMinutes).clamp(0, 1);

  MonthlyBudgetLevel get level {
    if (completedMinutes == 0) return MonthlyBudgetLevel.empty;
    if (completedMinutes > targetMinutes) return MonthlyBudgetLevel.over;
    if (completedMinutes == targetMinutes) return MonthlyBudgetLevel.full;
    if (progress >= .8) return MonthlyBudgetLevel.nearlyFull;
    return MonthlyBudgetLevel.inProgress;
  }

  static MonthlyWorkBudget calculate({
    required DateTime month,
    required Iterable<WorkEntry> entries,
    required List<AcademicPeriod> periods,
    required tz.Location location,
    required MonthlyBudgetSettings settings,
  }) {
    var completed = 0, planned = 0, lecture = 0, free = 0, unknown = 0;
    for (final entry in entries) {
      if (entry.status != WorkEntryStatus.completed &&
          entry.status != WorkEntryStatus.planned) {
        continue;
      }
      for (final segment in workingMinutesByLocalDay(entry, location).entries) {
        if (segment.key.year != month.year ||
            segment.key.month != month.month) {
          continue;
        }
        if (entry.status == WorkEntryStatus.completed) {
          completed += segment.value;
        } else {
          planned += segment.value;
        }
      }
    }
    final days = DateTime(month.year, month.month + 1, 0).day;
    for (var day = 1; day <= days; day++) {
      switch (const AcademicContextCalculator().contextFor(
        DateTime(month.year, month.month, day),
        periods,
      )) {
        case AcademicContext.lecturePeriod:
          lecture++;
        case AcademicContext.lectureFree:
          free++;
        case AcademicContext.outsideConfiguredSemester:
          unknown++;
      }
    }
    final override = settings.overrides[MonthlyBudgetSettings.monthKey(month)];
    return MonthlyWorkBudget(
      completedMinutes: completed,
      plannedMinutes: planned,
      targetMinutes:
          override ??
          (((lecture + unknown) * settings.lectureWeeklyMinutes +
                      free * settings.freeWeeklyMinutes) /
                  7)
              .round(),
      lectureDays: lecture,
      freeDays: free,
      unknownDays: unknown,
      isOverride: override != null,
    );
  }
}
