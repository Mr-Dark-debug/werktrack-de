import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../domain/entities/academic_period.dart';

class AcademicPeriodFormScreen extends ConsumerStatefulWidget {
  const AcademicPeriodFormScreen({super.key, this.existing});
  final AcademicPeriod? existing;
  @override
  ConsumerState<AcademicPeriodFormScreen> createState() =>
      _AcademicPeriodFormScreenState();
}

class _AcademicPeriodFormScreenState
    extends ConsumerState<AcademicPeriodFormScreen> {
  final _name = TextEditingController(text: 'My semester');
  DateTime _semesterStart = DateUtils.dateOnly(DateTime.now());
  DateTime _semesterEnd = DateUtils.dateOnly(DateTime.now());
  DateTime _lectureStart = DateUtils.dateOnly(DateTime.now());
  DateTime _lectureEnd = DateUtils.dateOnly(DateTime.now());
  final List<DateTimeRange> _exceptions = [];

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    if (item == null) return;
    _name.text = item.semesterName;
    _semesterStart = item.semesterStart;
    _semesterEnd = item.semesterEnd;
    _lectureStart = item.lectureStart;
    _lectureEnd = item.lectureEnd;
    for (final interval
        in jsonDecode(item.exceptionalLectureFreeJson) as List<dynamic>) {
      _exceptions.add(
        DateTimeRange(
          start: DateTime.parse(interval['start'] as String),
          end: DateTime.parse(interval['end'] as String),
        ),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.existing == null
            ? 'New academic period'
            : 'Edit academic period',
      ),
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.all(16),
      child: FilledButton(
        onPressed: _save,
        child: const Text('Save academic period'),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Your university,\nyour dates.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'Enter your university’s published dates. Today is only a date-picker starting point, not a semester assumption.',
        ),
        const SizedBox(height: 22),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Semester name'),
        ),
        const SizedBox(height: 12),
        _DateTile(
          label: 'Semester starts',
          value: _semesterStart,
          onTap: () => _pick(0),
        ),
        _DateTile(
          label: 'Semester ends',
          value: _semesterEnd,
          onTap: () => _pick(1),
        ),
        _DateTile(
          label: 'Lectures start',
          value: _lectureStart,
          onTap: () => _pick(2),
        ),
        _DateTile(
          label: 'Lectures end',
          value: _lectureEnd,
          onTap: () => _pick(3),
        ),
        const SizedBox(height: 18),
        Text(
          'Exceptional lecture-free intervals',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ..._exceptions.map(
          (range) => ListTile(
            title: Text(
              '${MaterialLocalizations.of(context).formatMediumDate(range.start)} – ${MaterialLocalizations.of(context).formatMediumDate(range.end)}',
            ),
            trailing: IconButton(
              tooltip: 'Remove interval',
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _exceptions.remove(range)),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _addException,
          icon: const Icon(Icons.add),
          label: const Text('Add lecture-free interval'),
        ),
      ],
    ),
  );

  Future<void> _addException() async {
    if (_semesterEnd.isBefore(_semesterStart)) return;
    final range = await showDateRangePicker(
      context: context,
      firstDate: _semesterStart,
      lastDate: _semesterEnd,
    );
    if (range != null) setState(() => _exceptions.add(range));
  }

  Future<void> _pick(int field) async {
    final current = [
      _semesterStart,
      _semesterEnd,
      _lectureStart,
      _lectureEnd,
    ][field];
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      initialDate: current,
    );
    if (value == null) return;
    setState(() {
      if (field == 0) _semesterStart = value;
      if (field == 1) _semesterEnd = value;
      if (field == 2) _lectureStart = value;
      if (field == 3) _lectureEnd = value;
    });
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty ||
        _semesterEnd.isBefore(_semesterStart) ||
        _lectureStart.isBefore(_semesterStart) ||
        _lectureEnd.isAfter(_semesterEnd) ||
        _lectureEnd.isBefore(_lectureStart) ||
        _exceptions.any(
          (range) =>
              range.start.isBefore(_semesterStart) ||
              range.end.isAfter(_semesterEnd),
        )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check the semester and lecture date order.'),
        ),
      );
      return;
    }
    final now = DateTime.now().toUtc();
    await ref
        .read(workRepositoryProvider)
        .saveAcademicPeriod(
          AcademicPeriod(
            id: widget.existing?.id ?? const Uuid().v4(),
            semesterName: _name.text.trim(),
            semesterStart: _semesterStart,
            semesterEnd: _semesterEnd,
            lectureStart: _lectureStart,
            lectureEnd: _lectureEnd,
            exceptionalLectureFreeJson: jsonEncode(
              _exceptions
                  .map(
                    (range) => {
                      'start': range.start.toIso8601String(),
                      'end': range.end.toIso8601String(),
                    },
                  )
                  .toList(),
            ),
            createdAt: widget.existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    if (mounted) context.pop();
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(label),
      trailing: Text(
        MaterialLocalizations.of(context).formatMediumDate(value),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
