import 'package:timezone/timezone.dart' as tz;

import '../entities/work_entry.dart';

Map<DateTime, int> workingMinutesByLocalDay(
  WorkEntry entry,
  tz.Location location,
) {
  final end = entry.endTimeUtc;
  if (end == null || !end.isAfter(entry.startTimeUtc)) return {};
  final segments = <DateTime, int>{};
  var cursorUtc = entry.startTimeUtc.toUtc();
  final endUtc = end.toUtc();
  while (cursorUtc.isBefore(endUtc)) {
    final local = tz.TZDateTime.from(cursorUtc, location);
    final nextMidnightLocal = tz.TZDateTime(
      location,
      local.year,
      local.month,
      local.day + 1,
    );
    final segmentEndUtc = nextMidnightLocal.toUtc().isBefore(endUtc)
        ? nextMidnightLocal.toUtc()
        : endUtc;
    final key = DateTime(local.year, local.month, local.day);
    segments[key] =
        (segments[key] ?? 0) + segmentEndUtc.difference(cursorUtc).inMinutes;
    cursorUtc = segmentEndUtc;
  }

  var remainingBreak = entry.breakMinutes;
  final ordered = segments.keys.toList()
    ..sort((a, b) => segments[b]!.compareTo(segments[a]!));
  for (final key in ordered) {
    if (remainingBreak == 0) break;
    final deducted = remainingBreak > segments[key]!
        ? segments[key]!
        : remainingBreak;
    segments[key] = segments[key]! - deducted;
    remainingBreak -= deducted;
  }
  return segments;
}
