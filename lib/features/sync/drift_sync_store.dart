import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../database/app_database.dart' as db;
import '../../database/drift_work_repository.dart';
import 'sync_engine.dart';

/// Reconciles complete personal datasets, including deletion tombstones.
/// A full scan deliberately avoids losing delayed edits behind a time cursor.
class DriftSyncStore implements LocalSyncStore {
  DriftSyncStore(this.database);
  final db.AppDatabase database;

  Future<String> _deviceId() async {
    final repository = DriftWorkRepository(database);
    final existing = await repository.readSetting('sync.deviceId');
    if (existing != null) return existing;
    final id = const Uuid().v4();
    await repository.writeSetting('sync.deviceId', id);
    return id;
  }

  @override
  Future<List<SyncRecord>> changesSince(DateTime? watermark) async {
    final deviceId = await _deviceId();
    final metadata = {
      for (final row in await database.select(database.syncMetadata).get())
        '${row.entityType}:${row.entityId}': row,
    };
    final records = <SyncRecord>[];
    void add(
      String type,
      String id,
      DateTime updatedAt,
      Map<String, dynamic> payload, [
      bool deleted = false,
    ]) {
      final previous = metadata['$type:$id'];
      records.add(
        SyncRecord(
          id: id,
          entityType: type,
          updatedAt: updatedAt.toUtc(),
          deviceId: previous?.localUpdatedAt == updatedAt
              ? previous!.deviceId
              : deviceId,
          tombstone: deleted,
          payload: payload,
        ),
      );
    }

    for (final row in await database.select(database.userProfiles).get()) {
      add('profile', row.id, row.updatedAt, row.toJson());
    }
    for (final row in await database.select(database.employers).get()) {
      add('employer', row.id, row.updatedAt, row.toJson(), row.deleted);
    }
    for (final row in await database.select(database.workEntries).get()) {
      add('work', row.id, row.updatedAt, row.toJson(), row.deleted);
    }
    for (final row in await database.select(database.academicPeriods).get()) {
      add('academic', row.id, row.updatedAt, row.toJson());
    }
    for (final row in await database.select(database.payslips).get()) {
      add('payslip', row.id, row.updatedAt, row.toJson());
    }
    for (final row in await database.select(database.legalRules).get()) {
      add('rule', row.id, row.lastVerified, row.toJson());
    }
    for (final row in await database.select(database.appSettings).get()) {
      if (!row.key.startsWith('sync.')) {
        add('setting', row.key, row.updatedAt, row.toJson());
      }
    }
    return records;
  }

  @override
  Future<SyncRecord?> find(String entityType, String id) async {
    final records = await changesSince(null);
    return records
        .where((r) => r.entityType == entityType && r.id == id)
        .firstOrNull;
  }

  @override
  Future<void> applyWinner(SyncRecord record) async {
    final payload = Map<String, dynamic>.from(record.payload);
    if (record.entityType == 'work' || record.entityType == 'employer') {
      payload['deleted'] = record.tombstone;
    }
    await database.transaction(() async {
      switch (record.entityType) {
        case 'profile':
          await database
              .into(database.userProfiles)
              .insertOnConflictUpdate(db.UserProfile.fromJson(payload));
        case 'employer':
          await database
              .into(database.employers)
              .insertOnConflictUpdate(db.Employer.fromJson(payload));
        case 'work':
          await database
              .into(database.workEntries)
              .insertOnConflictUpdate(db.WorkEntry.fromJson(payload));
        case 'academic':
          await database
              .into(database.academicPeriods)
              .insertOnConflictUpdate(db.AcademicPeriod.fromJson(payload));
        case 'payslip':
          await database
              .into(database.payslips)
              .insertOnConflictUpdate(db.Payslip.fromJson(payload));
        case 'rule':
          await database
              .into(database.legalRules)
              .insertOnConflictUpdate(db.LegalRule.fromJson(payload));
        case 'setting':
          if (record.id.startsWith('sync.')) return;
          await database
              .into(database.appSettings)
              .insertOnConflictUpdate(db.AppSetting.fromJson(payload));
        default:
          throw FormatException(
            'Unsupported sync entity: ${record.entityType}',
          );
      }
      await database
          .into(database.syncMetadata)
          .insertOnConflictUpdate(
            db.SyncMetadataCompanion.insert(
              entityId: record.id,
              entityType: record.entityType,
              deviceId: record.deviceId,
              status: 'synced',
              tombstone: Value(record.tombstone),
              localUpdatedAt: record.updatedAt,
              remoteUpdatedAt: Value(record.updatedAt),
            ),
          );
    });
  }

  @override
  Future<DateTime?> readWatermark() async {
    final value = await DriftWorkRepository(
      database,
    ).readSetting('sync.watermark');
    return value == null ? null : DateTime.tryParse(value);
  }

  @override
  Future<void> writeWatermark(DateTime value) => DriftWorkRepository(
    database,
  ).writeSetting('sync.watermark', value.toUtc().toIso8601String());
}
