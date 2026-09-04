import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/calculators/academic_context_calculator.dart';
import '../../domain/calculators/calendar_segments.dart';
import '../../domain/entities/academic_period.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';

class WorkCalendarEvent extends CalendarEvent {
  WorkCalendarEvent({
    required this.entry,
    required this.title,
    DateTimeRange? range,
  }) : super(
         id: entry.id,
         dateTimeRange:
             range ??
             DateTimeRange(start: entry.startTimeUtc, end: entry.endTimeUtc!),
         interaction: EventInteraction.allowNone(),
       );
  final WorkEntry entry;
  final String title;
  @override
  WorkCalendarEvent copyWithData({required DateTimeRange dateTimeRange}) =>
      WorkCalendarEvent(entry: entry, title: title, range: dateTimeRange);
  @override
  bool operator ==(Object other) =>
      super == other &&
      other is WorkCalendarEvent &&
      other.title == title &&
      other.entry.updatedAt == entry.updatedAt &&
      other.entry.status == entry.status;
  @override
  int get hashCode =>
      Object.hash(super.hashCode, title, entry.updatedAt, entry.status);
}

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final CalendarController _calendar;
  final _visibleRange = ValueNotifier<DateTimeRange?>(null);
  late final DefaultEventsController _events;
  late final List<ViewConfiguration> _views;
  int _view = 0;
  static final _readOnly = CalendarInteraction(
    allowEventCreation: false,
    allowRescheduling: false,
    allowResizing: false,
  );

  @override
  void initState() {
    super.initState();
    final location = ref.read(berlinLocationProvider);
    final now = tz.TZDateTime.now(location);
    _calendar = CalendarController();
    _calendar.visibleDateTimeRange.addListener(_queueVisibleRange);
    _events = DefaultEventsController(locations: [location]);
    _views = [
      MonthViewConfiguration.singleMonth(
        initialDateTime: now,
        firstDayOfWeek: DateTime.monday,
      ),
      MultiDayViewConfiguration.week(
        initialDateTime: now,
        firstDayOfWeek: DateTime.monday,
        initialTimeOfDay: const TimeOfDay(hour: 8, minute: 0),
      ),
      MultiDayViewConfiguration.singleDay(
        initialDateTime: now,
        initialTimeOfDay: const TimeOfDay(hour: 8, minute: 0),
      ),
    ];
    ref.listenManual(
      entriesProvider,
      (_, _) => _syncEvents(),
      fireImmediately: true,
    );
    ref.listenManual(
      employersProvider,
      (_, _) => _syncEvents(),
      fireImmediately: true,
    );
  }

  void _syncEvents() {
    final employers = {
      for (final e in ref.read(employersProvider).value ?? const []) e.id: e,
    };
    _events.replaceEvents([
      for (final entry
          in ref.read(entriesProvider).value ?? const <WorkEntry>[])
        if (entry.endTimeUtc != null &&
            entry.endTimeUtc!.isAfter(entry.startTimeUtc) &&
            entry.status != WorkEntryStatus.cancelled &&
            entry.status != WorkEntryStatus.active)
          WorkCalendarEvent(
            entry: entry,
            title: employers[entry.employerId]?.name ?? 'Employer',
          ),
    ]);
  }

  void _queueVisibleRange() {
    // Kalender updates its range while mounting/switching views. Publish to
    // the sibling toolbar after layout so it never rebuilds during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _visibleRange.value = _calendar.visibleDateTimeRange.value;
    });
  }

  @override
  void dispose() {
    _calendar.visibleDateTimeRange.removeListener(_queueVisibleRange);
    _visibleRange.dispose();
    _calendar.dispose();
    _events.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = TileComponents(
      tileBuilder: (context, event, range) {
        final work = event as WorkCalendarEvent;
        final planned = work.entry.status == WorkEntryStatus.planned;
        return Tooltip(
          message: '${work.title} · ${work.entry.status.name}',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: planned ? AppColors.pink : AppColors.sage,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${planned ? '○ ' : ''}${work.title}',
              maxLines: _view == 0 ? 1 : 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 168),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Calendar',
                      maxLines: 1,
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 44),
                    ),
                  ),
                ),
                PopupMenuButton<int>(
                  tooltip: 'Calendar view',
                  initialValue: _view,
                  onSelected: (v) => setState(() => _view = v),
                  itemBuilder: (_) => [
                    for (var i = 0; i < 3; i++)
                      PopupMenuItem(
                        value: i,
                        child: Text(['Month', 'Week', 'Day'][i]),
                      ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '${['Month', 'Week', 'Day'][_view]} ▾',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous period',
                  onPressed: _calendar.animateToPreviousPage,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _visibleRange,
                    builder: (context, range, _) {
                      final mid = range == null
                          ? tz.TZDateTime.now(ref.read(berlinLocationProvider))
                          : tz.TZDateTime.from(
                              range.start.add(range.duration ~/ 2),
                              ref.read(berlinLocationProvider),
                            );
                      return Text(
                        DateFormat('MMMM yyyy').format(mid),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      );
                    },
                  ),
                ),
                IconButton(
                  tooltip: 'Next period',
                  onPressed: _calendar.animateToNextPage,
                  icon: const Icon(Icons.chevron_right),
                ),
                IconButton(
                  tooltip: 'Today',
                  onPressed: () => _calendar.animateToDate(
                    tz.TZDateTime.now(ref.read(berlinLocationProvider)),
                  ),
                  icon: const Icon(Icons.today_outlined),
                ),
              ],
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ColoredBox(
                  color: Theme.of(context).cardColor,
                  child: KalenderView(
                    key: const Key('work-kalender'),
                    calendarController: _calendar,
                    eventsController: _events,
                    viewConfiguration: _views[_view],
                    locale: Localizations.localeOf(context),
                    location: ref.watch(berlinLocationProvider),
                    components: CalendarComponents(
                      monthComponents: MonthComponents(
                        headerComponents: MonthHeaderComponents(
                          weekDayHeaderBuilder: (context, date) => SizedBox(
                            height: 30,
                            child: Center(
                              child: Text(
                                DateFormat(
                                  'EEEEE',
                                  Localizations.localeOf(
                                    context,
                                  ).toLanguageTag(),
                                ).format(date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        bodyComponents: MonthBodyComponents(
                          monthDayHeaderBuilder: (context, date) =>
                              MonthDayHeader(
                                date: date,
                                style: const MonthDayHeaderStyle(
                                  buttonSize: Size(28, 28),
                                  numberTextStyle: TextStyle(fontSize: 12),
                                  margin: EdgeInsets.zero,
                                ),
                              ),
                        ),
                      ),
                      multiDayComponents: MultiDayComponents(
                        headerComponents: MultiDayHeaderComponents(
                          dayHeaderBuilder: (context, date) => SizedBox(
                            height: 48,
                            child: InkWell(
                              onTap: () => _showDay(date),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${date.day}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'EEEEE',
                                          Localizations.localeOf(
                                            context,
                                          ).toLanguageTag(),
                                        ).format(date),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    callbacks: CalendarCallbacks(
                      onEventTapped: (event) => context.push(
                        '/work/add',
                        extra: (event as WorkCalendarEvent).entry,
                      ),
                      onTapped: _showDay,
                    ),
                    header: CalendarHeader(
                      interaction: _readOnly,
                      multiDayTileComponents: tiles,
                    ),
                    body: CalendarBody(
                      interaction: _readOnly,
                      multiDayTileComponents: tiles,
                      monthTileComponents: tiles,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDay(DateTime date) {
    final location = ref.read(berlinLocationProvider);
    final local = tz.TZDateTime.from(date, location);
    final day = DateTime(local.year, local.month, local.day);
    final entries =
        (ref.read(entriesProvider).value ?? const <WorkEntry>[])
            .where(
              (e) =>
                  e.status != WorkEntryStatus.cancelled &&
                  workingMinutesByLocalDay(e, location).containsKey(day),
            )
            .toList()
          ..sort((a, b) => a.startTimeUtc.compareTo(b.startTimeUtc));
    final minutes = entries
        .where((e) => e.status == WorkEntryStatus.completed)
        .fold<int>(
          0,
          (sum, e) => sum + (workingMinutesByLocalDay(e, location)[day] ?? 0),
        );
    final employers = {
      for (final e in ref.read(employersProvider).value ?? const []) e.id: e,
    };
    final academic = const AcademicContextCalculator().contextFor(
      day,
      ref.read(academicPeriodsProvider).value ?? const [],
    );
    final label = switch (academic) {
      AcademicContext.lecturePeriod => 'Lecture period',
      AcademicContext.lectureFree => 'Lecture-free',
      AcademicContext.outsideConfiguredSemester =>
        'Academic dates not configured',
    };
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheet).height * .7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(
                DateFormat('EEEE, d MMMM').format(day),
                style: Theme.of(sheet).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${formatDuration(Duration(minutes: minutes))} worked · $label',
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty) const Text('No shifts on this date.'),
              for (final entry in entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(sheet);
                    context.push('/work/add', extra: entry);
                  },
                  title: Text(employers[entry.employerId]?.name ?? 'Employer'),
                  subtitle: Text(
                    '${DateFormat('HH:mm').format(tz.TZDateTime.from(entry.startTimeUtc, location))} · ${entry.status.name}',
                  ),
                  trailing: Text(
                    formatDuration(
                      Duration(
                        minutes:
                            workingMinutesByLocalDay(entry, location)[day] ?? 0,
                      ),
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(sheet);
                  context.push('/review');
                },
                child: const Text('Review working-time checks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
