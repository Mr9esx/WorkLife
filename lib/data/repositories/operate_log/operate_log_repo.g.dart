// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operate_log_repo.dart';

// ignore_for_file: type=lint
class $OperateLogTableTable extends OperateLogTable
    with TableInfo<$OperateLogTableTable, OperateLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperateLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _writerIdMeta =
      const VerificationMeta('writerId');
  @override
  late final GeneratedColumn<int> writerId = GeneratedColumn<int>(
      'writer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operateTypeMeta =
      const VerificationMeta('operateType');
  @override
  late final GeneratedColumn<int> operateType = GeneratedColumn<int>(
      'operate_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operateAfterDataMeta =
      const VerificationMeta('operateAfterData');
  @override
  late final GeneratedColumn<String> operateAfterData = GeneratedColumn<String>(
      'operate_after_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operateBeforeDataMeta =
      const VerificationMeta('operateBeforeData');
  @override
  late final GeneratedColumn<String> operateBeforeData =
      GeneratedColumn<String>('operate_before_data', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operatedAtMeta =
      const VerificationMeta('operatedAt');
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
      'operated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        writerId,
        operateType,
        operateAfterData,
        operateBeforeData,
        operatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operate_log_table';
  @override
  VerificationContext validateIntegrity(Insertable<OperateLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('writer_id')) {
      context.handle(_writerIdMeta,
          writerId.isAcceptableOrUnknown(data['writer_id']!, _writerIdMeta));
    } else if (isInserting) {
      context.missing(_writerIdMeta);
    }
    if (data.containsKey('operate_type')) {
      context.handle(
          _operateTypeMeta,
          operateType.isAcceptableOrUnknown(
              data['operate_type']!, _operateTypeMeta));
    } else if (isInserting) {
      context.missing(_operateTypeMeta);
    }
    if (data.containsKey('operate_after_data')) {
      context.handle(
          _operateAfterDataMeta,
          operateAfterData.isAcceptableOrUnknown(
              data['operate_after_data']!, _operateAfterDataMeta));
    } else if (isInserting) {
      context.missing(_operateAfterDataMeta);
    }
    if (data.containsKey('operate_before_data')) {
      context.handle(
          _operateBeforeDataMeta,
          operateBeforeData.isAcceptableOrUnknown(
              data['operate_before_data']!, _operateBeforeDataMeta));
    } else if (isInserting) {
      context.missing(_operateBeforeDataMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
          _operatedAtMeta,
          operatedAt.isAcceptableOrUnknown(
              data['operated_at']!, _operatedAtMeta));
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperateLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperateLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      writerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}writer_id'])!,
      operateType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}operate_type'])!,
      operateAfterData: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}operate_after_data'])!,
      operateBeforeData: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}operate_before_data'])!,
      operatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}operated_at'])!,
    );
  }

  @override
  $OperateLogTableTable createAlias(String alias) {
    return $OperateLogTableTable(attachedDatabase, alias);
  }
}

class OperateLog extends DataClass implements Insertable<OperateLog> {
  final int id;
  final int writerId;
  final int operateType;
  final String operateAfterData;
  final String operateBeforeData;
  final DateTime operatedAt;
  const OperateLog(
      {required this.id,
      required this.writerId,
      required this.operateType,
      required this.operateAfterData,
      required this.operateBeforeData,
      required this.operatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['writer_id'] = Variable<int>(writerId);
    map['operate_type'] = Variable<int>(operateType);
    map['operate_after_data'] = Variable<String>(operateAfterData);
    map['operate_before_data'] = Variable<String>(operateBeforeData);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    return map;
  }

  OperateLogTableCompanion toCompanion(bool nullToAbsent) {
    return OperateLogTableCompanion(
      id: Value(id),
      writerId: Value(writerId),
      operateType: Value(operateType),
      operateAfterData: Value(operateAfterData),
      operateBeforeData: Value(operateBeforeData),
      operatedAt: Value(operatedAt),
    );
  }

  factory OperateLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperateLog(
      id: serializer.fromJson<int>(json['id']),
      writerId: serializer.fromJson<int>(json['writerId']),
      operateType: serializer.fromJson<int>(json['operateType']),
      operateAfterData: serializer.fromJson<String>(json['operateAfterData']),
      operateBeforeData: serializer.fromJson<String>(json['operateBeforeData']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'writerId': serializer.toJson<int>(writerId),
      'operateType': serializer.toJson<int>(operateType),
      'operateAfterData': serializer.toJson<String>(operateAfterData),
      'operateBeforeData': serializer.toJson<String>(operateBeforeData),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
    };
  }

  OperateLog copyWith(
          {int? id,
          int? writerId,
          int? operateType,
          String? operateAfterData,
          String? operateBeforeData,
          DateTime? operatedAt}) =>
      OperateLog(
        id: id ?? this.id,
        writerId: writerId ?? this.writerId,
        operateType: operateType ?? this.operateType,
        operateAfterData: operateAfterData ?? this.operateAfterData,
        operateBeforeData: operateBeforeData ?? this.operateBeforeData,
        operatedAt: operatedAt ?? this.operatedAt,
      );
  OperateLog copyWithCompanion(OperateLogTableCompanion data) {
    return OperateLog(
      id: data.id.present ? data.id.value : this.id,
      writerId: data.writerId.present ? data.writerId.value : this.writerId,
      operateType:
          data.operateType.present ? data.operateType.value : this.operateType,
      operateAfterData: data.operateAfterData.present
          ? data.operateAfterData.value
          : this.operateAfterData,
      operateBeforeData: data.operateBeforeData.present
          ? data.operateBeforeData.value
          : this.operateBeforeData,
      operatedAt:
          data.operatedAt.present ? data.operatedAt.value : this.operatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperateLog(')
          ..write('id: $id, ')
          ..write('writerId: $writerId, ')
          ..write('operateType: $operateType, ')
          ..write('operateAfterData: $operateAfterData, ')
          ..write('operateBeforeData: $operateBeforeData, ')
          ..write('operatedAt: $operatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, writerId, operateType, operateAfterData,
      operateBeforeData, operatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperateLog &&
          other.id == this.id &&
          other.writerId == this.writerId &&
          other.operateType == this.operateType &&
          other.operateAfterData == this.operateAfterData &&
          other.operateBeforeData == this.operateBeforeData &&
          other.operatedAt == this.operatedAt);
}

class OperateLogTableCompanion extends UpdateCompanion<OperateLog> {
  final Value<int> id;
  final Value<int> writerId;
  final Value<int> operateType;
  final Value<String> operateAfterData;
  final Value<String> operateBeforeData;
  final Value<DateTime> operatedAt;
  const OperateLogTableCompanion({
    this.id = const Value.absent(),
    this.writerId = const Value.absent(),
    this.operateType = const Value.absent(),
    this.operateAfterData = const Value.absent(),
    this.operateBeforeData = const Value.absent(),
    this.operatedAt = const Value.absent(),
  });
  OperateLogTableCompanion.insert({
    this.id = const Value.absent(),
    required int writerId,
    required int operateType,
    required String operateAfterData,
    required String operateBeforeData,
    required DateTime operatedAt,
  })  : writerId = Value(writerId),
        operateType = Value(operateType),
        operateAfterData = Value(operateAfterData),
        operateBeforeData = Value(operateBeforeData),
        operatedAt = Value(operatedAt);
  static Insertable<OperateLog> custom({
    Expression<int>? id,
    Expression<int>? writerId,
    Expression<int>? operateType,
    Expression<String>? operateAfterData,
    Expression<String>? operateBeforeData,
    Expression<DateTime>? operatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (writerId != null) 'writer_id': writerId,
      if (operateType != null) 'operate_type': operateType,
      if (operateAfterData != null) 'operate_after_data': operateAfterData,
      if (operateBeforeData != null) 'operate_before_data': operateBeforeData,
      if (operatedAt != null) 'operated_at': operatedAt,
    });
  }

  OperateLogTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? writerId,
      Value<int>? operateType,
      Value<String>? operateAfterData,
      Value<String>? operateBeforeData,
      Value<DateTime>? operatedAt}) {
    return OperateLogTableCompanion(
      id: id ?? this.id,
      writerId: writerId ?? this.writerId,
      operateType: operateType ?? this.operateType,
      operateAfterData: operateAfterData ?? this.operateAfterData,
      operateBeforeData: operateBeforeData ?? this.operateBeforeData,
      operatedAt: operatedAt ?? this.operatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (writerId.present) {
      map['writer_id'] = Variable<int>(writerId.value);
    }
    if (operateType.present) {
      map['operate_type'] = Variable<int>(operateType.value);
    }
    if (operateAfterData.present) {
      map['operate_after_data'] = Variable<String>(operateAfterData.value);
    }
    if (operateBeforeData.present) {
      map['operate_before_data'] = Variable<String>(operateBeforeData.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperateLogTableCompanion(')
          ..write('id: $id, ')
          ..write('writerId: $writerId, ')
          ..write('operateType: $operateType, ')
          ..write('operateAfterData: $operateAfterData, ')
          ..write('operateBeforeData: $operateBeforeData, ')
          ..write('operatedAt: $operatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$OperateLogRepo extends GeneratedDatabase {
  _$OperateLogRepo(QueryExecutor e) : super(e);
  $OperateLogRepoManager get managers => $OperateLogRepoManager(this);
  late final $OperateLogTableTable operateLogTable =
      $OperateLogTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [operateLogTable];
}

typedef $$OperateLogTableTableCreateCompanionBuilder = OperateLogTableCompanion
    Function({
  Value<int> id,
  required int writerId,
  required int operateType,
  required String operateAfterData,
  required String operateBeforeData,
  required DateTime operatedAt,
});
typedef $$OperateLogTableTableUpdateCompanionBuilder = OperateLogTableCompanion
    Function({
  Value<int> id,
  Value<int> writerId,
  Value<int> operateType,
  Value<String> operateAfterData,
  Value<String> operateBeforeData,
  Value<DateTime> operatedAt,
});

class $$OperateLogTableTableFilterComposer
    extends Composer<_$OperateLogRepo, $OperateLogTableTable> {
  $$OperateLogTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get writerId => $composableBuilder(
      column: $table.writerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get operateType => $composableBuilder(
      column: $table.operateType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operateAfterData => $composableBuilder(
      column: $table.operateAfterData,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operateBeforeData => $composableBuilder(
      column: $table.operateBeforeData,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
      column: $table.operatedAt, builder: (column) => ColumnFilters(column));
}

class $$OperateLogTableTableOrderingComposer
    extends Composer<_$OperateLogRepo, $OperateLogTableTable> {
  $$OperateLogTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get writerId => $composableBuilder(
      column: $table.writerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get operateType => $composableBuilder(
      column: $table.operateType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operateAfterData => $composableBuilder(
      column: $table.operateAfterData,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operateBeforeData => $composableBuilder(
      column: $table.operateBeforeData,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
      column: $table.operatedAt, builder: (column) => ColumnOrderings(column));
}

class $$OperateLogTableTableAnnotationComposer
    extends Composer<_$OperateLogRepo, $OperateLogTableTable> {
  $$OperateLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get writerId =>
      $composableBuilder(column: $table.writerId, builder: (column) => column);

  GeneratedColumn<int> get operateType => $composableBuilder(
      column: $table.operateType, builder: (column) => column);

  GeneratedColumn<String> get operateAfterData => $composableBuilder(
      column: $table.operateAfterData, builder: (column) => column);

  GeneratedColumn<String> get operateBeforeData => $composableBuilder(
      column: $table.operateBeforeData, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
      column: $table.operatedAt, builder: (column) => column);
}

class $$OperateLogTableTableTableManager extends RootTableManager<
    _$OperateLogRepo,
    $OperateLogTableTable,
    OperateLog,
    $$OperateLogTableTableFilterComposer,
    $$OperateLogTableTableOrderingComposer,
    $$OperateLogTableTableAnnotationComposer,
    $$OperateLogTableTableCreateCompanionBuilder,
    $$OperateLogTableTableUpdateCompanionBuilder,
    (
      OperateLog,
      BaseReferences<_$OperateLogRepo, $OperateLogTableTable, OperateLog>
    ),
    OperateLog,
    PrefetchHooks Function()> {
  $$OperateLogTableTableTableManager(
      _$OperateLogRepo db, $OperateLogTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperateLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperateLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperateLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> writerId = const Value.absent(),
            Value<int> operateType = const Value.absent(),
            Value<String> operateAfterData = const Value.absent(),
            Value<String> operateBeforeData = const Value.absent(),
            Value<DateTime> operatedAt = const Value.absent(),
          }) =>
              OperateLogTableCompanion(
            id: id,
            writerId: writerId,
            operateType: operateType,
            operateAfterData: operateAfterData,
            operateBeforeData: operateBeforeData,
            operatedAt: operatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int writerId,
            required int operateType,
            required String operateAfterData,
            required String operateBeforeData,
            required DateTime operatedAt,
          }) =>
              OperateLogTableCompanion.insert(
            id: id,
            writerId: writerId,
            operateType: operateType,
            operateAfterData: operateAfterData,
            operateBeforeData: operateBeforeData,
            operatedAt: operatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OperateLogTableTableProcessedTableManager = ProcessedTableManager<
    _$OperateLogRepo,
    $OperateLogTableTable,
    OperateLog,
    $$OperateLogTableTableFilterComposer,
    $$OperateLogTableTableOrderingComposer,
    $$OperateLogTableTableAnnotationComposer,
    $$OperateLogTableTableCreateCompanionBuilder,
    $$OperateLogTableTableUpdateCompanionBuilder,
    (
      OperateLog,
      BaseReferences<_$OperateLogRepo, $OperateLogTableTable, OperateLog>
    ),
    OperateLog,
    PrefetchHooks Function()>;

class $OperateLogRepoManager {
  final _$OperateLogRepo _db;
  $OperateLogRepoManager(this._db);
  $$OperateLogTableTableTableManager get operateLogTable =>
      $$OperateLogTableTableTableManager(_db, _db.operateLogTable);
}
