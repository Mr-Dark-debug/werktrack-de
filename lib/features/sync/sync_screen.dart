import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'drift_sync_store.dart';
import 'firebase_sync_gateway.dart';
import 'sync_engine.dart';

class SyncScreen extends ConsumerStatefulWidget {
  const SyncScreen({super.key});
  @override
  ConsumerState<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends ConsumerState<SyncScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _enabled = false;
  String _status = 'Your data stays on this device until you enable sync.';
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _senderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  bool get _configured =>
      [_projectId, _apiKey, _appId, _senderId].every((s) => s.isNotEmpty);

  @override
  void initState() {
    super.initState();
    ref.read(workRepositoryProvider).readSetting('sync.enabled').then((value) {
      if (mounted) setState(() => _enabled = value == 'true');
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: _apiKey,
          appId: _appId,
          messagingSenderId: _senderId,
          projectId: _projectId,
        ),
      );
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await _initialize();
      await action();
    } on FirebaseException catch (error) {
      if (mounted) {
        setState(
          () => _status =
              'Sync unavailable (${error.code}). Local data is unchanged; retry when connected.',
        );
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _status =
              'Sync could not complete. Local data remains available. $error',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sync() async {
    final summary = await DeterministicSyncEngine(
      local: DriftSyncStore(ref.read(databaseProvider)),
      cloud: FirebaseSyncGateway(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    ).synchronize();
    await ref.read(workRepositoryProvider).writeSetting('sync.enabled', 'true');
    if (mounted) {
      setState(() {
        _enabled = true;
        _status =
            'Sync complete: ${summary.pushed} local records reconciled, ${summary.applied} remote records applied.';
      });
    }
  }

  Future<void> _signIn(bool create) async {
    if (create) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
    }
    _password.clear();
    await _sync();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Optional cloud sync')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Local first.\nCloud by choice.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text(
          'Enabling sync uploads your profile, work records, payslips, academic periods, settings and rules to the configured Firebase project. Use the same account on another device. Back up before joining datasets.',
        ),
        const SizedBox(height: 16),
        if (!_configured)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'This build has no Firebase project configuration. All offline features work. The project owner must supply the four documented FIREBASE_* build values and deploy owner-only Firestore rules.',
              ),
            ),
          )
        else ...[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Sync account email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : () => _run(() => _signIn(false)),
            child: const Text('Sign in & enable sync'),
          ),
          TextButton(
            onPressed: _busy ? null : () => _run(() => _signIn(true)),
            child: const Text('Create sync account & enable'),
          ),
          OutlinedButton(
            onPressed: _busy ? null : () => _run(_sync),
            child: Text(
              _enabled ? 'Sync now' : 'Enable anonymous sync on this device',
            ),
          ),
          if (_enabled)
            TextButton(
              onPressed: _busy
                  ? null
                  : () async {
                      await ref
                          .read(workRepositoryProvider)
                          .writeSetting('sync.enabled', 'false');
                      if (Firebase.apps.isNotEmpty) {
                        await FirebaseAuth.instance.signOut();
                      }
                      if (mounted) {
                        setState(() {
                          _enabled = false;
                          _status =
                              'Sync disabled. Local and previously uploaded cloud records are retained.';
                        });
                      }
                    },
              child: const Text('Disable sync & sign out'),
            ),
        ],
        const SizedBox(height: 16),
        if (_busy) const LinearProgressIndicator(),
        const SizedBox(height: 12),
        Text(_status),
      ],
    ),
  );
}
