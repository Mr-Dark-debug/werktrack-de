import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../database/app_database.dart' as db;
import '../../domain/calculators/academic_context_calculator.dart';
import '../../domain/calculators/residence_work_day_calculator.dart';
import '../../domain/calculators/student_weekly_hours_calculator.dart';
import '../../domain/entities/academic_period.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';
import '../../domain/rules/resolved_rules.dart';

class ExportService {
  const ExportService(this.database);
  final db.AppDatabase database;

  Future<File> writeCsv({
    required List<WorkEntry> entries,
    required List<Employer> employers,
    required List<AcademicPeriod> periods,
    required ResolvedRules rules,
    required tz.Location location,
  }) => _write(
    'werktrack-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.csv',
    buildCsv(
      entries: entries,
      employers: employers,
      periods: periods,
      rules: rules,
      location: location,
    ),
  );

  String buildCsv({
    required List<WorkEntry> entries,
    required List<Employer> employers,
    required List<AcademicPeriod> periods,
    required ResolvedRules rules,
    required tz.Location location,
  }) {
    final byId = {for (final e in employers) e.id: e};
    final residence = const ResidenceWorkDayCalculator().calculate(
      entries: entries,
      employers: byId,
      rules: rules,
      location: location,
    );
    final lines = <String>[
      'date,employer,jobTitle,start,end,breakMinutes,paidHours,hourlyRate,grossIncome,estimatedNet,semesterStatus,ISOWeek,residenceDayEquivalent,notes',
    ];
    for (final entry in entries.where(
      (e) => e.status == WorkEntryStatus.completed,
    )) {
      final localStart = tz.TZDateTime.from(entry.startTimeUtc, location);
      final localEnd = entry.endTimeUtc == null
          ? null
          : tz.TZDateTime.from(entry.endTimeUtc!, location);
      final employer = byId[entry.employerId];
      final day = DateTime(localStart.year, localStart.month, localStart.day);
      final context = const AcademicContextCalculator().contextFor(
        day,
        periods,
      );
      final week = IsoWeekKey.fromDate(day);
      lines.add(
        [
          DateFormat('yyyy-MM-dd').format(day),
          employer?.name ?? '',
          employer?.jobTitle ?? '',
          DateFormat('HH:mm').format(localStart),
          localEnd == null ? '' : DateFormat('HH:mm').format(localEnd),
          entry.breakMinutes,
          (entry.paidDuration.inMinutes / 60).toStringAsFixed(2),
          (entry.hourlyRateSnapshotCents / 100).toStringAsFixed(2),
          (entry.grossCents / 100).toStringAsFixed(2),
          '',
          context.name,
          week.toString(),
          ((residence.byDate[day] ?? 0) / 2).toStringAsFixed(1),
          entry.notes,
        ].map((value) => _csv(value.toString())).join(','),
      );
    }
    return lines.join('\r\n');
  }

  Future<File> writeJsonExport({
    required List<WorkEntry> entries,
    required List<Employer> employers,
  }) => _write(
    'werktrack-export-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.json',
    const JsonEncoder.withIndent('  ').convert({
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'employers': employers.map(_domainEmployerJson).toList(),
      'workEntries': entries.map(_domainEntryJson).toList(),
    }),
  );

  Future<File> writeCompleteBackup() async {
    final payload = {
      'schemaVersion': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'userProfiles': (await database.select(database.userProfiles).get())
          .map((e) => e.toJson())
          .toList(),
      'employers': (await database.select(database.employers).get())
          .map((e) => e.toJson())
          .toList(),
      'workEntries': (await database.select(database.workEntries).get())
          .map((e) => e.toJson())
          .toList(),
      'academicPeriods': (await database.select(database.academicPeriods).get())
          .map((e) => e.toJson())
          .toList(),
      'payslips': (await database.select(database.payslips).get())
          .map((e) => e.toJson())
          .toList(),
      'legalRules': (await database.select(database.legalRules).get())
          .map((e) => e.toJson())
          .toList(),
      'plannedShifts': (await database.select(database.plannedShifts).get())
          .map((e) => e.toJson())
          .toList(),
      'appSettings': (await database.select(database.appSettings).get())
          .map((e) => e.toJson())
          .toList(),
      'syncMetadata': (await database.select(database.syncMetadata).get())
          .map((e) => e.toJson())
          .toList(),
    };
    return _write(
      'werktrack-backup-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.json',
      const JsonEncoder.withIndent('  ').convert(payload),
    );
  }

  Future<void> restoreCompleteBackup(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup root must be an object.');
    }
    _validate(decoded);
    List<Map<String, dynamic>> list(String key) =>
        (decoded[key] as List<dynamic>).cast<Map<String, dynamic>>();
    final profiles = list('userProfiles').map(db.UserProfile.fromJson).toList();
    final employers = list('employers').map(db.Employer.fromJson).toList();
    final entries = list('workEntries').map(db.WorkEntry.fromJson).toList();
    final periods = list(
      'academicPeriods',
    ).map(db.AcademicPeriod.fromJson).toList();
    final payslips = list('payslips').map(db.Payslip.fromJson).toList();
    final rules = list('legalRules').map(db.LegalRule.fromJson).toList();
    final planned = list(
      'plannedShifts',
    ).map(db.PlannedShift.fromJson).toList();
    final settings = list('appSettings').map(db.AppSetting.fromJson).toList();
    final sync = list(
      'syncMetadata',
    ).map(db.SyncMetadataData.fromJson).toList();
    final employerIds = employers.map((row) => row.id).toSet();
    final workIds = entries.map((row) => row.id).toSet();
    if (payslips.any((row) => !employerIds.contains(row.employerId)) ||
        planned.any((row) => !workIds.contains(row.workEntryId))) {
      throw const FormatException(
        'A backup record references a missing parent.',
      );
    }
    if (employers.any((row) => row.hourlyRateCents < 0) ||
        rules.any((row) => !row.value.isFinite || row.value <= 0)) {
      throw const FormatException('Backup rates or rule values are invalid.');
    }
    for (final entry in entries) {
      final duration = entry.endTimeUtc
          ?.difference(entry.startTimeUtc)
          .inMinutes;
      if (!WorkEntryStatus.values.any(
            (status) => status.name == entry.status,
          ) ||
          entry.breakMinutes < 0 ||
          entry.paidBreakMinutes < 0 ||
          entry.paidBreakMinutes > entry.breakMinutes ||
          entry.hourlyRateSnapshotCents < 0 ||
          (duration != null &&
              (duration < 0 || entry.breakMinutes > duration))) {
        throw const FormatException(
          'A work record has invalid time, break, rate or status data.',
        );
      }
    }
    await database.transaction(() async {
      await database.delete(database.plannedShifts).go();
      await database.delete(database.syncMetadata).go();
      await database.delete(database.payslips).go();
      await database.delete(database.workEntries).go();
      await database.delete(database.academicPeriods).go();
      await database.delete(database.employers).go();
      await database.delete(database.userProfiles).go();
      await database.delete(database.appSettings).go();
      await database.delete(database.legalRules).go();
      await database.batch((batch) {
        batch.insertAll(database.userProfiles, profiles);
        batch.insertAll(database.employers, employers);
        batch.insertAll(database.workEntries, entries);
        batch.insertAll(database.academicPeriods, periods);
        batch.insertAll(database.payslips, payslips);
        batch.insertAll(database.legalRules, rules);
        batch.insertAll(database.plannedShifts, planned);
        batch.insertAll(database.appSettings, settings);
        batch.insertAll(database.syncMetadata, sync);
      });
    });
  }

  void _validate(Map<String, dynamic> data) {
    if (data['schemaVersion'] != 1) {
      throw const FormatException('Unsupported backup schema version.');
    }
    const keys = [
      'userProfiles',
      'employers',
      'workEntries',
      'academicPeriods',
      'payslips',
      'legalRules',
      'plannedShifts',
      'appSettings',
      'syncMetadata',
    ];
    for (final key in keys) {
      if (data[key] is! List<dynamic>) {
        throw FormatException('Backup section "$key" is missing or invalid.');
      }
    }
    final employerIds = (data['employers'] as List<dynamic>)
        .map((e) => (e as Map<String, dynamic>)['id'])
        .toSet();
    for (final entry in data['workEntries'] as List<dynamic>) {
      if (!employerIds.contains(
        (entry as Map<String, dynamic>)['employerId'],
      )) {
        throw const FormatException(
          'A work entry references a missing employer.',
        );
      }
    }
    if ((data['legalRules'] as List<dynamic>).isEmpty) {
      throw const FormatException('Backup contains no legal rule versions.');
    }
  }

  Future<File> _write(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, filename));
    return file.writeAsString(content, flush: true);
  }

  String _csv(String value) => '"${value.replaceAll('"', '""')}"';

  static Map<String, Object?> _domainEmployerJson(Employer e) => {
    'id': e.id,
    'name': e.name,
    'jobTitle': e.jobTitle,
    'employmentType': e.employmentType.name,
    'hourlyRateCents': e.hourlyRateCents,
    'startDate': e.startDate.toIso8601String(),
    'endDate': e.endDate?.toIso8601String(),
    'isActive': e.isActive,
    'countsForResidenceLimit': e.countsForResidenceLimit,
    'countsForStudentHourRule': e.countsForStudentHourRule,
    'isSocialInsuranceLiable': e.isSocialInsuranceLiable,
    'pensionExempt': e.pensionExempt,
    'taxClass': e.taxClass,
    'notes': e.notes,
  };

  static Map<String, Object?> _domainEntryJson(WorkEntry e) => {
    'id': e.id,
    'employerId': e.employerId,
    'startTimeUtc': e.startTimeUtc.toIso8601String(),
    'endTimeUtc': e.endTimeUtc?.toIso8601String(),
    'timezone': e.timezone,
    'breakMinutes': e.breakMinutes,
    'paidBreakMinutes': e.paidBreakMinutes,
    'hourlyRateSnapshotCents': e.hourlyRateSnapshotCents,
    'bonusCents': e.bonusCents,
    'tipsCents': e.tipsCents,
    'grossCents': e.grossCents,
    'status': e.status.name,
    'notes': e.notes,
  };
}
