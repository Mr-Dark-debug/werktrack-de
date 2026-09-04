class SyncRecord {
  const SyncRecord({
    required this.id,
    required this.entityType,
    required this.updatedAt,
    required this.deviceId,
    required this.tombstone,
    required this.payload,
  });
  final String id;
  final String entityType;
  final DateTime updatedAt;
  final String deviceId;
  final bool tombstone;
  final Map<String, Object?> payload;

  Map<String, Object?> toRemoteJson() => {
    'id': id,
    'entityType': entityType,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'deviceId': deviceId,
    'tombstone': tombstone,
    'payload': payload,
  };

  factory SyncRecord.fromRemoteJson(Map<String, dynamic> json) => SyncRecord(
    id: json['id'] as String,
    entityType: json['entityType'] as String,
    updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
    deviceId: json['deviceId'] as String,
    tombstone: json['tombstone'] as bool? ?? false,
    payload: (json['payload'] as Map<String, dynamic>).cast<String, Object?>(),
  );
}

abstract interface class CloudSyncGateway {
  Future<List<SyncRecord>> pullSince(DateTime? watermark);
  Future<void> push(Iterable<SyncRecord> records);
}

abstract interface class LocalSyncStore {
  Future<List<SyncRecord>> changesSince(DateTime? watermark);
  Future<SyncRecord?> find(String entityType, String id);
  Future<void> applyWinner(SyncRecord record);
  Future<DateTime?> readWatermark();
  Future<void> writeWatermark(DateTime value);
}

class SyncSummary {
  const SyncSummary({
    required this.pushed,
    required this.pulled,
    required this.applied,
  });
  final int pushed;
  final int pulled;
  final int applied;
}

class DeterministicSyncEngine {
  const DeterministicSyncEngine({required this.local, required this.cloud});
  final LocalSyncStore local;
  final CloudSyncGateway cloud;

  Future<SyncSummary> synchronize() async {
    final watermark = await local.readWatermark();
    final localChanges = await local.changesSince(watermark);
    await cloud.push(localChanges);
    final remoteChanges = await cloud.pullSince(watermark);
    const order = {
      'profile': 0,
      'employer': 1,
      'academic': 2,
      'rule': 3,
      'work': 4,
      'payslip': 5,
      'setting': 6,
    };
    remoteChanges.sort(
      (a, b) =>
          (order[a.entityType] ?? 99).compareTo(order[b.entityType] ?? 99),
    );
    var applied = 0;
    DateTime? latest = watermark;
    for (final remote in remoteChanges) {
      final localRecord = await local.find(remote.entityType, remote.id);
      final winner = chooseWinner(localRecord, remote);
      if (identical(winner, remote)) {
        await local.applyWinner(remote);
        applied++;
      }
      if (latest == null || remote.updatedAt.isAfter(latest)) {
        latest = remote.updatedAt;
      }
    }
    if (latest != null) await local.writeWatermark(latest);
    return SyncSummary(
      pushed: localChanges.length,
      pulled: remoteChanges.length,
      applied: applied,
    );
  }

  static SyncRecord chooseWinner(SyncRecord? local, SyncRecord remote) {
    if (local == null) return remote;
    final time = local.updatedAt.compareTo(remote.updatedAt);
    if (time < 0) return remote;
    if (time > 0) return local;
    if (local.tombstone != remote.tombstone) {
      return remote.tombstone ? remote : local;
    }
    return remote.deviceId.compareTo(local.deviceId) > 0 ? remote : local;
  }
}
