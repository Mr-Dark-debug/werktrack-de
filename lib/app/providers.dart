import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../database/app_database.dart' show AppDatabase;
import '../database/drift_work_repository.dart';
import '../domain/calculators/minijob_calculator.dart';
import '../domain/calculators/calendar_segments.dart';
import '../domain/calculators/payslip_net_forecaster.dart';
import '../domain/calculators/residence_work_day_calculator.dart';
import '../domain/calculators/student_weekly_hours_calculator.dart';
import '../domain/calculators/working_time_compliance_calculator.dart';
import '../domain/entities/academic_period.dart';
import '../domain/entities/employer.dart';
import '../domain/entities/legal_rule.dart';
import '../domain/entities/payslip.dart';
import '../domain/entities/work_entry.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/work_repository.dart';
import '../domain/rules/resolved_rules.dart';
import '../domain/rules/legal_rule_book.dart';
import '../features/notifications/local_notification_service.dart';
import '../features/notifications/notification_coordinator.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final workRepositoryProvider = Provider<WorkRepository>(
  (ref) => DriftWorkRepository(ref.watch(databaseProvider)),
);

final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(),
);

final notificationCoordinatorProvider = Provider<NotificationCoordinator>(
  (ref) => NotificationCoordinator(
    repository: ref.watch(workRepositoryProvider),
    service: ref.watch(localNotificationServiceProvider),
  ),
);

final employersProvider = StreamProvider<List<Employer>>(
  (ref) => ref.watch(workRepositoryProvider).watchEmployers(),
);
final entriesProvider = StreamProvider<List<WorkEntry>>(
  (ref) => ref.watch(workRepositoryProvider).watchEntries(),
);
final academicPeriodsProvider = StreamProvider<List<AcademicPeriod>>(
  (ref) => ref.watch(workRepositoryProvider).watchAcademicPeriods(),
);
final payslipsProvider = StreamProvider<List<Payslip>>(
  (ref) => ref.watch(workRepositoryProvider).watchPayslips(),
);
final legalRulesProvider = StreamProvider<List<LegalRule>>(
  (ref) => ref.watch(workRepositoryProvider).watchLegalRules(),
);
final onboardingProvider = StreamProvider<bool>(
  (ref) => ref.watch(workRepositoryProvider).watchOnboardingComplete(),
);
final userProfileProvider = StreamProvider<UserProfile?>(
  (ref) => ref.watch(workRepositoryProvider).watchProfile(),
);

final berlinLocationProvider = Provider<tz.Location>(
  (ref) => tz.getLocation('Europe/Berlin'),
);

final resolvedRulesProvider = Provider<AsyncValue<ResolvedRules>>((ref) {
  return ref.watch(legalRulesProvider).whenData((rules) {
    final result = LegalRuleBook(
      rules,
    ).forDate(tz.TZDateTime.now(ref.watch(berlinLocationProvider)));
    if (result == null) {
      throw StateError('No complete rule version applies to today.');
    }
    return result;
  });
});

final legalRuleBookProvider = Provider<LegalRuleBook>(
  (ref) => LegalRuleBook(ref.watch(legalRulesProvider).value ?? const []),
);

class DashboardData {
  const DashboardData({
    required this.monthMinutes,
    required this.monthGrossCents,
    required this.projectedMonthCents,
    required this.estimatedNetCents,
    required this.weekMinutes,
    required this.weekReferenceMinutes,
    required this.residence,
    required this.residenceAllowanceFullDays,
    required this.minijob,
    required this.issueCount,
  });
  final int monthMinutes;
  final int monthGrossCents;
  final int projectedMonthCents;
  final int? estimatedNetCents;
  final int weekMinutes;
  final int weekReferenceMinutes;
  final ResidenceWorkDayResult residence;
  final int residenceAllowanceFullDays;
  final MinijobResult minijob;
  final int issueCount;
}

final dashboardProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final entries = ref.watch(entriesProvider);
  final employers = ref.watch(employersProvider);
  final payslips = ref.watch(payslipsProvider);
  final rules = ref.watch(resolvedRulesProvider);
  if (entries.isLoading ||
      employers.isLoading ||
      payslips.isLoading ||
      rules.isLoading) {
    return const AsyncLoading();
  }
  if (entries.hasError) {
    return AsyncError(entries.error!, entries.stackTrace!);
  }
  if (employers.hasError) {
    return AsyncError(employers.error!, employers.stackTrace!);
  }
  if (payslips.hasError) {
    return AsyncError(payslips.error!, payslips.stackTrace!);
  }
  if (rules.hasError) {
    return AsyncError(rules.error!, rules.stackTrace!);
  }
  final location = ref.watch(berlinLocationProvider);
  final ruleBook = ref.watch(legalRuleBookProvider);
  final now = tz.TZDateTime.now(location);
  final allEntries = entries.value!;
  final allEmployers = employers.value!;
  final resolved = rules.value!;
  final actualPayslips = payslips.value!;
  final employerMap = {for (final e in allEmployers) e.id: e};
  final completedThisMonth = allEntries.where((e) {
    final localStart = tz.TZDateTime.from(e.startTimeUtc, location);
    return e.status == WorkEntryStatus.completed &&
        localStart.year == now.year &&
        localStart.month == now.month;
  });
  final monthMinutes = allEntries
      .where((e) => e.status == WorkEntryStatus.completed)
      .fold<int>(
        0,
        (sum, e) =>
            sum +
            workingMinutesByLocalDay(e, location).entries
                .where(
                  (segment) =>
                      segment.key.year == now.year &&
                      segment.key.month == now.month,
                )
                .fold<int>(0, (total, segment) => total + segment.value),
      );
  final gross = completedThisMonth.fold(0, (sum, e) => sum + e.grossCents);
  final grossByEmployer = <String, int>{};
  for (final entry in completedThisMonth) {
    grossByEmployer.update(
      entry.employerId,
      (value) => value + entry.grossCents,
      ifAbsent: () => entry.grossCents,
    );
  }
  final estimatedNet = const PayslipNetForecaster().estimate(
    grossByEmployer: grossByEmployer,
    payslips: actualPayslips,
    month: now,
  );
  final daysElapsed = now.day.clamp(1, 31);
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final weekly = const StudentWeeklyHoursCalculator().calculate(
    entries: allEntries,
    employers: employerMap,
    rules: resolved,
    location: location,
    ruleResolver: ruleBook.forDate,
  );
  final weekKey = IsoWeekKey.fromDate(now);
  final residence = const ResidenceWorkDayCalculator().calculate(
    entries: allEntries,
    employers: employerMap,
    rules: resolved,
    location: location,
    year: now.year,
    ruleResolver: ruleBook.forDate,
  );
  final minijob = const MinijobCalculator().calculate(
    entries: allEntries,
    employers: allEmployers,
    month: now,
    rules: resolved,
    location: location,
  );
  final issues = const WorkingTimeComplianceCalculator().calculate(
    entries: allEntries,
    rules: resolved,
    location: location,
    sourceUrl: 'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
    ruleResolver: ruleBook.forDate,
  );
  return AsyncData(
    DashboardData(
      monthMinutes: monthMinutes,
      monthGrossCents: gross,
      projectedMonthCents: (gross / daysElapsed * daysInMonth).round(),
      estimatedNetCents: estimatedNet,
      weekMinutes: weekly.minutesByWeek[weekKey] ?? 0,
      weekReferenceMinutes: resolved.studentWeeklyMinutes,
      residence: residence,
      residenceAllowanceFullDays: resolved.residenceFullDays,
      minijob: minijob,
      issueCount: issues.length,
    ),
  );
});

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    ref.read(workRepositoryProvider).readSetting('appearance.theme').then((
      value,
    ) {
      if (ref.mounted && value != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.name == value,
          orElse: () => ThemeMode.system,
        );
      }
    });
    return ThemeMode.system;
  }

  void setMode(ThemeMode mode) {
    state = mode;
    ref
        .read(workRepositoryProvider)
        .writeSetting('appearance.theme', mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
