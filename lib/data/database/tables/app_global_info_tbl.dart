// 导入 Drift 包，提供数据库表定义的功能
import 'package:drift/drift.dart';

/// @DataClassName 注解
/// 指定生成的数据类名称
/// 这里会生成一个名为 "AppGlobalInfo" 的数据类
@DataClassName("AppGlobalInfo")
class AppGlobalInfoTable extends Table {
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 应用版本号
  TextColumn get appVersion => text()();

  // 数据库版本号
  IntColumn get dbVersion => integer()();

  // 是否首次启动
  BoolColumn get isFirstLaunch => boolean().withDefault(const Constant(true))();

  // 是否已初始化默认数据
  BoolColumn get isDefaultDataInitialized => boolean().withDefault(const Constant(false))();

  // 最后启动时间
  DateTimeColumn get lastLaunchTime => dateTime().nullable()();

  // 启动次数
  IntColumn get launchCount => integer().withDefault(const Constant(0))();

  // 用户协议版本
  TextColumn get privacyPolicyVersion => text().nullable()();

  // 是否同意用户协议
  BoolColumn get isPrivacyPolicyAccepted => boolean().withDefault(const Constant(false))();

  // 应用语言设置
  TextColumn get appLanguage => text().withDefault(const Constant('zh_CN'))();

  // 主题设置（light/dark/system）
  TextColumn get themeMode => text().withDefault(const Constant('system'))();

  // 扩展配置（JSON格式存储其他配置）
  TextColumn get extendedConfig => text().nullable()();

  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();
} 