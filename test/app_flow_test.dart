import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:werktrack_de/app/providers.dart';
import 'package:werktrack_de/app/router.dart';
import 'package:werktrack_de/app/werk_track_app.dart';
import 'package:werktrack_de/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(tz_data.initializeTimeZones);

  testWidgets(
    'onboarding to employer, semester, shift and dashboard aggregate',
    (tester) async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      appRouter.go('/');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(database)],
          child: const WerkTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Know your work,\nnot just your shifts.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField).first, 'Alex');
      final onboardingList = find.byType(ListView).first;
      await tester.drag(onboardingList, const Offset(0, -420));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Hello, Alex'), findsOneWidget);

      appRouter.push('/employers/add');
      await tester.pumpAndSettle();
      final employerFields = find.byType(TextFormField);
      await tester.enterText(employerFields.at(0), 'Campus Lab');
      await tester.enterText(employerFields.at(1), 'Assistant');
      await tester.tap(find.text('Save employer'));
      await tester.pumpAndSettle();

      appRouter.push('/periods/add');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save academic period'));
      await tester.pumpAndSettle();

      appRouter.push('/work/add');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save completed shift'));
      await tester.pumpAndSettle();
      appRouter.go('/home');
      await tester.pumpAndSettle();

      expect(find.textContaining('7h 30m'), findsWidgets);
      expect(find.textContaining('€104'), findsOneWidget);

      // Dispose the provider streams while the test clock is still active.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    },
  );
}
