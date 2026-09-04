import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/domain/calculators/income_tax_calculator.dart';
import 'package:werktrack_de/core/utils/formatters.dart';

import 'calculator_test_support.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);
  test('decimal input parses exactly and rejects unsupported precision', () {
    expect(parseEuroCents('13,90'), 1390);
    expect(parseEuroCents('0.29'), 29);
    expect(parseEuroCents('100.1'), 10010);
    expect(parseEuroCents('1.005'), isNull);
    expect(parseEuroCents('-3'), isNull);
    expect(parseEuroCents('NaN'), isNull);
  });
  test('2026 basic allowance and tariff boundary are applied', () {
    const calculator = IncomeTaxCalculator2026();
    expect(calculator.calculate(1234800).taxEuros, 0);
    expect(calculator.calculate(1779900).taxEuros, greaterThan(0));
    expect(calculator.calculate(30000000).taxEuros, greaterThan(0));
  });

  test(
    'gross pay rounds from minute-based cents and preserves rate snapshot',
    () {
      final berlin = tz.getLocation('Europe/Berlin');
      final oneMinute = shift(
        start: tz.TZDateTime(berlin, 2026, 1, 1, 9),
        elapsed: const Duration(minutes: 1),
        rate: 1390,
      );
      expect(oneMinute.grossCents, 23);
      final historic = shift(
        start: tz.TZDateTime(berlin, 2026, 1, 1, 9),
        elapsed: const Duration(hours: 2),
        rate: 1200,
      );
      final changedEmployer = employer(rate: 2000);
      expect(historic.grossCents, 2400);
      expect(changedEmployer.hourlyRateCents, 2000);
    },
  );

  test('leap-year elapsed duration remains exact', () {
    final berlin = tz.getLocation('Europe/Berlin');
    final overnight = shift(
      start: tz.TZDateTime(berlin, 2028, 2, 29, 22),
      elapsed: const Duration(hours: 8),
    );
    expect(overnight.workingDuration, const Duration(hours: 8));
    expect(
      overnight.endTimeUtc!.toLocal().isAfter(overnight.startTimeUtc.toLocal()),
      isTrue,
    );
  });
}
