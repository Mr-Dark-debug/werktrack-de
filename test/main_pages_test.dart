import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/app/providers.dart';
import 'package:werktrack_de/app/router.dart';
import 'package:werktrack_de/app/werk_track_app.dart';
import 'package:werktrack_de/database/app_database.dart' show AppDatabase;
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';

import 'calculator_test_support.dart';

void main() {
  setUpAll(() async {
    tz_data.initializeTimeZones();
    await initializeDateFormatting();
  });

  testWidgets(
    'compact pages: unobstructed navigation, rounded search, filters and Kalender views',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 1));
        await database.close();
      });
      final repository = DriftWorkRepository(database);
      await repository.completeOnboarding('Alex');
      await repository.saveEmployer(employer(id: 'Campus Lab'));
      await repository.saveEmployer(employer(id: 'Studio'));
      final berlin = tz.getLocation('Europe/Berlin');
      final now = tz.TZDateTime.now(berlin);
      await repository.saveEntry(
        shift(
          id: 'saved',
          employerId: 'Campus Lab',
          start: tz.TZDateTime(berlin, now.year, now.month, now.day, 8),
          elapsed: const Duration(hours: 4),
        ),
      );
      await repository.saveEntry(
        shift(
          id: 'planned',
          employerId: 'Studio',
          start: tz.TZDateTime(berlin, now.year, now.month, now.day + 1, 10),
          elapsed: const Duration(hours: 3),
          status: WorkEntryStatus.planned,
        ),
      );
      appRouter.go('/home');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(database)],
          child: const WerkTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      final fab = tester.getRect(find.byType(FloatingActionButton));
      final nav = tester.getRect(find.byType(NavigationBar));
      expect(
        fab.bottom,
        lessThan(nav.top),
        reason:
            'The + button must sit entirely above all navigation destinations.',
      );
      expect(find.text('Monthly hours'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.work_rounded));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('work-search')), findsOneWidget);
      expect(find.text('Start timer'), findsNothing);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Planned'));
      await tester.pumpAndSettle();
      expect(find.text('Campus Lab'), findsNothing);
      expect(find.text('Studio'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('work-search')), 'No match');
      await tester.pumpAndSettle();
      expect(find.text('No shifts match this view.'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_month_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(KalenderView), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Month must render without layout errors',
      );
      for (final name in ['Week', 'Day', 'Month']) {
        await tester.tap(find.byTooltip('Calendar view'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(name).last);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '$name must render without layout errors',
        );
      }
      await tester.tap(find.byTooltip('Next period'));
      await tester.pumpAndSettle();
      final next = DateTime(now.year, now.month + 1);
      expect(find.text(DateFormat('MMMM yyyy').format(next)), findsOneWidget);
      await tester.tap(find.byTooltip('Today'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    },
  );
}
