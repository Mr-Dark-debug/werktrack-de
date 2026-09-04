import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../localization/app_localizations.dart';
import '../../theme/app_colors.dart';

class OnboardingGate extends ConsumerWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(onboardingProvider)
      .when(
        data: (complete) =>
            complete ? const _GoHome() : const OnboardingScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Could not open local data: $error')),
        ),
      );
}

class _GoHome extends StatefulWidget {
  const _GoHome();
  @override
  State<_GoHome> createState() => _GoHomeState();
}

class _GoHomeState extends State<_GoHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/home'));
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController();
  bool _accepted = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              right: -40,
              top: -60,
              child: _Blob(color: AppColors.sage, size: 180),
            ),
            const Positioned(
              left: -70,
              top: 210,
              child: _Blob(color: AppColors.pink, size: 160),
            ),
            const Positioned(
              right: -50,
              bottom: 90,
              child: _Blob(color: AppColors.periwinkle, size: 160),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
              children: [
                Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 54),
                Text(
                  l10n.welcomeTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 55),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.welcomeBody,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 42),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: l10n.yourName,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.disclaimerTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.disclaimer,
                        style: const TextStyle(
                          height: 1.35,
                          color: AppColors.ink,
                        ),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _accepted,
                        activeColor: AppColors.ink,
                        checkColor: Colors.white,
                        title: const Text(
                          'I understand',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => _accepted = value ?? false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: !_accepted || _saving ? null : _finish,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    backgroundColor: AppColors.ink,
                    foregroundColor: Colors.white,
                  ),
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.continueAction),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.offline_bolt_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text(l10n.offlineReady),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await ref.read(workRepositoryProvider).completeOnboarding(_name.text);
    if (mounted) context.go('/home');
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
