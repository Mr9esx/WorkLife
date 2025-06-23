// 导入必要的包
import 'package:drift/drift.dart' hide JsonKey;  // 导入 Drift 包，hide 表示隐藏 JsonKey 以避免命名冲突
import 'package:WeekLife/data/database/tables/app_global_info_tbl.dart';  // 导入表定义
import 'package:WeekLife/data/repositories/app_global_info/app_global_info_repo.dart';  // 导入生成的类

/// App Global Info 数据模型
/// 用于存储应用的全局配置和状态信息
class AppGlobalInfoData {
  // final 表示这些字段是只读的，一旦赋值就不能修改
  // 类型声明（如 int?, String）是 Dart 的类型系统的一部分，用于类型安全
  // ? 表示该字段可以为 null（空安全特性）
  final int? id;                    // 可空的整数类型（自增主键）
  final String appVersion;          // 应用版本号（必填）
  final int dbVersion;              // 数据库版本号（必填）
  final bool isFirstLaunch;         // 是否首次启动（必填）
  final bool isDefaultDataInitialized; // 是否已初始化默认数据（必填）
  final DateTime? lastLaunchTime;   // 最后启动时间（可选）
  final int launchCount;            // 启动次数（必填）
  final String? privacyPolicyVersion; // 用户协议版本（可选）
  final bool isPrivacyPolicyAccepted; // 是否同意用户协议（必填）
  final String appLanguage;         // 应用语言设置（必填）
  final String themeMode;           // 主题设置（必填）
  final String? extendedConfig;     // 扩展配置（可选，JSON格式）
  final DateTime createdAt;         // 创建时间（必填）
  final DateTime? updatedAt;        // 更新时间（可选）

  // const 构造函数，表示这是一个编译时常量构造函数
  // required 表示这些参数在创建对象时必须提供
  const AppGlobalInfoData({
    this.id,                        // 可选参数，因为 id 是可空的
    required this.appVersion,       // 必需参数
    required this.dbVersion,        // 必需参数
    required this.isFirstLaunch,    // 必需参数
    required this.isDefaultDataInitialized, // 必需参数
    this.lastLaunchTime,            // 可选参数
    required this.launchCount,      // 必需参数
    this.privacyPolicyVersion,      // 可选参数
    required this.isPrivacyPolicyAccepted, // 必需参数
    required this.appLanguage,      // 必需参数
    required this.themeMode,        // 必需参数
    this.extendedConfig,            // 可选参数
    required this.createdAt,        // 必需参数
    this.updatedAt,                 // 可选参数
  });

  // factory 构造函数，用于从数据库实体创建数据模型
  // 工厂构造函数可以返回类的实例，而不是必须创建新实例
  factory AppGlobalInfoData.fromDb(AppGlobalInfo info) => AppGlobalInfoData(
    // 从数据库实体中提取数据并创建新的 AppGlobalInfoData 实例
    id: info.id,                    // 直接访问数据库实体的字段
    appVersion: info.appVersion,
    dbVersion: info.dbVersion,
    isFirstLaunch: info.isFirstLaunch,
    isDefaultDataInitialized: info.isDefaultDataInitialized,
    lastLaunchTime: info.lastLaunchTime,
    launchCount: info.launchCount,
    privacyPolicyVersion: info.privacyPolicyVersion,
    isPrivacyPolicyAccepted: info.isPrivacyPolicyAccepted,
    appLanguage: info.appLanguage,
    themeMode: info.themeMode,
    extendedConfig: info.extendedConfig,
    createdAt: info.createdAt,
    updatedAt: info.updatedAt,
  );

  // 将数据模型转换为数据库实体
  // 用于将数据保存到数据库
  AppGlobalInfoTableCompanion toCompanion() => AppGlobalInfoTableCompanion(
    // Value 是 Drift 提供的包装类，用于处理可空值
    id: id == null ? const Value.absent() : Value(id!),  // ! 表示非空断言
    appVersion: Value(appVersion),  // 非空值直接包装
    dbVersion: Value(dbVersion),
    isFirstLaunch: Value(isFirstLaunch),
    isDefaultDataInitialized: Value(isDefaultDataInitialized),
    lastLaunchTime: lastLaunchTime == null ? const Value.absent() : Value(lastLaunchTime!),
    launchCount: Value(launchCount),
    privacyPolicyVersion: privacyPolicyVersion == null ? const Value.absent() : Value(privacyPolicyVersion!),
    isPrivacyPolicyAccepted: Value(isPrivacyPolicyAccepted),
    appLanguage: Value(appLanguage),
    themeMode: Value(themeMode),
    extendedConfig: extendedConfig == null ? const Value.absent() : Value(extendedConfig!),
    createdAt: Value(createdAt),
    updatedAt: updatedAt == null ? const Value.absent() : Value(updatedAt!),
  );

  // copyWith 方法用于创建对象的副本，同时允许修改部分字段
  // 这是 Dart 中常用的不可变对象模式
  AppGlobalInfoData copyWith({
    int? id,                        // 所有参数都是可选的
    String? appVersion,
    int? dbVersion,
    bool? isFirstLaunch,
    bool? isDefaultDataInitialized,
    DateTime? lastLaunchTime,
    int? launchCount,
    String? privacyPolicyVersion,
    bool? isPrivacyPolicyAccepted,
    String? appLanguage,
    String? themeMode,
    String? extendedConfig,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppGlobalInfoData(
      id: id ?? this.id,
      appVersion: appVersion ?? this.appVersion,
      dbVersion: dbVersion ?? this.dbVersion,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isDefaultDataInitialized: isDefaultDataInitialized ?? this.isDefaultDataInitialized,
      lastLaunchTime: lastLaunchTime ?? this.lastLaunchTime,
      launchCount: launchCount ?? this.launchCount,
      privacyPolicyVersion: privacyPolicyVersion ?? this.privacyPolicyVersion,
      isPrivacyPolicyAccepted: isPrivacyPolicyAccepted ?? this.isPrivacyPolicyAccepted,
      appLanguage: appLanguage ?? this.appLanguage,
      themeMode: themeMode ?? this.themeMode,
      extendedConfig: extendedConfig ?? this.extendedConfig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // toString 方法用于调试和日志输出
  @override
  String toString() {
    return 'AppGlobalInfoData('
        'id: $id, '
        'appVersion: $appVersion, '
        'dbVersion: $dbVersion, '
        'isFirstLaunch: $isFirstLaunch, '
        'isDefaultDataInitialized: $isDefaultDataInitialized, '
        'lastLaunchTime: $lastLaunchTime, '
        'launchCount: $launchCount, '
        'privacyPolicyVersion: $privacyPolicyVersion, '
        'isPrivacyPolicyAccepted: $isPrivacyPolicyAccepted, '
        'appLanguage: $appLanguage, '
        'themeMode: $themeMode, '
        'extendedConfig: $extendedConfig, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }

  // 相等性比较
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppGlobalInfoData &&
        other.id == id &&
        other.appVersion == appVersion &&
        other.dbVersion == dbVersion &&
        other.isFirstLaunch == isFirstLaunch &&
        other.isDefaultDataInitialized == isDefaultDataInitialized &&
        other.lastLaunchTime == lastLaunchTime &&
        other.launchCount == launchCount &&
        other.privacyPolicyVersion == privacyPolicyVersion &&
        other.isPrivacyPolicyAccepted == isPrivacyPolicyAccepted &&
        other.appLanguage == appLanguage &&
        other.themeMode == themeMode &&
        other.extendedConfig == extendedConfig &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  // 哈希码
  @override
  int get hashCode {
    return Object.hash(
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
      updatedAt,
    );
  }
}

/// App Global Info 查询条件类
/// 用于构建复杂的查询条件
class AppGlobalInfoQuery {
  final int? id;
  final String? appVersion;
  final int? dbVersion;
  final bool? isFirstLaunch;
  final bool? isDefaultDataInitialized;
  final String? appLanguage;
  final String? themeMode;
  final int? limit;
  final int? offset;
  final String? orderBy;
  final bool? orderDesc;

  const AppGlobalInfoQuery({
    this.id,
    this.appVersion,
    this.dbVersion,
    this.isFirstLaunch,
    this.isDefaultDataInitialized,
    this.appLanguage,
    this.themeMode,
    this.limit,
    this.offset,
    this.orderBy,
    this.orderDesc,
  });

  // 将查询条件转换为 WHERE 子句
  Expression<bool> toWhereClause(AppGlobalInfoTable table) {
    Expression<bool>? where;

    if (id != null) {
      final condition = table.id.equals(id!);
      where = where == null ? condition : where & condition;
    }

    if (appVersion != null) {
      final condition = table.appVersion.equals(appVersion!);
      where = where == null ? condition : where & condition;
    }

    if (dbVersion != null) {
      final condition = table.dbVersion.equals(dbVersion!);
      where = where == null ? condition : where & condition;
    }

    if (isFirstLaunch != null) {
      final condition = table.isFirstLaunch.equals(isFirstLaunch!);
      where = where == null ? condition : where & condition;
    }

    if (isDefaultDataInitialized != null) {
      final condition = table.isDefaultDataInitialized.equals(isDefaultDataInitialized!);
      where = where == null ? condition : where & condition;
    }

    if (appLanguage != null) {
      final condition = table.appLanguage.equals(appLanguage!);
      where = where == null ? condition : where & condition;
    }

    if (themeMode != null) {
      final condition = table.themeMode.equals(themeMode!);
      where = where == null ? condition : where & condition;
    }

    // 如果没有任何条件，返回一个总是为真的条件
    return where ?? const Constant(true);
  }
} 