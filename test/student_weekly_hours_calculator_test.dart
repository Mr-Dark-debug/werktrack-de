import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/student_weekly_hours_calculator.dart';

import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  test('12h plus 9h across employers becomes a 21h review week', () {
    final result = const StudentWeeklyHoursCalculator().calculate(
      entries: [
        shift(
          employerId: 'a',
          start: tz.TZDateTime(berlin, 2026, 8, 31, 8),
          elapsed: const Duration(hours: 12),
        ),
        shift(
          employerId: 'b',
          start: tz.TZDateTime(berlin, 2026, 9, 2, 8),
          elapsed: const Duration(hours: 9),
        ),
      ],
      employers: {
        'a': employer(id: 'a'),
        'b': employer(id: 'b'),
      },
      rules: rules2026,
      location: berlin,
    );
    const key = IsoWeekKey(2026, 36);
    expect(result.minutesByWeek[key], 1260);
    expect(result.stateFor(key), WeeklyHourState.reviewRequired);
  });

  test('ISO week uses week-year across December and January', () {
    expect(
      IsoWeekKey.fromDate(DateTime(2025, 12, 29)),
      const IsoWeekKey(2026, 1),
    );
    expect(
      IsoWeekKey.fromDate(DateTime(2026, 1, 1)),
      const IsoWeekKey(2026, 1),
    );
  });

  test(
    'rolling tracker counts only over-reference weeks in the prior 12 months',
    () {
      final weekly = WeeklyHoursResult({
        const IsoWeekKey(2025, 10): 1300,
        const IsoWeekKey(2026, 20): 1200,
        const IsoWeekKey(2026, 30): 1300,
      }, 1200);
      final result = const WerkstudentRollingWeekTracker().calculate(
        weekly: weekly,
        asOf: DateTime(2026, 9, 3),
        configuredReference: 26,
      );
      expect(result.relevantWeeks, [const IsoWeekKey(2026, 30)]);
      expect(result.configuredReference, 26);
    },
  );
}
