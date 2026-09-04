import '../entities/employer.dart';
import '../entities/work_entry.dart';
import '../rules/resolved_rules.dart';
import 'package:timezone/timezone.dart' as tz;

enum MinijobWarningState {
  normal,
  approaching,
  reviewRequired,
  multipleWithMainJob,
}

class MinijobResult {
  const MinijobResult({
    required this.monthlyEarningsCents,
    required this.annualEarningsCents,
    required this.projectedRegularEarningsCents,
    required this.monthlyReferenceCents,
    required this.annualReferenceCents,
    required this.warningState,
    required this.explanation,
  });
  final int monthlyEarningsCents;
  final int annualEarningsCents;
  final int projectedRegularEarningsCents;
  final int monthlyReferenceCents;
  final int annualReferenceCents;
  final MinijobWarningState warningState;
  final String explanation;
}

class MinijobCalculator {
  const MinijobCalculator();

  MinijobResult calculate({
    required Iterable<WorkEntry> entries,
    required Iterable<Employer> employers,
    required DateTime month,
    required ResolvedRules rules,
    required tz.Location location,
  }) {
    final byId = {for (final employer in employers) employer.id: employer};
    final minijobIds = byId.values
        .where((e) => e.employmentType == EmploymentType.minijob)
        .map((e) => e.id)
        .toSet();
    final completed = entries.where(
      (e) =>
          e.status == WorkEntryStatus.completed &&
          minijobIds.contains(e.employerId),
    );
    final monthly = completed
        .where((e) {
          final local = tz.TZDateTime.from(e.startTimeUtc, location);
          return local.year == month.year && local.month == month.month;
        })
        .fold(0, (sum, e) => sum + e.grossCents);
    final annual = completed
        .where(
          (e) =>
              tz.TZDateTime.from(e.startTimeUtc, location).year == month.year,
        )
        .fold(0, (sum, e) => sum + e.grossCents);
    final elapsedMonths = month.month.clamp(1, 12);
    final projected = elapsedMonths == 0
        ? 0
        : (annual / elapsedMonths * 12).round();
    final hasMain = byId.values.any(
      (e) =>
          e.isActive &&
          e.isSocialInsuranceLiable &&
          e.employmentType != EmploymentType.minijob,
    );
    late MinijobWarningState state;
    late String explanation;
    final activeMinijobs = byId.values
        .where((e) => e.isActive && e.employmentType == EmploymentType.minijob)
        .length;
    if (hasMain && activeMinijobs > 1) {
      state = MinijobWarningState.multipleWithMainJob;
      explanation =
          'A liable main employment and multiple Minijobs are configured. Usually only the first Minijob retains privileged treatment; individual assessment is required.';
    } else if (monthly > rules.minijobMonthlyCents ||
        annual > rules.minijobAnnualCents) {
      state = MinijobWarningState.reviewRequired;
      explanation =
          'The tracked earnings exceed a reference amount. A single monthly exceedance does not by itself determine Minijob status.';
    } else if (monthly >= (rules.minijobMonthlyCents * 9 ~/ 10)) {
      state = MinijobWarningState.approaching;
      explanation =
          'Tracked earnings are approaching the configured monthly reference.';
    } else {
      state = MinijobWarningState.normal;
      explanation = minijobIds.length > 1
          ? 'Combined earnings across configured Minijobs are shown.'
          : 'Tracked earnings are below the configured references.';
    }
    return MinijobResult(
      monthlyEarningsCents: monthly,
      annualEarningsCents: annual,
      projectedRegularEarningsCents: projected,
      monthlyReferenceCents: rules.minijobMonthlyCents,
      annualReferenceCents: rules.minijobAnnualCents,
      warningState: state,
      explanation: explanation,
    );
  }
}
