import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  static const timerReminderId = 91001;

  Future<void> scheduleTimerReminder(DateTime startedAt) async {
    await initialize();
    final due = startedAt.toUtc().add(const Duration(hours: 12));
    if (!due.isAfter(DateTime.now().toUtc())) {
      return show(
        id: timerReminderId,
        title: 'Timer still running',
        body:
            'Your work timer has been running for more than 12 hours. Review it when you can.',
      );
    }
    await _plugin.zonedSchedule(
      id: timerReminderId,
      title: 'Timer still running',
      body: 'Your work timer has reached 12 hours. Review it when you can.',
      scheduledDate: tz.TZDateTime.from(due, tz.getLocation('Europe/Berlin')),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_reminders',
          'Timer reminders',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelTimerReminder() async {
    await initialize();
    await _plugin.cancel(id: timerReminderId);
  }

  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  Future<void> initialize() async {
    if (_initialized) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_werktrack'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: false, sound: true);
    return android ?? ios ?? true;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'threshold_advisories',
        'Threshold advisories',
        channelDescription:
            'Configurable reminders about tracked work references.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
