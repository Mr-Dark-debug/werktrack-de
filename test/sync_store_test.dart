import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/database/app_database.dart';
import 'package:werktrack_de/database/drift_work_repository.dart';
import 'package:werktrack_de/features/sync/drift_sync_store.dart';
import 'package:werktrack_de/features/sync/sync_engine.dart';

import 'calculator_test_support.dart';

class MemoryCloud implements CloudSyncGateway {
  final records = <String, SyncRecord>{};
  @override
  Future<List<SyncRecord>> pullSince(DateTime? watermark) async =>
      records.values.toList();
  @override
  Future<void> push(Iterable<SyncRecord> values) async {
    for (final value in values) {
      final key = '${value.entityType}:${value.id}';
      records[key] = DeterministicSyncEngine.chooseWinner(records[key], value);
    }
  }
}

void main() {
  test(
    'two Drift stores reconcile real employer records without duplicate writes',
    () async {
      final a = AppDatabase.forTesting(NativeDatabase.memory());
      final b = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(a.close);
      addTearDown(b.close);
      final cloud = MemoryCloud();
      await DriftWorkRepository(
        a,
      ).saveEmployer(employer(id: 'campus', rate: 1600));
      final first = DeterministicSyncEngine(
        local: DriftSyncStore(a),
        cloud: cloud,
      );
      final second = DeterministicSyncEngine(
        local: DriftSyncStore(b),
        cloud: cloud,
      );
      await first.synchronize();
      await second.synchronize();
      await second.synchronize();
      final jobs = await DriftWorkRepository(b).watchEmployers().first;
      expect(jobs.single.id, 'campus');
      expect(jobs.single.hourlyRateCents, 1600);
      expect(
        cloud.records.keys.where((key) => key == 'employer:campus'),
        hasLength(1),
      );
    },
  );
}
