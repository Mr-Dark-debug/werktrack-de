import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:werktrack_de/domain/entities/employer.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';
import 'package:werktrack_de/domain/rules/resolved_rules.dart';

const rules2026 = ResolvedRules(
  residenceFullDays: 140,
  halfDayMaxMinutes: 240,
  studentWeeklyMinutes: 1200,
  werkstudentExceptionWeeks: 26,
  standardDailyMinutes: 480,
  extendedDailyMinutes: 600,
  breakAfterSixMinutes: 30,
  breakAboveNineMinutes: 45,
  breakSixHourTriggerMinutes: 360,
  breakNineHourTriggerMinutes: 540,
  minimumRestMinutes: 660,
  minijobMonthlyCents: 60300,
  minijobAnnualCents: 723600,
  minimumWageCents: 1390,
  taxBasicAllowanceEuros: 12348,
);

Employer employer({
  String id = 'employer',
  EmploymentType type = EmploymentType.werkstudent,
  bool residence = true,
  bool weekly = true,
  bool liable = false,
  int rate = 1390,
}) {
  final now = DateTime.utc(2026);
  return Employer(
    id: id,
    name: id,
    jobTitle: 'Student worker',
    employmentType: type,
    hourlyRateCents: rate,
    startDate: now,
    isActive: true,
    countsForResidenceLimit: residence,
    countsForStudentHourRule: weekly,
    isSocialInsuranceLiable: liable,
    pensionExempt: false,
    taxClass: 1,
    notes: '',
    createdAt: now,
    updatedAt: now,
  );
}

WorkEntry shift({
  String? id,
  String employerId = 'employer',
  required tz.TZDateTime start,
  required Duration elapsed,
  int breakMinutes = 0,
  int rate = 1390,
  WorkEntryStatus status = WorkEntryStatus.completed,
}) {
  final now = DateTime.utc(2026);
  return WorkEntry(
    id: id ?? const Uuid().v4(),
    employerId: employerId,
    startTimeUtc: start.toUtc(),
    endTimeUtc: start.add(elapsed).toUtc(),
    timezone: 'Europe/Berlin',
    breakMinutes: breakMinutes,
    paidBreakMinutes: 0,
    hourlyRateSnapshotCents: rate,
    bonusCents: 0,
    tipsCents: 0,
    notes: '',
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}
