import '../entities/legal_rule.dart';
import 'resolved_rules.dart';

/// Effective dates are calendar dates, not device-local timestamps.
class LegalRuleBook {
  const LegalRuleBook(this.rules);
  final List<LegalRule> rules;

  LegalRule? ruleFor(String key, DateTime date) {
    final day = DateTime.utc(date.year, date.month, date.day);
    final candidates =
        rules
            .where(
              (rule) =>
                  rule.key == key &&
                  !rule.effectiveFrom.isAfter(day) &&
                  (rule.effectiveTo == null ||
                      !rule.effectiveTo!.isBefore(day)),
            )
            .toList()
          ..sort((a, b) => b.effectiveFrom.compareTo(a.effectiveFrom));
    return candidates.firstOrNull;
  }

  ResolvedRules? forDate(DateTime date) {
    int value(String key) {
      final rule = ruleFor(key, date);
      if (rule == null) throw StateError('No rule for $key on $date');
      return rule.value.toInt();
    }

    try {
      return ResolvedRules(
        residenceFullDays: value('student_full_day_allowance'),
        halfDayMaxMinutes: value('half_day_max_hours'),
        studentWeeklyMinutes: value('student_weekly_reference'),
        werkstudentExceptionWeeks: value('werkstudent_exception_weeks'),
        standardDailyMinutes: value('standard_daily_hours'),
        extendedDailyMinutes: value('extended_daily_hours'),
        breakAfterSixMinutes: value('break_six_to_nine'),
        breakAboveNineMinutes: value('break_above_nine'),
        breakSixHourTriggerMinutes: value('break_six_hour_trigger'),
        breakNineHourTriggerMinutes: value('break_nine_hour_trigger'),
        minimumRestMinutes: value('minimum_daily_rest'),
        minijobMonthlyCents: value('minijob_monthly_limit'),
        minijobAnnualCents: value('minijob_annual_limit'),
        minimumWageCents: value('minimum_wage'),
        taxBasicAllowanceEuros: value('income_tax_basic_allowance'),
      );
    } on StateError {
      return null;
    }
  }
}
