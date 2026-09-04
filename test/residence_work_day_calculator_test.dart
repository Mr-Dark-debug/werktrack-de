import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/residence_work_day_calculator.dart';

import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  test('3:59 and 4:00 are half days; 4:01 is a full day', () {
    final calculator = const ResidenceWorkDayCalculator();
    var day = 1;
    for (final pair in [(239, 1), (240, 1), (241, 2)]) {
      final result = calculator.calculate(
        entries: [
          shift(
            start: tz.TZDateTime(berlin, 2026, 4, day++),
            elapsed: Duration(minutes: pair.$1),
          ),
        ],
        employers: {'employer': employer()},
        rules: rules2026,
        location: berlin,
      );
      expect(result.usedHalfDayEquivalents, pair.$2);
    }
  });

  test('same-day work aggregates before day-equivalent rounding', () {
    final entries = [
      shift(
        employerId: 'a',
        start: tz.TZDateTime(berlin, 2026, 5, 2, 8),
        elapsed: const Duration(hours: 2),
      ),
      shift(
        employerId: 'b',
        start: tz.TZDateTime(berlin, 2026, 5, 2, 13),
        elapsed: const Duration(hours: 2),
      ),
    ];
    final calculator = const ResidenceWorkDayCalculator();
    expect(
      calculator
          .calculate(
            entries: entries,
            employers: {
              'a': employer(id: 'a'),
              'b': employer(id: 'b'),
            },
            rules: rules2026,
            location: berlin,
          )
          .usedHalfDayEquivalents,
      1,
    );
    final fiveHours = [
      ...entries.take(1),
      shift(
        employerId: 'b',
        start: tz.TZDateTime(berlin, 2026, 5, 2, 13),
        elapsed: const Duration(hours: 3),
      ),
    ];
    expect(
      calculator
          .calculate(
            entries: fiveHours,
            employers: {
              'a': employer(id: 'a'),
              'b': employer(id: 'b'),
            },
            rules: rules2026,
            location: berlin,
          )
          .usedHalfDayEquivalents,
      2,
    );
  });

  test(
    'DST spring transition uses elapsed timestamps, not wall-clock subtraction',
    () {
      final entry = shift(
        start: tz.TZDateTime(berlin, 2026, 3, 29, 1, 30),
        elapsed: const Duration(hours: 2),
      );
      expect(entry.workingDuration, const Duration(hours: 2));
      final result = const ResidenceWorkDayCalculator().calculate(
        entries: [entry],
        employers: {'employer': employer()},
        rules: rules2026,
        location: berlin,
      );
      expect(result.usedFullDayEquivalents, .5);
    },
  );
}
