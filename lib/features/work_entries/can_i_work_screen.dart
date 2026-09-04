import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/minijob_calculator.dart';
import '../../domain/calculators/residence_work_day_calculator.dart';
import '../../domain/calculators/student_weekly_hours_calculator.dart';
import '../../domain/calculators/working_time_compliance_calculator.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';

class CanIWorkScreen extends ConsumerStatefulWidget {
  const CanIWorkScreen({super.key});
  @override
  ConsumerState<CanIWorkScreen> createState() => _CanIWorkScreenState();
}

class _CanIWorkScreenState extends ConsumerState<CanIWorkScreen> {
  String? _employerId;
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 21, minute: 0);
  final _breaks = TextEditingController(text: '0');
  WorkEntry? _candidate;
  _Preview? _preview;

  @override
  void dispose() {
    _breaks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employers = ref.watch(employersProvider).value ?? const <Employer>[];
    _employerId ??= employers.firstOrNull?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Can I Work?')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Text(
            'Test a shift,\nwithout saving it.',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 46),
          ),
          const SizedBox(height: 10),
          const Text('This is a threshold tracking aid, not legal permission.'),
          const SizedBox(height: 24),
          if (employers.isEmpty)
            const Text('Add an employer before running a simulation.')
          else ...[
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _employerId,
              decoration: const InputDecoration(labelText: 'Employer'),
              items: employers
                  .map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _employerId = value;
                _preview = null;
                _candidate = null;
              }),
            ),
            const SizedBox(height: 12),
            ListTile(
              onTap: _pickDate,
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              leading: const Icon(Icons.calendar_today_rounded),
              title: const Text('Date'),
              trailing: Text(
                MaterialLocalizations.of(context).formatMediumDate(_date),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TimeButton(
                    label: 'Start',
                    time: _start,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeButton(
                    label: 'End',
                    time: _end,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _breaks,
              onChanged: (_) => setState(() {
                _preview = null;
                _candidate = null;
              }),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Break',
                suffixText: 'minutes',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _simulate,
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('Simulate shift'),
            ),
          ],
          if (_preview != null) ...[
            const SizedBox(height: 26),
            _PreviewCard(preview: _preview!),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _save(WorkEntryStatus.planned),
                    child: const Text('Add planned'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _save(WorkEntryStatus.completed),
                    child: const Text('Add completed'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: _date,
    );
    if (value != null) {
      setState(() {
        _date = value;
        _preview = null;
        _candidate = null;
      });
    }
  }

  Future<void> _pickTime(bool start) async {
    final value = await showTimePicker(
      context: context,
      initialTime: start ? _start : _end,
    );
    if (value != null) {
      setState(() {
        start ? _start = value : _end = value;
        _preview = null;
        _candidate = null;
      });
    }
  }

  void _simulate() {
    final employerList =
        ref.read(employersProvider).value ?? const <Employer>[];
    final employers = {for (final item in employerList) item.id: item};
    final employer = employers[_employerId];
    final ruleBook = ref.read(legalRuleBookProvider);
    final rules = ruleBook.forDate(_date);
    if (employer == null) return;
    if (rules == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No complete verified rule version applies to this date. You can still record work; regulatory assessment is unavailable.',
          ),
        ),
      );
      return;
    }
    final location = ref.read(berlinLocationProvider);
    final startLocal = tz.TZDateTime(
      location,
      _date.year,
      _date.month,
      _date.day,
      _start.hour,
      _start.minute,
    );
    var endLocal = tz.TZDateTime(
      location,
      _date.year,
      _date.month,
      _date.day,
      _end.hour,
      _end.minute,
    );
    if (!endLocal.isAfter(startLocal)) {
      endLocal = tz.TZDateTime(
        location,
        _date.year,
        _date.month,
        _date.day + 1,
        _end.hour,
        _end.minute,
      );
    }
    final breakMinutes = int.tryParse(_breaks.text);
    if (breakMinutes == null ||
        breakMinutes < 0 ||
        breakMinutes >= endLocal.difference(startLocal).inMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter whole break minutes shorter than the shift.'),
        ),
      );
      return;
    }
    final now = DateTime.now().toUtc();
    final candidate = WorkEntry(
      id: const Uuid().v4(),
      employerId: employer.id,
      startTimeUtc: startLocal.toUtc(),
      endTimeUtc: endLocal.toUtc(),
      timezone: 'Europe/Berlin',
      breakMinutes: breakMinutes,
      paidBreakMinutes: 0,
      hourlyRateSnapshotCents: employer.hourlyRateCents,
      bonusCents: 0,
      tipsCents: 0,
      notes: '',
      status: WorkEntryStatus.completed,
      createdAt: now,
      updatedAt: now,
    );
    final existing = (ref.read(entriesProvider).value ?? const <WorkEntry>[])
        .map(
          (entry) => entry.status == WorkEntryStatus.planned
              ? entry.copyWith(status: WorkEntryStatus.completed)
              : entry,
        )
        .toList();
    final beforeResidence = const ResidenceWorkDayCalculator().calculate(
      entries: existing,
      employers: employers,
      rules: rules,
      location: location,
      year: _date.year,
      ruleResolver: ruleBook.forDate,
    );
    final simulated = [...existing, candidate];
    final residence = const ResidenceWorkDayCalculator().calculate(
      entries: simulated,
      employers: employers,
      rules: rules,
      location: location,
      year: _date.year,
      ruleResolver: ruleBook.forDate,
    );
    final weekly = const StudentWeeklyHoursCalculator().calculate(
      entries: simulated,
      employers: employers,
      rules: rules,
      location: location,
      ruleResolver: ruleBook.forDate,
    );
    final minijob = const MinijobCalculator().calculate(
      entries: simulated,
      employers: employerList,
      month: _date,
      rules: rules,
      location: location,
    );
    final issues = const WorkingTimeComplianceCalculator().calculate(
      entries: simulated,
      rules: rules,
      location: location,
      sourceUrl: 'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
      ruleResolver: ruleBook.forDate,
    );
    final key = IsoWeekKey.fromDate(_date);
    setState(() {
      _candidate = candidate;
      _preview = _Preview(
        duration: candidate.workingDuration,
        grossCents: candidate.grossCents,
        weeklyMinutes: weekly.minutesByWeek[key] ?? 0,
        weeklyReferenceMinutes: rules.studentWeeklyMinutes,
        residenceImpact:
            residence.usedFullDayEquivalents -
            beforeResidence.usedFullDayEquivalents,
        residenceRemaining: residence.remainingFullDayEquivalents,
        minijobMonthCents: minijob.monthlyEarningsCents,
        minijobReferenceCents: minijob.monthlyReferenceCents,
        issueCount: issues
            .where(
              (issue) =>
                  issue.affectedDate.year == _date.year &&
                  issue.affectedDate.month == _date.month &&
                  issue.affectedDate.day == _date.day,
            )
            .length,
      );
    });
  }

  Future<void> _save(WorkEntryStatus status) async {
    final candidate = _candidate;
    if (candidate == null) return;
    await ref
        .read(workRepositoryProvider)
        .saveEntry(
          candidate.copyWith(status: status, updatedAt: DateTime.now().toUtc()),
        );
    if (mounted) Navigator.pop(context);
  }
}

class _Preview {
  const _Preview({
    required this.duration,
    required this.grossCents,
    required this.weeklyMinutes,
    required this.weeklyReferenceMinutes,
    required this.residenceImpact,
    required this.residenceRemaining,
    required this.minijobMonthCents,
    required this.minijobReferenceCents,
    required this.issueCount,
  });
  final Duration duration;
  final int grossCents;
  final int weeklyMinutes;
  final int weeklyReferenceMinutes;
  final double residenceImpact;
  final double residenceRemaining;
  final int minijobMonthCents;
  final int minijobReferenceCents;
  final int issueCount;
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.preview});
  final _Preview preview;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.pink,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SIMULATION',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Result(
                label: 'Duration',
                value: formatDuration(preview.duration),
              ),
            ),
            Expanded(
              child: _Result(
                label: 'Gross',
                value: formatMoney(preview.grossCents),
              ),
            ),
          ],
        ),
        const Divider(height: 28, color: Color(0x40171714)),
        _Result(
          label: 'New weekly hours',
          value:
              '${(preview.weeklyMinutes / 60).toStringAsFixed(1)} / ${(preview.weeklyReferenceMinutes / 60).toStringAsFixed(1)}h',
        ),
        _Result(
          label: 'Residence-day impact',
          value:
              '+${preview.residenceImpact.toStringAsFixed(1)} · ${preview.residenceRemaining.toStringAsFixed(1)} full-day equivalents remain',
        ),
        _Result(
          label: 'Minijob impact',
          value:
              '${formatMoney(preview.minijobMonthCents)} / ${formatMoney(preview.minijobReferenceCents)} reference',
        ),
        _Result(
          label: 'Working-time / rest checks',
          value: preview.issueCount == 0
              ? 'No warnings from tracked inputs'
              : '${preview.issueCount} warning(s) — review may be required',
        ),
      ],
    ),
  );
}

class _Result extends StatelessWidget {
  const _Result({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.time,
    required this.onTap,
  });
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    tileColor: Theme.of(context).cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    title: Text(label),
    subtitle: Text(
      time.format(context),
      style: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}
