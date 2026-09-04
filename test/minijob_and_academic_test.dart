import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/academic_context_calculator.dart';
import 'package:werktrack_de/domain/calculators/minijob_calculator.dart';
import 'package:werktrack_de/domain/entities/academic_period.dart';
import 'package:werktrack_de/domain/entities/employer.dart';

import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  test(
    'multiple Minijobs combine and main employment produces advisory state',
    () {
      final a = employer(id: 'a', type: EmploymentType.minijob, rate: 1000);
      final b = employer(id: 'b', type: EmploymentType.minijob, rate: 1000);
      final mainJob = employer(
        id: 'main',
        type: EmploymentType.partTime,
        liable: true,
      );
      final entries = [
        shift(
          employerId: 'a',
          start: tz.TZDateTime(berlin, 2026, 9, 1, 9),
          elapsed: const Duration(hours: 30),
          rate: 1000,
        ),
        shift(
          employerId: 'b',
          start: tz.TZDateTime(berlin, 2026, 9, 5, 9),
          elapsed: const Duration(hours: 20),
          rate: 1000,
        ),
      ];
      const calculator = MinijobCalculator();
      final combined = calculator.calculate(
        entries: entries,
        employers: [a, b],
        month: DateTime(2026, 9),
        rules: rules2026,
        location: berlin,
      );
      expect(combined.monthlyEarningsCents, 50000);
      expect(combined.warningState, MinijobWarningState.normal);
      final withMain = calculator.calculate(
        entries: entries,
        employers: [a, b, mainJob],
        month: DateTime(2026, 9),
        rules: rules2026,
        location: berlin,
      );
      expect(withMain.warningState, MinijobWarningState.multipleWithMainJob);
    },
  );

  test('Minijob month and year follow Berlin, not UTC', () {
    final job = employer(type: EmploymentType.minijob, rate: 1500);
    final entry = shift(
      start: tz.TZDateTime(berlin, 2026, 1, 1, 0, 30),
      elapsed: const Duration(hours: 1),
      rate: 1500,
    );
    final result = const MinijobCalculator().calculate(
      entries: [entry],
      employers: [job],
      month: DateTime(2026, 1),
      rules: rules2026,
      location: berlin,
    );
    expect(entry.startTimeUtc.year, 2025);
    expect(result.monthlyEarningsCents, 1500);
    expect(result.annualEarningsCents, 1500);
  });

  test(
    'semester boundaries and exceptional lecture-free intervals classify dates',
    () {
      final period = AcademicPeriod(
        id: 'winter',
        semesterName: 'Winter',
        semesterStart: DateTime(2026, 10, 1),
        semesterEnd: DateTime(2027, 3, 31),
        lectureStart: DateTime(2026, 10, 12),
        lectureEnd: DateTime(2027, 2, 13),
        exceptionalLectureFreeJson:
            '[{"start":"2026-12-24","end":"2027-01-06"}]',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );
      const calculator = AcademicContextCalculator();
      expect(
        calculator.contextFor(DateTime(2026, 10, 12), [period]),
        AcademicContext.lecturePeriod,
      );
      expect(
        calculator.contextFor(DateTime(2026, 12, 24), [period]),
        AcademicContext.lectureFree,
      );
      expect(
        calculator.contextFor(DateTime(2027, 4, 1), [period]),
        AcademicContext.outsideConfiguredSemester,
      );
    },
  );
}
