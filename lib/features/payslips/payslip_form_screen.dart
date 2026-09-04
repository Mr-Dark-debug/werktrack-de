import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/payslip.dart';

class PayslipFormScreen extends ConsumerStatefulWidget {
  const PayslipFormScreen({super.key});
  @override
  ConsumerState<PayslipFormScreen> createState() => _PayslipFormScreenState();
}

class _PayslipFormScreenState extends ConsumerState<PayslipFormScreen> {
  String? _employerId;
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  final _controllers = <String, TextEditingController>{
    for (final key in [
      'gross',
      'wageTax',
      'solidarity',
      'churchTax',
      'pension',
      'health',
      'care',
      'unemployment',
      'other',
      'net',
    ])
      key: TextEditingController(text: '0'),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employers = ref.watch(employersProvider).value ?? const <Employer>[];
    _employerId ??= employers.firstOrNull?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Add payslip')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Actual payroll,\nnot a guess.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            'Recorded payslips improve forecasts without changing the official tax calculator.',
          ),
          const SizedBox(height: 22),
          if (employers.isEmpty)
            const Text('Add an employer first.')
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
              onChanged: (value) => setState(() => _employerId = value),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _month,
                  decoration: const InputDecoration(labelText: 'Month'),
                  items: [
                    for (var i = 1; i <= 12; i++)
                      DropdownMenuItem(value: i, child: Text('$i')),
                  ],
                  onChanged: (value) =>
                      setState(() => _month = value ?? _month),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: '$_year',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Year'),
                  onChanged: (value) => _year = int.tryParse(value) ?? _year,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _moneyField('gross', 'Gross'),
          Row(
            children: [
              Expanded(child: _moneyField('wageTax', 'Wage tax')),
              const SizedBox(width: 10),
              Expanded(child: _moneyField('solidarity', 'Solidarity')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _moneyField('churchTax', 'Church tax')),
              const SizedBox(width: 10),
              Expanded(child: _moneyField('pension', 'Pension')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _moneyField('health', 'Health')),
              const SizedBox(width: 10),
              Expanded(child: _moneyField('care', 'Care')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _moneyField('unemployment', 'Unemployment')),
              const SizedBox(width: 10),
              Expanded(child: _moneyField('other', 'Other')),
            ],
          ),
          _moneyField('net', 'Actual net'),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: employers.isEmpty ? null : _save,
            child: const Text('Save payslip'),
          ),
        ],
      ),
    );
  }

  Widget _moneyField(String key, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: _controllers[key],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixText: '€ '),
    ),
  );

  int _cents(String key) => parseEuroCents(_controllers[key]!.text)!;

  Future<void> _save() async {
    if (_controllers.values.any(
          (controller) => parseEuroCents(controller.text) == null,
        ) ||
        _year < 2000 ||
        _year > 2100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid year and non-negative amounts with at most two decimals.',
          ),
        ),
      );
      return;
    }
    final now = DateTime.now().toUtc();
    await ref
        .read(workRepositoryProvider)
        .savePayslip(
          Payslip(
            id: const Uuid().v4(),
            employerId: _employerId!,
            month: _month,
            year: _year,
            grossCents: _cents('gross'),
            wageTaxCents: _cents('wageTax'),
            solidaritySurchargeCents: _cents('solidarity'),
            churchTaxCents: _cents('churchTax'),
            pensionCents: _cents('pension'),
            healthCents: _cents('health'),
            careCents: _cents('care'),
            unemploymentCents: _cents('unemployment'),
            otherDeductionsCents: _cents('other'),
            netCents: _cents('net'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    if (mounted) context.pop();
  }
}
