import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/working_time_compliance_calculator.dart';

import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });
  const source = 'official-source';

  List<String> rulesFor(Duration worked, {int breakMinutes = 0}) {
    final entry = shift(
      start: tz.TZDateTime(berlin, 2026, 6, 1, 8),
      elapsed: worked + Duration(minutes: breakMinutes),
      breakMinutes: breakMinutes,
    );
    return const WorkingTimeComplianceCalculator()
        .calculate(
          entries: [entry],
          rules: rules2026,
          location: berlin,
          sourceUrl: source,
        )
        .map((e) => e.ruleId)
        .toList();
  }

  test('8:00 has no extended notice, 8:01 does, 10:01 is high priority', () {
    expect(
      rulesFor(const Duration(hours: 8), breakMinutes: 30),
      isNot(contains('standard_daily_hours')),
    );
    expect(
      rulesFor(const Duration(hours: 8, minutes: 1), breakMinutes: 30),
      contains('standard_daily_hours'),
    );
    expect(
      rulesFor(const Duration(hours: 10), breakMinutes: 45),
      isNot(contains('extended_daily_hours')),
    );
    expect(
      rulesFor(const Duration(hours: 10, minutes: 1), breakMinutes: 45),
      contains('extended_daily_hours'),
    );
  });

  test('break thresholds respect exact 6:00 and 9:00 boundaries', () {
    expect(
      rulesFor(const Duration(hours: 6)),
      isNot(contains('minimum_break')),
    );
    expect(
      rulesFor(const Duration(hours: 6, minutes: 1)),
      contains('minimum_break'),
    );
    expect(
      rulesFor(const Duration(hours: 9), breakMinutes: 30),
      isNot(contains('minimum_break')),
    );
    expect(
      rulesFor(const Duration(hours: 9, minutes: 1), breakMinutes: 30),
      contains('minimum_break'),
    );
  });

  test(
    'nested overlaps do not hide the latest preceding end for rest checks',
    () {
      final entries = [
        shift(
          start: tz.TZDateTime(berlin, 2026, 6, 1, 9),
          elapsed: const Duration(hours: 8),
        ),
        shift(
          start: tz.TZDateTime(berlin, 2026, 6, 1, 10),
          elapsed: const Duration(hours: 1),
        ),
        shift(
          start: tz.TZDateTime(berlin, 2026, 6, 2, 1),
          elapsed: const Duration(hours: 1),
        ),
      ];
      final issues = const WorkingTimeComplianceCalculator().calculate(
        entries: entries,
        rules: rules2026,
        location: berlin,
        sourceUrl: source,
      );
      expect(
        issues.where(
          (issue) =>
              issue.ruleId == 'minimum_daily_rest' &&
              issue.affectedDate == DateTime(2026, 6, 2),
        ),
        hasLength(1),
      );
    },
  );

  test('10:59 rest warns and 11:00 satisfies the base reference', () {
    final first = shift(
      start: tz.TZDateTime(berlin, 2026, 6, 1, 12),
      elapsed: const Duration(hours: 4),
    );
    final short = shift(
      start: tz.TZDateTime(berlin, 2026, 6, 2, 2, 59),
      elapsed: const Duration(hours: 2),
    );
    final exact = shift(
      start: tz.TZDateTime(berlin, 2026, 6, 2, 3),
      elapsed: const Duration(hours: 2),
    );
    final calculator = const WorkingTimeComplianceCalculator();
    expect(
      calculator
          .calculate(
            entries: [first, short],
            rules: rules2026,
            location: berlin,
            sourceUrl: source,
          )
          .map((e) => e.ruleId),
      contains('minimum_daily_rest'),
    );
    expect(
      calculator
          .calculate(
            entries: [first, exact],
            rules: rules2026,
            location: berlin,
            sourceUrl: source,
          )
          .map((e) => e.ruleId),
      isNot(contains('minimum_daily_rest')),
    );
  });
}
