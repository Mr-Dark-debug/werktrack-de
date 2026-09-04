import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../domain/calculators/student_weekly_hours_calculator.dart';
import '../../domain/rules/legal_rule_book.dart';
import '../../domain/entities/work_entry.dart';
import '../../domain/repositories/work_repository.dart';
import 'local_notification_service.dart';

class AdvisoryNotification {
  const AdvisoryNotification(this.key, this.title, this.body);
  final String key;
  final String title;
  final String body;
}

class NotificationAdvisor {
  const NotificationAdvisor();

  List<AdvisoryNotification> evaluate(
    DashboardData data,
    Iterable<WorkEntry> entries,
  ) {
    final items = <AdvisoryNotification>[];
    final weeklyRatio = data.weekMinutes / data.weekReferenceMinutes;
    if (weeklyRatio >= .75) {
      items.add(
        AdvisoryNotification(
          'weekly-${weeklyRatio > 1 ? 'review' : 'approaching'}',
          weeklyRatio > 1
              ? 'Weekly reference exceeded'
              : 'Weekly reference approaching',
          '${(data.weekMinutes / 60).toStringAsFixed(1)} hours are tracked this ISO week. Review may be required.',
        ),
      );
    }
    if (data.minijob.monthlyEarningsCents >=
            data.minijob.monthlyReferenceCents * .9 ||
        data.minijob.projectedRegularEarningsCents >
            data.minijob.annualReferenceCents) {
      items.add(
        const AdvisoryNotification(
          'minijob-projection',
          'Minijob reference update',
          'Tracked or projected earnings are near a configured reference. A single month does not determine status.',
        ),
      );
    }
    if (data.residence.remainingFullDayEquivalents <= 20) {
      items.add(
        AdvisoryNotification(
          'residence-milestone',
          'Residence allowance milestone',
          '${data.residence.remainingFullDayEquivalents.toStringAsFixed(1)} configured full-day equivalents remain.',
        ),
      );
    }
    final staleTimer = entries.where(
      (e) =>
          e.status == WorkEntryStatus.active &&
          DateTime.now().toUtc().difference(e.startTimeUtc) >
              const Duration(hours: 12),
    );
    if (staleTimer.isNotEmpty) {
      items.add(
        const AdvisoryNotification(
          'long-running-timer',
          'Timer still running',
          'An active work timer has been running for more than 12 hours.',
        ),
      );
    }
    return items;
  }
}

class NotificationCoordinator {
  NotificationCoordinator({required this.repository, required this.service});
  final WorkRepository repository;
  final LocalNotificationService service;
  bool _processing = false;

  Future<void> process(DashboardData data, Iterable<WorkEntry> entries) async {
    if (_processing) return;
    _processing = true;
    try {
      if (await repository.readSetting('notificationsEnabled') != 'true') {
        return;
      }
      final location = tz.getLocation('Europe/Berlin');
      final date = tz.TZDateTime.now(location);
      final day = '${date.year}-${date.month}-${date.day}';
      final profile = await repository.watchProfile().first;
      final advisories = const NotificationAdvisor()
          .evaluate(data, entries)
          .where(
            (item) =>
                !(profile?.isStudent == false &&
                    item.key.startsWith('weekly')) &&
                !(profile?.tracksResidenceAllowance == false &&
                    item.key.startsWith('residence')),
          )
          .toList();
      final plans = entries
          .where((entry) => entry.status == WorkEntryStatus.planned)
          .toList();
      if (plans.isNotEmpty && profile?.isStudent != false) {
        final book = LegalRuleBook(await repository.watchLegalRules().first);
        final rules = book.forDate(date);
        if (rules != null) {
          final employers = await repository.watchEmployers().first;
          final preview = const StudentWeeklyHoursCalculator().calculate(
            entries: entries.map(
              (entry) => entry.status == WorkEntryStatus.planned
                  ? entry.copyWith(status: WorkEntryStatus.completed)
                  : entry,
            ),
            employers: {for (final job in employers) job.id: job},
            rules: rules,
            location: location,
            ruleResolver: book.forDate,
          );
          final planWeeks = plans
              .map(
                (entry) => IsoWeekKey.fromDate(
                  tz.TZDateTime.from(entry.startTimeUtc, location),
                ),
              )
              .toSet();
          for (final week in planWeeks) {
            if (!preview.unresolvedWeeks.contains(week) &&
                preview.stateFor(week) == WeeklyHourState.reviewRequired) {
              advisories.add(
                AdvisoryNotification(
                  'planned-$week',
                  'Planned work crosses a weekly reference',
                  '$week would contain ${((preview.minutesByWeek[week] ?? 0) / 60).toStringAsFixed(1)} tracked hours including plans. Review may be required.',
                ),
              );
            }
          }
        }
      }
      for (final advisory in advisories) {
        final sentKey = 'notificationSent:${advisory.key}:$day';
        if (await repository.readSetting(sentKey) == 'true') continue;
        await service.show(
          id: advisory.key.hashCode & 0x7fffffff,
          title: advisory.title,
          body: advisory.body,
        );
        await repository.writeSetting(sentKey, 'true');
      }
    } catch (_) {
      // Notification availability must never prevent local work tracking.
      // Unsent advisories are retried on a later data refresh.
    } finally {
      _processing = false;
    }
  }
}
