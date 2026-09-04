import 'package:flutter_test/flutter_test.dart';
import 'package:werktrack_de/features/sync/sync_engine.dart';

void main() {
  SyncRecord record({
    required String device,
    required DateTime time,
    bool tombstone = false,
  }) => SyncRecord(
    id: '1',
    entityType: 'workEntry',
    updatedAt: time,
    deviceId: device,
    tombstone: tombstone,
    payload: const {'id': '1'},
  );

  test('newer timestamp wins deterministically', () {
    final older = record(device: 'z', time: DateTime.utc(2026, 1, 1));
    final newer = record(device: 'a', time: DateTime.utc(2026, 1, 2));
    expect(DeterministicSyncEngine.chooseWinner(older, newer), same(newer));
  });

  test('tombstone wins equal-timestamp conflict', () {
    final live = record(
      device: 'z',
      time: DateTime.utc(2026),
      tombstone: false,
    );
    final deleted = record(
      device: 'a',
      time: DateTime.utc(2026),
      tombstone: true,
    );
    expect(DeterministicSyncEngine.chooseWinner(live, deleted), same(deleted));
  });

  test('device ID breaks remaining ties independent of argument order', () {
    final a = record(device: 'a', time: DateTime.utc(2026));
    final z = record(device: 'z', time: DateTime.utc(2026));
    expect(DeterministicSyncEngine.chooseWinner(a, z), same(z));
    expect(DeterministicSyncEngine.chooseWinner(z, a), same(z));
  });
}
