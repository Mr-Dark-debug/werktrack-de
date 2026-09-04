import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  BoolColumn get isStudent => boolean().withDefault(const Constant(true))();
  BoolColumn get tracksResidenceAllowance =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Employers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get jobTitle => text()();
  TextColumn get employmentType => text()();
  IntColumn get hourlyRateCents => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get countsForResidenceLimit =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get countsForStudentHourRule =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isSocialInsuranceLiable =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get pensionExempt =>
      boolean().withDefault(const Constant(false))();
  IntColumn get taxClass => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkEntries extends Table {
  TextColumn get id => text()();
  TextColumn get employerId => text().references(Employers, #id)();
  DateTimeColumn get startTimeUtc => dateTime()();
  DateTimeColumn get endTimeUtc => dateTime().nullable()();
  TextColumn get timezone =>
      text().withDefault(const Constant('Europe/Berlin'))();
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  IntColumn get paidBreakMinutes => integer().withDefault(const Constant(0))();
  IntColumn get hourlyRateSnapshotCents => integer()();
  IntColumn get bonusCents => integer().withDefault(const Constant(0))();
  IntColumn get tipsCents => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get status => text()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AcademicPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get semesterName => text()();
  DateTimeColumn get semesterStart => dateTime()();
  DateTimeColumn get semesterEnd => dateTime()();
  DateTimeColumn get lectureStart => dateTime()();
  DateTimeColumn get lectureEnd => dateTime()();
  TextColumn get exceptionalLectureFreeJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Payslips extends Table {
  TextColumn get id => text()();
  TextColumn get employerId => text().references(Employers, #id)();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  IntColumn get grossCents => integer()();
  IntColumn get wageTaxCents => integer().withDefault(const Constant(0))();
  IntColumn get solidaritySurchargeCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get churchTaxCents => integer().withDefault(const Constant(0))();
  IntColumn get pensionCents => integer().withDefault(const Constant(0))();
  IntColumn get healthCents => integer().withDefault(const Constant(0))();
  IntColumn get careCents => integer().withDefault(const Constant(0))();
  IntColumn get unemploymentCents => integer().withDefault(const Constant(0))();
  IntColumn get otherDeductionsCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get netCents => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LegalRules extends Table {
  TextColumn get id => text()();
  TextColumn get key => text()();
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get sourceTitle => text()();
  DateTimeColumn get lastVerified => dateTime()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {key, effectiveFrom},
  ];
}

class PlannedShifts extends Table {
  TextColumn get id => text()();
  TextColumn get workEntryId => text().references(WorkEntries, #id)();
  BoolColumn get notificationScheduled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {key};
}

class SyncMetadata extends Table {
  TextColumn get entityId => text()();
  TextColumn get entityType => text()();
  TextColumn get deviceId => text()();
  TextColumn get status => text()();
  BoolColumn get tombstone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get localUpdatedAt => dateTime()();
  DateTimeColumn get remoteUpdatedAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {entityId, entityType};
}

@DriftDatabase(
  tables: [
    UserProfiles,
    Employers,
    WorkEntries,
    AcademicPeriods,
    Payslips,
    LegalRules,
    PlannedShifts,
    AppSettings,
    SyncMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedRules();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedRules() async {
    final verified = DateTime.utc(2026, 9, 2);
    final from = DateTime.utc(2026);
    final rules = <LegalRulesCompanion>[
      _rule(
        'minimum_wage',
        1390,
        'euro_cents_per_hour',
        from,
        verified,
        'https://www.bmas.de/DE/Arbeit/Arbeitsrecht/Mindestlohn/mindestlohn.html',
        'BMAS — General minimum wage',
      ),
      _rule(
        'minijob_monthly_limit',
        60300,
        'euro_cents',
        from,
        verified,
        'https://www.minijob-zentrale.de/DE/die-minijobs/mehrere-jobs/mehrere-jobs_node.html',
        'Minijob-Zentrale — Multiple jobs',
      ),
      _rule(
        'minijob_annual_limit',
        723600,
        'euro_cents',
        from,
        verified,
        'https://www.minijob-zentrale.de/DE/die-minijobs/mehrere-jobs/mehrere-jobs_node.html',
        'Minijob-Zentrale — Multiple jobs',
      ),
      _rule(
        'student_full_day_allowance',
        140,
        'full_days',
        from,
        verified,
        'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work',
        'Make it in Germany — Study and work',
      ),
      _rule(
        'student_half_day_allowance',
        280,
        'half_days',
        from,
        verified,
        'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work',
        'Make it in Germany — Study and work',
      ),
      _rule(
        'half_day_max_hours',
        240,
        'minutes',
        from,
        verified,
        'https://www.make-it-in-germany.com/en/study-vocational-training/studies-in-germany/work',
        'Make it in Germany — Study and work',
      ),
      _rule(
        'student_weekly_reference',
        1200,
        'minutes',
        from,
        verified,
        'https://www.tk.de/techniker/versicherung/gut-versichert-in-jeder-lebenslage/versichert-als-studierende/geld-verdienen-im-studium/beschaeftigte-studenten-2007410',
        'TK — Employed students',
      ),
      _rule(
        'werkstudent_exception_weeks',
        26,
        'weeks',
        from,
        verified,
        'https://www.tk.de/firmenkunden/versicherung/versicherung-faq/haeufige-fragen-zu-studenten-und-praktikanten/wie-oft-duerfen-werkstudenten-ueber-20-std-arbeiten-2036712',
        'TK — 26-week rule',
      ),
      _rule(
        'standard_daily_hours',
        480,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §3',
      ),
      _rule(
        'extended_daily_hours',
        600,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §3',
      ),
      _rule(
        'break_six_hour_trigger',
        360,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §4',
      ),
      _rule(
        'break_nine_hour_trigger',
        540,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §4',
      ),
      _rule(
        'break_six_to_nine',
        30,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §4',
      ),
      _rule(
        'break_above_nine',
        45,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §4',
      ),
      _rule(
        'minimum_daily_rest',
        660,
        'minutes',
        from,
        verified,
        'https://www.gesetze-im-internet.de/arbzg/BJNR117100994.html',
        'Working Time Act §5',
      ),
      _rule(
        'income_tax_basic_allowance',
        12348,
        'euro',
        from,
        verified,
        'https://www.gesetze-im-internet.de/estg/__32a.html',
        'Income Tax Act §32a',
      ),
    ];
    await batch(
      (batch) =>
          batch.insertAll(legalRules, rules, mode: InsertMode.insertOrIgnore),
    );
  }

  LegalRulesCompanion _rule(
    String key,
    double value,
    String unit,
    DateTime from,
    DateTime verified,
    String url,
    String title,
  ) => LegalRulesCompanion.insert(
    id: '${key}_${from.year}',
    key: key,
    effectiveFrom: from,
    value: value,
    unit: unit,
    sourceUrl: url,
    sourceTitle: title,
    lastVerified: verified,
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'werktrack.sqlite'));
  return NativeDatabase.createInBackground(file);
});
