// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_global_info_repo.dart';

// ignore_for_file: type=lint
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

abstract class _$AppGlobalInfoRepo extends GeneratedDatabase {
  _$AppGlobalInfoRepo(QueryExecutor e) : super(e);
  $AppGlobalInfoRepoManager get managers => $AppGlobalInfoRepoManager(this);
  late final $AppGlobalInfoTableTable appGlobalInfoTable =
      $AppGlobalInfoTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appGlobalInfoTable];
}

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
    extends Composer<_$AppGlobalInfoRepo, $AppGlobalInfoTableTable> {
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
    extends Composer<_$AppGlobalInfoRepo, $AppGlobalInfoTableTable> {
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
    extends Composer<_$AppGlobalInfoRepo, $AppGlobalInfoTableTable> {
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
    _$AppGlobalInfoRepo,
    $AppGlobalInfoTableTable,
    AppGlobalInfo,
    $$AppGlobalInfoTableTableFilterComposer,
    $$AppGlobalInfoTableTableOrderingComposer,
    $$AppGlobalInfoTableTableAnnotationComposer,
    $$AppGlobalInfoTableTableCreateCompanionBuilder,
    $$AppGlobalInfoTableTableUpdateCompanionBuilder,
    (
      AppGlobalInfo,
      BaseReferences<_$AppGlobalInfoRepo, $AppGlobalInfoTableTable,
          AppGlobalInfo>
    ),
    AppGlobalInfo,
    PrefetchHooks Function()> {
  $$AppGlobalInfoTableTableTableManager(
      _$AppGlobalInfoRepo db, $AppGlobalInfoTableTable table)
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
    _$AppGlobalInfoRepo,
    $AppGlobalInfoTableTable,
    AppGlobalInfo,
    $$AppGlobalInfoTableTableFilterComposer,
    $$AppGlobalInfoTableTableOrderingComposer,
    $$AppGlobalInfoTableTableAnnotationComposer,
    $$AppGlobalInfoTableTableCreateCompanionBuilder,
    $$AppGlobalInfoTableTableUpdateCompanionBuilder,
    (
      AppGlobalInfo,
      BaseReferences<_$AppGlobalInfoRepo, $AppGlobalInfoTableTable,
          AppGlobalInfo>
    ),
    AppGlobalInfo,
    PrefetchHooks Function()>;

class $AppGlobalInfoRepoManager {
  final _$AppGlobalInfoRepo _db;
  $AppGlobalInfoRepoManager(this._db);
  $$AppGlobalInfoTableTableTableManager get appGlobalInfoTable =>
      $$AppGlobalInfoTableTableTableManager(_db, _db.appGlobalInfoTable);
}
