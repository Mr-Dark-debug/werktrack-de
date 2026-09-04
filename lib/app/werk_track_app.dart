import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import 'providers.dart';
import 'router.dart';

class WerkTrackApp extends ConsumerWidget {
  const WerkTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(dashboardProvider, (previous, next) {
      final data = next.value;
      final entries = ref.read(entriesProvider).value;
      if (data != null && entries != null) {
        ref.read(notificationCoordinatorProvider).process(data, entries);
      }
    });
    return MaterialApp.router(
      title: 'WerkTrack DE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: appRouter,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
