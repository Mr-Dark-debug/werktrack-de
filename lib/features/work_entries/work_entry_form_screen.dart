import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';

class WorkEntryFormScreen extends ConsumerStatefulWidget {
  const WorkEntryFormScreen({required this.planned, this.existing, super.key});
  final bool planned;
  final WorkEntry? existing;
  @override
  ConsumerState<WorkEntryFormScreen> createState() =>
      _WorkEntryFormScreenState();
}

class _WorkEntryFormScreenState extends ConsumerState<WorkEntryFormScreen> {
  String? _employerId;
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 17, minute: 0);
  final _breaks = TextEditingController(text: '30');
  final _bonus = TextEditingController(text: '0');
  final _tips = TextEditingController(text: '0');
  final _paidBreaks = TextEditingController(text: '0');
  final _snapshot = TextEditingController();
  final _notes = TextEditingController();
  late WorkEntryStatus _status;

  @override
  void initState() {
    super.initState();
    _status =
        widget.existing?.status ??
        (widget.planned ? WorkEntryStatus.planned : WorkEntryStatus.completed);
    final entry = widget.existing;
    if (entry != null) {
      final location = ref.read(berlinLocationProvider);
      final start = tz.TZDateTime.from(entry.startTimeUtc, location);
      final end = entry.endTimeUtc == null
          ? start
          : tz.TZDateTime.from(entry.endTimeUtc!, location);
      _employerId = entry.employerId;
      _date = DateTime(start.year, start.month, start.day);
      _start = TimeOfDay(hour: start.hour, minute: start.minute);
      _end = TimeOfDay(hour: end.hour, minute: end.minute);
      _breaks.text = entry.breakMinutes.toString();
      _bonus.text = (entry.bonusCents / 100).toStringAsFixed(2);
      _tips.text = (entry.tipsCents / 100).toStringAsFixed(2);
      _paidBreaks.text = entry.paidBreakMinutes.toString();
      _snapshot.text = (entry.hourlyRateSnapshotCents / 100).toStringAsFixed(2);
      _notes.text = entry.notes;
    }
  }

  @override
  void dispose() {
    _breaks.dispose();
    _bonus.dispose();
    _tips.dispose();
    _paidBreaks.dispose();
    _snapshot.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employers = ref.watch(employersProvider).value ?? const <Employer>[];
    _employerId ??= employers.firstOrNull?.id;
    if (_snapshot.text.isEmpty && employers.isNotEmpty) {
      _snapshot.text =
          (employers.firstWhere((e) => e.id == _employerId).hourlyRateCents /
                  100)
              .toStringAsFixed(2);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing != null
              ? 'Edit work'
              : widget.planned
              ? 'Plan shift'
              : 'Add completed work',
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: employers.isEmpty ? null : _save,
          child: Text(
            widget.existing != null
                ? 'Save changes'
                : widget.planned
                ? 'Add planned shift'
                : 'Save completed shift',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.planned ? 'Plan ahead' : 'Record the actual shift',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 22),
          if (employers.isEmpty)
            FilledButton.icon(
              onPressed: () => context.push('/employers/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add an employer first'),
            )
          else
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
                if (widget.existing == null) {
                  _snapshot.text =
                      (employers
                                  .firstWhere((e) => e.id == value)
                                  .hourlyRateCents /
                              100)
                          .toStringAsFixed(2);
                }
              }),
            ),
          const SizedBox(height: 12),
          _PickerTile(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: MaterialLocalizations.of(context).formatMediumDate(_date),
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PickerTile(
                  icon: Icons.login_rounded,
                  label: 'Start',
                  value: _start.format(context),
                  onTap: () => _pickTime(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PickerTile(
                  icon: Icons.logout_rounded,
                  label: 'End',
                  value: _end.format(context),
                  onTap: () => _pickTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _breaks,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Total break (paid + unpaid)',
              suffixText: 'minutes',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _paidBreaks,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Paid part of the break',
              suffixText: 'minutes',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _snapshot,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'This shift’s hourly-rate snapshot',
              prefixText: '€ ',
              helperText: 'Changing this affects only this shift.',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bonus,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bonus',
                    prefixText: '€ ',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _tips,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tips',
                    prefixText: '€ ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<WorkEntryStatus>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: WorkEntryStatus.values
                .where((value) => value != WorkEntryStatus.active)
                .map(
                  (value) =>
                      DropdownMenuItem(value: value, child: Text(value.name)),
                )
                .toList(),
            onChanged: (value) => setState(() => _status = value!),
          ),
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
    if (value != null) setState(() => _date = value);
  }

  Future<void> _pickTime(bool start) async {
    final value = await showTimePicker(
      context: context,
      initialTime: start ? _start : _end,
    );
    if (value != null) setState(() => start ? _start = value : _end = value);
  }

  Future<void> _save() async {
    final employer = ref
        .read(employersProvider)
        .value!
        .firstWhere((e) => e.id == _employerId);
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
    final breaks = int.tryParse(_breaks.text);
    final paidBreaks = int.tryParse(_paidBreaks.text);
    final rate = parseEuroCents(_snapshot.text);
    final bonus = parseEuroCents(_bonus.text);
    final tips = parseEuroCents(_tips.text);
    if (breaks == null ||
        rate == null ||
        bonus == null ||
        tips == null ||
        paidBreaks == null ||
        paidBreaks < 0 ||
        paidBreaks > breaks ||
        breaks < 0 ||
        breaks >= endLocal.difference(startLocal).inMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Check amounts and breaks: paid break cannot exceed total break, and total break must be shorter than the shift.',
          ),
        ),
      );
      return;
    }
    final now = DateTime.now().toUtc();
    final existing = widget.existing;
    await ref
        .read(workRepositoryProvider)
        .saveEntry(
          WorkEntry(
            id: existing?.id ?? const Uuid().v4(),
            employerId: employer.id,
            startTimeUtc: startLocal.toUtc(),
            endTimeUtc: endLocal.toUtc(),
            timezone: 'Europe/Berlin',
            breakMinutes: breaks,
            paidBreakMinutes: paidBreaks,
            hourlyRateSnapshotCents: rate,
            bonusCents: bonus,
            tipsCents: tips,
            notes: _notes.text.trim(),
            status: _status,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    if (mounted) context.pop();
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    tileColor: Theme.of(context).cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    leading: Icon(icon),
    title: Text(label),
    subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}
