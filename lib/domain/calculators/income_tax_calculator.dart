import 'dart:math' as math;

class IncomeTaxResult {
  const IncomeTaxResult({
    required this.taxableIncomeEuros,
    required this.taxEuros,
  });
  final int taxableIncomeEuros;
  final int taxEuros;
}

abstract interface class IncomeTaxCalculator {
  int get taxYear;
  IncomeTaxResult calculate(int taxableIncomeCents);
}

class IncomeTaxCalculator2026 implements IncomeTaxCalculator {
  const IncomeTaxCalculator2026();

  @override
  int get taxYear => 2026;

  @override
  IncomeTaxResult calculate(int taxableIncomeCents) {
    final x = math.max(0, taxableIncomeCents ~/ 100);
    int tax;
    if (x <= 12348) {
      tax = 0;
    } else if (x <= 17799) {
      final delta = x - 12348;
      tax = (91451 * delta * delta + 1400000000 * delta) ~/ 10000000000;
    } else if (x <= 69878) {
      final delta = x - 17799;
      tax =
          (17310 * delta * delta + 2397000000 * delta + 10348700000000) ~/
          10000000000;
    } else if (x <= 277825) {
      tax = (42 * x - 1113563) ~/ 100;
    } else {
      tax = (45 * x - 1947038) ~/ 100;
    }
    return IncomeTaxResult(taxableIncomeEuros: x, taxEuros: math.max(0, tax));
  }
}

class NetIncomeEstimate {
  const NetIncomeEstimate({
    required this.grossCents,
    required this.estimatedNetCents,
    required this.estimatedIncomeTaxCents,
    required this.uncertainty,
  });
  final int grossCents;
  final int estimatedNetCents;
  final int estimatedIncomeTaxCents;
  final String uncertainty;
}

class NetIncomeEstimator {
  const NetIncomeEstimator(this.taxCalculator);
  final IncomeTaxCalculator taxCalculator;

  NetIncomeEstimate estimateAnnual({
    required int grossCents,
    int knownContributionCents = 0,
  }) {
    final tax = taxCalculator.calculate(grossCents);
    final net = math.max(
      0,
      grossCents - tax.taxEuros * 100 - knownContributionCents,
    );
    return NetIncomeEstimate(
      grossCents: grossCents,
      estimatedNetCents: net,
      estimatedIncomeTaxCents: tax.taxEuros * 100,
      uncertainty:
          'Estimated net: wage-tax withholding, social insurance, health insurance, pension treatment, allowances, and personal circumstances may differ.',
    );
  }
}
