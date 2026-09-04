import 'dart:convert';

import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../database/app_database.dart' as db;
import '../../database/drift_work_repository.dart';
import '../../domain/entities/employer.dart';
import '../../domain/entities/work_entry.dart';

enum WorkLogFormat { csv, txt, json }

class WorkLogImportPreview {
  const WorkLogImportPreview(this.entries, this.duplicateCount);
  final List<WorkEntry> entries;
  final int duplicateCount;
  int get completedMinutes => entries
      .where((e) => e.status == WorkEntryStatus.completed)
      .fold(0, (sum, e) => sum + e.workingDuration.inMinutes);
}

/// Lossless, employer-scoped work-log interchange. No profile/settings mutation.
class WorkLogTransfer {
  const WorkLogTransfer(this.database);
  final db.AppDatabase database;
  static const maxBytes = 10 * 1024 * 1024;
  static const maxRows = 20000;
  static const columns = [
    'schemaVersion',
    'id',
    'employerId',
    'employer',
    'startTimeUtc',
    'endTimeUtc',
    'timezone',
    'breakMinutes',
    'paidBreakMinutes',
    'hourlyRateSnapshotCents',
    'bonusCents',
    'tipsCents',
    'status',
    'notes',
    'workingMinutes',
    'paidMinutes',
    'grossCents',
  ];
  static const textColumns = {
    'id',
    'employerId',
    'employer',
    'timezone',
    'status',
    'notes',
  };

  static Map<String, Object?> record(WorkEntry e) => {
    'schemaVersion': 2,
    'id': e.id,
    'employerId': e.employerId,
    'startTimeUtc': e.startTimeUtc.toUtc().toIso8601String(),
    'endTimeUtc': e.endTimeUtc?.toUtc().toIso8601String(),
    'timezone': e.timezone,
    'breakMinutes': e.breakMinutes,
    'paidBreakMinutes': e.paidBreakMinutes,
    'hourlyRateSnapshotCents': e.hourlyRateSnapshotCents,
    'bonusCents': e.bonusCents,
    'tipsCents': e.tipsCents,
    'status': e.status.name,
    'notes': e.notes,
    'workingMinutes': e.workingDuration.inMinutes,
    'paidMinutes': e.paidDuration.inMinutes,
    'grossCents': e.grossCents,
  };

  String encode(
    WorkLogFormat format,
    Iterable<WorkEntry> entries,
    List<Employer> employers,
  ) {
    final names = {for (final e in employers) e.id: e.name};
    final records = entries
        .where((e) => e.status != WorkEntryStatus.active)
        .map((e) => {...record(e), 'employer': names[e.employerId] ?? ''})
        .toList();
    if (format == WorkLogFormat.json) {
      return const JsonEncoder.withIndent('  ').convert({
        'format': 'werktrack-worklogs',
        'schemaVersion': 2,
        'workEntries': records,
      });
    }
    final delimiter = format == WorkLogFormat.csv ? ',' : '\t';
    return [
      columns.join(delimiter),
      ...records.map(
        (row) => columns
            .map((key) {
              var value = '${row[key] ?? ''}';
              // A reversible prefix keeps user text from becoming spreadsheet formulas.
              if (textColumns.contains(key) && _needsPrefix(value)) {
                value = "'$value";
              }
              return '"${value.replaceAll('"', '""')}"';
            })
            .join(delimiter),
      ),
    ].join('\r\n');
  }

  static bool _needsPrefix(String value) =>
      RegExp(r"^\s*[=+\-@']|^[\t\r\n]").hasMatch(value);

  List<WorkEntry> decode(String raw, WorkLogFormat format, String employerId) {
    if (utf8.encode(raw).length > maxBytes) {
      throw const FormatException('File exceeds 10 MiB.');
    }
    final content = raw.startsWith('\uFEFF') ? raw.substring(1) : raw;
    final List<Map<String, dynamic>> rows;
    if (format == WorkLogFormat.json) {
      final data = jsonDecode(content);
      if (data is! Map<String, dynamic> ||
          data['format'] != 'werktrack-worklogs' ||
          data['schemaVersion'] != 2 ||
          data['workEntries'] is! List) {
        throw const FormatException(
          'Choose a WerkTrack work-log JSON v2 file, not a complete backup.',
        );
      }
      rows = (data['workEntries'] as List).map((row) {
        if (row is! Map<String, dynamic>) {
          throw const FormatException('Invalid work-log row.');
        }
        return row;
      }).toList();
    } else {
      final table = _parseDelimited(
        content,
        format == WorkLogFormat.csv ? ',' : '\t',
      );
      if (table.isEmpty) throw const FormatException('The file is empty.');
      final headers = table.first;
      if (headers.toSet().length != headers.length ||
          !columns.every(headers.contains)) {
        throw const FormatException(
          'Missing or duplicate columns. Use the work-log export as your template.',
        );
      }
      rows = table.skip(1).where((r) => r.any((v) => v.isNotEmpty)).map((row) {
        if (row.length != headers.length) {
          throw const FormatException('A row has the wrong number of columns.');
        }
        return <String, dynamic>{
          for (var i = 0; i < headers.length; i++)
            headers[i]:
                textColumns.contains(headers[i]) &&
                    row[i].startsWith("'") &&
                    _needsPrefix(row[i].substring(1))
                ? row[i].substring(1)
                : row[i],
        };
      }).toList();
    }
    if (rows.length > maxRows) {
      throw const FormatException('Import at most 20,000 records at once.');
    }
    final result = <WorkEntry>[];
    for (var i = 0; i < rows.length; i++) {
      try {
        result.add(_entry(rows[i], employerId));
      } on FormatException catch (e) {
        throw FormatException('Row ${i + 1}: ${e.message}');
      }
    }
    return result;
  }

  WorkEntry _entry(Map<String, dynamic> row, String target) {
    String text(String key, {int max = 10000}) {
      final value = row[key];
      if (value is! String || value.length > max || value.contains('\u0000')) {
        throw FormatException('Invalid $key.');
      }
      return value;
    }

    int number(String key) {
      final value = row[key];
      final parsed = value is int
          ? value
          : value is String && RegExp(r'^\d+$').hasMatch(value)
          ? int.tryParse(value)
          : null;
      if (parsed == null || parsed < 0 || parsed > 1000000000) {
        throw FormatException('Invalid $key.');
      }
      return parsed;
    }

    DateTime instant(String key) {
      final value = text(key, max: 50);
      final match = RegExp(
        r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d{1,6})?(?:Z|[+-]\d{2}:\d{2})$',
      ).firstMatch(value);
      if (match == null) {
        throw FormatException(
          '$key must be ISO 8601 with Z or an explicit UTC offset.',
        );
      }
      final parts = [for (var i = 1; i <= 6; i++) int.parse(match.group(i)!)];
      final d = DateTime.utc(parts[0], parts[1], parts[2]);
      if (parts[0] < 2000 ||
          parts[0] > 2100 ||
          d.month != parts[1] ||
          d.day != parts[2] ||
          parts[3] > 23 ||
          parts[4] > 59 ||
          parts[5] > 59) {
        throw FormatException('Invalid date in $key.');
      }
      final offset = RegExp(r'[+-](\d{2}):(\d{2})$').firstMatch(value);
      if (offset != null &&
          (int.parse(offset.group(1)!) > 23 ||
              int.parse(offset.group(2)!) > 59)) {
        throw FormatException('Invalid offset in $key.');
      }
      final parsed = DateTime.parse(value).toUtc();
      if (parsed.microsecondsSinceEpoch % Duration.microsecondsPerSecond != 0) {
        throw FormatException(
          '$key must use whole-second precision, matching the database.',
        );
      }
      return parsed;
    }

    if (number('schemaVersion') != 2) {
      throw const FormatException('Unsupported schema version.');
    }
    final sourceId = text('id', max: 200);
    if (sourceId.isEmpty) {
      throw const FormatException('Missing stable record id.');
    }
    final timezone = text('timezone', max: 100);
    try {
      tz.getLocation(timezone);
    } catch (_) {
      throw const FormatException('Unknown IANA timezone.');
    }
    final status = WorkEntryStatus.values
        .where((s) => s.name == row['status'])
        .firstOrNull;
    if (status == null || status == WorkEntryStatus.active) {
      throw const FormatException(
        'Only completed, planned or cancelled records may be imported.',
      );
    }
    final start = instant('startTimeUtc'), end = instant('endTimeUtc');
    final totalBreak = number('breakMinutes'),
        paidBreak = number('paidBreakMinutes');
    final duration = end.difference(start);
    if (duration <= Duration.zero ||
        duration > const Duration(days: 7) ||
        totalBreak > duration.inMinutes ||
        paidBreak > totalBreak) {
      throw const FormatException(
        'Invalid duration or breaks (maximum seven days per record).',
      );
    }
    final now = DateTime.now().toUtc();
    return WorkEntry(
      id: sourceId,
      employerId: target,
      startTimeUtc: start,
      endTimeUtc: end,
      timezone: timezone,
      breakMinutes: totalBreak,
      paidBreakMinutes: paidBreak,
      hourlyRateSnapshotCents: number('hourlyRateSnapshotCents'),
      bonusCents: number('bonusCents'),
      tipsCents: number('tipsCents'),
      notes: text('notes'),
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<WorkLogImportPreview> preview(
    String raw,
    WorkLogFormat format,
    String employerId,
  ) async {
    final decoded = decode(raw, format, employerId);
    return _prepare(decoded, employerId);
  }

  Future<WorkLogImportPreview> importLogs(
    String raw,
    WorkLogFormat format,
    String employerId,
  ) async {
    final decoded = decode(raw, format, employerId);
    return database.transaction(() async {
      // Recheck conflicts after confirmation, within the same atomic transaction.
      final plan = await _prepare(decoded, employerId);
      final repository = DriftWorkRepository(database);
      for (final entry in plan.entries) {
        await repository.saveEntry(entry);
      }
      return plan;
    });
  }

  Future<WorkLogImportPreview> _prepare(
    List<WorkEntry> entries,
    String employerId,
  ) async {
    final repository = DriftWorkRepository(database);
    final employers = await repository.watchEmployers().first;
    if (!employers.any((e) => e.id == employerId)) {
      throw const FormatException('Choose an existing employer.');
    }
    final existing = await repository.watchEntries().first;
    final byId = {for (final entry in existing) entry.id: entry};
    final fingerprints = existing.map(_fingerprint).toSet();
    final tombstones = (await database.select(database.workEntries).get())
        .where((e) => e.deleted)
        .map((e) => e.id)
        .toSet();
    final additions = <WorkEntry>[];
    var duplicates = 0;
    for (final entry in entries) {
      final id = const Uuid().v5(
        Namespace.url.value,
        'werktrack/import/$employerId/${entry.id}',
      );
      final fingerprint = _fingerprint(entry);
      final conflict =
          byId[id] ??
          (byId[entry.id]?.employerId == employerId ? byId[entry.id] : null);
      if (conflict != null && _fingerprint(conflict) != fingerprint) {
        throw const FormatException(
          'A record id has different saved content. Nothing was imported; edit it in Work instead.',
        );
      }
      if (tombstones.contains(id) ||
          tombstones.contains(entry.id) ||
          !fingerprints.add(fingerprint)) {
        duplicates++;
        continue;
      }
      final copy = entry.copyWith(id: id);
      additions.add(copy);
      byId[id] = copy;
    }
    return WorkLogImportPreview(List.unmodifiable(additions), duplicates);
  }

  static String _fingerprint(WorkEntry e) {
    final data = record(e)..remove('id');
    return jsonEncode(data);
  }

  static List<List<String>> _parseDelimited(String raw, String separator) {
    final result = <List<String>>[];
    var row = <String>[];
    var field = StringBuffer();
    var quoted = false, closed = false;
    void endField() {
      row.add(field.toString());
      field = StringBuffer();
      closed = false;
    }

    void endRow() {
      endField();
      result.add(row);
      row = [];
      if (result.length > maxRows + 2) {
        throw const FormatException('Too many records.');
      }
    }

    for (var i = 0; i < raw.length; i++) {
      final char = raw[i];
      if (quoted) {
        if (char == '"') {
          if (i + 1 < raw.length && raw[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            quoted = false;
            closed = true;
          }
        } else {
          field.write(char);
        }
      } else if (char == separator) {
        endField();
      } else if (char == '\r' || char == '\n') {
        if (char == '\r' && i + 1 < raw.length && raw[i + 1] == '\n') i++;
        endRow();
      } else if (char == '"' && field.isEmpty && !closed) {
        quoted = true;
      } else if (closed || char == '"') {
        throw const FormatException('Invalid quoted field.');
      } else {
        field.write(char);
      }
    }
    if (quoted) throw const FormatException('Unclosed quoted field.');
    if (field.isNotEmpty || row.isNotEmpty || closed) endRow();
    return result;
  }
}
