import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../theme/app_colors.dart';

class AcademicPeriodsScreen extends ConsumerWidget {
  const AcademicPeriodsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(academicPeriodsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Academic periods')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/periods/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add semester'),
      ),
      body: periods.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (items) => items.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Text(
                    'Add your university dates. WerkTrack never assumes German semester dates.',
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? AppColors.sage
                          : AppColors.periwinkle,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: 'Edit academic period',
                            onPressed: () =>
                                context.push('/periods/add', extra: item),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Text(
                          item.semesterName,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Semester ${DateFormat('d MMM').format(item.semesterStart)} – ${DateFormat('d MMM yyyy').format(item.semesterEnd)}',
                          style: const TextStyle(color: AppColors.ink),
                        ),
                        Text(
                          'Lectures ${DateFormat('d MMM').format(item.lectureStart)} – ${DateFormat('d MMM yyyy').format(item.lectureEnd)}',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
