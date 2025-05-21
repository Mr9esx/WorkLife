// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_writer_repo.dart';

// ignore_for_file: type=lint
class $JournalWriterTableTable extends JournalWriterTable
    with TableInfo<$JournalWriterTableTable, JournalWriter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalWriterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _birthDayMeta =
      const VerificationMeta('birthDay');
  @override
  late final GeneratedColumn<DateTime> birthDay = GeneratedColumn<DateTime>(
      'birth_day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthPlaceMeta =
      const VerificationMeta('birthPlace');
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
      'birth_place', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        gender,
        birthDay,
        avatar,
        birthPlace,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_writer_table';
  @override
  VerificationContext validateIntegrity(Insertable<JournalWriter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_day')) {
      context.handle(_birthDayMeta,
          birthDay.isAcceptableOrUnknown(data['birth_day']!, _birthDayMeta));
    } else if (isInserting) {
      context.missing(_birthDayMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('birth_place')) {
      context.handle(
          _birthPlaceMeta,
          birthPlace.isAcceptableOrUnknown(
              data['birth_place']!, _birthPlaceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalWriter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalWriter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!,
      birthDay: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birth_day'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      birthPlace: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birth_place']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $JournalWriterTableTable createAlias(String alias) {
    return $JournalWriterTableTable(attachedDatabase, alias);
  }
}

class JournalWriter extends DataClass implements Insertable<JournalWriter> {
  final int id;
  final String username;
  final int gender;
  final DateTime birthDay;
  final String? avatar;
  final String? birthPlace;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const JournalWriter(
      {required this.id,
      required this.username,
      required this.gender,
      required this.birthDay,
      this.avatar,
      this.birthPlace,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['gender'] = Variable<int>(gender);
    map['birth_day'] = Variable<DateTime>(birthDay);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || birthPlace != null) {
      map['birth_place'] = Variable<String>(birthPlace);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  JournalWriterTableCompanion toCompanion(bool nullToAbsent) {
    return JournalWriterTableCompanion(
      id: Value(id),
      username: Value(username),
      gender: Value(gender),
      birthDay: Value(birthDay),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      birthPlace: birthPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlace),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory JournalWriter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalWriter(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      gender: serializer.fromJson<int>(json['gender']),
      birthDay: serializer.fromJson<DateTime>(json['birthDay']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      birthPlace: serializer.fromJson<String?>(json['birthPlace']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'gender': serializer.toJson<int>(gender),
      'birthDay': serializer.toJson<DateTime>(birthDay),
      'avatar': serializer.toJson<String?>(avatar),
      'birthPlace': serializer.toJson<String?>(birthPlace),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  JournalWriter copyWith(
          {int? id,
          String? username,
          int? gender,
          DateTime? birthDay,
          Value<String?> avatar = const Value.absent(),
          Value<String?> birthPlace = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      JournalWriter(
        id: id ?? this.id,
        username: username ?? this.username,
        gender: gender ?? this.gender,
        birthDay: birthDay ?? this.birthDay,
        avatar: avatar.present ? avatar.value : this.avatar,
        birthPlace: birthPlace.present ? birthPlace.value : this.birthPlace,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  JournalWriter copyWithCompanion(JournalWriterTableCompanion data) {
    return JournalWriter(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDay: data.birthDay.present ? data.birthDay.value : this.birthDay,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      birthPlace:
          data.birthPlace.present ? data.birthPlace.value : this.birthPlace,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalWriter(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('gender: $gender, ')
          ..write('birthDay: $birthDay, ')
          ..write('avatar: $avatar, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, username, gender, birthDay, avatar, birthPlace, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalWriter &&
          other.id == this.id &&
          other.username == this.username &&
          other.gender == this.gender &&
          other.birthDay == this.birthDay &&
          other.avatar == this.avatar &&
          other.birthPlace == this.birthPlace &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalWriterTableCompanion extends UpdateCompanion<JournalWriter> {
  final Value<int> id;
  final Value<String> username;
  final Value<int> gender;
  final Value<DateTime> birthDay;
  final Value<String?> avatar;
  final Value<String?> birthPlace;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const JournalWriterTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDay = const Value.absent(),
    this.avatar = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalWriterTableCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required int gender,
    required DateTime birthDay,
    this.avatar = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        gender = Value(gender),
        birthDay = Value(birthDay);
  static Insertable<JournalWriter> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<int>? gender,
    Expression<DateTime>? birthDay,
    Expression<String>? avatar,
    Expression<String>? birthPlace,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (gender != null) 'gender': gender,
      if (birthDay != null) 'birth_day': birthDay,
      if (avatar != null) 'avatar': avatar,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalWriterTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<int>? gender,
      Value<DateTime>? birthDay,
      Value<String?>? avatar,
      Value<String?>? birthPlace,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return JournalWriterTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      avatar: avatar ?? this.avatar,
      birthPlace: birthPlace ?? this.birthPlace,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (birthDay.present) {
      map['birth_day'] = Variable<DateTime>(birthDay.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalWriterTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('gender: $gender, ')
          ..write('birthDay: $birthDay, ')
          ..write('avatar: $avatar, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$JournalWriterRepo extends GeneratedDatabase {
  _$JournalWriterRepo(QueryExecutor e) : super(e);
  $JournalWriterRepoManager get managers => $JournalWriterRepoManager(this);
  late final $JournalWriterTableTable journalWriterTable =
      $JournalWriterTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [journalWriterTable];
}

typedef $$JournalWriterTableTableCreateCompanionBuilder
    = JournalWriterTableCompanion Function({
  Value<int> id,
  required String username,
  required int gender,
  required DateTime birthDay,
  Value<String?> avatar,
  Value<String?> birthPlace,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$JournalWriterTableTableUpdateCompanionBuilder
    = JournalWriterTableCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<int> gender,
  Value<DateTime> birthDay,
  Value<String?> avatar,
  Value<String?> birthPlace,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$JournalWriterTableTableFilterComposer
    extends Composer<_$JournalWriterRepo, $JournalWriterTableTable> {
  $$JournalWriterTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthDay => $composableBuilder(
      column: $table.birthDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JournalWriterTableTableOrderingComposer
    extends Composer<_$JournalWriterRepo, $JournalWriterTableTable> {
  $$JournalWriterTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthDay => $composableBuilder(
      column: $table.birthDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalWriterTableTableAnnotationComposer
    extends Composer<_$JournalWriterRepo, $JournalWriterTableTable> {
  $$JournalWriterTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDay =>
      $composableBuilder(column: $table.birthDay, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JournalWriterTableTableTableManager extends RootTableManager<
    _$JournalWriterRepo,
    $JournalWriterTableTable,
    JournalWriter,
    $$JournalWriterTableTableFilterComposer,
    $$JournalWriterTableTableOrderingComposer,
    $$JournalWriterTableTableAnnotationComposer,
    $$JournalWriterTableTableCreateCompanionBuilder,
    $$JournalWriterTableTableUpdateCompanionBuilder,
    (
      JournalWriter,
      BaseReferences<_$JournalWriterRepo, $JournalWriterTableTable,
          JournalWriter>
    ),
    JournalWriter,
    PrefetchHooks Function()> {
  $$JournalWriterTableTableTableManager(
      _$JournalWriterRepo db, $JournalWriterTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalWriterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalWriterTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalWriterTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<int> gender = const Value.absent(),
            Value<DateTime> birthDay = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              JournalWriterTableCompanion(
            id: id,
            username: username,
            gender: gender,
            birthDay: birthDay,
            avatar: avatar,
            birthPlace: birthPlace,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required int gender,
            required DateTime birthDay,
            Value<String?> avatar = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              JournalWriterTableCompanion.insert(
            id: id,
            username: username,
            gender: gender,
            birthDay: birthDay,
            avatar: avatar,
            birthPlace: birthPlace,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalWriterTableTableProcessedTableManager = ProcessedTableManager<
    _$JournalWriterRepo,
    $JournalWriterTableTable,
    JournalWriter,
    $$JournalWriterTableTableFilterComposer,
    $$JournalWriterTableTableOrderingComposer,
    $$JournalWriterTableTableAnnotationComposer,
    $$JournalWriterTableTableCreateCompanionBuilder,
    $$JournalWriterTableTableUpdateCompanionBuilder,
    (
      JournalWriter,
      BaseReferences<_$JournalWriterRepo, $JournalWriterTableTable,
          JournalWriter>
    ),
    JournalWriter,
    PrefetchHooks Function()>;

class $JournalWriterRepoManager {
  final _$JournalWriterRepo _db;
  $JournalWriterRepoManager(this._db);
  $$JournalWriterTableTableTableManager get journalWriterTable =>
      $$JournalWriterTableTableTableManager(_db, _db.journalWriterTable);
}
