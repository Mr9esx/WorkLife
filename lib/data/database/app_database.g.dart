// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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
  static const VerificationMeta _currentWriterMeta =
      const VerificationMeta('currentWriter');
  @override
  late final GeneratedColumn<int> currentWriter = GeneratedColumn<int>(
      'current_writer', aliasedName, false,
      type: DriftSqlType.int,
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
        currentWriter,
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
    if (data.containsKey('current_writer')) {
      context.handle(
          _currentWriterMeta,
          currentWriter.isAcceptableOrUnknown(
              data['current_writer']!, _currentWriterMeta));
    } else if (isInserting) {
      context.missing(_currentWriterMeta);
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
      currentWriter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_writer'])!,
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
  final int currentWriter;
  final int gender;
  final DateTime birthDay;
  final String? avatar;
  final String? birthPlace;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const JournalWriter(
      {required this.id,
      required this.username,
      required this.currentWriter,
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
    map['current_writer'] = Variable<int>(currentWriter);
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
      currentWriter: Value(currentWriter),
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
      currentWriter: serializer.fromJson<int>(json['currentWriter']),
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
      'currentWriter': serializer.toJson<int>(currentWriter),
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
          int? currentWriter,
          int? gender,
          DateTime? birthDay,
          Value<String?> avatar = const Value.absent(),
          Value<String?> birthPlace = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      JournalWriter(
        id: id ?? this.id,
        username: username ?? this.username,
        currentWriter: currentWriter ?? this.currentWriter,
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
      currentWriter: data.currentWriter.present
          ? data.currentWriter.value
          : this.currentWriter,
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
          ..write('currentWriter: $currentWriter, ')
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
  int get hashCode => Object.hash(id, username, currentWriter, gender, birthDay,
      avatar, birthPlace, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalWriter &&
          other.id == this.id &&
          other.username == this.username &&
          other.currentWriter == this.currentWriter &&
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
  final Value<int> currentWriter;
  final Value<int> gender;
  final Value<DateTime> birthDay;
  final Value<String?> avatar;
  final Value<String?> birthPlace;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const JournalWriterTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.currentWriter = const Value.absent(),
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
    required int currentWriter,
    required int gender,
    required DateTime birthDay,
    this.avatar = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        currentWriter = Value(currentWriter),
        gender = Value(gender),
        birthDay = Value(birthDay);
  static Insertable<JournalWriter> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<int>? currentWriter,
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
      if (currentWriter != null) 'current_writer': currentWriter,
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
      Value<int>? currentWriter,
      Value<int>? gender,
      Value<DateTime>? birthDay,
      Value<String?>? avatar,
      Value<String?>? birthPlace,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return JournalWriterTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      currentWriter: currentWriter ?? this.currentWriter,
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
    if (currentWriter.present) {
      map['current_writer'] = Variable<int>(currentWriter.value);
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
          ..write('currentWriter: $currentWriter, ')
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

class $LocationRecordTableTable extends LocationRecordTable
    with TableInfo<$LocationRecordTableTable, LocationRecordTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationRecordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMeta =
      const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
      'altitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _distanceFromPreviousMeta =
      const VerificationMeta('distanceFromPrevious');
  @override
  late final GeneratedColumn<double> distanceFromPrevious =
      GeneratedColumn<double>('distance_from_previous', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        latitude,
        longitude,
        locationName,
        accuracy,
        altitude,
        distanceFromPrevious,
        recordedAt,
        userId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'location_record_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocationRecordTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    }
    if (data.containsKey('distance_from_previous')) {
      context.handle(
          _distanceFromPreviousMeta,
          distanceFromPrevious.isAcceptableOrUnknown(
              data['distance_from_previous']!, _distanceFromPreviousMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationRecordTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationRecordTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name']),
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy']),
      altitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}altitude']),
      distanceFromPrevious: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}distance_from_previous']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recorded_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LocationRecordTableTable createAlias(String alias) {
    return $LocationRecordTableTable(attachedDatabase, alias);
  }
}

class LocationRecordTableData extends DataClass
    implements Insertable<LocationRecordTableData> {
  /// 主键ID
  final int id;

  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  /// 位置名称/地址描述
  final String? locationName;

  /// 定位精度（米）
  final double? accuracy;

  /// 海拔高度（米）
  final double? altitude;

  /// 与上一次定位的直线距离（米）
  final double? distanceFromPrevious;

  /// 记录时间（Unix时间戳）
  final int recordedAt;

  /// 用户ID
  final int userId;

  /// 创建时间（Unix时间戳）
  final int createdAt;
  const LocationRecordTableData(
      {required this.id,
      required this.latitude,
      required this.longitude,
      this.locationName,
      this.accuracy,
      this.altitude,
      this.distanceFromPrevious,
      required this.recordedAt,
      required this.userId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || distanceFromPrevious != null) {
      map['distance_from_previous'] = Variable<double>(distanceFromPrevious);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  LocationRecordTableCompanion toCompanion(bool nullToAbsent) {
    return LocationRecordTableCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      distanceFromPrevious: distanceFromPrevious == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceFromPrevious),
      recordedAt: Value(recordedAt),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory LocationRecordTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationRecordTableData(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      distanceFromPrevious:
          serializer.fromJson<double?>(json['distanceFromPrevious']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'locationName': serializer.toJson<String?>(locationName),
      'accuracy': serializer.toJson<double?>(accuracy),
      'altitude': serializer.toJson<double?>(altitude),
      'distanceFromPrevious': serializer.toJson<double?>(distanceFromPrevious),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  LocationRecordTableData copyWith(
          {int? id,
          double? latitude,
          double? longitude,
          Value<String?> locationName = const Value.absent(),
          Value<double?> accuracy = const Value.absent(),
          Value<double?> altitude = const Value.absent(),
          Value<double?> distanceFromPrevious = const Value.absent(),
          int? recordedAt,
          int? userId,
          int? createdAt}) =>
      LocationRecordTableData(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        locationName:
            locationName.present ? locationName.value : this.locationName,
        accuracy: accuracy.present ? accuracy.value : this.accuracy,
        altitude: altitude.present ? altitude.value : this.altitude,
        distanceFromPrevious: distanceFromPrevious.present
            ? distanceFromPrevious.value
            : this.distanceFromPrevious,
        recordedAt: recordedAt ?? this.recordedAt,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
      );
  LocationRecordTableData copyWithCompanion(LocationRecordTableCompanion data) {
    return LocationRecordTableData(
      id: data.id.present ? data.id.value : this.id,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      distanceFromPrevious: data.distanceFromPrevious.present
          ? data.distanceFromPrevious.value
          : this.distanceFromPrevious,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationRecordTableData(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('distanceFromPrevious: $distanceFromPrevious, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, latitude, longitude, locationName,
      accuracy, altitude, distanceFromPrevious, recordedAt, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationRecordTableData &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.locationName == this.locationName &&
          other.accuracy == this.accuracy &&
          other.altitude == this.altitude &&
          other.distanceFromPrevious == this.distanceFromPrevious &&
          other.recordedAt == this.recordedAt &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class LocationRecordTableCompanion
    extends UpdateCompanion<LocationRecordTableData> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> locationName;
  final Value<double?> accuracy;
  final Value<double?> altitude;
  final Value<double?> distanceFromPrevious;
  final Value<int> recordedAt;
  final Value<int> userId;
  final Value<int> createdAt;
  const LocationRecordTableCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.distanceFromPrevious = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LocationRecordTableCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    this.locationName = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.distanceFromPrevious = const Value.absent(),
    required int recordedAt,
    required int userId,
    required int createdAt,
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        recordedAt = Value(recordedAt),
        userId = Value(userId),
        createdAt = Value(createdAt);
  static Insertable<LocationRecordTableData> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? locationName,
    Expression<double>? accuracy,
    Expression<double>? altitude,
    Expression<double>? distanceFromPrevious,
    Expression<int>? recordedAt,
    Expression<int>? userId,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationName != null) 'location_name': locationName,
      if (accuracy != null) 'accuracy': accuracy,
      if (altitude != null) 'altitude': altitude,
      if (distanceFromPrevious != null)
        'distance_from_previous': distanceFromPrevious,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LocationRecordTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? locationName,
      Value<double?>? accuracy,
      Value<double?>? altitude,
      Value<double?>? distanceFromPrevious,
      Value<int>? recordedAt,
      Value<int>? userId,
      Value<int>? createdAt}) {
    return LocationRecordTableCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      distanceFromPrevious: distanceFromPrevious ?? this.distanceFromPrevious,
      recordedAt: recordedAt ?? this.recordedAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (distanceFromPrevious.present) {
      map['distance_from_previous'] =
          Variable<double>(distanceFromPrevious.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationRecordTableCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('distanceFromPrevious: $distanceFromPrevious, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppGlobalInfoTableTable extends AppGlobalInfoTable
    with TableInfo<$AppGlobalInfoTableTable, AppGlobalInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppGlobalInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _appVersionMeta =
      const VerificationMeta('appVersion');
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
      'app_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dbVersionMeta =
      const VerificationMeta('dbVersion');
  @override
  late final GeneratedColumn<int> dbVersion = GeneratedColumn<int>(
      'db_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isFirstLaunchMeta =
      const VerificationMeta('isFirstLaunch');
  @override
  late final GeneratedColumn<bool> isFirstLaunch = GeneratedColumn<bool>(
      'is_first_launch', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_first_launch" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDefaultDataInitializedMeta =
      const VerificationMeta('isDefaultDataInitialized');
  @override
  late final GeneratedColumn<bool> isDefaultDataInitialized =
      GeneratedColumn<bool>(
          'is_default_data_initialized', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("is_default_data_initialized" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _lastLaunchTimeMeta =
      const VerificationMeta('lastLaunchTime');
  @override
  late final GeneratedColumn<DateTime> lastLaunchTime =
      GeneratedColumn<DateTime>('last_launch_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _launchCountMeta =
      const VerificationMeta('launchCount');
  @override
  late final GeneratedColumn<int> launchCount = GeneratedColumn<int>(
      'launch_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _privacyPolicyVersionMeta =
      const VerificationMeta('privacyPolicyVersion');
  @override
  late final GeneratedColumn<String> privacyPolicyVersion =
      GeneratedColumn<String>('privacy_policy_version', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPrivacyPolicyAcceptedMeta =
      const VerificationMeta('isPrivacyPolicyAccepted');
  @override
  late final GeneratedColumn<bool> isPrivacyPolicyAccepted =
      GeneratedColumn<bool>('is_privacy_policy_accepted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("is_privacy_policy_accepted" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _appLanguageMeta =
      const VerificationMeta('appLanguage');
  @override
  late final GeneratedColumn<String> appLanguage = GeneratedColumn<String>(
      'app_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('zh_CN'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _extendedConfigMeta =
      const VerificationMeta('extendedConfig');
  @override
  late final GeneratedColumn<String> extendedConfig = GeneratedColumn<String>(
      'extended_config', aliasedName, true,
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
        appVersion,
        dbVersion,
        isFirstLaunch,
        isDefaultDataInitialized,
        lastLaunchTime,
        launchCount,
        privacyPolicyVersion,
        isPrivacyPolicyAccepted,
        appLanguage,
        themeMode,
        extendedConfig,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_global_info_table';
  @override
  VerificationContext validateIntegrity(Insertable<AppGlobalInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('app_version')) {
      context.handle(
          _appVersionMeta,
          appVersion.isAcceptableOrUnknown(
              data['app_version']!, _appVersionMeta));
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('db_version')) {
      context.handle(_dbVersionMeta,
          dbVersion.isAcceptableOrUnknown(data['db_version']!, _dbVersionMeta));
    } else if (isInserting) {
      context.missing(_dbVersionMeta);
    }
    if (data.containsKey('is_first_launch')) {
      context.handle(
          _isFirstLaunchMeta,
          isFirstLaunch.isAcceptableOrUnknown(
              data['is_first_launch']!, _isFirstLaunchMeta));
    }
    if (data.containsKey('is_default_data_initialized')) {
      context.handle(
          _isDefaultDataInitializedMeta,
          isDefaultDataInitialized.isAcceptableOrUnknown(
              data['is_default_data_initialized']!,
              _isDefaultDataInitializedMeta));
    }
    if (data.containsKey('last_launch_time')) {
      context.handle(
          _lastLaunchTimeMeta,
          lastLaunchTime.isAcceptableOrUnknown(
              data['last_launch_time']!, _lastLaunchTimeMeta));
    }
    if (data.containsKey('launch_count')) {
      context.handle(
          _launchCountMeta,
          launchCount.isAcceptableOrUnknown(
              data['launch_count']!, _launchCountMeta));
    }
    if (data.containsKey('privacy_policy_version')) {
      context.handle(
          _privacyPolicyVersionMeta,
          privacyPolicyVersion.isAcceptableOrUnknown(
              data['privacy_policy_version']!, _privacyPolicyVersionMeta));
    }
    if (data.containsKey('is_privacy_policy_accepted')) {
      context.handle(
          _isPrivacyPolicyAcceptedMeta,
          isPrivacyPolicyAccepted.isAcceptableOrUnknown(
              data['is_privacy_policy_accepted']!,
              _isPrivacyPolicyAcceptedMeta));
    }
    if (data.containsKey('app_language')) {
      context.handle(
          _appLanguageMeta,
          appLanguage.isAcceptableOrUnknown(
              data['app_language']!, _appLanguageMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('extended_config')) {
      context.handle(
          _extendedConfigMeta,
          extendedConfig.isAcceptableOrUnknown(
              data['extended_config']!, _extendedConfigMeta));
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
  AppGlobalInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppGlobalInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      appVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_version'])!,
      dbVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}db_version'])!,
      isFirstLaunch: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_first_launch'])!,
      isDefaultDataInitialized: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}is_default_data_initialized'])!,
      lastLaunchTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_launch_time']),
      launchCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}launch_count'])!,
      privacyPolicyVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}privacy_policy_version']),
      isPrivacyPolicyAccepted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}is_privacy_policy_accepted'])!,
      appLanguage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_language'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      extendedConfig: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extended_config']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AppGlobalInfoTableTable createAlias(String alias) {
    return $AppGlobalInfoTableTable(attachedDatabase, alias);
  }
}

class AppGlobalInfo extends DataClass implements Insertable<AppGlobalInfo> {
  final int id;
  final String appVersion;
  final int dbVersion;
  final bool isFirstLaunch;
  final bool isDefaultDataInitialized;
  final DateTime? lastLaunchTime;
  final int launchCount;
  final String? privacyPolicyVersion;
  final bool isPrivacyPolicyAccepted;
  final String appLanguage;
  final String themeMode;
  final String? extendedConfig;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const AppGlobalInfo(
      {required this.id,
      required this.appVersion,
      required this.dbVersion,
      required this.isFirstLaunch,
      required this.isDefaultDataInitialized,
      this.lastLaunchTime,
      required this.launchCount,
      this.privacyPolicyVersion,
      required this.isPrivacyPolicyAccepted,
      required this.appLanguage,
      required this.themeMode,
      this.extendedConfig,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['app_version'] = Variable<String>(appVersion);
    map['db_version'] = Variable<int>(dbVersion);
    map['is_first_launch'] = Variable<bool>(isFirstLaunch);
    map['is_default_data_initialized'] =
        Variable<bool>(isDefaultDataInitialized);
    if (!nullToAbsent || lastLaunchTime != null) {
      map['last_launch_time'] = Variable<DateTime>(lastLaunchTime);
    }
    map['launch_count'] = Variable<int>(launchCount);
    if (!nullToAbsent || privacyPolicyVersion != null) {
      map['privacy_policy_version'] = Variable<String>(privacyPolicyVersion);
    }
    map['is_privacy_policy_accepted'] = Variable<bool>(isPrivacyPolicyAccepted);
    map['app_language'] = Variable<String>(appLanguage);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || extendedConfig != null) {
      map['extended_config'] = Variable<String>(extendedConfig);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AppGlobalInfoTableCompanion toCompanion(bool nullToAbsent) {
    return AppGlobalInfoTableCompanion(
      id: Value(id),
      appVersion: Value(appVersion),
      dbVersion: Value(dbVersion),
      isFirstLaunch: Value(isFirstLaunch),
      isDefaultDataInitialized: Value(isDefaultDataInitialized),
      lastLaunchTime: lastLaunchTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLaunchTime),
      launchCount: Value(launchCount),
      privacyPolicyVersion: privacyPolicyVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(privacyPolicyVersion),
      isPrivacyPolicyAccepted: Value(isPrivacyPolicyAccepted),
      appLanguage: Value(appLanguage),
      themeMode: Value(themeMode),
      extendedConfig: extendedConfig == null && nullToAbsent
          ? const Value.absent()
          : Value(extendedConfig),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AppGlobalInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppGlobalInfo(
      id: serializer.fromJson<int>(json['id']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      dbVersion: serializer.fromJson<int>(json['dbVersion']),
      isFirstLaunch: serializer.fromJson<bool>(json['isFirstLaunch']),
      isDefaultDataInitialized:
          serializer.fromJson<bool>(json['isDefaultDataInitialized']),
      lastLaunchTime: serializer.fromJson<DateTime?>(json['lastLaunchTime']),
      launchCount: serializer.fromJson<int>(json['launchCount']),
      privacyPolicyVersion:
          serializer.fromJson<String?>(json['privacyPolicyVersion']),
      isPrivacyPolicyAccepted:
          serializer.fromJson<bool>(json['isPrivacyPolicyAccepted']),
      appLanguage: serializer.fromJson<String>(json['appLanguage']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      extendedConfig: serializer.fromJson<String?>(json['extendedConfig']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appVersion': serializer.toJson<String>(appVersion),
      'dbVersion': serializer.toJson<int>(dbVersion),
      'isFirstLaunch': serializer.toJson<bool>(isFirstLaunch),
      'isDefaultDataInitialized':
          serializer.toJson<bool>(isDefaultDataInitialized),
      'lastLaunchTime': serializer.toJson<DateTime?>(lastLaunchTime),
      'launchCount': serializer.toJson<int>(launchCount),
      'privacyPolicyVersion': serializer.toJson<String?>(privacyPolicyVersion),
      'isPrivacyPolicyAccepted':
          serializer.toJson<bool>(isPrivacyPolicyAccepted),
      'appLanguage': serializer.toJson<String>(appLanguage),
      'themeMode': serializer.toJson<String>(themeMode),
      'extendedConfig': serializer.toJson<String?>(extendedConfig),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AppGlobalInfo copyWith(
          {int? id,
          String? appVersion,
          int? dbVersion,
          bool? isFirstLaunch,
          bool? isDefaultDataInitialized,
          Value<DateTime?> lastLaunchTime = const Value.absent(),
          int? launchCount,
          Value<String?> privacyPolicyVersion = const Value.absent(),
          bool? isPrivacyPolicyAccepted,
          String? appLanguage,
          String? themeMode,
          Value<String?> extendedConfig = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AppGlobalInfo(
        id: id ?? this.id,
        appVersion: appVersion ?? this.appVersion,
        dbVersion: dbVersion ?? this.dbVersion,
        isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
        isDefaultDataInitialized:
            isDefaultDataInitialized ?? this.isDefaultDataInitialized,
        lastLaunchTime:
            lastLaunchTime.present ? lastLaunchTime.value : this.lastLaunchTime,
        launchCount: launchCount ?? this.launchCount,
        privacyPolicyVersion: privacyPolicyVersion.present
            ? privacyPolicyVersion.value
            : this.privacyPolicyVersion,
        isPrivacyPolicyAccepted:
            isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
        appLanguage: appLanguage ?? this.appLanguage,
        themeMode: themeMode ?? this.themeMode,
        extendedConfig:
            extendedConfig.present ? extendedConfig.value : this.extendedConfig,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AppGlobalInfo copyWithCompanion(AppGlobalInfoTableCompanion data) {
    return AppGlobalInfo(
      id: data.id.present ? data.id.value : this.id,
      appVersion:
          data.appVersion.present ? data.appVersion.value : this.appVersion,
      dbVersion: data.dbVersion.present ? data.dbVersion.value : this.dbVersion,
      isFirstLaunch: data.isFirstLaunch.present
          ? data.isFirstLaunch.value
          : this.isFirstLaunch,
      isDefaultDataInitialized: data.isDefaultDataInitialized.present
          ? data.isDefaultDataInitialized.value
          : this.isDefaultDataInitialized,
      lastLaunchTime: data.lastLaunchTime.present
          ? data.lastLaunchTime.value
          : this.lastLaunchTime,
      launchCount:
          data.launchCount.present ? data.launchCount.value : this.launchCount,
      privacyPolicyVersion: data.privacyPolicyVersion.present
          ? data.privacyPolicyVersion.value
          : this.privacyPolicyVersion,
      isPrivacyPolicyAccepted: data.isPrivacyPolicyAccepted.present
          ? data.isPrivacyPolicyAccepted.value
          : this.isPrivacyPolicyAccepted,
      appLanguage:
          data.appLanguage.present ? data.appLanguage.value : this.appLanguage,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      extendedConfig: data.extendedConfig.present
          ? data.extendedConfig.value
          : this.extendedConfig,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppGlobalInfo(')
          ..write('id: $id, ')
          ..write('appVersion: $appVersion, ')
          ..write('dbVersion: $dbVersion, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('isDefaultDataInitialized: $isDefaultDataInitialized, ')
          ..write('lastLaunchTime: $lastLaunchTime, ')
          ..write('launchCount: $launchCount, ')
          ..write('privacyPolicyVersion: $privacyPolicyVersion, ')
          ..write('isPrivacyPolicyAccepted: $isPrivacyPolicyAccepted, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('themeMode: $themeMode, ')
          ..write('extendedConfig: $extendedConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      appVersion,
      dbVersion,
      isFirstLaunch,
      isDefaultDataInitialized,
      lastLaunchTime,
      launchCount,
      privacyPolicyVersion,
      isPrivacyPolicyAccepted,
      appLanguage,
      themeMode,
      extendedConfig,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppGlobalInfo &&
          other.id == this.id &&
          other.appVersion == this.appVersion &&
          other.dbVersion == this.dbVersion &&
          other.isFirstLaunch == this.isFirstLaunch &&
          other.isDefaultDataInitialized == this.isDefaultDataInitialized &&
          other.lastLaunchTime == this.lastLaunchTime &&
          other.launchCount == this.launchCount &&
          other.privacyPolicyVersion == this.privacyPolicyVersion &&
          other.isPrivacyPolicyAccepted == this.isPrivacyPolicyAccepted &&
          other.appLanguage == this.appLanguage &&
          other.themeMode == this.themeMode &&
          other.extendedConfig == this.extendedConfig &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppGlobalInfoTableCompanion extends UpdateCompanion<AppGlobalInfo> {
  final Value<int> id;
  final Value<String> appVersion;
  final Value<int> dbVersion;
  final Value<bool> isFirstLaunch;
  final Value<bool> isDefaultDataInitialized;
  final Value<DateTime?> lastLaunchTime;
  final Value<int> launchCount;
  final Value<String?> privacyPolicyVersion;
  final Value<bool> isPrivacyPolicyAccepted;
  final Value<String> appLanguage;
  final Value<String> themeMode;
  final Value<String?> extendedConfig;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const AppGlobalInfoTableCompanion({
    this.id = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.dbVersion = const Value.absent(),
    this.isFirstLaunch = const Value.absent(),
    this.isDefaultDataInitialized = const Value.absent(),
    this.lastLaunchTime = const Value.absent(),
    this.launchCount = const Value.absent(),
    this.privacyPolicyVersion = const Value.absent(),
    this.isPrivacyPolicyAccepted = const Value.absent(),
    this.appLanguage = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.extendedConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppGlobalInfoTableCompanion.insert({
    this.id = const Value.absent(),
    required String appVersion,
    required int dbVersion,
    this.isFirstLaunch = const Value.absent(),
    this.isDefaultDataInitialized = const Value.absent(),
    this.lastLaunchTime = const Value.absent(),
    this.launchCount = const Value.absent(),
    this.privacyPolicyVersion = const Value.absent(),
    this.isPrivacyPolicyAccepted = const Value.absent(),
    this.appLanguage = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.extendedConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : appVersion = Value(appVersion),
        dbVersion = Value(dbVersion);
  static Insertable<AppGlobalInfo> custom({
    Expression<int>? id,
    Expression<String>? appVersion,
    Expression<int>? dbVersion,
    Expression<bool>? isFirstLaunch,
    Expression<bool>? isDefaultDataInitialized,
    Expression<DateTime>? lastLaunchTime,
    Expression<int>? launchCount,
    Expression<String>? privacyPolicyVersion,
    Expression<bool>? isPrivacyPolicyAccepted,
    Expression<String>? appLanguage,
    Expression<String>? themeMode,
    Expression<String>? extendedConfig,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appVersion != null) 'app_version': appVersion,
      if (dbVersion != null) 'db_version': dbVersion,
      if (isFirstLaunch != null) 'is_first_launch': isFirstLaunch,
      if (isDefaultDataInitialized != null)
        'is_default_data_initialized': isDefaultDataInitialized,
      if (lastLaunchTime != null) 'last_launch_time': lastLaunchTime,
      if (launchCount != null) 'launch_count': launchCount,
      if (privacyPolicyVersion != null)
        'privacy_policy_version': privacyPolicyVersion,
      if (isPrivacyPolicyAccepted != null)
        'is_privacy_policy_accepted': isPrivacyPolicyAccepted,
      if (appLanguage != null) 'app_language': appLanguage,
      if (themeMode != null) 'theme_mode': themeMode,
      if (extendedConfig != null) 'extended_config': extendedConfig,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppGlobalInfoTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? appVersion,
      Value<int>? dbVersion,
      Value<bool>? isFirstLaunch,
      Value<bool>? isDefaultDataInitialized,
      Value<DateTime?>? lastLaunchTime,
      Value<int>? launchCount,
      Value<String?>? privacyPolicyVersion,
      Value<bool>? isPrivacyPolicyAccepted,
      Value<String>? appLanguage,
      Value<String>? themeMode,
      Value<String?>? extendedConfig,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return AppGlobalInfoTableCompanion(
      id: id ?? this.id,
      appVersion: appVersion ?? this.appVersion,
      dbVersion: dbVersion ?? this.dbVersion,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isDefaultDataInitialized:
          isDefaultDataInitialized ?? this.isDefaultDataInitialized,
      lastLaunchTime: lastLaunchTime ?? this.lastLaunchTime,
      launchCount: launchCount ?? this.launchCount,
      privacyPolicyVersion: privacyPolicyVersion ?? this.privacyPolicyVersion,
      isPrivacyPolicyAccepted:
          isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
      appLanguage: appLanguage ?? this.appLanguage,
      themeMode: themeMode ?? this.themeMode,
      extendedConfig: extendedConfig ?? this.extendedConfig,
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
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (dbVersion.present) {
      map['db_version'] = Variable<int>(dbVersion.value);
    }
    if (isFirstLaunch.present) {
      map['is_first_launch'] = Variable<bool>(isFirstLaunch.value);
    }
    if (isDefaultDataInitialized.present) {
      map['is_default_data_initialized'] =
          Variable<bool>(isDefaultDataInitialized.value);
    }
    if (lastLaunchTime.present) {
      map['last_launch_time'] = Variable<DateTime>(lastLaunchTime.value);
    }
    if (launchCount.present) {
      map['launch_count'] = Variable<int>(launchCount.value);
    }
    if (privacyPolicyVersion.present) {
      map['privacy_policy_version'] =
          Variable<String>(privacyPolicyVersion.value);
    }
    if (isPrivacyPolicyAccepted.present) {
      map['is_privacy_policy_accepted'] =
          Variable<bool>(isPrivacyPolicyAccepted.value);
    }
    if (appLanguage.present) {
      map['app_language'] = Variable<String>(appLanguage.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (extendedConfig.present) {
      map['extended_config'] = Variable<String>(extendedConfig.value);
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
    return (StringBuffer('AppGlobalInfoTableCompanion(')
          ..write('id: $id, ')
          ..write('appVersion: $appVersion, ')
          ..write('dbVersion: $dbVersion, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('isDefaultDataInitialized: $isDefaultDataInitialized, ')
          ..write('lastLaunchTime: $lastLaunchTime, ')
          ..write('launchCount: $launchCount, ')
          ..write('privacyPolicyVersion: $privacyPolicyVersion, ')
          ..write('isPrivacyPolicyAccepted: $isPrivacyPolicyAccepted, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('themeMode: $themeMode, ')
          ..write('extendedConfig: $extendedConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TodoRecordTableTable extends TodoRecordTable
    with TableInfo<$TodoRecordTableTable, TodoRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoRecordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _weeklyJournalIdMeta =
      const VerificationMeta('weeklyJournalId');
  @override
  late final GeneratedColumn<int> weeklyJournalId = GeneratedColumn<int>(
      'weekly_journal_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _writerIdMeta =
      const VerificationMeta('writerId');
  @override
  late final GeneratedColumn<int> writerId = GeneratedColumn<int>(
      'writer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekNumberMeta =
      const VerificationMeta('weekNumber');
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
      'week_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        weeklyJournalId,
        writerId,
        weekNumber,
        year,
        content,
        isCompleted,
        status,
        priority,
        sortOrder,
        reminderTime,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_record_table';
  @override
  VerificationContext validateIntegrity(Insertable<TodoRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weekly_journal_id')) {
      context.handle(
          _weeklyJournalIdMeta,
          weeklyJournalId.isAcceptableOrUnknown(
              data['weekly_journal_id']!, _weeklyJournalIdMeta));
    }
    if (data.containsKey('writer_id')) {
      context.handle(_writerIdMeta,
          writerId.isAcceptableOrUnknown(data['writer_id']!, _writerIdMeta));
    } else if (isInserting) {
      context.missing(_writerIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
          _weekNumberMeta,
          weekNumber.isAcceptableOrUnknown(
              data['week_number']!, _weekNumberMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
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
  TodoRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      weeklyJournalId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_journal_id']),
      writerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}writer_id'])!,
      weekNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_number']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_time']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $TodoRecordTableTable createAlias(String alias) {
    return $TodoRecordTableTable(attachedDatabase, alias);
  }
}

class TodoRecord extends DataClass implements Insertable<TodoRecord> {
  final int id;
  final int? weeklyJournalId;
  final int writerId;
  final int? weekNumber;
  final int? year;
  final String content;
  final bool isCompleted;
  final int status;
  final int priority;
  final int sortOrder;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const TodoRecord(
      {required this.id,
      this.weeklyJournalId,
      required this.writerId,
      this.weekNumber,
      this.year,
      required this.content,
      required this.isCompleted,
      required this.status,
      required this.priority,
      required this.sortOrder,
      this.reminderTime,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || weeklyJournalId != null) {
      map['weekly_journal_id'] = Variable<int>(weeklyJournalId);
    }
    map['writer_id'] = Variable<int>(writerId);
    if (!nullToAbsent || weekNumber != null) {
      map['week_number'] = Variable<int>(weekNumber);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['content'] = Variable<String>(content);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['status'] = Variable<int>(status);
    map['priority'] = Variable<int>(priority);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TodoRecordTableCompanion toCompanion(bool nullToAbsent) {
    return TodoRecordTableCompanion(
      id: Value(id),
      weeklyJournalId: weeklyJournalId == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyJournalId),
      writerId: Value(writerId),
      weekNumber: weekNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(weekNumber),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      content: Value(content),
      isCompleted: Value(isCompleted),
      status: Value(status),
      priority: Value(priority),
      sortOrder: Value(sortOrder),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TodoRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoRecord(
      id: serializer.fromJson<int>(json['id']),
      weeklyJournalId: serializer.fromJson<int?>(json['weeklyJournalId']),
      writerId: serializer.fromJson<int>(json['writerId']),
      weekNumber: serializer.fromJson<int?>(json['weekNumber']),
      year: serializer.fromJson<int?>(json['year']),
      content: serializer.fromJson<String>(json['content']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      status: serializer.fromJson<int>(json['status']),
      priority: serializer.fromJson<int>(json['priority']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weeklyJournalId': serializer.toJson<int?>(weeklyJournalId),
      'writerId': serializer.toJson<int>(writerId),
      'weekNumber': serializer.toJson<int?>(weekNumber),
      'year': serializer.toJson<int?>(year),
      'content': serializer.toJson<String>(content),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'status': serializer.toJson<int>(status),
      'priority': serializer.toJson<int>(priority),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TodoRecord copyWith(
          {int? id,
          Value<int?> weeklyJournalId = const Value.absent(),
          int? writerId,
          Value<int?> weekNumber = const Value.absent(),
          Value<int?> year = const Value.absent(),
          String? content,
          bool? isCompleted,
          int? status,
          int? priority,
          int? sortOrder,
          Value<DateTime?> reminderTime = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      TodoRecord(
        id: id ?? this.id,
        weeklyJournalId: weeklyJournalId.present
            ? weeklyJournalId.value
            : this.weeklyJournalId,
        writerId: writerId ?? this.writerId,
        weekNumber: weekNumber.present ? weekNumber.value : this.weekNumber,
        year: year.present ? year.value : this.year,
        content: content ?? this.content,
        isCompleted: isCompleted ?? this.isCompleted,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        sortOrder: sortOrder ?? this.sortOrder,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  TodoRecord copyWithCompanion(TodoRecordTableCompanion data) {
    return TodoRecord(
      id: data.id.present ? data.id.value : this.id,
      weeklyJournalId: data.weeklyJournalId.present
          ? data.weeklyJournalId.value
          : this.weeklyJournalId,
      writerId: data.writerId.present ? data.writerId.value : this.writerId,
      weekNumber:
          data.weekNumber.present ? data.weekNumber.value : this.weekNumber,
      year: data.year.present ? data.year.value : this.year,
      content: data.content.present ? data.content.value : this.content,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoRecord(')
          ..write('id: $id, ')
          ..write('weeklyJournalId: $weeklyJournalId, ')
          ..write('writerId: $writerId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('year: $year, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      weeklyJournalId,
      writerId,
      weekNumber,
      year,
      content,
      isCompleted,
      status,
      priority,
      sortOrder,
      reminderTime,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoRecord &&
          other.id == this.id &&
          other.weeklyJournalId == this.weeklyJournalId &&
          other.writerId == this.writerId &&
          other.weekNumber == this.weekNumber &&
          other.year == this.year &&
          other.content == this.content &&
          other.isCompleted == this.isCompleted &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.sortOrder == this.sortOrder &&
          other.reminderTime == this.reminderTime &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TodoRecordTableCompanion extends UpdateCompanion<TodoRecord> {
  final Value<int> id;
  final Value<int?> weeklyJournalId;
  final Value<int> writerId;
  final Value<int?> weekNumber;
  final Value<int?> year;
  final Value<String> content;
  final Value<bool> isCompleted;
  final Value<int> status;
  final Value<int> priority;
  final Value<int> sortOrder;
  final Value<DateTime?> reminderTime;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const TodoRecordTableCompanion({
    this.id = const Value.absent(),
    this.weeklyJournalId = const Value.absent(),
    this.writerId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.year = const Value.absent(),
    this.content = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TodoRecordTableCompanion.insert({
    this.id = const Value.absent(),
    this.weeklyJournalId = const Value.absent(),
    required int writerId,
    this.weekNumber = const Value.absent(),
    this.year = const Value.absent(),
    required String content,
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : writerId = Value(writerId),
        content = Value(content);
  static Insertable<TodoRecord> custom({
    Expression<int>? id,
    Expression<int>? weeklyJournalId,
    Expression<int>? writerId,
    Expression<int>? weekNumber,
    Expression<int>? year,
    Expression<String>? content,
    Expression<bool>? isCompleted,
    Expression<int>? status,
    Expression<int>? priority,
    Expression<int>? sortOrder,
    Expression<DateTime>? reminderTime,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weeklyJournalId != null) 'weekly_journal_id': weeklyJournalId,
      if (writerId != null) 'writer_id': writerId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (year != null) 'year': year,
      if (content != null) 'content': content,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TodoRecordTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? weeklyJournalId,
      Value<int>? writerId,
      Value<int?>? weekNumber,
      Value<int?>? year,
      Value<String>? content,
      Value<bool>? isCompleted,
      Value<int>? status,
      Value<int>? priority,
      Value<int>? sortOrder,
      Value<DateTime?>? reminderTime,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return TodoRecordTableCompanion(
      id: id ?? this.id,
      weeklyJournalId: weeklyJournalId ?? this.weeklyJournalId,
      writerId: writerId ?? this.writerId,
      weekNumber: weekNumber ?? this.weekNumber,
      year: year ?? this.year,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      sortOrder: sortOrder ?? this.sortOrder,
      reminderTime: reminderTime ?? this.reminderTime,
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
    if (weeklyJournalId.present) {
      map['weekly_journal_id'] = Variable<int>(weeklyJournalId.value);
    }
    if (writerId.present) {
      map['writer_id'] = Variable<int>(writerId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
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
    return (StringBuffer('TodoRecordTableCompanion(')
          ..write('id: $id, ')
          ..write('weeklyJournalId: $weeklyJournalId, ')
          ..write('writerId: $writerId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('year: $year, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JournalWriterTableTable journalWriterTable =
      $JournalWriterTableTable(this);
  late final $LocationRecordTableTable locationRecordTable =
      $LocationRecordTableTable(this);
  late final $AppGlobalInfoTableTable appGlobalInfoTable =
      $AppGlobalInfoTableTable(this);
  late final $TodoRecordTableTable todoRecordTable =
      $TodoRecordTableTable(this);
  late final $WeeklyJournalTableTable weeklyJournalTable =
      $WeeklyJournalTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        journalWriterTable,
        locationRecordTable,
        appGlobalInfoTable,
        todoRecordTable,
        weeklyJournalTable
      ];
}

typedef $$JournalWriterTableTableCreateCompanionBuilder
    = JournalWriterTableCompanion Function({
  Value<int> id,
  required String username,
  required int currentWriter,
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
  Value<int> currentWriter,
  Value<int> gender,
  Value<DateTime> birthDay,
  Value<String?> avatar,
  Value<String?> birthPlace,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$JournalWriterTableTableFilterComposer
    extends Composer<_$AppDatabase, $JournalWriterTableTable> {
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

  ColumnFilters<int> get currentWriter => $composableBuilder(
      column: $table.currentWriter, builder: (column) => ColumnFilters(column));

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
    extends Composer<_$AppDatabase, $JournalWriterTableTable> {
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

  ColumnOrderings<int> get currentWriter => $composableBuilder(
      column: $table.currentWriter,
      builder: (column) => ColumnOrderings(column));

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
    extends Composer<_$AppDatabase, $JournalWriterTableTable> {
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

  GeneratedColumn<int> get currentWriter => $composableBuilder(
      column: $table.currentWriter, builder: (column) => column);

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
    _$AppDatabase,
    $JournalWriterTableTable,
    JournalWriter,
    $$JournalWriterTableTableFilterComposer,
    $$JournalWriterTableTableOrderingComposer,
    $$JournalWriterTableTableAnnotationComposer,
    $$JournalWriterTableTableCreateCompanionBuilder,
    $$JournalWriterTableTableUpdateCompanionBuilder,
    (
      JournalWriter,
      BaseReferences<_$AppDatabase, $JournalWriterTableTable, JournalWriter>
    ),
    JournalWriter,
    PrefetchHooks Function()> {
  $$JournalWriterTableTableTableManager(
      _$AppDatabase db, $JournalWriterTableTable table)
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
            Value<int> currentWriter = const Value.absent(),
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
            currentWriter: currentWriter,
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
            required int currentWriter,
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
            currentWriter: currentWriter,
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
    _$AppDatabase,
    $JournalWriterTableTable,
    JournalWriter,
    $$JournalWriterTableTableFilterComposer,
    $$JournalWriterTableTableOrderingComposer,
    $$JournalWriterTableTableAnnotationComposer,
    $$JournalWriterTableTableCreateCompanionBuilder,
    $$JournalWriterTableTableUpdateCompanionBuilder,
    (
      JournalWriter,
      BaseReferences<_$AppDatabase, $JournalWriterTableTable, JournalWriter>
    ),
    JournalWriter,
    PrefetchHooks Function()>;
typedef $$LocationRecordTableTableCreateCompanionBuilder
    = LocationRecordTableCompanion Function({
  Value<int> id,
  required double latitude,
  required double longitude,
  Value<String?> locationName,
  Value<double?> accuracy,
  Value<double?> altitude,
  Value<double?> distanceFromPrevious,
  required int recordedAt,
  required int userId,
  required int createdAt,
});
typedef $$LocationRecordTableTableUpdateCompanionBuilder
    = LocationRecordTableCompanion Function({
  Value<int> id,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> locationName,
  Value<double?> accuracy,
  Value<double?> altitude,
  Value<double?> distanceFromPrevious,
  Value<int> recordedAt,
  Value<int> userId,
  Value<int> createdAt,
});

class $$LocationRecordTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocationRecordTableTable> {
  $$LocationRecordTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get altitude => $composableBuilder(
      column: $table.altitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceFromPrevious => $composableBuilder(
      column: $table.distanceFromPrevious,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$LocationRecordTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationRecordTableTable> {
  $$LocationRecordTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get altitude => $composableBuilder(
      column: $table.altitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceFromPrevious => $composableBuilder(
      column: $table.distanceFromPrevious,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$LocationRecordTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationRecordTableTable> {
  $$LocationRecordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get distanceFromPrevious => $composableBuilder(
      column: $table.distanceFromPrevious, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocationRecordTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocationRecordTableTable,
    LocationRecordTableData,
    $$LocationRecordTableTableFilterComposer,
    $$LocationRecordTableTableOrderingComposer,
    $$LocationRecordTableTableAnnotationComposer,
    $$LocationRecordTableTableCreateCompanionBuilder,
    $$LocationRecordTableTableUpdateCompanionBuilder,
    (
      LocationRecordTableData,
      BaseReferences<_$AppDatabase, $LocationRecordTableTable,
          LocationRecordTableData>
    ),
    LocationRecordTableData,
    PrefetchHooks Function()> {
  $$LocationRecordTableTableTableManager(
      _$AppDatabase db, $LocationRecordTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationRecordTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationRecordTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationRecordTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<double?> altitude = const Value.absent(),
            Value<double?> distanceFromPrevious = const Value.absent(),
            Value<int> recordedAt = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              LocationRecordTableCompanion(
            id: id,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            accuracy: accuracy,
            altitude: altitude,
            distanceFromPrevious: distanceFromPrevious,
            recordedAt: recordedAt,
            userId: userId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double latitude,
            required double longitude,
            Value<String?> locationName = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<double?> altitude = const Value.absent(),
            Value<double?> distanceFromPrevious = const Value.absent(),
            required int recordedAt,
            required int userId,
            required int createdAt,
          }) =>
              LocationRecordTableCompanion.insert(
            id: id,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            accuracy: accuracy,
            altitude: altitude,
            distanceFromPrevious: distanceFromPrevious,
            recordedAt: recordedAt,
            userId: userId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocationRecordTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocationRecordTableTable,
    LocationRecordTableData,
    $$LocationRecordTableTableFilterComposer,
    $$LocationRecordTableTableOrderingComposer,
    $$LocationRecordTableTableAnnotationComposer,
    $$LocationRecordTableTableCreateCompanionBuilder,
    $$LocationRecordTableTableUpdateCompanionBuilder,
    (
      LocationRecordTableData,
      BaseReferences<_$AppDatabase, $LocationRecordTableTable,
          LocationRecordTableData>
    ),
    LocationRecordTableData,
    PrefetchHooks Function()>;
typedef $$AppGlobalInfoTableTableCreateCompanionBuilder
    = AppGlobalInfoTableCompanion Function({
  Value<int> id,
  required String appVersion,
  required int dbVersion,
  Value<bool> isFirstLaunch,
  Value<bool> isDefaultDataInitialized,
  Value<DateTime?> lastLaunchTime,
  Value<int> launchCount,
  Value<String?> privacyPolicyVersion,
  Value<bool> isPrivacyPolicyAccepted,
  Value<String> appLanguage,
  Value<String> themeMode,
  Value<String?> extendedConfig,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$AppGlobalInfoTableTableUpdateCompanionBuilder
    = AppGlobalInfoTableCompanion Function({
  Value<int> id,
  Value<String> appVersion,
  Value<int> dbVersion,
  Value<bool> isFirstLaunch,
  Value<bool> isDefaultDataInitialized,
  Value<DateTime?> lastLaunchTime,
  Value<int> launchCount,
  Value<String?> privacyPolicyVersion,
  Value<bool> isPrivacyPolicyAccepted,
  Value<String> appLanguage,
  Value<String> themeMode,
  Value<String?> extendedConfig,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$AppGlobalInfoTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppGlobalInfoTableTable> {
  $$AppGlobalInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dbVersion => $composableBuilder(
      column: $table.dbVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFirstLaunch => $composableBuilder(
      column: $table.isFirstLaunch, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefaultDataInitialized => $composableBuilder(
      column: $table.isDefaultDataInitialized,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLaunchTime => $composableBuilder(
      column: $table.lastLaunchTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get launchCount => $composableBuilder(
      column: $table.launchCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get privacyPolicyVersion => $composableBuilder(
      column: $table.privacyPolicyVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrivacyPolicyAccepted => $composableBuilder(
      column: $table.isPrivacyPolicyAccepted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appLanguage => $composableBuilder(
      column: $table.appLanguage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extendedConfig => $composableBuilder(
      column: $table.extendedConfig,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppGlobalInfoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppGlobalInfoTableTable> {
  $$AppGlobalInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dbVersion => $composableBuilder(
      column: $table.dbVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFirstLaunch => $composableBuilder(
      column: $table.isFirstLaunch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefaultDataInitialized => $composableBuilder(
      column: $table.isDefaultDataInitialized,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLaunchTime => $composableBuilder(
      column: $table.lastLaunchTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get launchCount => $composableBuilder(
      column: $table.launchCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get privacyPolicyVersion => $composableBuilder(
      column: $table.privacyPolicyVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrivacyPolicyAccepted => $composableBuilder(
      column: $table.isPrivacyPolicyAccepted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appLanguage => $composableBuilder(
      column: $table.appLanguage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extendedConfig => $composableBuilder(
      column: $table.extendedConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppGlobalInfoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppGlobalInfoTableTable> {
  $$AppGlobalInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => column);

  GeneratedColumn<int> get dbVersion =>
      $composableBuilder(column: $table.dbVersion, builder: (column) => column);

  GeneratedColumn<bool> get isFirstLaunch => $composableBuilder(
      column: $table.isFirstLaunch, builder: (column) => column);

  GeneratedColumn<bool> get isDefaultDataInitialized => $composableBuilder(
      column: $table.isDefaultDataInitialized, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLaunchTime => $composableBuilder(
      column: $table.lastLaunchTime, builder: (column) => column);

  GeneratedColumn<int> get launchCount => $composableBuilder(
      column: $table.launchCount, builder: (column) => column);

  GeneratedColumn<String> get privacyPolicyVersion => $composableBuilder(
      column: $table.privacyPolicyVersion, builder: (column) => column);

  GeneratedColumn<bool> get isPrivacyPolicyAccepted => $composableBuilder(
      column: $table.isPrivacyPolicyAccepted, builder: (column) => column);

  GeneratedColumn<String> get appLanguage => $composableBuilder(
      column: $table.appLanguage, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get extendedConfig => $composableBuilder(
      column: $table.extendedConfig, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppGlobalInfoTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppGlobalInfoTableTable,
    AppGlobalInfo,
    $$AppGlobalInfoTableTableFilterComposer,
    $$AppGlobalInfoTableTableOrderingComposer,
    $$AppGlobalInfoTableTableAnnotationComposer,
    $$AppGlobalInfoTableTableCreateCompanionBuilder,
    $$AppGlobalInfoTableTableUpdateCompanionBuilder,
    (
      AppGlobalInfo,
      BaseReferences<_$AppDatabase, $AppGlobalInfoTableTable, AppGlobalInfo>
    ),
    AppGlobalInfo,
    PrefetchHooks Function()> {
  $$AppGlobalInfoTableTableTableManager(
      _$AppDatabase db, $AppGlobalInfoTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppGlobalInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppGlobalInfoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppGlobalInfoTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> appVersion = const Value.absent(),
            Value<int> dbVersion = const Value.absent(),
            Value<bool> isFirstLaunch = const Value.absent(),
            Value<bool> isDefaultDataInitialized = const Value.absent(),
            Value<DateTime?> lastLaunchTime = const Value.absent(),
            Value<int> launchCount = const Value.absent(),
            Value<String?> privacyPolicyVersion = const Value.absent(),
            Value<bool> isPrivacyPolicyAccepted = const Value.absent(),
            Value<String> appLanguage = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String?> extendedConfig = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AppGlobalInfoTableCompanion(
            id: id,
            appVersion: appVersion,
            dbVersion: dbVersion,
            isFirstLaunch: isFirstLaunch,
            isDefaultDataInitialized: isDefaultDataInitialized,
            lastLaunchTime: lastLaunchTime,
            launchCount: launchCount,
            privacyPolicyVersion: privacyPolicyVersion,
            isPrivacyPolicyAccepted: isPrivacyPolicyAccepted,
            appLanguage: appLanguage,
            themeMode: themeMode,
            extendedConfig: extendedConfig,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String appVersion,
            required int dbVersion,
            Value<bool> isFirstLaunch = const Value.absent(),
            Value<bool> isDefaultDataInitialized = const Value.absent(),
            Value<DateTime?> lastLaunchTime = const Value.absent(),
            Value<int> launchCount = const Value.absent(),
            Value<String?> privacyPolicyVersion = const Value.absent(),
            Value<bool> isPrivacyPolicyAccepted = const Value.absent(),
            Value<String> appLanguage = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String?> extendedConfig = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              AppGlobalInfoTableCompanion.insert(
            id: id,
            appVersion: appVersion,
            dbVersion: dbVersion,
            isFirstLaunch: isFirstLaunch,
            isDefaultDataInitialized: isDefaultDataInitialized,
            lastLaunchTime: lastLaunchTime,
            launchCount: launchCount,
            privacyPolicyVersion: privacyPolicyVersion,
            isPrivacyPolicyAccepted: isPrivacyPolicyAccepted,
            appLanguage: appLanguage,
            themeMode: themeMode,
            extendedConfig: extendedConfig,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppGlobalInfoTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppGlobalInfoTableTable,
    AppGlobalInfo,
    $$AppGlobalInfoTableTableFilterComposer,
    $$AppGlobalInfoTableTableOrderingComposer,
    $$AppGlobalInfoTableTableAnnotationComposer,
    $$AppGlobalInfoTableTableCreateCompanionBuilder,
    $$AppGlobalInfoTableTableUpdateCompanionBuilder,
    (
      AppGlobalInfo,
      BaseReferences<_$AppDatabase, $AppGlobalInfoTableTable, AppGlobalInfo>
    ),
    AppGlobalInfo,
    PrefetchHooks Function()>;
typedef $$TodoRecordTableTableCreateCompanionBuilder = TodoRecordTableCompanion
    Function({
  Value<int> id,
  Value<int?> weeklyJournalId,
  required int writerId,
  Value<int?> weekNumber,
  Value<int?> year,
  required String content,
  Value<bool> isCompleted,
  Value<int> status,
  Value<int> priority,
  Value<int> sortOrder,
  Value<DateTime?> reminderTime,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$TodoRecordTableTableUpdateCompanionBuilder = TodoRecordTableCompanion
    Function({
  Value<int> id,
  Value<int?> weeklyJournalId,
  Value<int> writerId,
  Value<int?> weekNumber,
  Value<int?> year,
  Value<String> content,
  Value<bool> isCompleted,
  Value<int> status,
  Value<int> priority,
  Value<int> sortOrder,
  Value<DateTime?> reminderTime,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$TodoRecordTableTableFilterComposer
    extends Composer<_$AppDatabase, $TodoRecordTableTable> {
  $$TodoRecordTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyJournalId => $composableBuilder(
      column: $table.weeklyJournalId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get writerId => $composableBuilder(
      column: $table.writerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TodoRecordTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoRecordTableTable> {
  $$TodoRecordTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyJournalId => $composableBuilder(
      column: $table.weeklyJournalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get writerId => $composableBuilder(
      column: $table.writerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TodoRecordTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoRecordTableTable> {
  $$TodoRecordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weeklyJournalId => $composableBuilder(
      column: $table.weeklyJournalId, builder: (column) => column);

  GeneratedColumn<int> get writerId =>
      $composableBuilder(column: $table.writerId, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TodoRecordTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoRecordTableTable,
    TodoRecord,
    $$TodoRecordTableTableFilterComposer,
    $$TodoRecordTableTableOrderingComposer,
    $$TodoRecordTableTableAnnotationComposer,
    $$TodoRecordTableTableCreateCompanionBuilder,
    $$TodoRecordTableTableUpdateCompanionBuilder,
    (
      TodoRecord,
      BaseReferences<_$AppDatabase, $TodoRecordTableTable, TodoRecord>
    ),
    TodoRecord,
    PrefetchHooks Function()> {
  $$TodoRecordTableTableTableManager(
      _$AppDatabase db, $TodoRecordTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoRecordTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoRecordTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoRecordTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> weeklyJournalId = const Value.absent(),
            Value<int> writerId = const Value.absent(),
            Value<int?> weekNumber = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              TodoRecordTableCompanion(
            id: id,
            weeklyJournalId: weeklyJournalId,
            writerId: writerId,
            weekNumber: weekNumber,
            year: year,
            content: content,
            isCompleted: isCompleted,
            status: status,
            priority: priority,
            sortOrder: sortOrder,
            reminderTime: reminderTime,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> weeklyJournalId = const Value.absent(),
            required int writerId,
            Value<int?> weekNumber = const Value.absent(),
            Value<int?> year = const Value.absent(),
            required String content,
            Value<bool> isCompleted = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              TodoRecordTableCompanion.insert(
            id: id,
            weeklyJournalId: weeklyJournalId,
            writerId: writerId,
            weekNumber: weekNumber,
            year: year,
            content: content,
            isCompleted: isCompleted,
            status: status,
            priority: priority,
            sortOrder: sortOrder,
            reminderTime: reminderTime,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoRecordTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoRecordTableTable,
    TodoRecord,
    $$TodoRecordTableTableFilterComposer,
    $$TodoRecordTableTableOrderingComposer,
    $$TodoRecordTableTableAnnotationComposer,
    $$TodoRecordTableTableCreateCompanionBuilder,
    $$TodoRecordTableTableUpdateCompanionBuilder,
    (
      TodoRecord,
      BaseReferences<_$AppDatabase, $TodoRecordTableTable, TodoRecord>
    ),
    TodoRecord,
    PrefetchHooks Function()>;
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
    extends Composer<_$AppDatabase, $WeeklyJournalTableTable> {
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
    extends Composer<_$AppDatabase, $WeeklyJournalTableTable> {
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
    extends Composer<_$AppDatabase, $WeeklyJournalTableTable> {
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
    _$AppDatabase,
    $WeeklyJournalTableTable,
    WeeklyJournal,
    $$WeeklyJournalTableTableFilterComposer,
    $$WeeklyJournalTableTableOrderingComposer,
    $$WeeklyJournalTableTableAnnotationComposer,
    $$WeeklyJournalTableTableCreateCompanionBuilder,
    $$WeeklyJournalTableTableUpdateCompanionBuilder,
    (
      WeeklyJournal,
      BaseReferences<_$AppDatabase, $WeeklyJournalTableTable, WeeklyJournal>
    ),
    WeeklyJournal,
    PrefetchHooks Function()> {
  $$WeeklyJournalTableTableTableManager(
      _$AppDatabase db, $WeeklyJournalTableTable table)
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
    _$AppDatabase,
    $WeeklyJournalTableTable,
    WeeklyJournal,
    $$WeeklyJournalTableTableFilterComposer,
    $$WeeklyJournalTableTableOrderingComposer,
    $$WeeklyJournalTableTableAnnotationComposer,
    $$WeeklyJournalTableTableCreateCompanionBuilder,
    $$WeeklyJournalTableTableUpdateCompanionBuilder,
    (
      WeeklyJournal,
      BaseReferences<_$AppDatabase, $WeeklyJournalTableTable, WeeklyJournal>
    ),
    WeeklyJournal,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JournalWriterTableTableTableManager get journalWriterTable =>
      $$JournalWriterTableTableTableManager(_db, _db.journalWriterTable);
  $$LocationRecordTableTableTableManager get locationRecordTable =>
      $$LocationRecordTableTableTableManager(_db, _db.locationRecordTable);
  $$AppGlobalInfoTableTableTableManager get appGlobalInfoTable =>
      $$AppGlobalInfoTableTableTableManager(_db, _db.appGlobalInfoTable);
  $$TodoRecordTableTableTableManager get todoRecordTable =>
      $$TodoRecordTableTableTableManager(_db, _db.todoRecordTable);
  $$WeeklyJournalTableTableTableManager get weeklyJournalTable =>
      $$WeeklyJournalTableTableTableManager(_db, _db.weeklyJournalTable);
}
