import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sync_engine.dart';

class FirebaseSyncGateway implements CloudSyncGateway {
  FirebaseSyncGateway({required this.auth, required this.firestore});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<String> _userId() async {
    final current = auth.currentUser;
    if (current != null) return current.uid;
    final credential = await auth.signInAnonymously();
    return credential.user!.uid;
  }

  @override
  Future<List<SyncRecord>> pullSince(DateTime? watermark) async {
    final userId = await _userId();
    final query = firestore
        .collection('users')
        .doc(userId)
        .collection('records');
    // Full reconciliation also finds offline edits with an older device clock.
    final snapshot = await query.orderBy('updatedAt').get();
    return snapshot.docs
        .map((doc) => SyncRecord.fromRemoteJson(doc.data()))
        .toList();
  }

  @override
  Future<void> push(Iterable<SyncRecord> records) async {
    final items = records.toList();
    if (items.isEmpty) return;
    final userId = await _userId();
    final collection = firestore
        .collection('users')
        .doc(userId)
        .collection('records');
    for (final record in items) {
      final reference = collection.doc('${record.entityType}:${record.id}');
      await firestore.runTransaction((transaction) async {
        final existing = await transaction.get(reference);
        final remote = existing.exists
            ? SyncRecord.fromRemoteJson(existing.data()!)
            : null;
        final winner = DeterministicSyncEngine.chooseWinner(remote, record);
        if (identical(winner, record)) {
          transaction.set(reference, record.toRemoteJson());
        }
      });
    }
  }
}
