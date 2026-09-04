import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../theme/app_colors.dart';

class EmployersScreen extends ConsumerWidget {
  const EmployersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employers = ref.watch(employersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Employers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/employers/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add employer'),
      ),
      body: employers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'Add every employer whose work you want to aggregate.',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final employer = items[index];
                  return ListTile(
                    onTap: () =>
                        context.push('/employers/add', extra: employer),
                    tileColor: [
                      AppColors.yellow,
                      AppColors.sage,
                      AppColors.pink,
                      AppColors.periwinkle,
                    ][index % 4],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Icon(
                        Icons.apartment_rounded,
                        color: AppColors.ink,
                      ),
                    ),
                    title: Text(
                      employer.name,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      '${employer.jobTitle} · ${employer.employmentType.name}',
                      style: const TextStyle(color: AppColors.ink),
                    ),
                    trailing: Text(
                      '${formatMoney(employer.hourlyRateCents)}/h',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
