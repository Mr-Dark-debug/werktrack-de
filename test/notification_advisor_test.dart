import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/app/providers.dart';
import 'package:werktrack_de/domain/calculators/minijob_calculator.dart';
import 'package:werktrack_de/domain/calculators/residence_work_day_calculator.dart';
import 'package:werktrack_de/features/notifications/notification_coordinator.dart';

void main() {
  test('advisories are generated for approaching configured thresholds', () {
    const data = DashboardData(
      monthMinutes: 0,
      monthGrossCents: 0,
      projectedMonthCents: 0,
      estimatedNetCents: null,
      weekMinutes: 1100,
      weekReferenceMinutes: 1200,
      residence: ResidenceWorkDayResult(
        usedHalfDayEquivalents: 250,
        allowanceHalfDayEquivalents: 280,
        byDate: {},
      ),
      residenceAllowanceFullDays: 140,
      minijob: MinijobResult(
        monthlyEarningsCents: 59000,
        annualEarningsCents: 500000,
        projectedRegularEarningsCents: 750000,
        monthlyReferenceCents: 60300,
        annualReferenceCents: 723600,
        warningState: MinijobWarningState.approaching,
        explanation: '',
      ),
      issueCount: 0,
    );
    final keys = const NotificationAdvisor()
        .evaluate(data, const [])
        .map((e) => e.key);
    expect(
      keys,
      containsAll([
        'weekly-approaching',
        'minijob-projection',
        'residence-milestone',
      ]),
    );
  });
}
