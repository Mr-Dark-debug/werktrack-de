// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isStudentMeta = const VerificationMeta(
    'isStudent',
  );
  @override
  late final GeneratedColumn<bool> isStudent = GeneratedColumn<bool>(
    'is_student',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_student" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _tracksResidenceAllowanceMeta =
      const VerificationMeta('tracksResidenceAllowance');
  @override
  late final GeneratedColumn<bool> tracksResidenceAllowance =
      GeneratedColumn<bool>(
        'tracks_residence_allowance',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tracks_residence_allowance" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    isStudent,
    tracksResidenceAllowance,
    onboardingComplete,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('is_student')) {
      context.handle(
        _isStudentMeta,
        isStudent.isAcceptableOrUnknown(data['is_student']!, _isStudentMeta),
      );
    }
    if (data.containsKey('tracks_residence_allowance')) {
      context.handle(
        _tracksResidenceAllowanceMeta,
        tracksResidenceAllowance.isAcceptableOrUnknown(
          data['tracks_residence_allowance']!,
          _tracksResidenceAllowanceMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isStudent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_student'],
      )!,
      tracksResidenceAllowance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tracks_residence_allowance'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String displayName;
  final bool isStudent;
  final bool tracksResidenceAllowance;
  final bool onboardingComplete;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.isStudent,
    required this.tracksResidenceAllowance,
    required this.onboardingComplete,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['is_student'] = Variable<bool>(isStudent);
    map['tracks_residence_allowance'] = Variable<bool>(
      tracksResidenceAllowance,
    );
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      isStudent: Value(isStudent),
      tracksResidenceAllowance: Value(tracksResidenceAllowance),
      onboardingComplete: Value(onboardingComplete),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isStudent: serializer.fromJson<bool>(json['isStudent']),
      tracksResidenceAllowance: serializer.fromJson<bool>(
        json['tracksResidenceAllowance'],
      ),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'isStudent': serializer.toJson<bool>(isStudent),
      'tracksResidenceAllowance': serializer.toJson<bool>(
        tracksResidenceAllowance,
      ),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    bool? isStudent,
    bool? tracksResidenceAllowance,
    bool? onboardingComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    isStudent: isStudent ?? this.isStudent,
    tracksResidenceAllowance:
        tracksResidenceAllowance ?? this.tracksResidenceAllowance,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isStudent: data.isStudent.present ? data.isStudent.value : this.isStudent,
      tracksResidenceAllowance: data.tracksResidenceAllowance.present
          ? data.tracksResidenceAllowance.value
          : this.tracksResidenceAllowance,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('isStudent: $isStudent, ')
          ..write('tracksResidenceAllowance: $tracksResidenceAllowance, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    isStudent,
    tracksResidenceAllowance,
    onboardingComplete,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.isStudent == this.isStudent &&
          other.tracksResidenceAllowance == this.tracksResidenceAllowance &&
          other.onboardingComplete == this.onboardingComplete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<bool> isStudent;
  final Value<bool> tracksResidenceAllowance;
  final Value<bool> onboardingComplete;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isStudent = const Value.absent(),
    this.tracksResidenceAllowance = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.isStudent = const Value.absent(),
    this.tracksResidenceAllowance = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<bool>? isStudent,
    Expression<bool>? tracksResidenceAllowance,
    Expression<bool>? onboardingComplete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (isStudent != null) 'is_student': isStudent,
      if (tracksResidenceAllowance != null)
        'tracks_residence_allowance': tracksResidenceAllowance,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<bool>? isStudent,
    Value<bool>? tracksResidenceAllowance,
    Value<bool>? onboardingComplete,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      isStudent: isStudent ?? this.isStudent,
      tracksResidenceAllowance:
          tracksResidenceAllowance ?? this.tracksResidenceAllowance,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isStudent.present) {
      map['is_student'] = Variable<bool>(isStudent.value);
    }
    if (tracksResidenceAllowance.present) {
      map['tracks_residence_allowance'] = Variable<bool>(
        tracksResidenceAllowance.value,
      );
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('isStudent: $isStudent, ')
          ..write('tracksResidenceAllowance: $tracksResidenceAllowance, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployersTable extends Employers
    with TableInfo<$EmployersTable, Employer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employmentTypeMeta = const VerificationMeta(
    'employmentType',
  );
  @override
  late final GeneratedColumn<String> employmentType = GeneratedColumn<String>(
    'employment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourlyRateCentsMeta = const VerificationMeta(
    'hourlyRateCents',
  );
  @override
  late final GeneratedColumn<int> hourlyRateCents = GeneratedColumn<int>(
    'hourly_rate_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _countsForResidenceLimitMeta =
      const VerificationMeta('countsForResidenceLimit');
  @override
  late final GeneratedColumn<bool> countsForResidenceLimit =
      GeneratedColumn<bool>(
        'counts_for_residence_limit',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("counts_for_residence_limit" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _countsForStudentHourRuleMeta =
      const VerificationMeta('countsForStudentHourRule');
  @override
  late final GeneratedColumn<bool> countsForStudentHourRule =
      GeneratedColumn<bool>(
        'counts_for_student_hour_rule',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("counts_for_student_hour_rule" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _isSocialInsuranceLiableMeta =
      const VerificationMeta('isSocialInsuranceLiable');
  @override
  late final GeneratedColumn<bool> isSocialInsuranceLiable =
      GeneratedColumn<bool>(
        'is_social_insurance_liable',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_social_insurance_liable" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _pensionExemptMeta = const VerificationMeta(
    'pensionExempt',
  );
  @override
  late final GeneratedColumn<bool> pensionExempt = GeneratedColumn<bool>(
    'pension_exempt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pension_exempt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taxClassMeta = const VerificationMeta(
    'taxClass',
  );
  @override
  late final GeneratedColumn<int> taxClass = GeneratedColumn<int>(
    'tax_class',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    jobTitle,
    employmentType,
    hourlyRateCents,
    startDate,
    endDate,
    isActive,
    countsForResidenceLimit,
    countsForStudentHourRule,
    isSocialInsuranceLiable,
    pensionExempt,
    taxClass,
    notes,
    deleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_jobTitleMeta);
    }
    if (data.containsKey('employment_type')) {
      context.handle(
        _employmentTypeMeta,
        employmentType.isAcceptableOrUnknown(
          data['employment_type']!,
          _employmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employmentTypeMeta);
    }
    if (data.containsKey('hourly_rate_cents')) {
      context.handle(
        _hourlyRateCentsMeta,
        hourlyRateCents.isAcceptableOrUnknown(
          data['hourly_rate_cents']!,
          _hourlyRateCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hourlyRateCentsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('counts_for_residence_limit')) {
      context.handle(
        _countsForResidenceLimitMeta,
        countsForResidenceLimit.isAcceptableOrUnknown(
          data['counts_for_residence_limit']!,
          _countsForResidenceLimitMeta,
        ),
      );
    }
    if (data.containsKey('counts_for_student_hour_rule')) {
      context.handle(
        _countsForStudentHourRuleMeta,
        countsForStudentHourRule.isAcceptableOrUnknown(
          data['counts_for_student_hour_rule']!,
          _countsForStudentHourRuleMeta,
        ),
      );
    }
    if (data.containsKey('is_social_insurance_liable')) {
      context.handle(
        _isSocialInsuranceLiableMeta,
        isSocialInsuranceLiable.isAcceptableOrUnknown(
          data['is_social_insurance_liable']!,
          _isSocialInsuranceLiableMeta,
        ),
      );
    }
    if (data.containsKey('pension_exempt')) {
      context.handle(
        _pensionExemptMeta,
        pensionExempt.isAcceptableOrUnknown(
          data['pension_exempt']!,
          _pensionExemptMeta,
        ),
      );
    }
    if (data.containsKey('tax_class')) {
      context.handle(
        _taxClassMeta,
        taxClass.isAcceptableOrUnknown(data['tax_class']!, _taxClassMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      )!,
      employmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employment_type'],
      )!,
      hourlyRateCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate_cents'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      countsForResidenceLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}counts_for_residence_limit'],
      )!,
      countsForStudentHourRule: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}counts_for_student_hour_rule'],
      )!,
      isSocialInsuranceLiable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_social_insurance_liable'],
      )!,
      pensionExempt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pension_exempt'],
      )!,
      taxClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_class'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmployersTable createAlias(String alias) {
    return $EmployersTable(attachedDatabase, alias);
  }
}

class Employer extends DataClass implements Insertable<Employer> {
  final String id;
  final String name;
  final String jobTitle;
  final String employmentType;
  final int hourlyRateCents;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool countsForResidenceLimit;
  final bool countsForStudentHourRule;
  final bool isSocialInsuranceLiable;
  final bool pensionExempt;
  final int taxClass;
  final String notes;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Employer({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.employmentType,
    required this.hourlyRateCents,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.countsForResidenceLimit,
    required this.countsForStudentHourRule,
    required this.isSocialInsuranceLiable,
    required this.pensionExempt,
    required this.taxClass,
    required this.notes,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['job_title'] = Variable<String>(jobTitle);
    map['employment_type'] = Variable<String>(employmentType);
    map['hourly_rate_cents'] = Variable<int>(hourlyRateCents);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['counts_for_residence_limit'] = Variable<bool>(countsForResidenceLimit);
    map['counts_for_student_hour_rule'] = Variable<bool>(
      countsForStudentHourRule,
    );
    map['is_social_insurance_liable'] = Variable<bool>(isSocialInsuranceLiable);
    map['pension_exempt'] = Variable<bool>(pensionExempt);
    map['tax_class'] = Variable<int>(taxClass);
    map['notes'] = Variable<String>(notes);
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmployersCompanion toCompanion(bool nullToAbsent) {
    return EmployersCompanion(
      id: Value(id),
      name: Value(name),
      jobTitle: Value(jobTitle),
      employmentType: Value(employmentType),
      hourlyRateCents: Value(hourlyRateCents),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
      countsForResidenceLimit: Value(countsForResidenceLimit),
      countsForStudentHourRule: Value(countsForStudentHourRule),
      isSocialInsuranceLiable: Value(isSocialInsuranceLiable),
      pensionExempt: Value(pensionExempt),
      taxClass: Value(taxClass),
      notes: Value(notes),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Employer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      jobTitle: serializer.fromJson<String>(json['jobTitle']),
      employmentType: serializer.fromJson<String>(json['employmentType']),
      hourlyRateCents: serializer.fromJson<int>(json['hourlyRateCents']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      countsForResidenceLimit: serializer.fromJson<bool>(
        json['countsForResidenceLimit'],
      ),
      countsForStudentHourRule: serializer.fromJson<bool>(
        json['countsForStudentHourRule'],
      ),
      isSocialInsuranceLiable: serializer.fromJson<bool>(
        json['isSocialInsuranceLiable'],
      ),
      pensionExempt: serializer.fromJson<bool>(json['pensionExempt']),
      taxClass: serializer.fromJson<int>(json['taxClass']),
      notes: serializer.fromJson<String>(json['notes']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'jobTitle': serializer.toJson<String>(jobTitle),
      'employmentType': serializer.toJson<String>(employmentType),
      'hourlyRateCents': serializer.toJson<int>(hourlyRateCents),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
      'countsForResidenceLimit': serializer.toJson<bool>(
        countsForResidenceLimit,
      ),
      'countsForStudentHourRule': serializer.toJson<bool>(
        countsForStudentHourRule,
      ),
      'isSocialInsuranceLiable': serializer.toJson<bool>(
        isSocialInsuranceLiable,
      ),
      'pensionExempt': serializer.toJson<bool>(pensionExempt),
      'taxClass': serializer.toJson<int>(taxClass),
      'notes': serializer.toJson<String>(notes),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Employer copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? employmentType,
    int? hourlyRateCents,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? isActive,
    bool? countsForResidenceLimit,
    bool? countsForStudentHourRule,
    bool? isSocialInsuranceLiable,
    bool? pensionExempt,
    int? taxClass,
    String? notes,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Employer(
    id: id ?? this.id,
    name: name ?? this.name,
    jobTitle: jobTitle ?? this.jobTitle,
    employmentType: employmentType ?? this.employmentType,
    hourlyRateCents: hourlyRateCents ?? this.hourlyRateCents,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isActive: isActive ?? this.isActive,
    countsForResidenceLimit:
        countsForResidenceLimit ?? this.countsForResidenceLimit,
    countsForStudentHourRule:
        countsForStudentHourRule ?? this.countsForStudentHourRule,
    isSocialInsuranceLiable:
        isSocialInsuranceLiable ?? this.isSocialInsuranceLiable,
    pensionExempt: pensionExempt ?? this.pensionExempt,
    taxClass: taxClass ?? this.taxClass,
    notes: notes ?? this.notes,
    deleted: deleted ?? this.deleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Employer copyWithCompanion(EmployersCompanion data) {
    return Employer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      employmentType: data.employmentType.present
          ? data.employmentType.value
          : this.employmentType,
      hourlyRateCents: data.hourlyRateCents.present
          ? data.hourlyRateCents.value
          : this.hourlyRateCents,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      countsForResidenceLimit: data.countsForResidenceLimit.present
          ? data.countsForResidenceLimit.value
          : this.countsForResidenceLimit,
      countsForStudentHourRule: data.countsForStudentHourRule.present
          ? data.countsForStudentHourRule.value
          : this.countsForStudentHourRule,
      isSocialInsuranceLiable: data.isSocialInsuranceLiable.present
          ? data.isSocialInsuranceLiable.value
          : this.isSocialInsuranceLiable,
      pensionExempt: data.pensionExempt.present
          ? data.pensionExempt.value
          : this.pensionExempt,
      taxClass: data.taxClass.present ? data.taxClass.value : this.taxClass,
      notes: data.notes.present ? data.notes.value : this.notes,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('employmentType: $employmentType, ')
          ..write('hourlyRateCents: $hourlyRateCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('countsForResidenceLimit: $countsForResidenceLimit, ')
          ..write('countsForStudentHourRule: $countsForStudentHourRule, ')
          ..write('isSocialInsuranceLiable: $isSocialInsuranceLiable, ')
          ..write('pensionExempt: $pensionExempt, ')
          ..write('taxClass: $taxClass, ')
          ..write('notes: $notes, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    jobTitle,
    employmentType,
    hourlyRateCents,
    startDate,
    endDate,
    isActive,
    countsForResidenceLimit,
    countsForStudentHourRule,
    isSocialInsuranceLiable,
    pensionExempt,
    taxClass,
    notes,
    deleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employer &&
          other.id == this.id &&
          other.name == this.name &&
          other.jobTitle == this.jobTitle &&
          other.employmentType == this.employmentType &&
          other.hourlyRateCents == this.hourlyRateCents &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive &&
          other.countsForResidenceLimit == this.countsForResidenceLimit &&
          other.countsForStudentHourRule == this.countsForStudentHourRule &&
          other.isSocialInsuranceLiable == this.isSocialInsuranceLiable &&
          other.pensionExempt == this.pensionExempt &&
          other.taxClass == this.taxClass &&
          other.notes == this.notes &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployersCompanion extends UpdateCompanion<Employer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> jobTitle;
  final Value<String> employmentType;
  final Value<int> hourlyRateCents;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  final Value<bool> countsForResidenceLimit;
  final Value<bool> countsForStudentHourRule;
  final Value<bool> isSocialInsuranceLiable;
  final Value<bool> pensionExempt;
  final Value<int> taxClass;
  final Value<String> notes;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmployersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.hourlyRateCents = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.countsForResidenceLimit = const Value.absent(),
    this.countsForStudentHourRule = const Value.absent(),
    this.isSocialInsuranceLiable = const Value.absent(),
    this.pensionExempt = const Value.absent(),
    this.taxClass = const Value.absent(),
    this.notes = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployersCompanion.insert({
    required String id,
    required String name,
    required String jobTitle,
    required String employmentType,
    required int hourlyRateCents,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.countsForResidenceLimit = const Value.absent(),
    this.countsForStudentHourRule = const Value.absent(),
    this.isSocialInsuranceLiable = const Value.absent(),
    this.pensionExempt = const Value.absent(),
    this.taxClass = const Value.absent(),
    this.notes = const Value.absent(),
    this.deleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       jobTitle = Value(jobTitle),
       employmentType = Value(employmentType),
       hourlyRateCents = Value(hourlyRateCents),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Employer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? jobTitle,
    Expression<String>? employmentType,
    Expression<int>? hourlyRateCents,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
    Expression<bool>? countsForResidenceLimit,
    Expression<bool>? countsForStudentHourRule,
    Expression<bool>? isSocialInsuranceLiable,
    Expression<bool>? pensionExempt,
    Expression<int>? taxClass,
    Expression<String>? notes,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (jobTitle != null) 'job_title': jobTitle,
      if (employmentType != null) 'employment_type': employmentType,
      if (hourlyRateCents != null) 'hourly_rate_cents': hourlyRateCents,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (countsForResidenceLimit != null)
        'counts_for_residence_limit': countsForResidenceLimit,
      if (countsForStudentHourRule != null)
        'counts_for_student_hour_rule': countsForStudentHourRule,
      if (isSocialInsuranceLiable != null)
        'is_social_insurance_liable': isSocialInsuranceLiable,
      if (pensionExempt != null) 'pension_exempt': pensionExempt,
      if (taxClass != null) 'tax_class': taxClass,
      if (notes != null) 'notes': notes,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? jobTitle,
    Value<String>? employmentType,
    Value<int>? hourlyRateCents,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isActive,
    Value<bool>? countsForResidenceLimit,
    Value<bool>? countsForStudentHourRule,
    Value<bool>? isSocialInsuranceLiable,
    Value<bool>? pensionExempt,
    Value<int>? taxClass,
    Value<String>? notes,
    Value<bool>? deleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EmployersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      employmentType: employmentType ?? this.employmentType,
      hourlyRateCents: hourlyRateCents ?? this.hourlyRateCents,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      countsForResidenceLimit:
          countsForResidenceLimit ?? this.countsForResidenceLimit,
      countsForStudentHourRule:
          countsForStudentHourRule ?? this.countsForStudentHourRule,
      isSocialInsuranceLiable:
          isSocialInsuranceLiable ?? this.isSocialInsuranceLiable,
      pensionExempt: pensionExempt ?? this.pensionExempt,
      taxClass: taxClass ?? this.taxClass,
      notes: notes ?? this.notes,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(employmentType.value);
    }
    if (hourlyRateCents.present) {
      map['hourly_rate_cents'] = Variable<int>(hourlyRateCents.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (countsForResidenceLimit.present) {
      map['counts_for_residence_limit'] = Variable<bool>(
        countsForResidenceLimit.value,
      );
    }
    if (countsForStudentHourRule.present) {
      map['counts_for_student_hour_rule'] = Variable<bool>(
        countsForStudentHourRule.value,
      );
    }
    if (isSocialInsuranceLiable.present) {
      map['is_social_insurance_liable'] = Variable<bool>(
        isSocialInsuranceLiable.value,
      );
    }
    if (pensionExempt.present) {
      map['pension_exempt'] = Variable<bool>(pensionExempt.value);
    }
    if (taxClass.present) {
      map['tax_class'] = Variable<int>(taxClass.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('employmentType: $employmentType, ')
          ..write('hourlyRateCents: $hourlyRateCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('countsForResidenceLimit: $countsForResidenceLimit, ')
          ..write('countsForStudentHourRule: $countsForStudentHourRule, ')
          ..write('isSocialInsuranceLiable: $isSocialInsuranceLiable, ')
          ..write('pensionExempt: $pensionExempt, ')
          ..write('taxClass: $taxClass, ')
          ..write('notes: $notes, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkEntriesTable extends WorkEntries
    with TableInfo<$WorkEntriesTable, WorkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employerIdMeta = const VerificationMeta(
    'employerId',
  );
  @override
  late final GeneratedColumn<String> employerId = GeneratedColumn<String>(
    'employer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employers (id)',
    ),
  );
  static const VerificationMeta _startTimeUtcMeta = const VerificationMeta(
    'startTimeUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startTimeUtc = GeneratedColumn<DateTime>(
    'start_time_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeUtcMeta = const VerificationMeta(
    'endTimeUtc',
  );
  @override
  late final GeneratedColumn<DateTime> endTimeUtc = GeneratedColumn<DateTime>(
    'end_time_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Europe/Berlin'),
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidBreakMinutesMeta = const VerificationMeta(
    'paidBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> paidBreakMinutes = GeneratedColumn<int>(
    'paid_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hourlyRateSnapshotCentsMeta =
      const VerificationMeta('hourlyRateSnapshotCents');
  @override
  late final GeneratedColumn<int> hourlyRateSnapshotCents =
      GeneratedColumn<int>(
        'hourly_rate_snapshot_cents',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _bonusCentsMeta = const VerificationMeta(
    'bonusCents',
  );
  @override
  late final GeneratedColumn<int> bonusCents = GeneratedColumn<int>(
    'bonus_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tipsCentsMeta = const VerificationMeta(
    'tipsCents',
  );
  @override
  late final GeneratedColumn<int> tipsCents = GeneratedColumn<int>(
    'tips_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employerId,
    startTimeUtc,
    endTimeUtc,
    timezone,
    breakMinutes,
    paidBreakMinutes,
    hourlyRateSnapshotCents,
    bonusCents,
    tipsCents,
    notes,
    status,
    deleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employer_id')) {
      context.handle(
        _employerIdMeta,
        employerId.isAcceptableOrUnknown(data['employer_id']!, _employerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employerIdMeta);
    }
    if (data.containsKey('start_time_utc')) {
      context.handle(
        _startTimeUtcMeta,
        startTimeUtc.isAcceptableOrUnknown(
          data['start_time_utc']!,
          _startTimeUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimeUtcMeta);
    }
    if (data.containsKey('end_time_utc')) {
      context.handle(
        _endTimeUtcMeta,
        endTimeUtc.isAcceptableOrUnknown(
          data['end_time_utc']!,
          _endTimeUtcMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('paid_break_minutes')) {
      context.handle(
        _paidBreakMinutesMeta,
        paidBreakMinutes.isAcceptableOrUnknown(
          data['paid_break_minutes']!,
          _paidBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate_snapshot_cents')) {
      context.handle(
        _hourlyRateSnapshotCentsMeta,
        hourlyRateSnapshotCents.isAcceptableOrUnknown(
          data['hourly_rate_snapshot_cents']!,
          _hourlyRateSnapshotCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hourlyRateSnapshotCentsMeta);
    }
    if (data.containsKey('bonus_cents')) {
      context.handle(
        _bonusCentsMeta,
        bonusCents.isAcceptableOrUnknown(data['bonus_cents']!, _bonusCentsMeta),
      );
    }
    if (data.containsKey('tips_cents')) {
      context.handle(
        _tipsCentsMeta,
        tipsCents.isAcceptableOrUnknown(data['tips_cents']!, _tipsCentsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employer_id'],
      )!,
      startTimeUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time_utc'],
      )!,
      endTimeUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time_utc'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      paidBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_break_minutes'],
      )!,
      hourlyRateSnapshotCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate_snapshot_cents'],
      )!,
      bonusCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_cents'],
      )!,
      tipsCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tips_cents'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkEntriesTable createAlias(String alias) {
    return $WorkEntriesTable(attachedDatabase, alias);
  }
}

class WorkEntry extends DataClass implements Insertable<WorkEntry> {
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
  final String status;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkEntry({
    required this.id,
    required this.employerId,
    required this.startTimeUtc,
    this.endTimeUtc,
    required this.timezone,
    required this.breakMinutes,
    required this.paidBreakMinutes,
    required this.hourlyRateSnapshotCents,
    required this.bonusCents,
    required this.tipsCents,
    required this.notes,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employer_id'] = Variable<String>(employerId);
    map['start_time_utc'] = Variable<DateTime>(startTimeUtc);
    if (!nullToAbsent || endTimeUtc != null) {
      map['end_time_utc'] = Variable<DateTime>(endTimeUtc);
    }
    map['timezone'] = Variable<String>(timezone);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['paid_break_minutes'] = Variable<int>(paidBreakMinutes);
    map['hourly_rate_snapshot_cents'] = Variable<int>(hourlyRateSnapshotCents);
    map['bonus_cents'] = Variable<int>(bonusCents);
    map['tips_cents'] = Variable<int>(tipsCents);
    map['notes'] = Variable<String>(notes);
    map['status'] = Variable<String>(status);
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkEntriesCompanion(
      id: Value(id),
      employerId: Value(employerId),
      startTimeUtc: Value(startTimeUtc),
      endTimeUtc: endTimeUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endTimeUtc),
      timezone: Value(timezone),
      breakMinutes: Value(breakMinutes),
      paidBreakMinutes: Value(paidBreakMinutes),
      hourlyRateSnapshotCents: Value(hourlyRateSnapshotCents),
      bonusCents: Value(bonusCents),
      tipsCents: Value(tipsCents),
      notes: Value(notes),
      status: Value(status),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkEntry(
      id: serializer.fromJson<String>(json['id']),
      employerId: serializer.fromJson<String>(json['employerId']),
      startTimeUtc: serializer.fromJson<DateTime>(json['startTimeUtc']),
      endTimeUtc: serializer.fromJson<DateTime?>(json['endTimeUtc']),
      timezone: serializer.fromJson<String>(json['timezone']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      paidBreakMinutes: serializer.fromJson<int>(json['paidBreakMinutes']),
      hourlyRateSnapshotCents: serializer.fromJson<int>(
        json['hourlyRateSnapshotCents'],
      ),
      bonusCents: serializer.fromJson<int>(json['bonusCents']),
      tipsCents: serializer.fromJson<int>(json['tipsCents']),
      notes: serializer.fromJson<String>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employerId': serializer.toJson<String>(employerId),
      'startTimeUtc': serializer.toJson<DateTime>(startTimeUtc),
      'endTimeUtc': serializer.toJson<DateTime?>(endTimeUtc),
      'timezone': serializer.toJson<String>(timezone),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'paidBreakMinutes': serializer.toJson<int>(paidBreakMinutes),
      'hourlyRateSnapshotCents': serializer.toJson<int>(
        hourlyRateSnapshotCents,
      ),
      'bonusCents': serializer.toJson<int>(bonusCents),
      'tipsCents': serializer.toJson<int>(tipsCents),
      'notes': serializer.toJson<String>(notes),
      'status': serializer.toJson<String>(status),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkEntry copyWith({
    String? id,
    String? employerId,
    DateTime? startTimeUtc,
    Value<DateTime?> endTimeUtc = const Value.absent(),
    String? timezone,
    int? breakMinutes,
    int? paidBreakMinutes,
    int? hourlyRateSnapshotCents,
    int? bonusCents,
    int? tipsCents,
    String? notes,
    String? status,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkEntry(
    id: id ?? this.id,
    employerId: employerId ?? this.employerId,
    startTimeUtc: startTimeUtc ?? this.startTimeUtc,
    endTimeUtc: endTimeUtc.present ? endTimeUtc.value : this.endTimeUtc,
    timezone: timezone ?? this.timezone,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    paidBreakMinutes: paidBreakMinutes ?? this.paidBreakMinutes,
    hourlyRateSnapshotCents:
        hourlyRateSnapshotCents ?? this.hourlyRateSnapshotCents,
    bonusCents: bonusCents ?? this.bonusCents,
    tipsCents: tipsCents ?? this.tipsCents,
    notes: notes ?? this.notes,
    status: status ?? this.status,
    deleted: deleted ?? this.deleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkEntry copyWithCompanion(WorkEntriesCompanion data) {
    return WorkEntry(
      id: data.id.present ? data.id.value : this.id,
      employerId: data.employerId.present
          ? data.employerId.value
          : this.employerId,
      startTimeUtc: data.startTimeUtc.present
          ? data.startTimeUtc.value
          : this.startTimeUtc,
      endTimeUtc: data.endTimeUtc.present
          ? data.endTimeUtc.value
          : this.endTimeUtc,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      paidBreakMinutes: data.paidBreakMinutes.present
          ? data.paidBreakMinutes.value
          : this.paidBreakMinutes,
      hourlyRateSnapshotCents: data.hourlyRateSnapshotCents.present
          ? data.hourlyRateSnapshotCents.value
          : this.hourlyRateSnapshotCents,
      bonusCents: data.bonusCents.present
          ? data.bonusCents.value
          : this.bonusCents,
      tipsCents: data.tipsCents.present ? data.tipsCents.value : this.tipsCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntry(')
          ..write('id: $id, ')
          ..write('employerId: $employerId, ')
          ..write('startTimeUtc: $startTimeUtc, ')
          ..write('endTimeUtc: $endTimeUtc, ')
          ..write('timezone: $timezone, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('paidBreakMinutes: $paidBreakMinutes, ')
          ..write('hourlyRateSnapshotCents: $hourlyRateSnapshotCents, ')
          ..write('bonusCents: $bonusCents, ')
          ..write('tipsCents: $tipsCents, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employerId,
    startTimeUtc,
    endTimeUtc,
    timezone,
    breakMinutes,
    paidBreakMinutes,
    hourlyRateSnapshotCents,
    bonusCents,
    tipsCents,
    notes,
    status,
    deleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkEntry &&
          other.id == this.id &&
          other.employerId == this.employerId &&
          other.startTimeUtc == this.startTimeUtc &&
          other.endTimeUtc == this.endTimeUtc &&
          other.timezone == this.timezone &&
          other.breakMinutes == this.breakMinutes &&
          other.paidBreakMinutes == this.paidBreakMinutes &&
          other.hourlyRateSnapshotCents == this.hourlyRateSnapshotCents &&
          other.bonusCents == this.bonusCents &&
          other.tipsCents == this.tipsCents &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkEntriesCompanion extends UpdateCompanion<WorkEntry> {
  final Value<String> id;
  final Value<String> employerId;
  final Value<DateTime> startTimeUtc;
  final Value<DateTime?> endTimeUtc;
  final Value<String> timezone;
  final Value<int> breakMinutes;
  final Value<int> paidBreakMinutes;
  final Value<int> hourlyRateSnapshotCents;
  final Value<int> bonusCents;
  final Value<int> tipsCents;
  final Value<String> notes;
  final Value<String> status;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkEntriesCompanion({
    this.id = const Value.absent(),
    this.employerId = const Value.absent(),
    this.startTimeUtc = const Value.absent(),
    this.endTimeUtc = const Value.absent(),
    this.timezone = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.paidBreakMinutes = const Value.absent(),
    this.hourlyRateSnapshotCents = const Value.absent(),
    this.bonusCents = const Value.absent(),
    this.tipsCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkEntriesCompanion.insert({
    required String id,
    required String employerId,
    required DateTime startTimeUtc,
    this.endTimeUtc = const Value.absent(),
    this.timezone = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.paidBreakMinutes = const Value.absent(),
    required int hourlyRateSnapshotCents,
    this.bonusCents = const Value.absent(),
    this.tipsCents = const Value.absent(),
    this.notes = const Value.absent(),
    required String status,
    this.deleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employerId = Value(employerId),
       startTimeUtc = Value(startTimeUtc),
       hourlyRateSnapshotCents = Value(hourlyRateSnapshotCents),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkEntry> custom({
    Expression<String>? id,
    Expression<String>? employerId,
    Expression<DateTime>? startTimeUtc,
    Expression<DateTime>? endTimeUtc,
    Expression<String>? timezone,
    Expression<int>? breakMinutes,
    Expression<int>? paidBreakMinutes,
    Expression<int>? hourlyRateSnapshotCents,
    Expression<int>? bonusCents,
    Expression<int>? tipsCents,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employerId != null) 'employer_id': employerId,
      if (startTimeUtc != null) 'start_time_utc': startTimeUtc,
      if (endTimeUtc != null) 'end_time_utc': endTimeUtc,
      if (timezone != null) 'timezone': timezone,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (paidBreakMinutes != null) 'paid_break_minutes': paidBreakMinutes,
      if (hourlyRateSnapshotCents != null)
        'hourly_rate_snapshot_cents': hourlyRateSnapshotCents,
      if (bonusCents != null) 'bonus_cents': bonusCents,
      if (tipsCents != null) 'tips_cents': tipsCents,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? employerId,
    Value<DateTime>? startTimeUtc,
    Value<DateTime?>? endTimeUtc,
    Value<String>? timezone,
    Value<int>? breakMinutes,
    Value<int>? paidBreakMinutes,
    Value<int>? hourlyRateSnapshotCents,
    Value<int>? bonusCents,
    Value<int>? tipsCents,
    Value<String>? notes,
    Value<String>? status,
    Value<bool>? deleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkEntriesCompanion(
      id: id ?? this.id,
      employerId: employerId ?? this.employerId,
      startTimeUtc: startTimeUtc ?? this.startTimeUtc,
      endTimeUtc: endTimeUtc ?? this.endTimeUtc,
      timezone: timezone ?? this.timezone,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      paidBreakMinutes: paidBreakMinutes ?? this.paidBreakMinutes,
      hourlyRateSnapshotCents:
          hourlyRateSnapshotCents ?? this.hourlyRateSnapshotCents,
      bonusCents: bonusCents ?? this.bonusCents,
      tipsCents: tipsCents ?? this.tipsCents,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employerId.present) {
      map['employer_id'] = Variable<String>(employerId.value);
    }
    if (startTimeUtc.present) {
      map['start_time_utc'] = Variable<DateTime>(startTimeUtc.value);
    }
    if (endTimeUtc.present) {
      map['end_time_utc'] = Variable<DateTime>(endTimeUtc.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (paidBreakMinutes.present) {
      map['paid_break_minutes'] = Variable<int>(paidBreakMinutes.value);
    }
    if (hourlyRateSnapshotCents.present) {
      map['hourly_rate_snapshot_cents'] = Variable<int>(
        hourlyRateSnapshotCents.value,
      );
    }
    if (bonusCents.present) {
      map['bonus_cents'] = Variable<int>(bonusCents.value);
    }
    if (tipsCents.present) {
      map['tips_cents'] = Variable<int>(tipsCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('employerId: $employerId, ')
          ..write('startTimeUtc: $startTimeUtc, ')
          ..write('endTimeUtc: $endTimeUtc, ')
          ..write('timezone: $timezone, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('paidBreakMinutes: $paidBreakMinutes, ')
          ..write('hourlyRateSnapshotCents: $hourlyRateSnapshotCents, ')
          ..write('bonusCents: $bonusCents, ')
          ..write('tipsCents: $tipsCents, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AcademicPeriodsTable extends AcademicPeriods
    with TableInfo<$AcademicPeriodsTable, AcademicPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AcademicPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _semesterNameMeta = const VerificationMeta(
    'semesterName',
  );
  @override
  late final GeneratedColumn<String> semesterName = GeneratedColumn<String>(
    'semester_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _semesterStartMeta = const VerificationMeta(
    'semesterStart',
  );
  @override
  late final GeneratedColumn<DateTime> semesterStart =
      GeneratedColumn<DateTime>(
        'semester_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _semesterEndMeta = const VerificationMeta(
    'semesterEnd',
  );
  @override
  late final GeneratedColumn<DateTime> semesterEnd = GeneratedColumn<DateTime>(
    'semester_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lectureStartMeta = const VerificationMeta(
    'lectureStart',
  );
  @override
  late final GeneratedColumn<DateTime> lectureStart = GeneratedColumn<DateTime>(
    'lecture_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lectureEndMeta = const VerificationMeta(
    'lectureEnd',
  );
  @override
  late final GeneratedColumn<DateTime> lectureEnd = GeneratedColumn<DateTime>(
    'lecture_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exceptionalLectureFreeJsonMeta =
      const VerificationMeta('exceptionalLectureFreeJson');
  @override
  late final GeneratedColumn<String> exceptionalLectureFreeJson =
      GeneratedColumn<String>(
        'exceptional_lecture_free_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    semesterName,
    semesterStart,
    semesterEnd,
    lectureStart,
    lectureEnd,
    exceptionalLectureFreeJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'academic_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<AcademicPeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('semester_name')) {
      context.handle(
        _semesterNameMeta,
        semesterName.isAcceptableOrUnknown(
          data['semester_name']!,
          _semesterNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_semesterNameMeta);
    }
    if (data.containsKey('semester_start')) {
      context.handle(
        _semesterStartMeta,
        semesterStart.isAcceptableOrUnknown(
          data['semester_start']!,
          _semesterStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_semesterStartMeta);
    }
    if (data.containsKey('semester_end')) {
      context.handle(
        _semesterEndMeta,
        semesterEnd.isAcceptableOrUnknown(
          data['semester_end']!,
          _semesterEndMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_semesterEndMeta);
    }
    if (data.containsKey('lecture_start')) {
      context.handle(
        _lectureStartMeta,
        lectureStart.isAcceptableOrUnknown(
          data['lecture_start']!,
          _lectureStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lectureStartMeta);
    }
    if (data.containsKey('lecture_end')) {
      context.handle(
        _lectureEndMeta,
        lectureEnd.isAcceptableOrUnknown(data['lecture_end']!, _lectureEndMeta),
      );
    } else if (isInserting) {
      context.missing(_lectureEndMeta);
    }
    if (data.containsKey('exceptional_lecture_free_json')) {
      context.handle(
        _exceptionalLectureFreeJsonMeta,
        exceptionalLectureFreeJson.isAcceptableOrUnknown(
          data['exceptional_lecture_free_json']!,
          _exceptionalLectureFreeJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AcademicPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AcademicPeriod(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      semesterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}semester_name'],
      )!,
      semesterStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}semester_start'],
      )!,
      semesterEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}semester_end'],
      )!,
      lectureStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lecture_start'],
      )!,
      lectureEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lecture_end'],
      )!,
      exceptionalLectureFreeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exceptional_lecture_free_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AcademicPeriodsTable createAlias(String alias) {
    return $AcademicPeriodsTable(attachedDatabase, alias);
  }
}

class AcademicPeriod extends DataClass implements Insertable<AcademicPeriod> {
  final String id;
  final String semesterName;
  final DateTime semesterStart;
  final DateTime semesterEnd;
  final DateTime lectureStart;
  final DateTime lectureEnd;
  final String exceptionalLectureFreeJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AcademicPeriod({
    required this.id,
    required this.semesterName,
    required this.semesterStart,
    required this.semesterEnd,
    required this.lectureStart,
    required this.lectureEnd,
    required this.exceptionalLectureFreeJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['semester_name'] = Variable<String>(semesterName);
    map['semester_start'] = Variable<DateTime>(semesterStart);
    map['semester_end'] = Variable<DateTime>(semesterEnd);
    map['lecture_start'] = Variable<DateTime>(lectureStart);
    map['lecture_end'] = Variable<DateTime>(lectureEnd);
    map['exceptional_lecture_free_json'] = Variable<String>(
      exceptionalLectureFreeJson,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AcademicPeriodsCompanion toCompanion(bool nullToAbsent) {
    return AcademicPeriodsCompanion(
      id: Value(id),
      semesterName: Value(semesterName),
      semesterStart: Value(semesterStart),
      semesterEnd: Value(semesterEnd),
      lectureStart: Value(lectureStart),
      lectureEnd: Value(lectureEnd),
      exceptionalLectureFreeJson: Value(exceptionalLectureFreeJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AcademicPeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AcademicPeriod(
      id: serializer.fromJson<String>(json['id']),
      semesterName: serializer.fromJson<String>(json['semesterName']),
      semesterStart: serializer.fromJson<DateTime>(json['semesterStart']),
      semesterEnd: serializer.fromJson<DateTime>(json['semesterEnd']),
      lectureStart: serializer.fromJson<DateTime>(json['lectureStart']),
      lectureEnd: serializer.fromJson<DateTime>(json['lectureEnd']),
      exceptionalLectureFreeJson: serializer.fromJson<String>(
        json['exceptionalLectureFreeJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'semesterName': serializer.toJson<String>(semesterName),
      'semesterStart': serializer.toJson<DateTime>(semesterStart),
      'semesterEnd': serializer.toJson<DateTime>(semesterEnd),
      'lectureStart': serializer.toJson<DateTime>(lectureStart),
      'lectureEnd': serializer.toJson<DateTime>(lectureEnd),
      'exceptionalLectureFreeJson': serializer.toJson<String>(
        exceptionalLectureFreeJson,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AcademicPeriod copyWith({
    String? id,
    String? semesterName,
    DateTime? semesterStart,
    DateTime? semesterEnd,
    DateTime? lectureStart,
    DateTime? lectureEnd,
    String? exceptionalLectureFreeJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AcademicPeriod(
    id: id ?? this.id,
    semesterName: semesterName ?? this.semesterName,
    semesterStart: semesterStart ?? this.semesterStart,
    semesterEnd: semesterEnd ?? this.semesterEnd,
    lectureStart: lectureStart ?? this.lectureStart,
    lectureEnd: lectureEnd ?? this.lectureEnd,
    exceptionalLectureFreeJson:
        exceptionalLectureFreeJson ?? this.exceptionalLectureFreeJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AcademicPeriod copyWithCompanion(AcademicPeriodsCompanion data) {
    return AcademicPeriod(
      id: data.id.present ? data.id.value : this.id,
      semesterName: data.semesterName.present
          ? data.semesterName.value
          : this.semesterName,
      semesterStart: data.semesterStart.present
          ? data.semesterStart.value
          : this.semesterStart,
      semesterEnd: data.semesterEnd.present
          ? data.semesterEnd.value
          : this.semesterEnd,
      lectureStart: data.lectureStart.present
          ? data.lectureStart.value
          : this.lectureStart,
      lectureEnd: data.lectureEnd.present
          ? data.lectureEnd.value
          : this.lectureEnd,
      exceptionalLectureFreeJson: data.exceptionalLectureFreeJson.present
          ? data.exceptionalLectureFreeJson.value
          : this.exceptionalLectureFreeJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AcademicPeriod(')
          ..write('id: $id, ')
          ..write('semesterName: $semesterName, ')
          ..write('semesterStart: $semesterStart, ')
          ..write('semesterEnd: $semesterEnd, ')
          ..write('lectureStart: $lectureStart, ')
          ..write('lectureEnd: $lectureEnd, ')
          ..write('exceptionalLectureFreeJson: $exceptionalLectureFreeJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    semesterName,
    semesterStart,
    semesterEnd,
    lectureStart,
    lectureEnd,
    exceptionalLectureFreeJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AcademicPeriod &&
          other.id == this.id &&
          other.semesterName == this.semesterName &&
          other.semesterStart == this.semesterStart &&
          other.semesterEnd == this.semesterEnd &&
          other.lectureStart == this.lectureStart &&
          other.lectureEnd == this.lectureEnd &&
          other.exceptionalLectureFreeJson == this.exceptionalLectureFreeJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AcademicPeriodsCompanion extends UpdateCompanion<AcademicPeriod> {
  final Value<String> id;
  final Value<String> semesterName;
  final Value<DateTime> semesterStart;
  final Value<DateTime> semesterEnd;
  final Value<DateTime> lectureStart;
  final Value<DateTime> lectureEnd;
  final Value<String> exceptionalLectureFreeJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AcademicPeriodsCompanion({
    this.id = const Value.absent(),
    this.semesterName = const Value.absent(),
    this.semesterStart = const Value.absent(),
    this.semesterEnd = const Value.absent(),
    this.lectureStart = const Value.absent(),
    this.lectureEnd = const Value.absent(),
    this.exceptionalLectureFreeJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AcademicPeriodsCompanion.insert({
    required String id,
    required String semesterName,
    required DateTime semesterStart,
    required DateTime semesterEnd,
    required DateTime lectureStart,
    required DateTime lectureEnd,
    this.exceptionalLectureFreeJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       semesterName = Value(semesterName),
       semesterStart = Value(semesterStart),
       semesterEnd = Value(semesterEnd),
       lectureStart = Value(lectureStart),
       lectureEnd = Value(lectureEnd),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AcademicPeriod> custom({
    Expression<String>? id,
    Expression<String>? semesterName,
    Expression<DateTime>? semesterStart,
    Expression<DateTime>? semesterEnd,
    Expression<DateTime>? lectureStart,
    Expression<DateTime>? lectureEnd,
    Expression<String>? exceptionalLectureFreeJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (semesterName != null) 'semester_name': semesterName,
      if (semesterStart != null) 'semester_start': semesterStart,
      if (semesterEnd != null) 'semester_end': semesterEnd,
      if (lectureStart != null) 'lecture_start': lectureStart,
      if (lectureEnd != null) 'lecture_end': lectureEnd,
      if (exceptionalLectureFreeJson != null)
        'exceptional_lecture_free_json': exceptionalLectureFreeJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AcademicPeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? semesterName,
    Value<DateTime>? semesterStart,
    Value<DateTime>? semesterEnd,
    Value<DateTime>? lectureStart,
    Value<DateTime>? lectureEnd,
    Value<String>? exceptionalLectureFreeJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AcademicPeriodsCompanion(
      id: id ?? this.id,
      semesterName: semesterName ?? this.semesterName,
      semesterStart: semesterStart ?? this.semesterStart,
      semesterEnd: semesterEnd ?? this.semesterEnd,
      lectureStart: lectureStart ?? this.lectureStart,
      lectureEnd: lectureEnd ?? this.lectureEnd,
      exceptionalLectureFreeJson:
          exceptionalLectureFreeJson ?? this.exceptionalLectureFreeJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (semesterName.present) {
      map['semester_name'] = Variable<String>(semesterName.value);
    }
    if (semesterStart.present) {
      map['semester_start'] = Variable<DateTime>(semesterStart.value);
    }
    if (semesterEnd.present) {
      map['semester_end'] = Variable<DateTime>(semesterEnd.value);
    }
    if (lectureStart.present) {
      map['lecture_start'] = Variable<DateTime>(lectureStart.value);
    }
    if (lectureEnd.present) {
      map['lecture_end'] = Variable<DateTime>(lectureEnd.value);
    }
    if (exceptionalLectureFreeJson.present) {
      map['exceptional_lecture_free_json'] = Variable<String>(
        exceptionalLectureFreeJson.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AcademicPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('semesterName: $semesterName, ')
          ..write('semesterStart: $semesterStart, ')
          ..write('semesterEnd: $semesterEnd, ')
          ..write('lectureStart: $lectureStart, ')
          ..write('lectureEnd: $lectureEnd, ')
          ..write('exceptionalLectureFreeJson: $exceptionalLectureFreeJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayslipsTable extends Payslips with TableInfo<$PayslipsTable, Payslip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayslipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employerIdMeta = const VerificationMeta(
    'employerId',
  );
  @override
  late final GeneratedColumn<String> employerId = GeneratedColumn<String>(
    'employer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employers (id)',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grossCentsMeta = const VerificationMeta(
    'grossCents',
  );
  @override
  late final GeneratedColumn<int> grossCents = GeneratedColumn<int>(
    'gross_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wageTaxCentsMeta = const VerificationMeta(
    'wageTaxCents',
  );
  @override
  late final GeneratedColumn<int> wageTaxCents = GeneratedColumn<int>(
    'wage_tax_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _solidaritySurchargeCentsMeta =
      const VerificationMeta('solidaritySurchargeCents');
  @override
  late final GeneratedColumn<int> solidaritySurchargeCents =
      GeneratedColumn<int>(
        'solidarity_surcharge_cents',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _churchTaxCentsMeta = const VerificationMeta(
    'churchTaxCents',
  );
  @override
  late final GeneratedColumn<int> churchTaxCents = GeneratedColumn<int>(
    'church_tax_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pensionCentsMeta = const VerificationMeta(
    'pensionCents',
  );
  @override
  late final GeneratedColumn<int> pensionCents = GeneratedColumn<int>(
    'pension_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _healthCentsMeta = const VerificationMeta(
    'healthCents',
  );
  @override
  late final GeneratedColumn<int> healthCents = GeneratedColumn<int>(
    'health_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _careCentsMeta = const VerificationMeta(
    'careCents',
  );
  @override
  late final GeneratedColumn<int> careCents = GeneratedColumn<int>(
    'care_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unemploymentCentsMeta = const VerificationMeta(
    'unemploymentCents',
  );
  @override
  late final GeneratedColumn<int> unemploymentCents = GeneratedColumn<int>(
    'unemployment_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _otherDeductionsCentsMeta =
      const VerificationMeta('otherDeductionsCents');
  @override
  late final GeneratedColumn<int> otherDeductionsCents = GeneratedColumn<int>(
    'other_deductions_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _netCentsMeta = const VerificationMeta(
    'netCents',
  );
  @override
  late final GeneratedColumn<int> netCents = GeneratedColumn<int>(
    'net_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employerId,
    month,
    year,
    grossCents,
    wageTaxCents,
    solidaritySurchargeCents,
    churchTaxCents,
    pensionCents,
    healthCents,
    careCents,
    unemploymentCents,
    otherDeductionsCents,
    netCents,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payslips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payslip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employer_id')) {
      context.handle(
        _employerIdMeta,
        employerId.isAcceptableOrUnknown(data['employer_id']!, _employerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employerIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('gross_cents')) {
      context.handle(
        _grossCentsMeta,
        grossCents.isAcceptableOrUnknown(data['gross_cents']!, _grossCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_grossCentsMeta);
    }
    if (data.containsKey('wage_tax_cents')) {
      context.handle(
        _wageTaxCentsMeta,
        wageTaxCents.isAcceptableOrUnknown(
          data['wage_tax_cents']!,
          _wageTaxCentsMeta,
        ),
      );
    }
    if (data.containsKey('solidarity_surcharge_cents')) {
      context.handle(
        _solidaritySurchargeCentsMeta,
        solidaritySurchargeCents.isAcceptableOrUnknown(
          data['solidarity_surcharge_cents']!,
          _solidaritySurchargeCentsMeta,
        ),
      );
    }
    if (data.containsKey('church_tax_cents')) {
      context.handle(
        _churchTaxCentsMeta,
        churchTaxCents.isAcceptableOrUnknown(
          data['church_tax_cents']!,
          _churchTaxCentsMeta,
        ),
      );
    }
    if (data.containsKey('pension_cents')) {
      context.handle(
        _pensionCentsMeta,
        pensionCents.isAcceptableOrUnknown(
          data['pension_cents']!,
          _pensionCentsMeta,
        ),
      );
    }
    if (data.containsKey('health_cents')) {
      context.handle(
        _healthCentsMeta,
        healthCents.isAcceptableOrUnknown(
          data['health_cents']!,
          _healthCentsMeta,
        ),
      );
    }
    if (data.containsKey('care_cents')) {
      context.handle(
        _careCentsMeta,
        careCents.isAcceptableOrUnknown(data['care_cents']!, _careCentsMeta),
      );
    }
    if (data.containsKey('unemployment_cents')) {
      context.handle(
        _unemploymentCentsMeta,
        unemploymentCents.isAcceptableOrUnknown(
          data['unemployment_cents']!,
          _unemploymentCentsMeta,
        ),
      );
    }
    if (data.containsKey('other_deductions_cents')) {
      context.handle(
        _otherDeductionsCentsMeta,
        otherDeductionsCents.isAcceptableOrUnknown(
          data['other_deductions_cents']!,
          _otherDeductionsCentsMeta,
        ),
      );
    }
    if (data.containsKey('net_cents')) {
      context.handle(
        _netCentsMeta,
        netCents.isAcceptableOrUnknown(data['net_cents']!, _netCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_netCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payslip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payslip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employer_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      grossCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_cents'],
      )!,
      wageTaxCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wage_tax_cents'],
      )!,
      solidaritySurchargeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}solidarity_surcharge_cents'],
      )!,
      churchTaxCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}church_tax_cents'],
      )!,
      pensionCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pension_cents'],
      )!,
      healthCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}health_cents'],
      )!,
      careCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}care_cents'],
      )!,
      unemploymentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unemployment_cents'],
      )!,
      otherDeductionsCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}other_deductions_cents'],
      )!,
      netCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PayslipsTable createAlias(String alias) {
    return $PayslipsTable(attachedDatabase, alias);
  }
}

class Payslip extends DataClass implements Insertable<Payslip> {
  final String id;
  final String employerId;
  final int month;
  final int year;
  final int grossCents;
  final int wageTaxCents;
  final int solidaritySurchargeCents;
  final int churchTaxCents;
  final int pensionCents;
  final int healthCents;
  final int careCents;
  final int unemploymentCents;
  final int otherDeductionsCents;
  final int netCents;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Payslip({
    required this.id,
    required this.employerId,
    required this.month,
    required this.year,
    required this.grossCents,
    required this.wageTaxCents,
    required this.solidaritySurchargeCents,
    required this.churchTaxCents,
    required this.pensionCents,
    required this.healthCents,
    required this.careCents,
    required this.unemploymentCents,
    required this.otherDeductionsCents,
    required this.netCents,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employer_id'] = Variable<String>(employerId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['gross_cents'] = Variable<int>(grossCents);
    map['wage_tax_cents'] = Variable<int>(wageTaxCents);
    map['solidarity_surcharge_cents'] = Variable<int>(solidaritySurchargeCents);
    map['church_tax_cents'] = Variable<int>(churchTaxCents);
    map['pension_cents'] = Variable<int>(pensionCents);
    map['health_cents'] = Variable<int>(healthCents);
    map['care_cents'] = Variable<int>(careCents);
    map['unemployment_cents'] = Variable<int>(unemploymentCents);
    map['other_deductions_cents'] = Variable<int>(otherDeductionsCents);
    map['net_cents'] = Variable<int>(netCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PayslipsCompanion toCompanion(bool nullToAbsent) {
    return PayslipsCompanion(
      id: Value(id),
      employerId: Value(employerId),
      month: Value(month),
      year: Value(year),
      grossCents: Value(grossCents),
      wageTaxCents: Value(wageTaxCents),
      solidaritySurchargeCents: Value(solidaritySurchargeCents),
      churchTaxCents: Value(churchTaxCents),
      pensionCents: Value(pensionCents),
      healthCents: Value(healthCents),
      careCents: Value(careCents),
      unemploymentCents: Value(unemploymentCents),
      otherDeductionsCents: Value(otherDeductionsCents),
      netCents: Value(netCents),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Payslip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payslip(
      id: serializer.fromJson<String>(json['id']),
      employerId: serializer.fromJson<String>(json['employerId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      grossCents: serializer.fromJson<int>(json['grossCents']),
      wageTaxCents: serializer.fromJson<int>(json['wageTaxCents']),
      solidaritySurchargeCents: serializer.fromJson<int>(
        json['solidaritySurchargeCents'],
      ),
      churchTaxCents: serializer.fromJson<int>(json['churchTaxCents']),
      pensionCents: serializer.fromJson<int>(json['pensionCents']),
      healthCents: serializer.fromJson<int>(json['healthCents']),
      careCents: serializer.fromJson<int>(json['careCents']),
      unemploymentCents: serializer.fromJson<int>(json['unemploymentCents']),
      otherDeductionsCents: serializer.fromJson<int>(
        json['otherDeductionsCents'],
      ),
      netCents: serializer.fromJson<int>(json['netCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employerId': serializer.toJson<String>(employerId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'grossCents': serializer.toJson<int>(grossCents),
      'wageTaxCents': serializer.toJson<int>(wageTaxCents),
      'solidaritySurchargeCents': serializer.toJson<int>(
        solidaritySurchargeCents,
      ),
      'churchTaxCents': serializer.toJson<int>(churchTaxCents),
      'pensionCents': serializer.toJson<int>(pensionCents),
      'healthCents': serializer.toJson<int>(healthCents),
      'careCents': serializer.toJson<int>(careCents),
      'unemploymentCents': serializer.toJson<int>(unemploymentCents),
      'otherDeductionsCents': serializer.toJson<int>(otherDeductionsCents),
      'netCents': serializer.toJson<int>(netCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Payslip copyWith({
    String? id,
    String? employerId,
    int? month,
    int? year,
    int? grossCents,
    int? wageTaxCents,
    int? solidaritySurchargeCents,
    int? churchTaxCents,
    int? pensionCents,
    int? healthCents,
    int? careCents,
    int? unemploymentCents,
    int? otherDeductionsCents,
    int? netCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Payslip(
    id: id ?? this.id,
    employerId: employerId ?? this.employerId,
    month: month ?? this.month,
    year: year ?? this.year,
    grossCents: grossCents ?? this.grossCents,
    wageTaxCents: wageTaxCents ?? this.wageTaxCents,
    solidaritySurchargeCents:
        solidaritySurchargeCents ?? this.solidaritySurchargeCents,
    churchTaxCents: churchTaxCents ?? this.churchTaxCents,
    pensionCents: pensionCents ?? this.pensionCents,
    healthCents: healthCents ?? this.healthCents,
    careCents: careCents ?? this.careCents,
    unemploymentCents: unemploymentCents ?? this.unemploymentCents,
    otherDeductionsCents: otherDeductionsCents ?? this.otherDeductionsCents,
    netCents: netCents ?? this.netCents,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Payslip copyWithCompanion(PayslipsCompanion data) {
    return Payslip(
      id: data.id.present ? data.id.value : this.id,
      employerId: data.employerId.present
          ? data.employerId.value
          : this.employerId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      grossCents: data.grossCents.present
          ? data.grossCents.value
          : this.grossCents,
      wageTaxCents: data.wageTaxCents.present
          ? data.wageTaxCents.value
          : this.wageTaxCents,
      solidaritySurchargeCents: data.solidaritySurchargeCents.present
          ? data.solidaritySurchargeCents.value
          : this.solidaritySurchargeCents,
      churchTaxCents: data.churchTaxCents.present
          ? data.churchTaxCents.value
          : this.churchTaxCents,
      pensionCents: data.pensionCents.present
          ? data.pensionCents.value
          : this.pensionCents,
      healthCents: data.healthCents.present
          ? data.healthCents.value
          : this.healthCents,
      careCents: data.careCents.present ? data.careCents.value : this.careCents,
      unemploymentCents: data.unemploymentCents.present
          ? data.unemploymentCents.value
          : this.unemploymentCents,
      otherDeductionsCents: data.otherDeductionsCents.present
          ? data.otherDeductionsCents.value
          : this.otherDeductionsCents,
      netCents: data.netCents.present ? data.netCents.value : this.netCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payslip(')
          ..write('id: $id, ')
          ..write('employerId: $employerId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('grossCents: $grossCents, ')
          ..write('wageTaxCents: $wageTaxCents, ')
          ..write('solidaritySurchargeCents: $solidaritySurchargeCents, ')
          ..write('churchTaxCents: $churchTaxCents, ')
          ..write('pensionCents: $pensionCents, ')
          ..write('healthCents: $healthCents, ')
          ..write('careCents: $careCents, ')
          ..write('unemploymentCents: $unemploymentCents, ')
          ..write('otherDeductionsCents: $otherDeductionsCents, ')
          ..write('netCents: $netCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employerId,
    month,
    year,
    grossCents,
    wageTaxCents,
    solidaritySurchargeCents,
    churchTaxCents,
    pensionCents,
    healthCents,
    careCents,
    unemploymentCents,
    otherDeductionsCents,
    netCents,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payslip &&
          other.id == this.id &&
          other.employerId == this.employerId &&
          other.month == this.month &&
          other.year == this.year &&
          other.grossCents == this.grossCents &&
          other.wageTaxCents == this.wageTaxCents &&
          other.solidaritySurchargeCents == this.solidaritySurchargeCents &&
          other.churchTaxCents == this.churchTaxCents &&
          other.pensionCents == this.pensionCents &&
          other.healthCents == this.healthCents &&
          other.careCents == this.careCents &&
          other.unemploymentCents == this.unemploymentCents &&
          other.otherDeductionsCents == this.otherDeductionsCents &&
          other.netCents == this.netCents &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PayslipsCompanion extends UpdateCompanion<Payslip> {
  final Value<String> id;
  final Value<String> employerId;
  final Value<int> month;
  final Value<int> year;
  final Value<int> grossCents;
  final Value<int> wageTaxCents;
  final Value<int> solidaritySurchargeCents;
  final Value<int> churchTaxCents;
  final Value<int> pensionCents;
  final Value<int> healthCents;
  final Value<int> careCents;
  final Value<int> unemploymentCents;
  final Value<int> otherDeductionsCents;
  final Value<int> netCents;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PayslipsCompanion({
    this.id = const Value.absent(),
    this.employerId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.grossCents = const Value.absent(),
    this.wageTaxCents = const Value.absent(),
    this.solidaritySurchargeCents = const Value.absent(),
    this.churchTaxCents = const Value.absent(),
    this.pensionCents = const Value.absent(),
    this.healthCents = const Value.absent(),
    this.careCents = const Value.absent(),
    this.unemploymentCents = const Value.absent(),
    this.otherDeductionsCents = const Value.absent(),
    this.netCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayslipsCompanion.insert({
    required String id,
    required String employerId,
    required int month,
    required int year,
    required int grossCents,
    this.wageTaxCents = const Value.absent(),
    this.solidaritySurchargeCents = const Value.absent(),
    this.churchTaxCents = const Value.absent(),
    this.pensionCents = const Value.absent(),
    this.healthCents = const Value.absent(),
    this.careCents = const Value.absent(),
    this.unemploymentCents = const Value.absent(),
    this.otherDeductionsCents = const Value.absent(),
    required int netCents,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employerId = Value(employerId),
       month = Value(month),
       year = Value(year),
       grossCents = Value(grossCents),
       netCents = Value(netCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Payslip> custom({
    Expression<String>? id,
    Expression<String>? employerId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<int>? grossCents,
    Expression<int>? wageTaxCents,
    Expression<int>? solidaritySurchargeCents,
    Expression<int>? churchTaxCents,
    Expression<int>? pensionCents,
    Expression<int>? healthCents,
    Expression<int>? careCents,
    Expression<int>? unemploymentCents,
    Expression<int>? otherDeductionsCents,
    Expression<int>? netCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employerId != null) 'employer_id': employerId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (grossCents != null) 'gross_cents': grossCents,
      if (wageTaxCents != null) 'wage_tax_cents': wageTaxCents,
      if (solidaritySurchargeCents != null)
        'solidarity_surcharge_cents': solidaritySurchargeCents,
      if (churchTaxCents != null) 'church_tax_cents': churchTaxCents,
      if (pensionCents != null) 'pension_cents': pensionCents,
      if (healthCents != null) 'health_cents': healthCents,
      if (careCents != null) 'care_cents': careCents,
      if (unemploymentCents != null) 'unemployment_cents': unemploymentCents,
      if (otherDeductionsCents != null)
        'other_deductions_cents': otherDeductionsCents,
      if (netCents != null) 'net_cents': netCents,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayslipsCompanion copyWith({
    Value<String>? id,
    Value<String>? employerId,
    Value<int>? month,
    Value<int>? year,
    Value<int>? grossCents,
    Value<int>? wageTaxCents,
    Value<int>? solidaritySurchargeCents,
    Value<int>? churchTaxCents,
    Value<int>? pensionCents,
    Value<int>? healthCents,
    Value<int>? careCents,
    Value<int>? unemploymentCents,
    Value<int>? otherDeductionsCents,
    Value<int>? netCents,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PayslipsCompanion(
      id: id ?? this.id,
      employerId: employerId ?? this.employerId,
      month: month ?? this.month,
      year: year ?? this.year,
      grossCents: grossCents ?? this.grossCents,
      wageTaxCents: wageTaxCents ?? this.wageTaxCents,
      solidaritySurchargeCents:
          solidaritySurchargeCents ?? this.solidaritySurchargeCents,
      churchTaxCents: churchTaxCents ?? this.churchTaxCents,
      pensionCents: pensionCents ?? this.pensionCents,
      healthCents: healthCents ?? this.healthCents,
      careCents: careCents ?? this.careCents,
      unemploymentCents: unemploymentCents ?? this.unemploymentCents,
      otherDeductionsCents: otherDeductionsCents ?? this.otherDeductionsCents,
      netCents: netCents ?? this.netCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employerId.present) {
      map['employer_id'] = Variable<String>(employerId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (grossCents.present) {
      map['gross_cents'] = Variable<int>(grossCents.value);
    }
    if (wageTaxCents.present) {
      map['wage_tax_cents'] = Variable<int>(wageTaxCents.value);
    }
    if (solidaritySurchargeCents.present) {
      map['solidarity_surcharge_cents'] = Variable<int>(
        solidaritySurchargeCents.value,
      );
    }
    if (churchTaxCents.present) {
      map['church_tax_cents'] = Variable<int>(churchTaxCents.value);
    }
    if (pensionCents.present) {
      map['pension_cents'] = Variable<int>(pensionCents.value);
    }
    if (healthCents.present) {
      map['health_cents'] = Variable<int>(healthCents.value);
    }
    if (careCents.present) {
      map['care_cents'] = Variable<int>(careCents.value);
    }
    if (unemploymentCents.present) {
      map['unemployment_cents'] = Variable<int>(unemploymentCents.value);
    }
    if (otherDeductionsCents.present) {
      map['other_deductions_cents'] = Variable<int>(otherDeductionsCents.value);
    }
    if (netCents.present) {
      map['net_cents'] = Variable<int>(netCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayslipsCompanion(')
          ..write('id: $id, ')
          ..write('employerId: $employerId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('grossCents: $grossCents, ')
          ..write('wageTaxCents: $wageTaxCents, ')
          ..write('solidaritySurchargeCents: $solidaritySurchargeCents, ')
          ..write('churchTaxCents: $churchTaxCents, ')
          ..write('pensionCents: $pensionCents, ')
          ..write('healthCents: $healthCents, ')
          ..write('careCents: $careCents, ')
          ..write('unemploymentCents: $unemploymentCents, ')
          ..write('otherDeductionsCents: $otherDeductionsCents, ')
          ..write('netCents: $netCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalRulesTable extends LegalRules
    with TableInfo<$LegalRulesTable, LegalRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _effectiveToMeta = const VerificationMeta(
    'effectiveTo',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
    'effective_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTitleMeta = const VerificationMeta(
    'sourceTitle',
  );
  @override
  late final GeneratedColumn<String> sourceTitle = GeneratedColumn<String>(
    'source_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastVerifiedMeta = const VerificationMeta(
    'lastVerified',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerified = GeneratedColumn<DateTime>(
    'last_verified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    effectiveFrom,
    effectiveTo,
    value,
    unit,
    sourceUrl,
    sourceTitle,
    lastVerified,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('effective_to')) {
      context.handle(
        _effectiveToMeta,
        effectiveTo.isAcceptableOrUnknown(
          data['effective_to']!,
          _effectiveToMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('source_title')) {
      context.handle(
        _sourceTitleMeta,
        sourceTitle.isAcceptableOrUnknown(
          data['source_title']!,
          _sourceTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceTitleMeta);
    }
    if (data.containsKey('last_verified')) {
      context.handle(
        _lastVerifiedMeta,
        lastVerified.isAcceptableOrUnknown(
          data['last_verified']!,
          _lastVerifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastVerifiedMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {key, effectiveFrom},
  ];
  @override
  LegalRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_from'],
      )!,
      effectiveTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_to'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      sourceTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_title'],
      )!,
      lastVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
    );
  }

  @override
  $LegalRulesTable createAlias(String alias) {
    return $LegalRulesTable(attachedDatabase, alias);
  }
}

class LegalRule extends DataClass implements Insertable<LegalRule> {
  final String id;
  final String key;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final double value;
  final String unit;
  final String sourceUrl;
  final String sourceTitle;
  final DateTime lastVerified;
  final String metadataJson;
  const LegalRule({
    required this.id,
    required this.key,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.value,
    required this.unit,
    required this.sourceUrl,
    required this.sourceTitle,
    required this.lastVerified,
    required this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['source_url'] = Variable<String>(sourceUrl);
    map['source_title'] = Variable<String>(sourceTitle);
    map['last_verified'] = Variable<DateTime>(lastVerified);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  LegalRulesCompanion toCompanion(bool nullToAbsent) {
    return LegalRulesCompanion(
      id: Value(id),
      key: Value(key),
      effectiveFrom: Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      value: Value(value),
      unit: Value(unit),
      sourceUrl: Value(sourceUrl),
      sourceTitle: Value(sourceTitle),
      lastVerified: Value(lastVerified),
      metadataJson: Value(metadataJson),
    );
  }

  factory LegalRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalRule(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      sourceTitle: serializer.fromJson<String>(json['sourceTitle']),
      lastVerified: serializer.fromJson<DateTime>(json['lastVerified']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'sourceTitle': serializer.toJson<String>(sourceTitle),
      'lastVerified': serializer.toJson<DateTime>(lastVerified),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  LegalRule copyWith({
    String? id,
    String? key,
    DateTime? effectiveFrom,
    Value<DateTime?> effectiveTo = const Value.absent(),
    double? value,
    String? unit,
    String? sourceUrl,
    String? sourceTitle,
    DateTime? lastVerified,
    String? metadataJson,
  }) => LegalRule(
    id: id ?? this.id,
    key: key ?? this.key,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    sourceTitle: sourceTitle ?? this.sourceTitle,
    lastVerified: lastVerified ?? this.lastVerified,
    metadataJson: metadataJson ?? this.metadataJson,
  );
  LegalRule copyWithCompanion(LegalRulesCompanion data) {
    return LegalRule(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo: data.effectiveTo.present
          ? data.effectiveTo.value
          : this.effectiveTo,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      sourceTitle: data.sourceTitle.present
          ? data.sourceTitle.value
          : this.sourceTitle,
      lastVerified: data.lastVerified.present
          ? data.lastVerified.value
          : this.lastVerified,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalRule(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('lastVerified: $lastVerified, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    key,
    effectiveFrom,
    effectiveTo,
    value,
    unit,
    sourceUrl,
    sourceTitle,
    lastVerified,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalRule &&
          other.id == this.id &&
          other.key == this.key &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.sourceUrl == this.sourceUrl &&
          other.sourceTitle == this.sourceTitle &&
          other.lastVerified == this.lastVerified &&
          other.metadataJson == this.metadataJson);
}

class LegalRulesCompanion extends UpdateCompanion<LegalRule> {
  final Value<String> id;
  final Value<String> key;
  final Value<DateTime> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> sourceUrl;
  final Value<String> sourceTitle;
  final Value<DateTime> lastVerified;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const LegalRulesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.sourceTitle = const Value.absent(),
    this.lastVerified = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalRulesCompanion.insert({
    required String id,
    required String key,
    required DateTime effectiveFrom,
    this.effectiveTo = const Value.absent(),
    required double value,
    required String unit,
    required String sourceUrl,
    required String sourceTitle,
    required DateTime lastVerified,
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       key = Value(key),
       effectiveFrom = Value(effectiveFrom),
       value = Value(value),
       unit = Value(unit),
       sourceUrl = Value(sourceUrl),
       sourceTitle = Value(sourceTitle),
       lastVerified = Value(lastVerified);
  static Insertable<LegalRule> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? sourceUrl,
    Expression<String>? sourceTitle,
    Expression<DateTime>? lastVerified,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (sourceTitle != null) 'source_title': sourceTitle,
      if (lastVerified != null) 'last_verified': lastVerified,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? key,
    Value<DateTime>? effectiveFrom,
    Value<DateTime?>? effectiveTo,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? sourceUrl,
    Value<String>? sourceTitle,
    Value<DateTime>? lastVerified,
    Value<String>? metadataJson,
    Value<int>? rowid,
  }) {
    return LegalRulesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      lastVerified: lastVerified ?? this.lastVerified,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (sourceTitle.present) {
      map['source_title'] = Variable<String>(sourceTitle.value);
    }
    if (lastVerified.present) {
      map['last_verified'] = Variable<DateTime>(lastVerified.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalRulesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('lastVerified: $lastVerified, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannedShiftsTable extends PlannedShifts
    with TableInfo<$PlannedShiftsTable, PlannedShift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workEntryIdMeta = const VerificationMeta(
    'workEntryId',
  );
  @override
  late final GeneratedColumn<String> workEntryId = GeneratedColumn<String>(
    'work_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES work_entries (id)',
    ),
  );
  static const VerificationMeta _notificationScheduledMeta =
      const VerificationMeta('notificationScheduled');
  @override
  late final GeneratedColumn<bool> notificationScheduled =
      GeneratedColumn<bool>(
        'notification_scheduled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_scheduled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workEntryId,
    notificationScheduled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedShift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_entry_id')) {
      context.handle(
        _workEntryIdMeta,
        workEntryId.isAcceptableOrUnknown(
          data['work_entry_id']!,
          _workEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workEntryIdMeta);
    }
    if (data.containsKey('notification_scheduled')) {
      context.handle(
        _notificationScheduledMeta,
        notificationScheduled.isAcceptableOrUnknown(
          data['notification_scheduled']!,
          _notificationScheduledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedShift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedShift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_entry_id'],
      )!,
      notificationScheduled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_scheduled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlannedShiftsTable createAlias(String alias) {
    return $PlannedShiftsTable(attachedDatabase, alias);
  }
}

class PlannedShift extends DataClass implements Insertable<PlannedShift> {
  final String id;
  final String workEntryId;
  final bool notificationScheduled;
  final DateTime createdAt;
  const PlannedShift({
    required this.id,
    required this.workEntryId,
    required this.notificationScheduled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_entry_id'] = Variable<String>(workEntryId);
    map['notification_scheduled'] = Variable<bool>(notificationScheduled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlannedShiftsCompanion toCompanion(bool nullToAbsent) {
    return PlannedShiftsCompanion(
      id: Value(id),
      workEntryId: Value(workEntryId),
      notificationScheduled: Value(notificationScheduled),
      createdAt: Value(createdAt),
    );
  }

  factory PlannedShift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedShift(
      id: serializer.fromJson<String>(json['id']),
      workEntryId: serializer.fromJson<String>(json['workEntryId']),
      notificationScheduled: serializer.fromJson<bool>(
        json['notificationScheduled'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workEntryId': serializer.toJson<String>(workEntryId),
      'notificationScheduled': serializer.toJson<bool>(notificationScheduled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlannedShift copyWith({
    String? id,
    String? workEntryId,
    bool? notificationScheduled,
    DateTime? createdAt,
  }) => PlannedShift(
    id: id ?? this.id,
    workEntryId: workEntryId ?? this.workEntryId,
    notificationScheduled: notificationScheduled ?? this.notificationScheduled,
    createdAt: createdAt ?? this.createdAt,
  );
  PlannedShift copyWithCompanion(PlannedShiftsCompanion data) {
    return PlannedShift(
      id: data.id.present ? data.id.value : this.id,
      workEntryId: data.workEntryId.present
          ? data.workEntryId.value
          : this.workEntryId,
      notificationScheduled: data.notificationScheduled.present
          ? data.notificationScheduled.value
          : this.notificationScheduled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedShift(')
          ..write('id: $id, ')
          ..write('workEntryId: $workEntryId, ')
          ..write('notificationScheduled: $notificationScheduled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workEntryId, notificationScheduled, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedShift &&
          other.id == this.id &&
          other.workEntryId == this.workEntryId &&
          other.notificationScheduled == this.notificationScheduled &&
          other.createdAt == this.createdAt);
}

class PlannedShiftsCompanion extends UpdateCompanion<PlannedShift> {
  final Value<String> id;
  final Value<String> workEntryId;
  final Value<bool> notificationScheduled;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlannedShiftsCompanion({
    this.id = const Value.absent(),
    this.workEntryId = const Value.absent(),
    this.notificationScheduled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedShiftsCompanion.insert({
    required String id,
    required String workEntryId,
    this.notificationScheduled = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workEntryId = Value(workEntryId),
       createdAt = Value(createdAt);
  static Insertable<PlannedShift> custom({
    Expression<String>? id,
    Expression<String>? workEntryId,
    Expression<bool>? notificationScheduled,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workEntryId != null) 'work_entry_id': workEntryId,
      if (notificationScheduled != null)
        'notification_scheduled': notificationScheduled,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedShiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? workEntryId,
    Value<bool>? notificationScheduled,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PlannedShiftsCompanion(
      id: id ?? this.id,
      workEntryId: workEntryId ?? this.workEntryId,
      notificationScheduled:
          notificationScheduled ?? this.notificationScheduled,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workEntryId.present) {
      map['work_entry_id'] = Variable<String>(workEntryId.value);
    }
    if (notificationScheduled.present) {
      map['notification_scheduled'] = Variable<bool>(
        notificationScheduled.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedShiftsCompanion(')
          ..write('id: $id, ')
          ..write('workEntryId: $workEntryId, ')
          ..write('notificationScheduled: $notificationScheduled, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String valueJson;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.valueJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? valueJson, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String valueJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tombstoneMeta = const VerificationMeta(
    'tombstone',
  );
  @override
  late final GeneratedColumn<bool> tombstone = GeneratedColumn<bool>(
    'tombstone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tombstone" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _remoteUpdatedAtMeta = const VerificationMeta(
    'remoteUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>(
        'remote_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    entityId,
    entityType,
    deviceId,
    status,
    tombstone,
    localUpdatedAt,
    remoteUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('tombstone')) {
      context.handle(
        _tombstoneMeta,
        tombstone.isAcceptableOrUnknown(data['tombstone']!, _tombstoneMeta),
      );
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localUpdatedAtMeta);
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
        _remoteUpdatedAtMeta,
        remoteUpdatedAt.isAcceptableOrUnknown(
          data['remote_updated_at']!,
          _remoteUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, entityType};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tombstone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tombstone'],
      )!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      )!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remote_updated_at'],
      ),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String entityId;
  final String entityType;
  final String deviceId;
  final String status;
  final bool tombstone;
  final DateTime localUpdatedAt;
  final DateTime? remoteUpdatedAt;
  const SyncMetadataData({
    required this.entityId,
    required this.entityType,
    required this.deviceId,
    required this.status,
    required this.tombstone,
    required this.localUpdatedAt,
    this.remoteUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['device_id'] = Variable<String>(deviceId);
    map['status'] = Variable<String>(status);
    map['tombstone'] = Variable<bool>(tombstone);
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      entityId: Value(entityId),
      entityType: Value(entityType),
      deviceId: Value(deviceId),
      status: Value(status),
      tombstone: Value(tombstone),
      localUpdatedAt: Value(localUpdatedAt),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      status: serializer.fromJson<String>(json['status']),
      tombstone: serializer.fromJson<bool>(json['tombstone']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<DateTime?>(json['remoteUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'deviceId': serializer.toJson<String>(deviceId),
      'status': serializer.toJson<String>(status),
      'tombstone': serializer.toJson<bool>(tombstone),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<DateTime?>(remoteUpdatedAt),
    };
  }

  SyncMetadataData copyWith({
    String? entityId,
    String? entityType,
    String? deviceId,
    String? status,
    bool? tombstone,
    DateTime? localUpdatedAt,
    Value<DateTime?> remoteUpdatedAt = const Value.absent(),
  }) => SyncMetadataData(
    entityId: entityId ?? this.entityId,
    entityType: entityType ?? this.entityType,
    deviceId: deviceId ?? this.deviceId,
    status: status ?? this.status,
    tombstone: tombstone ?? this.tombstone,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    remoteUpdatedAt: remoteUpdatedAt.present
        ? remoteUpdatedAt.value
        : this.remoteUpdatedAt,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      status: data.status.present ? data.status.value : this.status,
      tombstone: data.tombstone.present ? data.tombstone.value : this.tombstone,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('tombstone: $tombstone, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entityId,
    entityType,
    deviceId,
    status,
    tombstone,
    localUpdatedAt,
    remoteUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.deviceId == this.deviceId &&
          other.status == this.status &&
          other.tombstone == this.tombstone &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<String> deviceId;
  final Value<String> status;
  final Value<bool> tombstone;
  final Value<DateTime> localUpdatedAt;
  final Value<DateTime?> remoteUpdatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.status = const Value.absent(),
    this.tombstone = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String entityId,
    required String entityType,
    required String deviceId,
    required String status,
    this.tombstone = const Value.absent(),
    required DateTime localUpdatedAt,
    this.remoteUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId),
       entityType = Value(entityType),
       deviceId = Value(deviceId),
       status = Value(status),
       localUpdatedAt = Value(localUpdatedAt);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<String>? deviceId,
    Expression<String>? status,
    Expression<bool>? tombstone,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (deviceId != null) 'device_id': deviceId,
      if (status != null) 'status': status,
      if (tombstone != null) 'tombstone': tombstone,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? entityId,
    Value<String>? entityType,
    Value<String>? deviceId,
    Value<String>? status,
    Value<bool>? tombstone,
    Value<DateTime>? localUpdatedAt,
    Value<DateTime?>? remoteUpdatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      tombstone: tombstone ?? this.tombstone,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tombstone.present) {
      map['tombstone'] = Variable<bool>(tombstone.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('tombstone: $tombstone, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $EmployersTable employers = $EmployersTable(this);
  late final $WorkEntriesTable workEntries = $WorkEntriesTable(this);
  late final $AcademicPeriodsTable academicPeriods = $AcademicPeriodsTable(
    this,
  );
  late final $PayslipsTable payslips = $PayslipsTable(this);
  late final $LegalRulesTable legalRules = $LegalRulesTable(this);
  late final $PlannedShiftsTable plannedShifts = $PlannedShiftsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    employers,
    workEntries,
    academicPeriods,
    payslips,
    legalRules,
    plannedShifts,
    appSettings,
    syncMetadata,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String> displayName,
      Value<bool> isStudent,
      Value<bool> tracksResidenceAllowance,
      Value<bool> onboardingComplete,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<bool> isStudent,
      Value<bool> tracksResidenceAllowance,
      Value<bool> onboardingComplete,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStudent => $composableBuilder(
    column: $table.isStudent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tracksResidenceAllowance => $composableBuilder(
    column: $table.tracksResidenceAllowance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStudent => $composableBuilder(
    column: $table.isStudent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tracksResidenceAllowance => $composableBuilder(
    column: $table.tracksResidenceAllowance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStudent =>
      $composableBuilder(column: $table.isStudent, builder: (column) => column);

  GeneratedColumn<bool> get tracksResidenceAllowance => $composableBuilder(
    column: $table.tracksResidenceAllowance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isStudent = const Value.absent(),
                Value<bool> tracksResidenceAllowance = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                isStudent: isStudent,
                tracksResidenceAllowance: tracksResidenceAllowance,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> displayName = const Value.absent(),
                Value<bool> isStudent = const Value.absent(),
                Value<bool> tracksResidenceAllowance = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                isStudent: isStudent,
                tracksResidenceAllowance: tracksResidenceAllowance,
                onboardingComplete: onboardingComplete,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$EmployersTableCreateCompanionBuilder =
    EmployersCompanion Function({
      required String id,
      required String name,
      required String jobTitle,
      required String employmentType,
      required int hourlyRateCents,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<bool> countsForResidenceLimit,
      Value<bool> countsForStudentHourRule,
      Value<bool> isSocialInsuranceLiable,
      Value<bool> pensionExempt,
      Value<int> taxClass,
      Value<String> notes,
      Value<bool> deleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EmployersTableUpdateCompanionBuilder =
    EmployersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> jobTitle,
      Value<String> employmentType,
      Value<int> hourlyRateCents,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<bool> countsForResidenceLimit,
      Value<bool> countsForStudentHourRule,
      Value<bool> isSocialInsuranceLiable,
      Value<bool> pensionExempt,
      Value<int> taxClass,
      Value<String> notes,
      Value<bool> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$EmployersTableReferences
    extends BaseReferences<_$AppDatabase, $EmployersTable, Employer> {
  $$EmployersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkEntriesTable, List<WorkEntry>>
  _workEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workEntries,
    aliasName: 'employers__id__work_entries__employer_id',
  );

  $$WorkEntriesTableProcessedTableManager get workEntriesRefs {
    final manager = $$WorkEntriesTableTableManager(
      $_db,
      $_db.workEntries,
    ).filter((f) => f.employerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PayslipsTable, List<Payslip>> _payslipsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payslips,
    aliasName: 'employers__id__payslips__employer_id',
  );

  $$PayslipsTableProcessedTableManager get payslipsRefs {
    final manager = $$PayslipsTableTableManager(
      $_db,
      $_db.payslips,
    ).filter((f) => f.employerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_payslipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployersTableFilterComposer
    extends Composer<_$AppDatabase, $EmployersTable> {
  $$EmployersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get countsForResidenceLimit => $composableBuilder(
    column: $table.countsForResidenceLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get countsForStudentHourRule => $composableBuilder(
    column: $table.countsForStudentHourRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSocialInsuranceLiable => $composableBuilder(
    column: $table.isSocialInsuranceLiable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pensionExempt => $composableBuilder(
    column: $table.pensionExempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxClass => $composableBuilder(
    column: $table.taxClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workEntriesRefs(
    Expression<bool> Function($$WorkEntriesTableFilterComposer f) f,
  ) {
    final $$WorkEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workEntries,
      getReferencedColumn: (t) => t.employerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkEntriesTableFilterComposer(
            $db: $db,
            $table: $db.workEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> payslipsRefs(
    Expression<bool> Function($$PayslipsTableFilterComposer f) f,
  ) {
    final $$PayslipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payslips,
      getReferencedColumn: (t) => t.employerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayslipsTableFilterComposer(
            $db: $db,
            $table: $db.payslips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployersTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployersTable> {
  $$EmployersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get countsForResidenceLimit => $composableBuilder(
    column: $table.countsForResidenceLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get countsForStudentHourRule => $composableBuilder(
    column: $table.countsForStudentHourRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSocialInsuranceLiable => $composableBuilder(
    column: $table.isSocialInsuranceLiable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pensionExempt => $composableBuilder(
    column: $table.pensionExempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxClass => $composableBuilder(
    column: $table.taxClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployersTable> {
  $$EmployersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get countsForResidenceLimit => $composableBuilder(
    column: $table.countsForResidenceLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get countsForStudentHourRule => $composableBuilder(
    column: $table.countsForStudentHourRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSocialInsuranceLiable => $composableBuilder(
    column: $table.isSocialInsuranceLiable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pensionExempt => $composableBuilder(
    column: $table.pensionExempt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxClass =>
      $composableBuilder(column: $table.taxClass, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workEntriesRefs<T extends Object>(
    Expression<T> Function($$WorkEntriesTableAnnotationComposer a) f,
  ) {
    final $$WorkEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workEntries,
      getReferencedColumn: (t) => t.employerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.workEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> payslipsRefs<T extends Object>(
    Expression<T> Function($$PayslipsTableAnnotationComposer a) f,
  ) {
    final $$PayslipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payslips,
      getReferencedColumn: (t) => t.employerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayslipsTableAnnotationComposer(
            $db: $db,
            $table: $db.payslips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployersTable,
          Employer,
          $$EmployersTableFilterComposer,
          $$EmployersTableOrderingComposer,
          $$EmployersTableAnnotationComposer,
          $$EmployersTableCreateCompanionBuilder,
          $$EmployersTableUpdateCompanionBuilder,
          (Employer, $$EmployersTableReferences),
          Employer,
          PrefetchHooks Function({bool workEntriesRefs, bool payslipsRefs})
        > {
  $$EmployersTableTableManager(_$AppDatabase db, $EmployersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> jobTitle = const Value.absent(),
                Value<String> employmentType = const Value.absent(),
                Value<int> hourlyRateCents = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> countsForResidenceLimit = const Value.absent(),
                Value<bool> countsForStudentHourRule = const Value.absent(),
                Value<bool> isSocialInsuranceLiable = const Value.absent(),
                Value<bool> pensionExempt = const Value.absent(),
                Value<int> taxClass = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployersCompanion(
                id: id,
                name: name,
                jobTitle: jobTitle,
                employmentType: employmentType,
                hourlyRateCents: hourlyRateCents,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
                countsForResidenceLimit: countsForResidenceLimit,
                countsForStudentHourRule: countsForStudentHourRule,
                isSocialInsuranceLiable: isSocialInsuranceLiable,
                pensionExempt: pensionExempt,
                taxClass: taxClass,
                notes: notes,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String jobTitle,
                required String employmentType,
                required int hourlyRateCents,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> countsForResidenceLimit = const Value.absent(),
                Value<bool> countsForStudentHourRule = const Value.absent(),
                Value<bool> isSocialInsuranceLiable = const Value.absent(),
                Value<bool> pensionExempt = const Value.absent(),
                Value<int> taxClass = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EmployersCompanion.insert(
                id: id,
                name: name,
                jobTitle: jobTitle,
                employmentType: employmentType,
                hourlyRateCents: hourlyRateCents,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
                countsForResidenceLimit: countsForResidenceLimit,
                countsForStudentHourRule: countsForStudentHourRule,
                isSocialInsuranceLiable: isSocialInsuranceLiable,
                pensionExempt: pensionExempt,
                taxClass: taxClass,
                notes: notes,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workEntriesRefs = false, payslipsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workEntriesRefs) db.workEntries,
                    if (payslipsRefs) db.payslips,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workEntriesRefs)
                        await $_getPrefetchedData<
                          Employer,
                          $EmployersTable,
                          WorkEntry
                        >(
                          currentTable: table,
                          referencedTable: $$EmployersTableReferences
                              ._workEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployersTableReferences(
                                db,
                                table,
                                p0,
                              ).workEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (payslipsRefs)
                        await $_getPrefetchedData<
                          Employer,
                          $EmployersTable,
                          Payslip
                        >(
                          currentTable: table,
                          referencedTable: $$EmployersTableReferences
                              ._payslipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployersTableReferences(
                                db,
                                table,
                                p0,
                              ).payslipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmployersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployersTable,
      Employer,
      $$EmployersTableFilterComposer,
      $$EmployersTableOrderingComposer,
      $$EmployersTableAnnotationComposer,
      $$EmployersTableCreateCompanionBuilder,
      $$EmployersTableUpdateCompanionBuilder,
      (Employer, $$EmployersTableReferences),
      Employer,
      PrefetchHooks Function({bool workEntriesRefs, bool payslipsRefs})
    >;
typedef $$WorkEntriesTableCreateCompanionBuilder =
    WorkEntriesCompanion Function({
      required String id,
      required String employerId,
      required DateTime startTimeUtc,
      Value<DateTime?> endTimeUtc,
      Value<String> timezone,
      Value<int> breakMinutes,
      Value<int> paidBreakMinutes,
      required int hourlyRateSnapshotCents,
      Value<int> bonusCents,
      Value<int> tipsCents,
      Value<String> notes,
      required String status,
      Value<bool> deleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkEntriesTableUpdateCompanionBuilder =
    WorkEntriesCompanion Function({
      Value<String> id,
      Value<String> employerId,
      Value<DateTime> startTimeUtc,
      Value<DateTime?> endTimeUtc,
      Value<String> timezone,
      Value<int> breakMinutes,
      Value<int> paidBreakMinutes,
      Value<int> hourlyRateSnapshotCents,
      Value<int> bonusCents,
      Value<int> tipsCents,
      Value<String> notes,
      Value<String> status,
      Value<bool> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkEntriesTable, WorkEntry> {
  $$WorkEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployersTable _employerIdTable(_$AppDatabase db) =>
      db.employers.createAlias('work_entries__employer_id__employers__id');

  $$EmployersTableProcessedTableManager get employerId {
    final $_column = $_itemColumn<String>('employer_id')!;

    final manager = $$EmployersTableTableManager(
      $_db,
      $_db.employers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlannedShiftsTable, List<PlannedShift>>
  _plannedShiftsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedShifts,
    aliasName: 'work_entries__id__planned_shifts__work_entry_id',
  );

  $$PlannedShiftsTableProcessedTableManager get plannedShiftsRefs {
    final manager = $$PlannedShiftsTableTableManager(
      $_db,
      $_db.plannedShifts,
    ).filter((f) => f.workEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plannedShiftsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTimeUtc => $composableBuilder(
    column: $table.startTimeUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTimeUtc => $composableBuilder(
    column: $table.endTimeUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidBreakMinutes => $composableBuilder(
    column: $table.paidBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRateSnapshotCents => $composableBuilder(
    column: $table.hourlyRateSnapshotCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipsCents => $composableBuilder(
    column: $table.tipsCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployersTableFilterComposer get employerId {
    final $$EmployersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableFilterComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> plannedShiftsRefs(
    Expression<bool> Function($$PlannedShiftsTableFilterComposer f) f,
  ) {
    final $$PlannedShiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedShifts,
      getReferencedColumn: (t) => t.workEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedShiftsTableFilterComposer(
            $db: $db,
            $table: $db.plannedShifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTimeUtc => $composableBuilder(
    column: $table.startTimeUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTimeUtc => $composableBuilder(
    column: $table.endTimeUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidBreakMinutes => $composableBuilder(
    column: $table.paidBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRateSnapshotCents => $composableBuilder(
    column: $table.hourlyRateSnapshotCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipsCents => $composableBuilder(
    column: $table.tipsCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployersTableOrderingComposer get employerId {
    final $$EmployersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableOrderingComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTimeUtc => $composableBuilder(
    column: $table.startTimeUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endTimeUtc => $composableBuilder(
    column: $table.endTimeUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidBreakMinutes => $composableBuilder(
    column: $table.paidBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRateSnapshotCents => $composableBuilder(
    column: $table.hourlyRateSnapshotCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonusCents => $composableBuilder(
    column: $table.bonusCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tipsCents =>
      $composableBuilder(column: $table.tipsCents, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployersTableAnnotationComposer get employerId {
    final $$EmployersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableAnnotationComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> plannedShiftsRefs<T extends Object>(
    Expression<T> Function($$PlannedShiftsTableAnnotationComposer a) f,
  ) {
    final $$PlannedShiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedShifts,
      getReferencedColumn: (t) => t.workEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannedShiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.plannedShifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkEntriesTable,
          WorkEntry,
          $$WorkEntriesTableFilterComposer,
          $$WorkEntriesTableOrderingComposer,
          $$WorkEntriesTableAnnotationComposer,
          $$WorkEntriesTableCreateCompanionBuilder,
          $$WorkEntriesTableUpdateCompanionBuilder,
          (WorkEntry, $$WorkEntriesTableReferences),
          WorkEntry,
          PrefetchHooks Function({bool employerId, bool plannedShiftsRefs})
        > {
  $$WorkEntriesTableTableManager(_$AppDatabase db, $WorkEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employerId = const Value.absent(),
                Value<DateTime> startTimeUtc = const Value.absent(),
                Value<DateTime?> endTimeUtc = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> paidBreakMinutes = const Value.absent(),
                Value<int> hourlyRateSnapshotCents = const Value.absent(),
                Value<int> bonusCents = const Value.absent(),
                Value<int> tipsCents = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkEntriesCompanion(
                id: id,
                employerId: employerId,
                startTimeUtc: startTimeUtc,
                endTimeUtc: endTimeUtc,
                timezone: timezone,
                breakMinutes: breakMinutes,
                paidBreakMinutes: paidBreakMinutes,
                hourlyRateSnapshotCents: hourlyRateSnapshotCents,
                bonusCents: bonusCents,
                tipsCents: tipsCents,
                notes: notes,
                status: status,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String employerId,
                required DateTime startTimeUtc,
                Value<DateTime?> endTimeUtc = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> paidBreakMinutes = const Value.absent(),
                required int hourlyRateSnapshotCents,
                Value<int> bonusCents = const Value.absent(),
                Value<int> tipsCents = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required String status,
                Value<bool> deleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkEntriesCompanion.insert(
                id: id,
                employerId: employerId,
                startTimeUtc: startTimeUtc,
                endTimeUtc: endTimeUtc,
                timezone: timezone,
                breakMinutes: breakMinutes,
                paidBreakMinutes: paidBreakMinutes,
                hourlyRateSnapshotCents: hourlyRateSnapshotCents,
                bonusCents: bonusCents,
                tipsCents: tipsCents,
                notes: notes,
                status: status,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({employerId = false, plannedShiftsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plannedShiftsRefs) db.plannedShifts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (employerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employerId,
                                    referencedTable:
                                        $$WorkEntriesTableReferences
                                            ._employerIdTable(db),
                                    referencedColumn:
                                        $$WorkEntriesTableReferences
                                            ._employerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plannedShiftsRefs)
                        await $_getPrefetchedData<
                          WorkEntry,
                          $WorkEntriesTable,
                          PlannedShift
                        >(
                          currentTable: table,
                          referencedTable: $$WorkEntriesTableReferences
                              ._plannedShiftsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).plannedShiftsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkEntriesTable,
      WorkEntry,
      $$WorkEntriesTableFilterComposer,
      $$WorkEntriesTableOrderingComposer,
      $$WorkEntriesTableAnnotationComposer,
      $$WorkEntriesTableCreateCompanionBuilder,
      $$WorkEntriesTableUpdateCompanionBuilder,
      (WorkEntry, $$WorkEntriesTableReferences),
      WorkEntry,
      PrefetchHooks Function({bool employerId, bool plannedShiftsRefs})
    >;
typedef $$AcademicPeriodsTableCreateCompanionBuilder =
    AcademicPeriodsCompanion Function({
      required String id,
      required String semesterName,
      required DateTime semesterStart,
      required DateTime semesterEnd,
      required DateTime lectureStart,
      required DateTime lectureEnd,
      Value<String> exceptionalLectureFreeJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AcademicPeriodsTableUpdateCompanionBuilder =
    AcademicPeriodsCompanion Function({
      Value<String> id,
      Value<String> semesterName,
      Value<DateTime> semesterStart,
      Value<DateTime> semesterEnd,
      Value<DateTime> lectureStart,
      Value<DateTime> lectureEnd,
      Value<String> exceptionalLectureFreeJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AcademicPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $AcademicPeriodsTable> {
  $$AcademicPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get semesterName => $composableBuilder(
    column: $table.semesterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get semesterStart => $composableBuilder(
    column: $table.semesterStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get semesterEnd => $composableBuilder(
    column: $table.semesterEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lectureStart => $composableBuilder(
    column: $table.lectureStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lectureEnd => $composableBuilder(
    column: $table.lectureEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exceptionalLectureFreeJson => $composableBuilder(
    column: $table.exceptionalLectureFreeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AcademicPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $AcademicPeriodsTable> {
  $$AcademicPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get semesterName => $composableBuilder(
    column: $table.semesterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get semesterStart => $composableBuilder(
    column: $table.semesterStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get semesterEnd => $composableBuilder(
    column: $table.semesterEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lectureStart => $composableBuilder(
    column: $table.lectureStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lectureEnd => $composableBuilder(
    column: $table.lectureEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exceptionalLectureFreeJson => $composableBuilder(
    column: $table.exceptionalLectureFreeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AcademicPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AcademicPeriodsTable> {
  $$AcademicPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get semesterName => $composableBuilder(
    column: $table.semesterName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get semesterStart => $composableBuilder(
    column: $table.semesterStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get semesterEnd => $composableBuilder(
    column: $table.semesterEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lectureStart => $composableBuilder(
    column: $table.lectureStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lectureEnd => $composableBuilder(
    column: $table.lectureEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exceptionalLectureFreeJson => $composableBuilder(
    column: $table.exceptionalLectureFreeJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AcademicPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AcademicPeriodsTable,
          AcademicPeriod,
          $$AcademicPeriodsTableFilterComposer,
          $$AcademicPeriodsTableOrderingComposer,
          $$AcademicPeriodsTableAnnotationComposer,
          $$AcademicPeriodsTableCreateCompanionBuilder,
          $$AcademicPeriodsTableUpdateCompanionBuilder,
          (
            AcademicPeriod,
            BaseReferences<
              _$AppDatabase,
              $AcademicPeriodsTable,
              AcademicPeriod
            >,
          ),
          AcademicPeriod,
          PrefetchHooks Function()
        > {
  $$AcademicPeriodsTableTableManager(
    _$AppDatabase db,
    $AcademicPeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AcademicPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AcademicPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AcademicPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> semesterName = const Value.absent(),
                Value<DateTime> semesterStart = const Value.absent(),
                Value<DateTime> semesterEnd = const Value.absent(),
                Value<DateTime> lectureStart = const Value.absent(),
                Value<DateTime> lectureEnd = const Value.absent(),
                Value<String> exceptionalLectureFreeJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcademicPeriodsCompanion(
                id: id,
                semesterName: semesterName,
                semesterStart: semesterStart,
                semesterEnd: semesterEnd,
                lectureStart: lectureStart,
                lectureEnd: lectureEnd,
                exceptionalLectureFreeJson: exceptionalLectureFreeJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String semesterName,
                required DateTime semesterStart,
                required DateTime semesterEnd,
                required DateTime lectureStart,
                required DateTime lectureEnd,
                Value<String> exceptionalLectureFreeJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AcademicPeriodsCompanion.insert(
                id: id,
                semesterName: semesterName,
                semesterStart: semesterStart,
                semesterEnd: semesterEnd,
                lectureStart: lectureStart,
                lectureEnd: lectureEnd,
                exceptionalLectureFreeJson: exceptionalLectureFreeJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AcademicPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AcademicPeriodsTable,
      AcademicPeriod,
      $$AcademicPeriodsTableFilterComposer,
      $$AcademicPeriodsTableOrderingComposer,
      $$AcademicPeriodsTableAnnotationComposer,
      $$AcademicPeriodsTableCreateCompanionBuilder,
      $$AcademicPeriodsTableUpdateCompanionBuilder,
      (
        AcademicPeriod,
        BaseReferences<_$AppDatabase, $AcademicPeriodsTable, AcademicPeriod>,
      ),
      AcademicPeriod,
      PrefetchHooks Function()
    >;
typedef $$PayslipsTableCreateCompanionBuilder =
    PayslipsCompanion Function({
      required String id,
      required String employerId,
      required int month,
      required int year,
      required int grossCents,
      Value<int> wageTaxCents,
      Value<int> solidaritySurchargeCents,
      Value<int> churchTaxCents,
      Value<int> pensionCents,
      Value<int> healthCents,
      Value<int> careCents,
      Value<int> unemploymentCents,
      Value<int> otherDeductionsCents,
      required int netCents,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PayslipsTableUpdateCompanionBuilder =
    PayslipsCompanion Function({
      Value<String> id,
      Value<String> employerId,
      Value<int> month,
      Value<int> year,
      Value<int> grossCents,
      Value<int> wageTaxCents,
      Value<int> solidaritySurchargeCents,
      Value<int> churchTaxCents,
      Value<int> pensionCents,
      Value<int> healthCents,
      Value<int> careCents,
      Value<int> unemploymentCents,
      Value<int> otherDeductionsCents,
      Value<int> netCents,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PayslipsTableReferences
    extends BaseReferences<_$AppDatabase, $PayslipsTable, Payslip> {
  $$PayslipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployersTable _employerIdTable(_$AppDatabase db) =>
      db.employers.createAlias('payslips__employer_id__employers__id');

  $$EmployersTableProcessedTableManager get employerId {
    final $_column = $_itemColumn<String>('employer_id')!;

    final manager = $$EmployersTableTableManager(
      $_db,
      $_db.employers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PayslipsTableFilterComposer
    extends Composer<_$AppDatabase, $PayslipsTable> {
  $$PayslipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossCents => $composableBuilder(
    column: $table.grossCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wageTaxCents => $composableBuilder(
    column: $table.wageTaxCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get solidaritySurchargeCents => $composableBuilder(
    column: $table.solidaritySurchargeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get churchTaxCents => $composableBuilder(
    column: $table.churchTaxCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pensionCents => $composableBuilder(
    column: $table.pensionCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get healthCents => $composableBuilder(
    column: $table.healthCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get careCents => $composableBuilder(
    column: $table.careCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unemploymentCents => $composableBuilder(
    column: $table.unemploymentCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get otherDeductionsCents => $composableBuilder(
    column: $table.otherDeductionsCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netCents => $composableBuilder(
    column: $table.netCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployersTableFilterComposer get employerId {
    final $$EmployersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableFilterComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayslipsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayslipsTable> {
  $$PayslipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossCents => $composableBuilder(
    column: $table.grossCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wageTaxCents => $composableBuilder(
    column: $table.wageTaxCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get solidaritySurchargeCents => $composableBuilder(
    column: $table.solidaritySurchargeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get churchTaxCents => $composableBuilder(
    column: $table.churchTaxCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pensionCents => $composableBuilder(
    column: $table.pensionCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get healthCents => $composableBuilder(
    column: $table.healthCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get careCents => $composableBuilder(
    column: $table.careCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unemploymentCents => $composableBuilder(
    column: $table.unemploymentCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get otherDeductionsCents => $composableBuilder(
    column: $table.otherDeductionsCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netCents => $composableBuilder(
    column: $table.netCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployersTableOrderingComposer get employerId {
    final $$EmployersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableOrderingComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayslipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayslipsTable> {
  $$PayslipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get grossCents => $composableBuilder(
    column: $table.grossCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wageTaxCents => $composableBuilder(
    column: $table.wageTaxCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get solidaritySurchargeCents => $composableBuilder(
    column: $table.solidaritySurchargeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get churchTaxCents => $composableBuilder(
    column: $table.churchTaxCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pensionCents => $composableBuilder(
    column: $table.pensionCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get healthCents => $composableBuilder(
    column: $table.healthCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get careCents =>
      $composableBuilder(column: $table.careCents, builder: (column) => column);

  GeneratedColumn<int> get unemploymentCents => $composableBuilder(
    column: $table.unemploymentCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get otherDeductionsCents => $composableBuilder(
    column: $table.otherDeductionsCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netCents =>
      $composableBuilder(column: $table.netCents, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployersTableAnnotationComposer get employerId {
    final $$EmployersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employerId,
      referencedTable: $db.employers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployersTableAnnotationComposer(
            $db: $db,
            $table: $db.employers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayslipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayslipsTable,
          Payslip,
          $$PayslipsTableFilterComposer,
          $$PayslipsTableOrderingComposer,
          $$PayslipsTableAnnotationComposer,
          $$PayslipsTableCreateCompanionBuilder,
          $$PayslipsTableUpdateCompanionBuilder,
          (Payslip, $$PayslipsTableReferences),
          Payslip,
          PrefetchHooks Function({bool employerId})
        > {
  $$PayslipsTableTableManager(_$AppDatabase db, $PayslipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayslipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayslipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayslipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employerId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> grossCents = const Value.absent(),
                Value<int> wageTaxCents = const Value.absent(),
                Value<int> solidaritySurchargeCents = const Value.absent(),
                Value<int> churchTaxCents = const Value.absent(),
                Value<int> pensionCents = const Value.absent(),
                Value<int> healthCents = const Value.absent(),
                Value<int> careCents = const Value.absent(),
                Value<int> unemploymentCents = const Value.absent(),
                Value<int> otherDeductionsCents = const Value.absent(),
                Value<int> netCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayslipsCompanion(
                id: id,
                employerId: employerId,
                month: month,
                year: year,
                grossCents: grossCents,
                wageTaxCents: wageTaxCents,
                solidaritySurchargeCents: solidaritySurchargeCents,
                churchTaxCents: churchTaxCents,
                pensionCents: pensionCents,
                healthCents: healthCents,
                careCents: careCents,
                unemploymentCents: unemploymentCents,
                otherDeductionsCents: otherDeductionsCents,
                netCents: netCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String employerId,
                required int month,
                required int year,
                required int grossCents,
                Value<int> wageTaxCents = const Value.absent(),
                Value<int> solidaritySurchargeCents = const Value.absent(),
                Value<int> churchTaxCents = const Value.absent(),
                Value<int> pensionCents = const Value.absent(),
                Value<int> healthCents = const Value.absent(),
                Value<int> careCents = const Value.absent(),
                Value<int> unemploymentCents = const Value.absent(),
                Value<int> otherDeductionsCents = const Value.absent(),
                required int netCents,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PayslipsCompanion.insert(
                id: id,
                employerId: employerId,
                month: month,
                year: year,
                grossCents: grossCents,
                wageTaxCents: wageTaxCents,
                solidaritySurchargeCents: solidaritySurchargeCents,
                churchTaxCents: churchTaxCents,
                pensionCents: pensionCents,
                healthCents: healthCents,
                careCents: careCents,
                unemploymentCents: unemploymentCents,
                otherDeductionsCents: otherDeductionsCents,
                netCents: netCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PayslipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employerId,
                                referencedTable: $$PayslipsTableReferences
                                    ._employerIdTable(db),
                                referencedColumn: $$PayslipsTableReferences
                                    ._employerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PayslipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayslipsTable,
      Payslip,
      $$PayslipsTableFilterComposer,
      $$PayslipsTableOrderingComposer,
      $$PayslipsTableAnnotationComposer,
      $$PayslipsTableCreateCompanionBuilder,
      $$PayslipsTableUpdateCompanionBuilder,
      (Payslip, $$PayslipsTableReferences),
      Payslip,
      PrefetchHooks Function({bool employerId})
    >;
typedef $$LegalRulesTableCreateCompanionBuilder =
    LegalRulesCompanion Function({
      required String id,
      required String key,
      required DateTime effectiveFrom,
      Value<DateTime?> effectiveTo,
      required double value,
      required String unit,
      required String sourceUrl,
      required String sourceTitle,
      required DateTime lastVerified,
      Value<String> metadataJson,
      Value<int> rowid,
    });
typedef $$LegalRulesTableUpdateCompanionBuilder =
    LegalRulesCompanion Function({
      Value<String> id,
      Value<String> key,
      Value<DateTime> effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<double> value,
      Value<String> unit,
      Value<String> sourceUrl,
      Value<String> sourceTitle,
      Value<DateTime> lastVerified,
      Value<String> metadataJson,
      Value<int> rowid,
    });

class $$LegalRulesTableFilterComposer
    extends Composer<_$AppDatabase, $LegalRulesTable> {
  $$LegalRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalRulesTable> {
  $$LegalRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalRulesTable> {
  $$LegalRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceTitle => $composableBuilder(
    column: $table.sourceTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$LegalRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalRulesTable,
          LegalRule,
          $$LegalRulesTableFilterComposer,
          $$LegalRulesTableOrderingComposer,
          $$LegalRulesTableAnnotationComposer,
          $$LegalRulesTableCreateCompanionBuilder,
          $$LegalRulesTableUpdateCompanionBuilder,
          (
            LegalRule,
            BaseReferences<_$AppDatabase, $LegalRulesTable, LegalRule>,
          ),
          LegalRule,
          PrefetchHooks Function()
        > {
  $$LegalRulesTableTableManager(_$AppDatabase db, $LegalRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<DateTime> effectiveFrom = const Value.absent(),
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> sourceTitle = const Value.absent(),
                Value<DateTime> lastVerified = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalRulesCompanion(
                id: id,
                key: key,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                value: value,
                unit: unit,
                sourceUrl: sourceUrl,
                sourceTitle: sourceTitle,
                lastVerified: lastVerified,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String key,
                required DateTime effectiveFrom,
                Value<DateTime?> effectiveTo = const Value.absent(),
                required double value,
                required String unit,
                required String sourceUrl,
                required String sourceTitle,
                required DateTime lastVerified,
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalRulesCompanion.insert(
                id: id,
                key: key,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                value: value,
                unit: unit,
                sourceUrl: sourceUrl,
                sourceTitle: sourceTitle,
                lastVerified: lastVerified,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalRulesTable,
      LegalRule,
      $$LegalRulesTableFilterComposer,
      $$LegalRulesTableOrderingComposer,
      $$LegalRulesTableAnnotationComposer,
      $$LegalRulesTableCreateCompanionBuilder,
      $$LegalRulesTableUpdateCompanionBuilder,
      (LegalRule, BaseReferences<_$AppDatabase, $LegalRulesTable, LegalRule>),
      LegalRule,
      PrefetchHooks Function()
    >;
typedef $$PlannedShiftsTableCreateCompanionBuilder =
    PlannedShiftsCompanion Function({
      required String id,
      required String workEntryId,
      Value<bool> notificationScheduled,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PlannedShiftsTableUpdateCompanionBuilder =
    PlannedShiftsCompanion Function({
      Value<String> id,
      Value<String> workEntryId,
      Value<bool> notificationScheduled,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PlannedShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $PlannedShiftsTable, PlannedShift> {
  $$PlannedShiftsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkEntriesTable _workEntryIdTable(_$AppDatabase db) => db.workEntries
      .createAlias('planned_shifts__work_entry_id__work_entries__id');

  $$WorkEntriesTableProcessedTableManager get workEntryId {
    final $_column = $_itemColumn<String>('work_entry_id')!;

    final manager = $$WorkEntriesTableTableManager(
      $_db,
      $_db.workEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlannedShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedShiftsTable> {
  $$PlannedShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationScheduled => $composableBuilder(
    column: $table.notificationScheduled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkEntriesTableFilterComposer get workEntryId {
    final $$WorkEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workEntryId,
      referencedTable: $db.workEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkEntriesTableFilterComposer(
            $db: $db,
            $table: $db.workEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedShiftsTable> {
  $$PlannedShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationScheduled => $composableBuilder(
    column: $table.notificationScheduled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkEntriesTableOrderingComposer get workEntryId {
    final $$WorkEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workEntryId,
      referencedTable: $db.workEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.workEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedShiftsTable> {
  $$PlannedShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get notificationScheduled => $composableBuilder(
    column: $table.notificationScheduled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorkEntriesTableAnnotationComposer get workEntryId {
    final $$WorkEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workEntryId,
      referencedTable: $db.workEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.workEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlannedShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannedShiftsTable,
          PlannedShift,
          $$PlannedShiftsTableFilterComposer,
          $$PlannedShiftsTableOrderingComposer,
          $$PlannedShiftsTableAnnotationComposer,
          $$PlannedShiftsTableCreateCompanionBuilder,
          $$PlannedShiftsTableUpdateCompanionBuilder,
          (PlannedShift, $$PlannedShiftsTableReferences),
          PlannedShift,
          PrefetchHooks Function({bool workEntryId})
        > {
  $$PlannedShiftsTableTableManager(_$AppDatabase db, $PlannedShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workEntryId = const Value.absent(),
                Value<bool> notificationScheduled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannedShiftsCompanion(
                id: id,
                workEntryId: workEntryId,
                notificationScheduled: notificationScheduled,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workEntryId,
                Value<bool> notificationScheduled = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PlannedShiftsCompanion.insert(
                id: id,
                workEntryId: workEntryId,
                notificationScheduled: notificationScheduled,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlannedShiftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workEntryId,
                                referencedTable: $$PlannedShiftsTableReferences
                                    ._workEntryIdTable(db),
                                referencedColumn: $$PlannedShiftsTableReferences
                                    ._workEntryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlannedShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannedShiftsTable,
      PlannedShift,
      $$PlannedShiftsTableFilterComposer,
      $$PlannedShiftsTableOrderingComposer,
      $$PlannedShiftsTableAnnotationComposer,
      $$PlannedShiftsTableCreateCompanionBuilder,
      $$PlannedShiftsTableUpdateCompanionBuilder,
      (PlannedShift, $$PlannedShiftsTableReferences),
      PlannedShift,
      PrefetchHooks Function({bool workEntryId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String valueJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> valueJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String entityId,
      required String entityType,
      required String deviceId,
      required String status,
      Value<bool> tombstone,
      required DateTime localUpdatedAt,
      Value<DateTime?> remoteUpdatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> entityId,
      Value<String> entityType,
      Value<String> deviceId,
      Value<String> status,
      Value<bool> tombstone,
      Value<DateTime> localUpdatedAt,
      Value<DateTime?> remoteUpdatedAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tombstone => $composableBuilder(
    column: $table.tombstone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get tombstone =>
      $composableBuilder(column: $table.tombstone, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => column,
  );
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> tombstone = const Value.absent(),
                Value<DateTime> localUpdatedAt = const Value.absent(),
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                entityId: entityId,
                entityType: entityType,
                deviceId: deviceId,
                status: status,
                tombstone: tombstone,
                localUpdatedAt: localUpdatedAt,
                remoteUpdatedAt: remoteUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                required String entityType,
                required String deviceId,
                required String status,
                Value<bool> tombstone = const Value.absent(),
                required DateTime localUpdatedAt,
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                entityId: entityId,
                entityType: entityType,
                deviceId: deviceId,
                status: status,
                tombstone: tombstone,
                localUpdatedAt: localUpdatedAt,
                remoteUpdatedAt: remoteUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$EmployersTableTableManager get employers =>
      $$EmployersTableTableManager(_db, _db.employers);
  $$WorkEntriesTableTableManager get workEntries =>
      $$WorkEntriesTableTableManager(_db, _db.workEntries);
  $$AcademicPeriodsTableTableManager get academicPeriods =>
      $$AcademicPeriodsTableTableManager(_db, _db.academicPeriods);
  $$PayslipsTableTableManager get payslips =>
      $$PayslipsTableTableManager(_db, _db.payslips);
  $$LegalRulesTableTableManager get legalRules =>
      $$LegalRulesTableTableManager(_db, _db.legalRules);
  $$PlannedShiftsTableTableManager get plannedShifts =>
      $$PlannedShiftsTableTableManager(_db, _db.plannedShifts);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
