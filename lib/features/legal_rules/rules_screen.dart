import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../theme/app_colors.dart';

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(legalRulesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rules & Sources')),
      body: rules.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            Text(
              'Know every\nreference.',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 46),
            ),
            const SizedBox(height: 10),
            const Text(
              'Rules are versioned by effective date. Tap a card to open its official source.',
            ),
            const SizedBox(height: 22),
            ...items.asMap().entries.map((entry) {
              final rule = entry.value;
              final color = [
                AppColors.yellow,
                AppColors.pink,
                AppColors.sage,
                AppColors.periwinkle,
                AppColors.aqua,
              ][entry.key % 5];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => launchUrl(
                    Uri.parse(rule.sourceUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _title(rule.key),
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${rule.unit.startsWith('euro_cents') ? '€${(rule.value / 100).toStringAsFixed(2)}${rule.unit.endsWith('per_hour') ? '/h' : ''}' : '${_value(rule.value)} ${rule.unit.replaceAll('_', ' ')}'} · effective ${DateFormat('d MMM yyyy').format(rule.effectiveFrom)}',
                                style: const TextStyle(color: AppColors.ink),
                              ),
                              Text(
                                '${rule.metadataJson.contains('"manualOverride":true') ? 'User configured' : 'Verified'} ${DateFormat('d MMM yyyy').format(rule.lastVerified)} · ${rule.sourceTitle}',
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Add a user-configured version',
                          onPressed: () =>
                              context.push('/rules/override', extra: rule),
                          icon: const Icon(Icons.tune, color: AppColors.ink),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _title(String key) => key
      .split('_')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
  String _value(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
}
