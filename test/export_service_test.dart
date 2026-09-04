import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/database/app_database.dart' show AppDatabase;
import 'package:werktrack_de/domain/entities/academic_period.dart';
import 'package:werktrack_de/features/export/export_service.dart';

import 'calculator_test_support.dart';

void main() {
  late tz.Location berlin;

  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  test('CSV export contains payroll fields and escapes notes', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final job = employer(id: 'campus', rate: 1500);
    final entry = shift(
      employerId: job.id,
      start: tz.TZDateTime(berlin, 2026, 9, 3, 9),
      elapsed: const Duration(hours: 8),
      breakMinutes: 30,
      rate: 1500,
    ).copyWith(notes: 'Lab, "west"');
    final period = AcademicPeriod(
      id: 'summer',
      semesterName: 'Summer 2026',
      semesterStart: DateTime(2026, 4, 1),
      semesterEnd: DateTime(2026, 9, 30),
      lectureStart: DateTime(2026, 4, 13),
      lectureEnd: DateTime(2026, 7, 18),
      exceptionalLectureFreeJson: '[]',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    final csv = ExportService(database).buildCsv(
      entries: [entry],
      employers: [job],
      periods: [period],
      rules: rules2026,
      location: berlin,
    );

    expect(csv, contains('date,employer,jobTitle'));
    expect(csv, contains('"2026-09-03","campus"'));
    expect(csv, contains('"7.50","15.00","112.50"'));
    expect(csv, contains('"Lab, ""west"""'));
  });
}
