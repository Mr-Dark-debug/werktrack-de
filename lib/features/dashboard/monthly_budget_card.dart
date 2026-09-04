import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/monthly_work_budget.dart';
import '../../theme/app_colors.dart';

final monthlyBudgetSettingsProvider = StreamProvider<MonthlyBudgetSettings>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.appSettings)
        ..where((t) => t.key.equals('planning.monthly.v1')))
      .watchSingleOrNull()
      .map((row) => MonthlyBudgetSettings.fromJson(row?.valueJson));
});

class MonthlyBudgetCard extends ConsumerStatefulWidget {
  const MonthlyBudgetCard({super.key});
  @override
  ConsumerState<MonthlyBudgetCard> createState() => _MonthlyBudgetCardState();
}

class _MonthlyBudgetCardState extends ConsumerState<MonthlyBudgetCard> {
  DateTime? _month;

  @override
  Widget build(BuildContext context) {
    final now = tz.TZDateTime.now(ref.watch(berlinLocationProvider));
    final month = _month ?? DateTime(now.year, now.month);
    final settings =
        ref.watch(monthlyBudgetSettingsProvider).value ??
        const MonthlyBudgetSettings();
    final budget = MonthlyWorkBudget.calculate(
      month: month,
      entries: ref.watch(entriesProvider).value ?? const [],
      periods: ref.watch(academicPeriodsProvider).value ?? const [],
      location: ref.watch(berlinLocationProvider),
      settings: settings,
    );
    final (label, color) = switch (budget.level) {
      MonthlyBudgetLevel.empty => ('Empty', const Color(0xFF426645)),
      MonthlyBudgetLevel.inProgress => ('In progress', const Color(0xFF286B67)),
      MonthlyBudgetLevel.nearlyFull => ('Nearly full', const Color(0xFF946400)),
      MonthlyBudgetLevel.full => ('Full', const Color(0xFFAF4335)),
      MonthlyBudgetLevel.over => ('Over target', const Color(0xFFAA2840)),
    };
    return Container(
      key: const Key('monthly-budget-card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sage,
        borderRadius: BorderRadius.circular(26),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.ink),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Monthly hours',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Edit monthly planning target',
                  onPressed: () => _edit(month, settings, budget),
                  icon: const Icon(Icons.tune_rounded, color: AppColors.ink),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous month',
                  onPressed: () => setState(
                    () => _month = DateTime(month.year, month.month - 1),
                  ),
                  icon: const Icon(Icons.chevron_left, color: AppColors.ink),
                ),
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(month),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  tooltip: 'Next month',
                  onPressed: () => setState(
                    () => _month = DateTime(month.year, month.month + 1),
                  ),
                  icon: const Icon(Icons.chevron_right, color: AppColors.ink),
                ),
              ],
            ),
            Text(
              '${formatDuration(Duration(minutes: budget.completedMinutes))} / ${formatDuration(Duration(minutes: budget.targetMinutes))}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Monthly planning target: $label',
              value: '${(budget.progress * 100).round()} percent',
              child: LinearProgressIndicator(
                value: budget.progress,
                minHeight: 12,
                borderRadius: BorderRadius.circular(20),
                color: color,
                backgroundColor: Colors.white60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$label · All employers',
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Personal target, not a legal monthly limit.',
              style: TextStyle(fontSize: 12),
            ),
            if (budget.plannedMinutes > 0)
              Text(
                '+ ${formatDuration(Duration(minutes: budget.plannedMinutes))} planned',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(
    DateTime month,
    MonthlyBudgetSettings settings,
    MonthlyWorkBudget budget,
  ) async {
    final repository = ref.read(workRepositoryProvider);
    final lecture = TextEditingController(
      text: (settings.lectureWeeklyMinutes / 60).toStringAsFixed(2),
    );
    final free = TextEditingController(
      text: (settings.freeWeeklyMinutes / 60).toStringAsFixed(2),
    );
    final key = MonthlyBudgetSettings.monthKey(month);
    final override = TextEditingController(
      text: settings.overrides.containsKey(key)
          ? (settings.overrides[key]! / 60).toStringAsFixed(2)
          : '',
    );
    final form = GlobalKey<FormState>();
    final result = await showModalBottomSheet<MonthlyBudgetSettings>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            MediaQuery.viewInsetsOf(sheet).bottom + 24,
          ),
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan your month',
                  style: Theme.of(sheet).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${budget.lectureDays} lecture days · ${budget.freeDays} lecture-free · ${budget.unknownDays} unconfigured',
                ),
                const SizedBox(height: 8),
                const Text(
                  'The automatic target adds each day’s weekly budget ÷ 7. Unconfigured dates use the lecture budget. These are editable planning defaults, not work permission. Weekly and residence checks remain separate.',
                ),
                const SizedBox(height: 16),
                for (final field in [
                  (lecture, 'Lecture: hours per week', false),
                  (free, 'Lecture-free: hours per week', false),
                  (override, 'This month only: hours (optional)', true),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: field.$1,
                      decoration: InputDecoration(labelText: field.$2),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        if (field.$3 && (v ?? '').trim().isEmpty) return null;
                        final n = double.tryParse(
                          (v ?? '').replaceAll(',', '.'),
                        );
                        return n == null ||
                                !n.isFinite ||
                                n < 0 ||
                                n > (field.$3 ? 744 : 168)
                            ? 'Enter valid hours'
                            : null;
                      },
                    ),
                  ),
                FilledButton(
                  onPressed: () {
                    if (!form.currentState!.validate()) return;
                    int minutes(String value) =>
                        (double.parse(value.replaceAll(',', '.')) * 60).round();
                    final overrides = Map<String, int>.of(settings.overrides)
                      ..remove(key);
                    if (override.text.trim().isNotEmpty) {
                      overrides[key] = minutes(override.text);
                    }
                    Navigator.pop(
                      sheet,
                      MonthlyBudgetSettings(
                        lectureWeeklyMinutes: minutes(lecture.text),
                        freeWeeklyMinutes: minutes(free.text),
                        overrides: overrides,
                      ),
                    );
                  },
                  child: const Text('Save planning target'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(sheet);
                    context.push('/periods');
                  },
                  child: const Text('Edit academic dates'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result != null) {
      await repository.writeSetting('planning.monthly.v1', result.toJson());
    }
    // Bottom-sheet exit animation must finish before its fields lose controllers.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    lecture.dispose();
    free.dispose();
    override.dispose();
  }
}
