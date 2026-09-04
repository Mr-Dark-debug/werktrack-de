import 'package:flutter/material.dart';

import '../../domain/entities/academic_period.dart';
import '../../domain/entities/employer.dart';

class WorkHistoryFilters {
  const WorkHistoryFilters({
    this.range,
    this.employerId,
    this.type,
    this.academic,
    this.onlyWarnings = false,
  });
  final DateTimeRange? range;
  final String? employerId;
  final EmploymentType? type;
  final AcademicContext? academic;
  final bool onlyWarnings;
}

class HistoryFiltersPanel extends StatefulWidget {
  const HistoryFiltersPanel({
    super.key,
    required this.employers,
    required this.onChanged,
  });
  final List<Employer> employers;
  final ValueChanged<WorkHistoryFilters> onChanged;
  @override
  State<HistoryFiltersPanel> createState() => _HistoryFiltersPanelState();
}

class _HistoryFiltersPanelState extends State<HistoryFiltersPanel> {
  String _employer = '';
  String _type = '';
  String _academic = '';
  DateTimeRange? _range;
  bool _warnings = false;
  void _emit() => widget.onChanged(
    WorkHistoryFilters(
      range: _range,
      employerId: _employer.isEmpty ? null : _employer,
      type: _type.isEmpty ? null : EmploymentType.values.byName(_type),
      academic: _academic.isEmpty
          ? null
          : AcademicContext.values.byName(_academic),
      onlyWarnings: _warnings,
    ),
  );
  @override
  Widget build(BuildContext context) => ExpansionTile(
    shape: const Border(),
    collapsedShape: const Border(),
    tilePadding: const EdgeInsets.symmetric(horizontal: 8),
    title: const Text('More filters', style: TextStyle(fontSize: 14)),
    leading: const Icon(Icons.tune),
    children: [
      DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: _employer,
        decoration: const InputDecoration(labelText: 'Employer'),
        items: [
          const DropdownMenuItem(value: '', child: Text('All employers')),
          ...widget.employers.map(
            (e) => DropdownMenuItem(
              value: e.id,
              child: Text(e.name, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() => _employer = value!);
          _emit();
        },
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: _type,
        decoration: const InputDecoration(labelText: 'Employment type'),
        items: [
          const DropdownMenuItem(value: '', child: Text('All types')),
          ...EmploymentType.values.map(
            (type) =>
                DropdownMenuItem(value: type.name, child: Text(type.name)),
          ),
        ],
        onChanged: (value) {
          setState(() => _type = value!);
          _emit();
        },
      ),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: _academic,
        decoration: const InputDecoration(labelText: 'Academic context'),
        items: [
          const DropdownMenuItem(
            value: '',
            child: Text('All academic periods'),
          ),
          ...AcademicContext.values.map(
            (period) =>
                DropdownMenuItem(value: period.name, child: Text(period.name)),
          ),
        ],
        onChanged: (value) {
          setState(() => _academic = value!);
          _emit();
        },
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Only dates with warnings'),
        value: _warnings,
        onChanged: (value) {
          setState(() => _warnings = value);
          _emit();
        },
      ),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2040),
                  initialDateRange: _range,
                );
                if (range != null) {
                  setState(() => _range = range);
                  _emit();
                }
              },
              icon: const Icon(Icons.date_range),
              label: Text(
                _range == null
                    ? 'Shift start-date range'
                    : '${_range!.start.day}/${_range!.start.month} – ${_range!.end.day}/${_range!.end.month}',
              ),
            ),
          ),
          if (_range != null)
            IconButton(
              tooltip: 'Clear date range',
              onPressed: () {
                setState(() => _range = null);
                _emit();
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    ],
  );
}
