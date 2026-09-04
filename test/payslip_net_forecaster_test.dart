import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/domain/calculators/payslip_net_forecaster.dart';
import 'package:werktrack_de/domain/entities/payslip.dart';

void main() {
  Payslip slip(String employer, int net) => Payslip(
    id: employer,
    employerId: employer,
    month: 8,
    year: 2026,
    grossCents: 100000,
    wageTaxCents: 0,
    solidaritySurchargeCents: 0,
    churchTaxCents: 0,
    pensionCents: 0,
    healthCents: 0,
    careCents: 0,
    unemploymentCents: 0,
    otherDeductionsCents: 0,
    netCents: net,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
  test(
    'missing employer payroll evidence does not produce a misleading partial net',
    () {
      final result = const PayslipNetForecaster().estimate(
        grossByEmployer: {'a': 100000, 'b': 50000},
        payslips: [slip('a', 85000)],
        month: DateTime(2026, 9),
      );
      expect(result, isNull);
    },
  );
  test('employer-specific payroll ratios are applied using integer cents', () {
    final result = const PayslipNetForecaster().estimate(
      grossByEmployer: {'a': 100000, 'b': 50000},
      payslips: [slip('a', 85000), slip('b', 80000)],
      month: DateTime(2026, 9),
    );
    expect(result, 125000);
  });
}
