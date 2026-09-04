import '../entities/payslip.dart';

/// A payroll-informed estimate, deliberately separate from statutory tax logic.
class PayslipNetForecaster {
  const PayslipNetForecaster();
  int? estimate({
    required Map<String, int> grossByEmployer,
    required Iterable<Payslip> payslips,
    required DateTime month,
  }) {
    if (grossByEmployer.isEmpty) return null;
    var total = 0;
    final target = month.year * 12 + month.month;
    for (final item in grossByEmployer.entries) {
      if (item.value == 0) continue;
      final history =
          payslips
              .where(
                (p) =>
                    p.employerId == item.key &&
                    p.grossCents > 0 &&
                    p.year * 12 + p.month <= target,
              )
              .toList()
            ..sort(
              (a, b) =>
                  (b.year * 12 + b.month).compareTo(a.year * 12 + a.month),
            );
      if (history.isEmpty) return null;
      final latest = history.first;
      total +=
          (item.value * latest.netCents + latest.grossCents ~/ 2) ~/
          latest.grossCents;
    }
    return total;
  }
}
