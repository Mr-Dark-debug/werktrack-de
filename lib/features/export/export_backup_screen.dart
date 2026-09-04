import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/work_entry.dart';
import '../../theme/app_colors.dart';
import 'export_service.dart';
import 'work_log_transfer.dart';

class ExportBackupScreen extends ConsumerStatefulWidget {
  const ExportBackupScreen({super.key});
  @override
  ConsumerState<ExportBackupScreen> createState() => _ExportBackupScreenState();
}

class _ExportBackupScreenState extends ConsumerState<ExportBackupScreen> {
  bool _busy = false;
  String _employer = '';
  DateTimeRange? _range;
  WorkLogFormat _format = WorkLogFormat.csv;

  @override
  Widget build(BuildContext context) {
    final employers = ref.watch(employersProvider);
    final entries = ref.watch(entriesProvider);
    final ready =
        !employers.isLoading &&
        !entries.isLoading &&
        !employers.hasError &&
        !entries.hasError &&
        !_busy;
    return Scaffold(
      appBar: AppBar(title: const Text('Your data')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          Text(
            'Take it with you.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            key: ValueKey(employers.value?.length),
            isExpanded: true,
            initialValue: _employer,
            decoration: const InputDecoration(labelText: 'Employer'),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('All employers (export only)'),
              ),
              for (final e in employers.value ?? const [])
                DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: ready ? (v) => setState(() => _employer = v!) : null,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final format in WorkLogFormat.values)
                ChoiceChip(
                  label: Text(format.name.toUpperCase()),
                  selected: _format == format,
                  shape: const StadiumBorder(),
                  onSelected: ready
                      ? (_) => setState(() => _format = format)
                      : null,
                ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.date_range),
            title: Text(
              _range == null
                  ? 'All dates'
                  : '${DateFormat.yMMMd().format(_range!.start)} – ${DateFormat.yMMMd().format(_range!.end)}',
            ),
            subtitle: const Text('Export filter: shift start date in Berlin'),
            onTap: ready ? _pickRange : null,
            trailing: _range == null
                ? const Icon(Icons.chevron_right)
                : IconButton(
                    tooltip: 'Clear export dates',
                    onPressed: () => setState(() => _range = null),
                    icon: const Icon(Icons.close),
                  ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: ready ? _export : null,
            icon: const Icon(Icons.ios_share),
            label: Text('Export ${_format.name.toUpperCase()}'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: ready && _employer.isNotEmpty ? _import : null,
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Import into selected employer'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose an employer to import. CSV and TXT use the exported column template; JSON uses WerkTrack work-log v2. Running timers stay on this device.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 22),
          Card(
            color: AppColors.periwinkle,
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: AppColors.ink,
                  displayColor: AppColors.ink,
                ),
              ),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                iconColor: AppColors.ink,
                collapsedIconColor: AppColors.ink,
                title: const Text(
                  'Complete backup',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  const Text(
                    'Includes all employers, profile, settings, payslips and rules. Keep backups private. Restoring replaces this device’s data.',
                    style: TextStyle(color: AppColors.ink),
                  ),
                  TextButton(
                    onPressed: ready
                        ? () => _perform(
                            () async => _share(
                              await ExportService(
                                ref.read(databaseProvider),
                              ).writeCompleteBackup(),
                            ),
                          )
                        : null,
                    child: const Text(
                      'Create backup',
                      style: TextStyle(color: AppColors.ink),
                    ),
                  ),
                  TextButton(
                    onPressed: ready ? _restore : null,
                    child: const Text(
                      'Restore backup…',
                      style: TextStyle(color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (entries.hasError || employers.hasError)
            const Text('Records could not be loaded. Please reopen this page.'),
        ],
      ),
    );
  }

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
      initialDateRange: _range,
    );
    if (range != null && mounted) setState(() => _range = range);
  }

  Future<void> _export() => _perform(() async {
    final location = ref.read(berlinLocationProvider);
    final entries = (ref.read(entriesProvider).value ?? const <WorkEntry>[])
        .where((e) {
          if (_employer.isNotEmpty && e.employerId != _employer) return false;
          final start = tz.TZDateTime.from(e.startTimeUtc, location);
          final day = DateTime(start.year, start.month, start.day);
          return _range == null ||
              (!day.isBefore(_range!.start) && !day.isAfter(_range!.end));
        });
    final raw = WorkLogTransfer(
      ref.read(databaseProvider),
    ).encode(_format, entries, ref.read(employersProvider).value ?? const []);
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/werktrack-logs-${DateTime.now().microsecondsSinceEpoch}.${_format.name}',
    );
    await file.writeAsString(raw, flush: true);
    await _share(file);
  });

  Future<String?> _pickText(List<String> extensions) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (result == null) return null;
    final picked = result.files.single;
    if (picked.size > WorkLogTransfer.maxBytes) {
      throw const FormatException('File exceeds 10 MiB.');
    }
    if (picked.path == null) {
      throw const FormatException(
        'This file provider did not supply a readable file.',
      );
    }
    final file = File(picked.path!);
    if (await file.length() > WorkLogTransfer.maxBytes) {
      throw const FormatException('File exceeds 10 MiB.');
    }
    return file.readAsString();
  }

  Future<void> _import() => _perform(() async {
    final raw = await _pickText([_format.name]);
    if (raw == null || !mounted) return;
    final service = WorkLogTransfer(ref.read(databaseProvider));
    final preview = await service.preview(raw, _format, _employer);
    if (!mounted) return;
    final name = ref
        .read(employersProvider)
        .value!
        .firstWhere((e) => e.id == _employer)
        .name;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Review import'),
        content: Text(
          '${preview.entries.length} new records → $name\n'
          '${formatDuration(Duration(minutes: preview.completedMinutes))} completed work\n'
          '${preview.duplicateCount} duplicate/deleted records skipped\n\n'
          'All records in this file will be assigned to this employer. Original employers are not created. Export date filters do not limit imports. Existing records are not overwritten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: preview.entries.isEmpty
                ? null
                : () => Navigator.pop(dialog, true),
            child: const Text('Import records'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result = await service.importLogs(raw, _format, _employer);
    _message(
      'Imported ${result.entries.length} records. Skipped ${result.duplicateCount} duplicates.',
    );
  });

  Future<void> _restore() => _perform(() async {
    final raw = await _pickText(['json']);
    if (raw == null || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Replace all local data?'),
        content: const Text(
          'Create a backup first if you want to keep your current records. This replaces every employer, log, payslip, profile and setting after validation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Replace from backup'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ExportService(ref.read(databaseProvider)).restoreCompleteBackup(raw);
    if (mounted) setState(() => _employer = '');
    _message('Backup restored after validation.');
  });

  Future<void> _share(File file) async {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'WerkTrack DE export',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _perform(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on FormatException catch (e) {
      _message(e.message);
    } catch (_) {
      _message(
        'The operation could not finish. Your file provider or sharing app may be unavailable.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
