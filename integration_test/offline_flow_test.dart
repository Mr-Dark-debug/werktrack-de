import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/app/providers.dart';
import 'package:werktrack_de/app/router.dart';
import 'package:werktrack_de/app/werk_track_app.dart';
import 'package:werktrack_de/database/app_database.dart' show AppDatabase;
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/domain/calculators/residence_work_day_calculator.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';
import 'package:werktrack_de/features/export/export_service.dart';
import 'package:werktrack_de/features/export/work_log_transfer.dart';

import '../test/calculator_test_support.dart';

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await initializeDateFormatting();

  testWidgets(
    'offline UI, aggregation, simulation, CSV and timer disk-reopen flow',
    (tester) async {
      final temporary = await getTemporaryDirectory();
      final folder = await temporary.createTemp('werktrack-integration-');
      final file = File('${folder.path}/test.sqlite');
      var database = AppDatabase.forTesting(NativeDatabase(file));
      var repository = DriftWorkRepository(database);
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 1));
        await database.close();
        await folder.delete(recursive: true);
      });

      Future<void> mount() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(database)],
            child: const WerkTrackApp(),
          ),
        );
        await tester.pumpAndSettle();
      }

      appRouter.go('/');
      await mount();
      await tester.enterText(find.byType(TextField).first, 'Integration user');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(0, -700));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      appRouter.push('/periods/add');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save academic period'));
      await tester.pumpAndSettle();
      appRouter.push('/employers/add');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Campus Lab');
      await tester.enterText(find.byType(TextFormField).at(1), 'Assistant');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.tap(find.text('Save employer'));
      await tester.pumpAndSettle();
      appRouter.push('/work/add');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save completed shift'));
      await tester.pumpAndSettle();
      expect(find.textContaining('7h 30m'), findsWidgets);
      final first = (await repository.watchEntries().first).single;
      final originalGross = first.grossCents;
      await repository.saveEmployer(employer(id: first.employerId, rate: 2000));
      expect(
        (await repository.watchEntries().first).single.grossCents,
        originalGross,
      );

      final berlin = tz.getLocation('Europe/Berlin');
      final secondJob = employer(id: 'second-job', rate: 1800);
      await repository.saveEmployer(secondJob);
      final a = shift(
        id: 'a',
        employerId: first.employerId,
        start: tz.TZDateTime(berlin, 2026, 2, 10, 9),
        elapsed: const Duration(hours: 2),
      );
      final b = shift(
        id: 'b',
        employerId: secondJob.id,
        start: tz.TZDateTime(berlin, 2026, 2, 10, 13),
        elapsed: const Duration(hours: 2),
      );
      await repository.saveEntry(a);
      await repository.saveEntry(b);
      final jobs = await repository.watchEmployers().first;
      final residence = const ResidenceWorkDayCalculator().calculate(
        entries: [a, b],
        employers: {for (final job in jobs) job.id: job},
        rules: rules2026,
        location: berlin,
      );
      expect(residence.usedFullDayEquivalents, .5);

      appRouter.push('/can-i-work');
      await tester.pumpAndSettle();
      final beforePreview = (await repository.watchEntries().first).length;
      await tester.scrollUntilVisible(
        find.text('Simulate shift'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simulate shift'));
      await tester.pumpAndSettle();
      expect((await repository.watchEntries().first).length, beforePreview);
      await tester.scrollUntilVisible(
        find.text('Add planned'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add planned'));
      await tester.pumpAndSettle();
      final afterPlan = await repository.watchEntries().first;
      expect(
        afterPlan.where((entry) => entry.status == WorkEntryStatus.planned),
        hasLength(1),
      );
      expect(
        afterPlan.where((entry) => entry.status == WorkEntryStatus.completed),
        hasLength(3),
      );

      final csv = await ExportService(database).writeCsv(
        entries: afterPlan,
        employers: jobs,
        periods: await repository.watchAcademicPeriods().first,
        rules: rules2026,
        location: berlin,
      );
      final content = await csv.readAsString();
      expect(content, contains('hourlyRate,grossIncome,estimatedNet'));
      expect(content.split('\r\n'), hasLength(4));
      await csv.delete();

      final transfer = WorkLogTransfer(database);
      for (final format in WorkLogFormat.values) {
        final raw = transfer.encode(format, [first], jobs);
        final portable = File('${folder.path}/roundtrip.${format.name}');
        await portable.writeAsString(raw, flush: true);
        final imported = await transfer.importLogs(
          await portable.readAsString(),
          format,
          secondJob.id,
        );
        expect(imported.entries.length + imported.duplicateCount, 1);
      }
      expect(
        (await repository.watchEntries().first).where(
          (e) => e.status == WorkEntryStatus.completed,
        ),
        hasLength(4),
      );

      if (const bool.fromEnvironment('CAPTURE_DEVICE_QA')) {
        await binding.convertFlutterSurfaceToImage();
        for (final route in ['/home', '/work', '/calendar']) {
          appRouter.go(route);
          await tester.pumpAndSettle();
          await binding.takeScreenshot(route.substring(1));
        }
      }

      appRouter.go('/work?timer=true');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Start timer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start timer'));
      await tester.pumpAndSettle();
      final active = (await repository.watchEntries().first).singleWhere(
        (entry) => entry.status == WorkEntryStatus.active,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
      await database.close();
      database = AppDatabase.forTesting(NativeDatabase(file));
      repository = DriftWorkRepository(database);
      final resumed = (await repository.watchEntries().first).singleWhere(
        (entry) => entry.status == WorkEntryStatus.active,
      );
      expect(resumed.startTimeUtc, active.startTimeUtc);
      await mount();
      await tester.ensureVisible(find.text('Stop & save shift'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stop & save shift'));
      await tester.pumpAndSettle();
      expect(
        (await repository.watchEntries().first).where(
          (entry) => entry.status == WorkEntryStatus.active,
        ),
        isEmpty,
      );
      for (final route in [
        '/calendar',
        '/insights',
        '/settings',
        '/income',
        '/profile',
        '/rules',
        '/review',
        '/sync',
        '/export',
      ]) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Screen $route must render on the compact Android device.',
        );
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    },
  );
}
