enum WorkEntryStatus { planned, active, completed, cancelled }

class WorkEntry {
  const WorkEntry({
    required this.id,
    required this.employerId,
    required this.startTimeUtc,
    required this.timezone,
    required this.breakMinutes,
    required this.paidBreakMinutes,
    required this.hourlyRateSnapshotCents,
    required this.bonusCents,
    required this.tipsCents,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.endTimeUtc,
  });

  final String id;
  final String employerId;
  final DateTime startTimeUtc;
  final DateTime? endTimeUtc;
  final String timezone;
  final int breakMinutes;
  final int paidBreakMinutes;
  final int hourlyRateSnapshotCents;
  final int bonusCents;
  final int tipsCents;
  final String notes;
  final WorkEntryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Duration get elapsed =>
      endTimeUtc == null ? Duration.zero : endTimeUtc!.difference(startTimeUtc);

  Duration get workingDuration {
    final minutes = elapsed.inMinutes - breakMinutes;
    return Duration(minutes: minutes < 0 ? 0 : minutes);
  }

  Duration get paidDuration {
    final minutes = elapsed.inMinutes - breakMinutes + paidBreakMinutes;
    return Duration(minutes: minutes < 0 ? 0 : minutes);
  }

  int get grossCents {
    final minutePay =
        (paidDuration.inMinutes * hourlyRateSnapshotCents + 30) ~/ 60;
    return minutePay + bonusCents + tipsCents;
  }

  WorkEntry copyWith({
    String? id,
    DateTime? startTimeUtc,
    DateTime? endTimeUtc,
    int? breakMinutes,
    int? paidBreakMinutes,
    int? hourlyRateSnapshotCents,
    String? notes,
    WorkEntryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkEntry(
    id: id ?? this.id,
    employerId: employerId,
    startTimeUtc: startTimeUtc ?? this.startTimeUtc,
    endTimeUtc: endTimeUtc ?? this.endTimeUtc,
    timezone: timezone,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    paidBreakMinutes: paidBreakMinutes ?? this.paidBreakMinutes,
    hourlyRateSnapshotCents:
        hourlyRateSnapshotCents ?? this.hourlyRateSnapshotCents,
    bonusCents: bonusCents,
    tipsCents: tipsCents,
    notes: notes ?? this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
