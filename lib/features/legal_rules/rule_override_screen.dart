import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/legal_rule.dart';

class RuleOverrideScreen extends ConsumerStatefulWidget {
  const RuleOverrideScreen({super.key, required this.base});
  final LegalRule base;
  @override
  ConsumerState<RuleOverrideScreen> createState() => _RuleOverrideScreenState();
}

class _RuleOverrideScreenState extends ConsumerState<RuleOverrideScreen> {
  final _value = TextEditingController();
  final _reason = TextEditingController();
  DateTime _from = DateUtils.dateOnly(DateTime.now());
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _value.text = widget.base.unit.startsWith('euro_cents')
        ? (widget.base.value / 100).toStringAsFixed(2)
        : widget.base.value.toInt().toString();
  }

  @override
  void dispose() {
    _value.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add rule version')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          widget.base.key.replaceAll('_', ' '),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'This adds a user-configured version. It does not change the official source or erase an earlier version. A manual value is not independently verified legal guidance.',
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: widget.base.unit.startsWith('euro_cents')
                ? 'Amount in euro'
                : 'Value in ${widget.base.unit.replaceAll('_', ' ')}',
          ),
        ),
        ListTile(
          title: const Text('Effective from'),
          subtitle: Text(
            MaterialLocalizations.of(context).formatMediumDate(_from),
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2040),
              initialDate: _from,
            );
            if (date != null) setState(() => _from = date);
          },
        ),
        TextField(
          controller: _reason,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Reason / authority guidance',
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: const Text('Save new version'),
        ),
      ],
    ),
  );
  Future<void> _save() async {
    final value = widget.base.unit.startsWith('euro_cents')
        ? parseEuroCents(_value.text)
        : int.tryParse(_value.text);
    final date = DateTime.utc(_from.year, _from.month, _from.day);
    final existing = ref.read(legalRulesProvider).value ?? const <LegalRule>[];
    if (value == null ||
        value <= 0 ||
        _reason.text.trim().isEmpty ||
        existing.any(
          (rule) => rule.key == widget.base.key && rule.effectiveFrom == date,
        )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Use a positive value, a reason and an effective date without an existing version for this key.',
          ),
        ),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(workRepositoryProvider)
          .addLegalRuleVersion(
            LegalRule(
              id: const Uuid().v4(),
              key: widget.base.key,
              effectiveFrom: date,
              value: value,
              unit: widget.base.unit,
              sourceUrl: widget.base.sourceUrl,
              sourceTitle:
                  'User override; source context: ${widget.base.sourceTitle}',
              lastVerified: DateTime.now().toUtc(),
              metadataJson: jsonEncode({
                'manualOverride': true,
                'basedOn': widget.base.id,
                'reason': _reason.text.trim(),
              }),
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The new version could not be saved. Earlier rules are unchanged.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
