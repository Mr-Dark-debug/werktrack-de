import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/academic_period.dart';
import '../domain/entities/employer.dart' as domain;
import '../domain/entities/legal_rule.dart';
import '../domain/entities/payslip.dart' as domain;
import '../domain/entities/work_entry.dart' as domain;
import '../domain/entities/user_profile.dart';
import '../domain/repositories/work_repository.dart';
import 'app_database.dart' as db;

class DriftWorkRepository implements WorkRepository {
  DriftWorkRepository(this.database);
  final db.AppDatabase database;

  @override
  Stream<List<domain.Employer>> watchEmployers() =>
      (database.select(database.employers)
            ..where((t) => t.deleted.equals(false)))
          .watch()
          .map((rows) => rows.map(_employer).toList());

  @override
  Stream<List<domain.WorkEntry>> watchEntries() =>
      (database.select(database.workEntries)
            ..where((t) => t.deleted.equals(false)))
          .watch()
          .map((rows) => rows.map(_entry).toList());

  @override
  Stream<List<AcademicPeriod>> watchAcademicPeriods() => database
      .select(database.academicPeriods)
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => AcademicPeriod(
                id: row.id,
                semesterName: row.semesterName,
                semesterStart: row.semesterStart,
                semesterEnd: row.semesterEnd,
                lectureStart: row.lectureStart,
                lectureEnd: row.lectureEnd,
                exceptionalLectureFreeJson: row.exceptionalLectureFreeJson,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ),
            )
            .toList(),
      );

  @override
  Stream<List<domain.Payslip>> watchPayslips() => database
      .select(database.payslips)
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => domain.Payslip(
                id: row.id,
                employerId: row.employerId,
                month: row.month,
                year: row.year,
                grossCents: row.grossCents,
                wageTaxCents: row.wageTaxCents,
                solidaritySurchargeCents: row.solidaritySurchargeCents,
                churchTaxCents: row.churchTaxCents,
                pensionCents: row.pensionCents,
                healthCents: row.healthCents,
                careCents: row.careCents,
                unemploymentCents: row.unemploymentCents,
                otherDeductionsCents: row.otherDeductionsCents,
                netCents: row.netCents,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ),
            )
            .toList(),
      );

  @override
  Stream<List<LegalRule>> watchLegalRules() => database
      .select(database.legalRules)
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => LegalRule(
                id: row.id,
                key: row.key,
                effectiveFrom: row.effectiveFrom,
                effectiveTo: row.effectiveTo,
                value: row.value,
                unit: row.unit,
                sourceUrl: row.sourceUrl,
                sourceTitle: row.sourceTitle,
                lastVerified: row.lastVerified,
                metadataJson: row.metadataJson,
              ),
            )
            .toList(),
      );

  @override
  Stream<bool> watchOnboardingComplete() => database
      .select(database.userProfiles)
      .watch()
      .map((rows) => rows.isNotEmpty && rows.first.onboardingComplete);

  @override
  Stream<UserProfile?> watchProfile() => database
      .select(database.userProfiles)
      .watch()
      .map(
        (rows) => rows.isEmpty
            ? null
            : UserProfile(
                displayName: rows.first.displayName,
                isStudent: rows.first.isStudent,
                tracksResidenceAllowance: rows.first.tracksResidenceAllowance,
              ),
      );

  @override
  Future<void> completeOnboarding(
    String displayName, {
    bool isStudent = true,
    bool tracksResidenceAllowance = true,
  }) async {
    final now = DateTime.now().toUtc();
    final existing =
        (await database.select(database.userProfiles).get()).firstOrNull;
    await database
        .into(database.userProfiles)
        .insertOnConflictUpdate(
          db.UserProfilesCompanion.insert(
            id: existing?.id ?? const Uuid().v4(),
            displayName: Value(displayName.trim()),
            isStudent: Value(isStudent),
            tracksResidenceAllowance: Value(tracksResidenceAllowance),
            onboardingComplete: const Value(true),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> saveEmployer(domain.Employer employer) => database
      .into(database.employers)
      .insertOnConflictUpdate(
        db.EmployersCompanion.insert(
          id: employer.id,
          name: employer.name,
          jobTitle: employer.jobTitle,
          employmentType: employer.employmentType.name,
          hourlyRateCents: employer.hourlyRateCents,
          startDate: employer.startDate,
          endDate: Value(employer.endDate),
          isActive: Value(employer.isActive),
          countsForResidenceLimit: Value(employer.countsForResidenceLimit),
          countsForStudentHourRule: Value(employer.countsForStudentHourRule),
          isSocialInsuranceLiable: Value(employer.isSocialInsuranceLiable),
          pensionExempt: Value(employer.pensionExempt),
          taxClass: Value(employer.taxClass),
          notes: Value(employer.notes),
          createdAt: employer.createdAt,
          updatedAt: employer.updatedAt,
        ),
      );

  @override
  Future<void> saveEntry(domain.WorkEntry entry) => database
      .into(database.workEntries)
      .insertOnConflictUpdate(
        db.WorkEntriesCompanion.insert(
          id: entry.id,
          employerId: entry.employerId,
          startTimeUtc: entry.startTimeUtc,
          endTimeUtc: Value(entry.endTimeUtc),
          timezone: Value(entry.timezone),
          breakMinutes: Value(entry.breakMinutes),
          paidBreakMinutes: Value(entry.paidBreakMinutes),
          hourlyRateSnapshotCents: entry.hourlyRateSnapshotCents,
          bonusCents: Value(entry.bonusCents),
          tipsCents: Value(entry.tipsCents),
          notes: Value(entry.notes),
          status: entry.status.name,
          createdAt: entry.createdAt,
          updatedAt: entry.updatedAt,
        ),
      );

  @override
  Future<void> saveAcademicPeriod(AcademicPeriod period) => database
      .into(database.academicPeriods)
      .insertOnConflictUpdate(
        db.AcademicPeriodsCompanion.insert(
          id: period.id,
          semesterName: period.semesterName,
          semesterStart: period.semesterStart,
          semesterEnd: period.semesterEnd,
          lectureStart: period.lectureStart,
          lectureEnd: period.lectureEnd,
          exceptionalLectureFreeJson: Value(period.exceptionalLectureFreeJson),
          createdAt: period.createdAt,
          updatedAt: period.updatedAt,
        ),
      );

  @override
  Future<void> savePayslip(domain.Payslip payslip) => database
      .into(database.payslips)
      .insertOnConflictUpdate(
        db.PayslipsCompanion.insert(
          id: payslip.id,
          employerId: payslip.employerId,
          month: payslip.month,
          year: payslip.year,
          grossCents: payslip.grossCents,
          wageTaxCents: Value(payslip.wageTaxCents),
          solidaritySurchargeCents: Value(payslip.solidaritySurchargeCents),
          churchTaxCents: Value(payslip.churchTaxCents),
          pensionCents: Value(payslip.pensionCents),
          healthCents: Value(payslip.healthCents),
          careCents: Value(payslip.careCents),
          unemploymentCents: Value(payslip.unemploymentCents),
          otherDeductionsCents: Value(payslip.otherDeductionsCents),
          netCents: payslip.netCents,
          createdAt: payslip.createdAt,
          updatedAt: payslip.updatedAt,
        ),
      );

  @override
  Future<void> deleteEntry(String id) async {
    await (database.update(
      database.workEntries,
    )..where((t) => t.id.equals(id))).write(
      db.WorkEntriesCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> addLegalRuleVersion(LegalRule rule) => database
      .into(database.legalRules)
      .insert(
        db.LegalRulesCompanion.insert(
          id: rule.id,
          key: rule.key,
          effectiveFrom: rule.effectiveFrom,
          effectiveTo: Value(rule.effectiveTo),
          value: rule.value.toDouble(),
          unit: rule.unit,
          sourceUrl: rule.sourceUrl,
          sourceTitle: rule.sourceTitle,
          lastVerified: rule.lastVerified,
          metadataJson: Value(rule.metadataJson),
        ),
      );

  @override
  Future<void> restoreEntry(String id) async {
    await (database.update(
      database.workEntries,
    )..where((t) => t.id.equals(id))).write(
      db.WorkEntriesCompanion(
        deleted: const Value(false),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<String?> readSetting(String key) async =>
      (database.select(database.appSettings)..where((t) => t.key.equals(key)))
          .getSingleOrNull()
          .then((value) => value?.valueJson);

  @override
  Future<void> writeSetting(String key, String valueJson) => database
      .into(database.appSettings)
      .insertOnConflictUpdate(
        db.AppSettingsCompanion.insert(
          key: key,
          valueJson: valueJson,
          updatedAt: DateTime.now().toUtc(),
        ),
      );

  domain.Employer _employer(db.Employer row) => domain.Employer(
    id: row.id,
    name: row.name,
    jobTitle: row.jobTitle,
    employmentType: domain.EmploymentType.values.byName(row.employmentType),
    hourlyRateCents: row.hourlyRateCents,
    startDate: row.startDate,
    endDate: row.endDate,
    isActive: row.isActive,
    countsForResidenceLimit: row.countsForResidenceLimit,
    countsForStudentHourRule: row.countsForStudentHourRule,
    isSocialInsuranceLiable: row.isSocialInsuranceLiable,
    pensionExempt: row.pensionExempt,
    taxClass: row.taxClass,
    notes: row.notes,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  domain.WorkEntry _entry(db.WorkEntry row) => domain.WorkEntry(
    id: row.id,
    employerId: row.employerId,
    startTimeUtc: row.startTimeUtc.toUtc(),
    endTimeUtc: row.endTimeUtc?.toUtc(),
    timezone: row.timezone,
    breakMinutes: row.breakMinutes,
    paidBreakMinutes: row.paidBreakMinutes,
    hourlyRateSnapshotCents: row.hourlyRateSnapshotCents,
    bonusCents: row.bonusCents,
    tipsCents: row.tipsCents,
    notes: row.notes,
    status: domain.WorkEntryStatus.values.byName(row.status),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
