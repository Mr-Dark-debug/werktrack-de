import 'package:flutter/material.dart';
import 'package:werktrack_de/database/app_database.dart' show AppDatabase;
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';

import '../test/calculator_test_support.dart';

/// Install once with adb, launch, force-stop, then launch the same APK again.
/// Unlike `flutter test`, adb does not uninstall the app during test cleanup.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!const bool.fromEnvironment('ENABLE_RESTART_HARNESS')) {
    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('QA harness disabled'))),
      ),
    );
    return;
  }
  final database = AppDatabase();
  final repository = DriftWorkRepository(database);
  String result;
  try {
    final expected = await repository.readSetting('test.restart.timestamp');
    if (expected == null) {
      final job = employer(id: 'restart-test-employer');
      final now = DateTime.now().toUtc();
      await repository.saveEmployer(job);
      await repository.saveEntry(
        WorkEntry(
          id: 'restart-test-entry',
          employerId: job.id,
          startTimeUtc: now,
          timezone: 'Europe/Berlin',
          breakMinutes: 0,
          paidBreakMinutes: 0,
          hourlyRateSnapshotCents: job.hourlyRateCents,
          bonusCents: 0,
          tipsCents: 0,
          notes: 'Automated process-restart fixture',
          status: WorkEntryStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final stored = (await repository.watchEntries().first).firstWhere(
        (entry) => entry.id == 'restart-test-entry',
      );
      await repository.writeSetting(
        'test.restart.timestamp',
        stored.startTimeUtc.toUtc().toIso8601String(),
      );
      result = 'RESTART_TEST_SEEDED';
    } else {
      final active = (await repository.watchEntries().first).firstWhere(
        (entry) => entry.id == 'restart-test-entry',
      );
      if (active.status != WorkEntryStatus.active ||
          active.startTimeUtc.toUtc().toIso8601String() != expected) {
        throw StateError(
          'Persisted active timer does not match the first process.',
        );
      }
      result = 'RESTART_TEST_PASS';
    }
  } catch (error) {
    result = 'RESTART_TEST_FAIL: $error';
  } finally {
    await database.close();
  }
  debugPrint(result);
  runApp(
    MaterialApp(
      home: Scaffold(body: Center(child: Text(result))),
    ),
  );
}
