import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:intl/date_symbol_data_local.dart';

import 'app/werk_track_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await initializeDateFormatting();
  runApp(const ProviderScope(child: WerkTrackApp()));
}
