import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/employer.dart';

class EmployerFormScreen extends ConsumerStatefulWidget {
  const EmployerFormScreen({super.key, this.existing});
  final Employer? existing;
  @override
  ConsumerState<EmployerFormScreen> createState() => _EmployerFormScreenState();
}

class _EmployerFormScreenState extends ConsumerState<EmployerFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _title = TextEditingController();
  final _rate = TextEditingController();
  bool _seededRate = false;
  EmploymentType _type = EmploymentType.werkstudent;
  bool _residence = true;
  bool _studentHours = true;
  bool _liable = false;
  bool _pensionExempt = false;
  bool _active = true;
  int _taxClass = 1;
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    if (item == null) return;
    _name.text = item.name;
    _title.text = item.jobTitle;
    _rate.text = (item.hourlyRateCents / 100).toStringAsFixed(2);
    _seededRate = true;
    _type = item.employmentType;
    _residence = item.countsForResidenceLimit;
    _studentHours = item.countsForStudentHourRule;
    _liable = item.isSocialInsuranceLiable;
    _pensionExempt = item.pensionExempt;
    _active = item.isActive;
    _taxClass = item.taxClass;
    _notes.text = item.notes;
  }

  @override
  void dispose() {
    _name.dispose();
    _title.dispose();
    _rate.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(resolvedRulesProvider).value;
    if (!_seededRate && rules != null) {
      _rate.text = (rules.minimumWageCents / 100).toStringAsFixed(2);
      _seededRate = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New employer' : 'Edit employer'),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _save,
          child: const Text('Save employer'),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Job details',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Employer name'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Job title'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EmploymentType>(
              isExpanded: true,
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Employment type'),
              items: EmploymentType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _type = value ?? _type),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _rate,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Hourly rate',
                prefixText: '€ ',
              ),
              validator: _money,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<int>(
              initialValue: _taxClass,
              decoration: const InputDecoration(labelText: 'Tax class'),
              items: [
                for (var i = 1; i <= 6; i++)
                  DropdownMenuItem(value: i, child: Text('$i')),
              ],
              onChanged: (value) => setState(() => _taxClass = value!),
            ),
            SwitchListTile(
              title: const Text('Active employment'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
            ),
            TextField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),
            Text(
              'Compliance switches',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text(
              'Set these from your actual circumstances. Job type alone does not settle immigration or insurance treatment.',
            ),
            SwitchListTile(
              title: const Text('Counts for residence allowance'),
              value: _residence,
              onChanged: (v) => setState(() => _residence = v),
            ),
            SwitchListTile(
              title: const Text('Counts for student weekly hours'),
              value: _studentHours,
              onChanged: (v) => setState(() => _studentHours = v),
            ),
            SwitchListTile(
              title: const Text('Social-insurance-liable main employment'),
              value: _liable,
              onChanged: (v) => setState(() => _liable = v),
            ),
            SwitchListTile(
              title: const Text('Pension exemption recorded'),
              value: _pensionExempt,
              onChanged: (v) => setState(() => _pensionExempt = v),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;
  String? _money(String? value) => parseEuroCents(value ?? '') == null
      ? 'Enter a non-negative amount with at most two decimals'
      : null;

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    await ref
        .read(workRepositoryProvider)
        .saveEmployer(
          Employer(
            id: widget.existing?.id ?? const Uuid().v4(),
            name: _name.text.trim(),
            jobTitle: _title.text.trim(),
            employmentType: _type,
            hourlyRateCents: parseEuroCents(_rate.text)!,
            startDate:
                widget.existing?.startDate ??
                DateTime(now.year, now.month, now.day),
            endDate: widget.existing?.endDate,
            isActive: _active,
            countsForResidenceLimit: _residence,
            countsForStudentHourRule: _studentHours,
            isSocialInsuranceLiable: _liable,
            pensionExempt: _pensionExempt,
            taxClass: _taxClass,
            notes: _notes.text.trim(),
            createdAt: widget.existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
    if (mounted) context.pop();
  }
}
