import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/database/app_database.dart';
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/domain/entities/work_entry.dart' as domain;
import 'package:werktrack_de/features/export/export_service.dart';
import 'package:werktrack_de/domain/entities/legal_rule.dart' as legal;
import 'package:werktrack_de/domain/rules/legal_rule_book.dart';

import 'calculator_test_support.dart';

void main() {
  late AppDatabase database;
  late DriftWorkRepository repository;
  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftWorkRepository(database);
    await database.customSelect('SELECT 1').get();
  });
  tearDown(() => database.close());

  test(
    'edit and tombstone update repository streams without losing rate snapshot',
    () async {
      final item = employer(rate: 1390);
      await repository.saveEmployer(item);
      final start = DateTime.utc(2026, 9, 1, 8);
      final entry = domain.WorkEntry(
        id: 'entry',
        employerId: item.id,
        startTimeUtc: start,
        endTimeUtc: start.add(const Duration(hours: 2)),
        timezone: 'Europe/Berlin',
        breakMinutes: 0,
        paidBreakMinutes: 0,
        hourlyRateSnapshotCents: item.hourlyRateCents,
        bonusCents: 0,
        tipsCents: 0,
        notes: '',
        status: domain.WorkEntryStatus.completed,
        createdAt: start,
        updatedAt: start,
      );
      await repository.saveEntry(entry);
      await repository.saveEmployer(employer(rate: 2000));
      expect((await repository.watchEntries().first).single.grossCents, 2780);
      await repository.saveEntry(
        entry.copyWith(
          endTimeUtc: start.add(const Duration(hours: 3)),
          updatedAt: start.add(const Duration(hours: 4)),
        ),
      );
      expect((await repository.watchEntries().first).single.grossCents, 4170);
      await repository.deleteEntry(entry.id);
      expect(await repository.watchEntries().first, isEmpty);
      await repository.restoreEntry(entry.id);
      expect((await repository.watchEntries().first).single.id, entry.id);
    },
  );

  test('database seeds date-versioned legal rules', () async {
    final rules = await repository.watchLegalRules().first;
    expect(
      rules.where((rule) => rule.key == 'minimum_wage').single.value,
      1390,
    );
    expect(
      rules
          .where((rule) => rule.key == 'student_full_day_allowance')
          .single
          .value,
      140,
    );
  });

  test(
    'profile preferences and name persist through repository reads',
    () async {
      await repository.completeOnboarding(
        'Sam',
        isStudent: false,
        tracksResidenceAllowance: false,
      );
      final profile = await repository.watchProfile().first;
      expect(profile!.displayName, 'Sam');
      expect(profile.isStudent, isFalse);
      expect(profile.tracksResidenceAllowance, isFalse);
      expect(await repository.watchOnboardingComplete().first, isTrue);
    },
  );

  test('new legal version preserves the original date-scoped value', () async {
    final original = (await repository.watchLegalRules().first).firstWhere(
      (rule) => rule.key == 'minimum_wage',
    );
    await repository.addLegalRuleVersion(
      legal.LegalRule(
        id: 'new-version',
        key: original.key,
        effectiveFrom: DateTime.utc(2027),
        value: 2000,
        unit: original.unit,
        sourceUrl: original.sourceUrl,
        sourceTitle: 'Test override',
        lastVerified: DateTime.utc(2026),
        metadataJson: '{"manualOverride":true}',
      ),
    );
    final book = LegalRuleBook(await repository.watchLegalRules().first);
    expect(book.ruleFor('minimum_wage', DateTime(2026, 12, 31))!.value, 1390);
    expect(book.ruleFor('minimum_wage', DateTime(2027, 1, 1))!.value, 2000);
  });

  test(
    'invalid backup is rejected before current records are changed',
    () async {
      await repository.saveEmployer(employer(id: 'safe-record'));
      await expectLater(
        ExportService(database).restoreCompleteBackup('{"schemaVersion":999}'),
        throwsA(isA<FormatException>()),
      );
      expect(
        (await repository.watchEmployers().first).single.id,
        'safe-record',
      );
    },
  );
}
