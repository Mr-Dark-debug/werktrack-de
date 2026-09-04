import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/monthly_work_budget.dart';
import 'package:werktrack_de/domain/entities/academic_period.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';
import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });
  final period = AcademicPeriod(
    id: 'semester',
    semesterName: 'Mixed',
    semesterStart: DateTime(2026, 9),
    semesterEnd: DateTime(2026, 9, 30),
    lectureStart: DateTime(2026, 9),
    lectureEnd: DateTime(2026, 9, 15),
    exceptionalLectureFreeJson: '[]',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  test('mixed month weights actual academic days and totals all employers', () {
    final entries = [
      shift(
        employerId: 'a',
        start: tz.TZDateTime(berlin, 2026, 9, 1, 9),
        elapsed: const Duration(hours: 2),
      ),
      shift(
        employerId: 'b',
        start: tz.TZDateTime(berlin, 2026, 9, 1, 12),
        elapsed: const Duration(hours: 3),
      ),
      shift(
        start: tz.TZDateTime(berlin, 2026, 9, 2, 9),
        elapsed: const Duration(hours: 4),
        status: WorkEntryStatus.planned,
      ),
      shift(
        start: tz.TZDateTime(berlin, 2026, 9, 2, 14),
        elapsed: const Duration(hours: 5),
        status: WorkEntryStatus.cancelled,
      ),
    ];
    final budget = MonthlyWorkBudget.calculate(
      month: DateTime(2026, 9),
      entries: entries,
      periods: [period],
      location: berlin,
      settings: const MonthlyBudgetSettings(),
    );
    expect(budget.completedMinutes, 300);
    expect(budget.plannedMinutes, 240);
    expect(budget.lectureDays, 15);
    expect(budget.freeDays, 15);
    expect(budget.unknownDays, 0);
    expect(budget.targetMinutes, (15 * 3600 / 7).round());
  });

  test(
    'unknown dates are not treated as lecture-free and month boundaries split overnight',
    () {
      final budget = MonthlyWorkBudget.calculate(
        month: DateTime(2026, 10),
        entries: [
          shift(
            start: tz.TZDateTime(berlin, 2026, 9, 30, 23),
            elapsed: const Duration(hours: 3),
          ),
        ],
        periods: [period],
        location: berlin,
        settings: const MonthlyBudgetSettings(),
      );
      expect(budget.completedMinutes, 120);
      expect(budget.unknownDays, 31);
      expect(budget.targetMinutes, (31 * 1200 / 7).round());
    },
  );

  test(
    'empty, nearly full, full and over-target states including zero target',
    () {
      MonthlyWorkBudget value(int completed, int target) => MonthlyWorkBudget(
        completedMinutes: completed,
        plannedMinutes: 0,
        targetMinutes: target,
        lectureDays: 0,
        freeDays: 0,
        unknownDays: 0,
        isOverride: true,
      );
      expect(value(0, 0).level, MonthlyBudgetLevel.empty);
      expect(value(79, 100).level, MonthlyBudgetLevel.inProgress);
      expect(value(80, 100).level, MonthlyBudgetLevel.nearlyFull);
      expect(value(100, 100).level, MonthlyBudgetLevel.full);
      expect(value(101, 100).level, MonthlyBudgetLevel.over);
      expect(value(1, 0).progress, 1);
    },
  );

  test(
    'monthly override survives serialization and overrides weighted target',
    () {
      final settings = MonthlyBudgetSettings.fromJson(
        const MonthlyBudgetSettings(overrides: {'2026-09': 300}).toJson(),
      );
      final budget = MonthlyWorkBudget.calculate(
        month: DateTime(2026, 9),
        entries: [],
        periods: [period],
        location: berlin,
        settings: settings,
      );
      expect(budget.targetMinutes, 300);
      expect(budget.isOverride, true);
    },
  );
}
