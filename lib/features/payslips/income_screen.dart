import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/income_tax_calculator.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/payslip.dart';
import '../../domain/entities/work_entry.dart';

class IncomeScreen extends ConsumerStatefulWidget {
  const IncomeScreen({super.key});
  @override
  ConsumerState<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends ConsumerState<IncomeScreen> {
  final _taxable = TextEditingController();
  IncomeTaxResult? _tax;
  @override
  void dispose() {
    _taxable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payslips =
        (ref.watch(payslipsProvider).value ?? const <Payslip>[]).toList()..sort(
          (a, b) => (b.year * 12 + b.month).compareTo(a.year * 12 + a.month),
        );
    final employers = {
      for (final e in ref.watch(employersProvider).value ?? const <Employer>[])
        e.id: e,
    };
    final entries = ref.watch(entriesProvider).value ?? const <WorkEntry>[];
    final location = ref.watch(berlinLocationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Income & payslips')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/payslips/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add payslip'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Text(
            'Estimates meet actuals.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tracked gross uses each shift’s saved rate. Actual payslip net is separate from estimated net. Payroll withholding and social-insurance treatment cannot be inferred from the basic tax allowance alone.',
          ),
          const SizedBox(height: 18),
          if (payslips.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'No payslips yet. Add actual payroll values to compare them with tracked earnings and inform later forecasts.',
                ),
              ),
            ),
          ...payslips.map((payslip) {
            final tracked = entries
                .where((entry) {
                  final date = tz.TZDateTime.from(entry.startTimeUtc, location);
                  return entry.status == WorkEntryStatus.completed &&
                      entry.employerId == payslip.employerId &&
                      date.year == payslip.year &&
                      date.month == payslip.month;
                })
                .fold<int>(0, (sum, entry) => sum + entry.grossCents);
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employers[payslip.employerId]?.name ?? 'Employer'} · ${payslip.month}/${payslip.year}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tracked gross ${formatMoney(tracked)} · Payslip gross ${formatMoney(payslip.grossCents)}',
                    ),
                    Text(
                      'Gross difference ${formatMoney(payslip.grossCents - tracked)}',
                    ),
                    Text(
                      'Actual net ${formatMoney(payslip.netCents)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Wage tax ${formatMoney(payslip.wageTaxCents)} · Pension ${formatMoney(payslip.pensionCents)}',
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 22),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('2026 annual income-tax reference'),
            children: [
              const Text(
                'Enter annual taxable income, not salary gross. This is the basic §32a tariff, not a wage-tax or total payroll deduction calculator.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _taxable,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '2026 taxable annual income',
                  prefixText: '€ ',
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  final cents = parseEuroCents(_taxable.text);
                  if (cents == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a valid non-negative amount.'),
                      ),
                    );
                    return;
                  }
                  setState(
                    () =>
                        _tax = const IncomeTaxCalculator2026().calculate(cents),
                  );
                },
                child: const Text('Calculate tariff reference'),
              ),
              if (_tax != null)
                Text(
                  'Annual basic income-tax tariff: ${formatMoney(_tax!.taxEuros * 100)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              TextButton(
                onPressed: () => context.push('/rules'),
                child: const Text('View official source and rule versions'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
