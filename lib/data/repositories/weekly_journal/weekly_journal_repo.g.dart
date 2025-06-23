// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_journal_repo.dart';

// ignore_for_file: type=lint
class $WeeklyJournalTableTable extends WeeklyJournalTable
    with TableInfo<$WeeklyJournalTableTable, WeeklyJournal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyJournalTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekNumberMeta =
      const VerificationMeta('weekNumber');
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
      'week_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _moodColorMeta =
      const VerificationMeta('moodColor');
  @override
  late final GeneratedColumn<String> moodColor = GeneratedColumn<String>(
      'mood_color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _picsMeta = const VerificationMeta('pics');
  @override
  late final GeneratedColumn<String> pics = GeneratedColumn<String>(
      'pics', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _geoMeta = const VerificationMeta('geo');
  @override
  late final GeneratedColumn<String> geo = GeneratedColumn<String>(
      'geo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        writerId,
        year,
        weekNumber,
        title,
        content,
        mood,
        moodColor,
        pics,
        geo,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_journal_table';
  @override
  VerificationContext validateIntegrity(Insertable<WeeklyJournal> instance,
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
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
          _weekNumberMeta,
          weekNumber.isAcceptableOrUnknown(
              data['week_number']!, _weekNumberMeta));
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('mood_color')) {
      context.handle(_moodColorMeta,
          moodColor.isAcceptableOrUnknown(data['mood_color']!, _moodColorMeta));
    } else if (isInserting) {
      context.missing(_moodColorMeta);
    }
    if (data.containsKey('pics')) {
      context.handle(
          _picsMeta, pics.isAcceptableOrUnknown(data['pics']!, _picsMeta));
    } else if (isInserting) {
      context.missing(_picsMeta);
    }
    if (data.containsKey('geo')) {
      context.handle(
          _geoMeta, geo.isAcceptableOrUnknown(data['geo']!, _geoMeta));
    } else if (isInserting) {
      context.missing(_geoMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {writerId, year, weekNumber},
      ];
  @override
  WeeklyJournal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyJournal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      writerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}writer_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      weekNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_number'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood'])!,
      moodColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood_color'])!,
      pics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pics'])!,
      geo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geo'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $WeeklyJournalTableTable createAlias(String alias) {
    return $WeeklyJournalTableTable(attachedDatabase, alias);
  }
}

class WeeklyJournal extends DataClass implements Insertable<WeeklyJournal> {
  final int id;
  final int writerId;
  final int year;
  final int weekNumber;
  final String title;
  final String content;
  final int mood;
  final String moodColor;
  final String pics;
  final String geo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  const WeeklyJournal(
      {required this.id,
      required this.writerId,
      required this.year,
      required this.weekNumber,
      required this.title,
      required this.content,
      required this.mood,
      required this.moodColor,
      required this.pics,
      required this.geo,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['writer_id'] = Variable<int>(writerId);
    map['year'] = Variable<int>(year);
    map['week_number'] = Variable<int>(weekNumber);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['mood'] = Variable<int>(mood);
    map['mood_color'] = Variable<String>(moodColor);
    map['pics'] = Variable<String>(pics);
    map['geo'] = Variable<String>(geo);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  WeeklyJournalTableCompanion toCompanion(bool nullToAbsent) {
    return WeeklyJournalTableCompanion(
      id: Value(id),
      writerId: Value(writerId),
      year: Value(year),
      weekNumber: Value(weekNumber),
      title: Value(title),
      content: Value(content),
      mood: Value(mood),
      moodColor: Value(moodColor),
      pics: Value(pics),
      geo: Value(geo),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory WeeklyJournal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyJournal(
      id: serializer.fromJson<int>(json['id']),
      writerId: serializer.fromJson<int>(json['writerId']),
      year: serializer.fromJson<int>(json['year']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      mood: serializer.fromJson<int>(json['mood']),
      moodColor: serializer.fromJson<String>(json['moodColor']),
      pics: serializer.fromJson<String>(json['pics']),
      geo: serializer.fromJson<String>(json['geo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'writerId': serializer.toJson<int>(writerId),
      'year': serializer.toJson<int>(year),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'mood': serializer.toJson<int>(mood),
      'moodColor': serializer.toJson<String>(moodColor),
      'pics': serializer.toJson<String>(pics),
      'geo': serializer.toJson<String>(geo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  WeeklyJournal copyWith(
          {int? id,
          int? writerId,
          int? year,
          int? weekNumber,
          String? title,
          String? content,
          int? mood,
          String? moodColor,
          String? pics,
          String? geo,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      WeeklyJournal(
        id: id ?? this.id,
        writerId: writerId ?? this.writerId,
        year: year ?? this.year,
        weekNumber: weekNumber ?? this.weekNumber,
        title: title ?? this.title,
        content: content ?? this.content,
        mood: mood ?? this.mood,
        moodColor: moodColor ?? this.moodColor,
        pics: pics ?? this.pics,
        geo: geo ?? this.geo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  WeeklyJournal copyWithCompanion(WeeklyJournalTableCompanion data) {
    return WeeklyJournal(
      id: data.id.present ? data.id.value : this.id,
      writerId: data.writerId.present ? data.writerId.value : this.writerId,
      year: data.year.present ? data.year.value : this.year,
      weekNumber:
          data.weekNumber.present ? data.weekNumber.value : this.weekNumber,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      mood: data.mood.present ? data.mood.value : this.mood,
      moodColor: data.moodColor.present ? data.moodColor.value : this.moodColor,
      pics: data.pics.present ? data.pics.value : this.pics,
      geo: data.geo.present ? data.geo.value : this.geo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyJournal(')
          ..write('id: $id, ')
          ..write('writerId: $writerId, ')
          ..write('year: $year, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('mood: $mood, ')
          ..write('moodColor: $moodColor, ')
          ..write('pics: $pics, ')
          ..write('geo: $geo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, writerId, year, weekNumber, title,
      content, mood, moodColor, pics, geo, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyJournal &&
          other.id == this.id &&
          other.writerId == this.writerId &&
          other.year == this.year &&
          other.weekNumber == this.weekNumber &&
          other.title == this.title &&
          other.content == this.content &&
          other.mood == this.mood &&
          other.moodColor == this.moodColor &&
          other.pics == this.pics &&
          other.geo == this.geo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class WeeklyJournalTableCompanion extends UpdateCompanion<WeeklyJournal> {
  final Value<int> id;
  final Value<int> writerId;
  final Value<int> year;
  final Value<int> weekNumber;
  final Value<String> title;
  final Value<String> content;
  final Value<int> mood;
  final Value<String> moodColor;
  final Value<String> pics;
  final Value<String> geo;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  const WeeklyJournalTableCompanion({
    this.id = const Value.absent(),
    this.writerId = const Value.absent(),
    this.year = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.mood = const Value.absent(),
    this.moodColor = const Value.absent(),
    this.pics = const Value.absent(),
    this.geo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  WeeklyJournalTableCompanion.insert({
    this.id = const Value.absent(),
    required int writerId,
    required int year,
    required int weekNumber,
    required String title,
    required String content,
    required int mood,
    required String moodColor,
    required String pics,
    required String geo,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : writerId = Value(writerId),
        year = Value(year),
        weekNumber = Value(weekNumber),
        title = Value(title),
        content = Value(content),
        mood = Value(mood),
        moodColor = Value(moodColor),
        pics = Value(pics),
        geo = Value(geo);
  static Insertable<WeeklyJournal> custom({
    Expression<int>? id,
    Expression<int>? writerId,
    Expression<int>? year,
    Expression<int>? weekNumber,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? mood,
    Expression<String>? moodColor,
    Expression<String>? pics,
    Expression<String>? geo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (writerId != null) 'writer_id': writerId,
      if (year != null) 'year': year,
      if (weekNumber != null) 'week_number': weekNumber,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (mood != null) 'mood': mood,
      if (moodColor != null) 'mood_color': moodColor,
      if (pics != null) 'pics': pics,
      if (geo != null) 'geo': geo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  WeeklyJournalTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? writerId,
      Value<int>? year,
      Value<int>? weekNumber,
      Value<String>? title,
      Value<String>? content,
      Value<int>? mood,
      Value<String>? moodColor,
      Value<String>? pics,
      Value<String>? geo,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? deletedAt}) {
    return WeeklyJournalTableCompanion(
      id: id ?? this.id,
      writerId: writerId ?? this.writerId,
      year: year ?? this.year,
      weekNumber: weekNumber ?? this.weekNumber,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      moodColor: moodColor ?? this.moodColor,
      pics: pics ?? this.pics,
      geo: geo ?? this.geo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (moodColor.present) {
      map['mood_color'] = Variable<String>(moodColor.value);
    }
    if (pics.present) {
      map['pics'] = Variable<String>(pics.value);
    }
    if (geo.present) {
      map['geo'] = Variable<String>(geo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyJournalTableCompanion(')
          ..write('id: $id, ')
          ..write('writerId: $writerId, ')
          ..write('year: $year, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('mood: $mood, ')
          ..write('moodColor: $moodColor, ')
          ..write('pics: $pics, ')
          ..write('geo: $geo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$WeeklyJournalRepo extends GeneratedDatabase {
  _$WeeklyJournalRepo(QueryExecutor e) : super(e);
  $WeeklyJournalRepoManager get managers => $WeeklyJournalRepoManager(this);
  late final $WeeklyJournalTableTable weeklyJournalTable =
      $WeeklyJournalTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [weeklyJournalTable];
}

typedef $$WeeklyJournalTableTableCreateCompanionBuilder
    = WeeklyJournalTableCompanion Function({
  Value<int> id,
  required int writerId,
  required int year,
  required int weekNumber,
  required String title,
  required String content,
  required int mood,
  required String moodColor,
  required String pics,
  required String geo,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> deletedAt,
});
typedef $$WeeklyJournalTableTableUpdateCompanionBuilder
    = WeeklyJournalTableCompanion Function({
  Value<int> id,
  Value<int> writerId,
  Value<int> year,
  Value<int> weekNumber,
  Value<String> title,
  Value<String> content,
  Value<int> mood,
  Value<String> moodColor,
  Value<String> pics,
  Value<String> geo,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> deletedAt,
});

class $$WeeklyJournalTableTableFilterComposer
    extends Composer<_$WeeklyJournalRepo, $WeeklyJournalTableTable> {
  $$WeeklyJournalTableTableFilterComposer({
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

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moodColor => $composableBuilder(
      column: $table.moodColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pics => $composableBuilder(
      column: $table.pics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geo => $composableBuilder(
      column: $table.geo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$WeeklyJournalTableTableOrderingComposer
    extends Composer<_$WeeklyJournalRepo, $WeeklyJournalTableTable> {
  $$WeeklyJournalTableTableOrderingComposer({
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

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moodColor => $composableBuilder(
      column: $table.moodColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pics => $composableBuilder(
      column: $table.pics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geo => $composableBuilder(
      column: $table.geo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$WeeklyJournalTableTableAnnotationComposer
    extends Composer<_$WeeklyJournalRepo, $WeeklyJournalTableTable> {
  $$WeeklyJournalTableTableAnnotationComposer({
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

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get moodColor =>
      $composableBuilder(column: $table.moodColor, builder: (column) => column);

  GeneratedColumn<String> get pics =>
      $composableBuilder(column: $table.pics, builder: (column) => column);

  GeneratedColumn<String> get geo =>
      $composableBuilder(column: $table.geo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$WeeklyJournalTableTableTableManager extends RootTableManager<
    _$WeeklyJournalRepo,
    $WeeklyJournalTableTable,
    WeeklyJournal,
    $$WeeklyJournalTableTableFilterComposer,
    $$WeeklyJournalTableTableOrderingComposer,
    $$WeeklyJournalTableTableAnnotationComposer,
    $$WeeklyJournalTableTableCreateCompanionBuilder,
    $$WeeklyJournalTableTableUpdateCompanionBuilder,
    (
      WeeklyJournal,
      BaseReferences<_$WeeklyJournalRepo, $WeeklyJournalTableTable,
          WeeklyJournal>
    ),
    WeeklyJournal,
    PrefetchHooks Function()> {
  $$WeeklyJournalTableTableTableManager(
      _$WeeklyJournalRepo db, $WeeklyJournalTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyJournalTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyJournalTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyJournalTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> writerId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> weekNumber = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<String> moodColor = const Value.absent(),
            Value<String> pics = const Value.absent(),
            Value<String> geo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              WeeklyJournalTableCompanion(
            id: id,
            writerId: writerId,
            year: year,
            weekNumber: weekNumber,
            title: title,
            content: content,
            mood: mood,
            moodColor: moodColor,
            pics: pics,
            geo: geo,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int writerId,
            required int year,
            required int weekNumber,
            required String title,
            required String content,
            required int mood,
            required String moodColor,
            required String pics,
            required String geo,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              WeeklyJournalTableCompanion.insert(
            id: id,
            writerId: writerId,
            year: year,
            weekNumber: weekNumber,
            title: title,
            content: content,
            mood: mood,
            moodColor: moodColor,
            pics: pics,
            geo: geo,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeeklyJournalTableTableProcessedTableManager = ProcessedTableManager<
    _$WeeklyJournalRepo,
    $WeeklyJournalTableTable,
    WeeklyJournal,
    $$WeeklyJournalTableTableFilterComposer,
    $$WeeklyJournalTableTableOrderingComposer,
    $$WeeklyJournalTableTableAnnotationComposer,
    $$WeeklyJournalTableTableCreateCompanionBuilder,
    $$WeeklyJournalTableTableUpdateCompanionBuilder,
    (
      WeeklyJournal,
      BaseReferences<_$WeeklyJournalRepo, $WeeklyJournalTableTable,
          WeeklyJournal>
    ),
    WeeklyJournal,
    PrefetchHooks Function()>;

class $WeeklyJournalRepoManager {
  final _$WeeklyJournalRepo _db;
  $WeeklyJournalRepoManager(this._db);
  $$WeeklyJournalTableTableTableManager get weeklyJournalTable =>
      $$WeeklyJournalTableTableTableManager(_db, _db.weeklyJournalTable);
}
