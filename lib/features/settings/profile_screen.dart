import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _name = TextEditingController();
  bool _student = true;
  bool _residence = true;
  bool _loaded = false;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    if (!_loaded && profile != null) {
      _name.text = profile.displayName;
      _student = profile.isStudent;
      _residence = profile.tracksResidenceAllowance;
      _loaded = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () async {
            await ref
                .read(workRepositoryProvider)
                .completeOnboarding(
                  _name.text,
                  isStudent: _student,
                  tracksResidenceAllowance: _residence,
                );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save profile'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Student profile'),
            subtitle: const Text('Show student weekly-reference guidance.'),
            value: _student,
            onChanged: (value) => setState(() => _student = value),
          ),
          SwitchListTile(
            title: const Text('Track residence work allowance'),
            subtitle: const Text(
              'Use only when relevant to your residence conditions.',
            ),
            value: _residence,
            onChanged: (value) => setState(() => _residence = value),
          ),
          const SizedBox(height: 16),
          const Text(
            'Employer-level switches still control which work counts toward each system. Your job category alone does not determine immigration or insurance treatment.',
          ),
        ],
      ),
    );
  }
}
