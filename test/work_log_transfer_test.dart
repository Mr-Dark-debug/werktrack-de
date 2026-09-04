import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:werktrack_de/database/app_database.dart' show AppDatabase;
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart';
import 'package:werktrack_de/features/export/work_log_transfer.dart';
import 'calculator_test_support.dart';

void main() {
  late AppDatabase database;
  late DriftWorkRepository repository;
  late WorkLogTransfer service;
  late tz.Location berlin;
  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });
  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftWorkRepository(database);
    service = WorkLogTransfer(database);
    await repository.saveEmployer(employer(id: 'target', rate: 9999));
  });
  tearDown(() => database.close());
  WorkEntry sample() => shift(
    id: 'source-id',
    employerId: 'source',
    start: tz.TZDateTime(berlin, 2026, 10, 25, 1),
    elapsed: const Duration(hours: 5),
    breakMinutes: 30,
    rate: 1703,
  ).copyWith(paidBreakMinutes: 15, notes: '=SUM(1,2)\nA "quote"\tß');

  for (final format in WorkLogFormat.values) {
    test(
      '${format.name} roundtrip preserves cents, breaks, DST instant and escaped multiline text',
      () async {
        final source = sample();
        final raw = service.encode(format, [source], [employer(id: 'source')]);
        final preview = await service.preview(raw, format, 'target');
        expect((await repository.watchEntries().first), isEmpty);
        expect(preview.entries.single.employerId, 'target');
        final result = await service.importLogs(raw, format, 'target');
        final saved = (await repository.watchEntries().first).single;
        expect(result.entries, hasLength(1));
        expect(saved.startTimeUtc.isAtSameMomentAs(source.startTimeUtc), true);
        expect(saved.endTimeUtc!.isAtSameMomentAs(source.endTimeUtc!), true);
        expect(saved.grossCents, source.grossCents);
        expect(saved.hourlyRateSnapshotCents, 1703);
        expect(saved.paidBreakMinutes, 15);
        expect(saved.notes, source.notes);
        expect(
          (await service.importLogs(raw, format, 'target')).duplicateCount,
          1,
        );
        expect(await repository.watchEntries().first, hasLength(1));
      },
    );
  }

  test(
    'same source id with changed content rejects entire batch without overwriting',
    () async {
      final original = service.encode(WorkLogFormat.json, [sample()], []);
      await service.importLogs(original, WorkLogFormat.json, 'target');
      final altered = sample().copyWith(notes: 'Changed');
      final other = sample().copyWith(
        id: 'new',
        startTimeUtc: DateTime.utc(2026, 10, 24),
        endTimeUtc: DateTime.utc(2026, 10, 24, 2),
      );
      await expectLater(
        service.importLogs(
          service.encode(WorkLogFormat.json, [other, altered], []),
          WorkLogFormat.json,
          'target',
        ),
        throwsFormatException,
      );
      expect(await repository.watchEntries().first, hasLength(1));
      expect(
        (await repository.watchEntries().first).single.notes,
        sample().notes,
      );
    },
  );

  test(
    'invalid row, date normalization and missing employer are rejected atomically',
    () async {
      final data =
          jsonDecode(
                service.encode(WorkLogFormat.json, [
                  sample(),
                  sample().copyWith(id: 'b'),
                ], []),
              )
              as Map<String, dynamic>;
      data['workEntries'][1]['paidBreakMinutes'] = 999;
      await expectLater(
        service.importLogs(jsonEncode(data), WorkLogFormat.json, 'target'),
        throwsFormatException,
      );
      data['workEntries'][1]['paidBreakMinutes'] = 0;
      data['workEntries'][1]['startTimeUtc'] = '2026-02-31T00:00:00Z';
      await expectLater(
        service.importLogs(jsonEncode(data), WorkLogFormat.json, 'target'),
        throwsFormatException,
      );
      await expectLater(
        service.importLogs(
          service.encode(WorkLogFormat.json, [sample()], []),
          WorkLogFormat.json,
          'missing',
        ),
        throwsFormatException,
      );
      expect(await repository.watchEntries().first, isEmpty);
    },
  );

  test(
    'duplicate rows and deleted records do not inflate totals or resurrect tombstones',
    () async {
      final raw = service.encode(WorkLogFormat.csv, [sample(), sample()], []);
      final first = await service.importLogs(raw, WorkLogFormat.csv, 'target');
      expect(first.entries, hasLength(1));
      expect(first.duplicateCount, 1);
      await repository.deleteEntry(first.entries.single.id);
      expect(
        (await service.importLogs(raw, WorkLogFormat.csv, 'target')).entries,
        isEmpty,
      );
      expect(await repository.watchEntries().first, isEmpty);
    },
  );

  test(
    'running timers are excluded; broken quotes rejected; formula text is escaped',
    () {
      final raw = service.encode(WorkLogFormat.csv, [
        sample(),
        sample().copyWith(status: WorkEntryStatus.active),
      ], []);
      expect(raw, contains("'=SUM"));
      expect(service.decode(raw, WorkLogFormat.csv, 'target'), hasLength(1));
      expect(
        () => service.decode('$raw\n"broken', WorkLogFormat.csv, 'target'),
        throwsFormatException,
      );
    },
  );
}
