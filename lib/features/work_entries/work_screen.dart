import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';
import '../../domain/calculators/academic_context_calculator.dart';
import '../../domain/calculators/working_time_compliance_calculator.dart';
import 'history_filters.dart';

class WorkScreen extends ConsumerStatefulWidget {
  const WorkScreen({super.key});

  @override
  ConsumerState<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends ConsumerState<WorkScreen> {
  String _query = '';
  WorkEntryStatus? _status;
  WorkHistoryFilters _filters = const WorkHistoryFilters();
  bool _showTimer = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(entriesProvider).value ?? const <WorkEntry>[];
    final employers = ref.watch(employersProvider).value ?? const <Employer>[];
    final byId = {for (final e in employers) e.id: e};
    final location = ref.watch(berlinLocationProvider);
    final periods = ref.watch(academicPeriodsProvider).value ?? const [];
    final rules = ref.watch(resolvedRulesProvider).value;
    final warningDates = rules == null
        ? <DateTime>{}
        : const WorkingTimeComplianceCalculator()
              .calculate(
                entries: entries,
                rules: rules,
                location: location,
                ruleResolver: ref.watch(legalRuleBookProvider).forDate,
                sourceUrl:
                    'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
              )
              .map((issue) => issue.affectedDate)
              .toSet();
    final active = entries
        .where((e) => e.status == WorkEntryStatus.active)
        .firstOrNull;
    final history = entries.where((entry) {
      if (entry.status == WorkEntryStatus.active) return false;
      if (_status != null && entry.status != _status) return false;
      final employer = byId[entry.employerId];
      final day = DateUtils.dateOnly(
        tz.TZDateTime.from(entry.startTimeUtc, location),
      );
      if (_filters.employerId != null &&
          _filters.employerId != entry.employerId) {
        return false;
      }
      if (_filters.type != null && _filters.type != employer?.employmentType) {
        return false;
      }
      if (_filters.academic != null &&
          _filters.academic !=
              const AcademicContextCalculator().contextFor(day, periods)) {
        return false;
      }
      if (_filters.range != null &&
          (day.isBefore(_filters.range!.start) ||
              day.isAfter(_filters.range!.end))) {
        return false;
      }
      if (_filters.onlyWarnings && !warningDates.contains(day)) return false;
      final searchable = [
        employer?.name ?? '',
        employer?.jobTitle ?? '',
        employer?.employmentType.name ?? '',
        entry.notes,
      ].join(' ').toLowerCase();
      return searchable.contains(_query.trim().toLowerCase());
    }).toList()..sort((a, b) => b.startTimeUtc.compareTo(a.startTimeUtc));
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 180),
        children: [
          Text(
            'Work',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 52),
          ),
          const SizedBox(height: 16),
          if (active != null ||
              _showTimer ||
              GoRouterState.of(context).uri.queryParameters['timer'] == 'true')
            _TimerCard(
              active: active,
              employer: active == null ? null : byId[active.employerId],
              employers: employers,
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/work/add'),
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Add work'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showTimer = !_showTimer),
                  icon: const Icon(Icons.timer_outlined),
                  label: Text(_showTimer ? 'Hide timer' : 'Timer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('History', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          TextField(
            key: const Key('work-search'),
            controller: _search,
            decoration: InputDecoration(
              hintText: 'Search your shifts',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                showCheckmark: false,
                shape: const StadiumBorder(),
                side: BorderSide.none,
                selectedColor: AppColors.ink,
                backgroundColor: AppColors.periwinkle,
                labelStyle: TextStyle(
                  color: _status == null ? Colors.white : AppColors.ink,
                ),
                label: const Text('All'),
                selected: _status == null,
                onSelected: (_) => setState(() => _status = null),
              ),
              ChoiceChip(
                showCheckmark: false,
                shape: const StadiumBorder(),
                side: BorderSide.none,
                selectedColor: AppColors.ink,
                backgroundColor: AppColors.sage,
                labelStyle: TextStyle(
                  color: _status == WorkEntryStatus.completed
                      ? Colors.white
                      : AppColors.ink,
                ),
                label: const Text('Completed'),
                selected: _status == WorkEntryStatus.completed,
                onSelected: (_) =>
                    setState(() => _status = WorkEntryStatus.completed),
              ),
              ChoiceChip(
                showCheckmark: false,
                shape: const StadiumBorder(),
                side: BorderSide.none,
                selectedColor: AppColors.ink,
                backgroundColor: AppColors.pink,
                labelStyle: TextStyle(
                  color: _status == WorkEntryStatus.planned
                      ? Colors.white
                      : AppColors.ink,
                ),
                label: const Text('Planned'),
                selected: _status == WorkEntryStatus.planned,
                onSelected: (_) =>
                    setState(() => _status = WorkEntryStatus.planned),
              ),
            ],
          ),
          const SizedBox(height: 10),
          HistoryFiltersPanel(
            employers: employers,
            onChanged: (value) => setState(() => _filters = value),
          ),
          const SizedBox(height: 10),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: Text('No shifts match this view.')),
            )
          else
            ...history.map(
              (entry) =>
                  _HistoryTile(entry: entry, employer: byId[entry.employerId]),
            ),
        ],
      ),
    );
  }
}

class _TimerCard extends ConsumerStatefulWidget {
  const _TimerCard({
    required this.active,
    required this.employer,
    required this.employers,
  });
  final WorkEntry? active;
  final Employer? employer;
  final List<Employer> employers;
  @override
  ConsumerState<_TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends ConsumerState<_TimerCard> {
  Timer? _ticker;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.active != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    _selected ??= widget.employers.firstOrNull?.id;
    final elapsed = active == null
        ? Duration.zero
        : DateTime.now().toUtc().difference(active.startTimeUtc);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: active == null ? AppColors.aqua : AppColors.coral,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_rounded, color: AppColors.ink),
              const SizedBox(width: 8),
              Text(
                active == null ? 'READY TO CLOCK IN' : 'TIMER RUNNING',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            active == null ? 'Ready when you are.' : formatDuration(elapsed),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 14),
          if (active == null && widget.employers.isNotEmpty)
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _selected,
              dropdownColor: AppColors.white,
              decoration: const InputDecoration(
                labelText: 'Employer',
                fillColor: Colors.white70,
              ),
              items: widget.employers
                  .map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selected = value),
            )
          else if (active != null)
            Text(
              widget.employer?.name ?? 'Unknown employer',
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: active == null
                ? (widget.employers.isEmpty ? null : _start)
                : _stop,
            icon: Icon(
              active == null ? Icons.play_arrow_rounded : Icons.stop_rounded,
            ),
            label: Text(active == null ? 'Start timer' : 'Stop & save shift'),
          ),
        ],
      ),
    );
  }

  Future<void> _start() async {
    final employer = widget.employers.firstWhere((e) => e.id == _selected);
    final now = DateTime.now().toUtc();
    await ref
        .read(workRepositoryProvider)
        .saveEntry(
          WorkEntry(
            id: const Uuid().v4(),
            employerId: employer.id,
            startTimeUtc: now,
            timezone: 'Europe/Berlin',
            breakMinutes: 0,
            paidBreakMinutes: 0,
            hourlyRateSnapshotCents: employer.hourlyRateCents,
            bonusCents: 0,
            tipsCents: 0,
            notes: '',
            status: WorkEntryStatus.active,
            createdAt: now,
            updatedAt: now,
          ),
        );
    if (await ref
            .read(workRepositoryProvider)
            .readSetting('notificationsEnabled') ==
        'true') {
      await ref
          .read(localNotificationServiceProvider)
          .scheduleTimerReminder(now);
    }
  }

  Future<void> _stop() async {
    final active = widget.active!;
    final now = DateTime.now().toUtc();
    await ref
        .read(workRepositoryProvider)
        .saveEntry(
          active.copyWith(
            endTimeUtc: now,
            status: WorkEntryStatus.completed,
            updatedAt: now,
          ),
        );
    if (await ref
            .read(workRepositoryProvider)
            .readSetting('notificationsEnabled') ==
        'true') {
      await ref.read(localNotificationServiceProvider).cancelTimerReminder();
    }
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.entry, required this.employer});
  final WorkEntry entry;
  final Employer? employer;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete this work record?'),
          content: const Text(
            'It will be hidden from totals and retained as a sync tombstone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        await ref.read(workRepositoryProvider).deleteEntry(entry.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Work record deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () =>
                    ref.read(workRepositoryProvider).restoreEntry(entry.id),
              ),
            ),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.coral,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.ink),
      ),
      child: ListTile(
        leading: IconButton(
          tooltip: 'Duplicate and edit shift',
          icon: const Icon(Icons.copy_outlined),
          onPressed: () {
            final now = DateTime.now().toUtc();
            context.push(
              '/work/add',
              extra: entry.copyWith(
                id: const Uuid().v4(),
                createdAt: now,
                updatedAt: now,
              ),
            );
          },
        ),
        onTap: () => context.push('/work/add', extra: entry),
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          employer?.name ?? 'Unknown employer',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${DateFormat('d MMM yyyy · HH:mm').format(tz.TZDateTime.from(entry.startTimeUtc, ref.watch(berlinLocationProvider)))} · ${entry.status.name}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatDuration(entry.workingDuration),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(formatMoney(entry.grossCents)),
          ],
        ),
      ),
    ),
  );
}
