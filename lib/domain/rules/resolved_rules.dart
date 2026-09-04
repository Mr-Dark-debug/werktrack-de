class ResolvedRules {
  const ResolvedRules({
    required this.residenceFullDays,
    required this.halfDayMaxMinutes,
    required this.studentWeeklyMinutes,
    required this.werkstudentExceptionWeeks,
    required this.standardDailyMinutes,
    required this.extendedDailyMinutes,
    required this.breakAfterSixMinutes,
    required this.breakAboveNineMinutes,
    required this.breakSixHourTriggerMinutes,
    required this.breakNineHourTriggerMinutes,
    required this.minimumRestMinutes,
    required this.minijobMonthlyCents,
    required this.minijobAnnualCents,
    required this.minimumWageCents,
    required this.taxBasicAllowanceEuros,
  });

  final int residenceFullDays;
  final int halfDayMaxMinutes;
  final int studentWeeklyMinutes;
  final int werkstudentExceptionWeeks;
  final int standardDailyMinutes;
  final int extendedDailyMinutes;
  final int breakAfterSixMinutes;
  final int breakAboveNineMinutes;
  final int breakSixHourTriggerMinutes;
  final int breakNineHourTriggerMinutes;
  final int minimumRestMinutes;
  final int minijobMonthlyCents;
  final int minijobAnnualCents;
  final int minimumWageCents;
  final int taxBasicAllowanceEuros;
}
