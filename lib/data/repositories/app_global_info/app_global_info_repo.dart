// 导入必要的包
import 'package:drift/drift.dart';  // Drift 数据库核心包
import 'package:WeekLife/data/database/tables/app_global_info_tbl.dart';
import 'package:WeekLife/data/models/app_global_info/app_global_info_data.dart';
import 'package:WeekLife/data/repositories/app_global_info/interfaces/app_global_info_repo_interface.dart';

// 声明这是一个生成代码的部分
// 这行代码告诉 Dart 编译器，app_global_info_repo.g.dart 是当前文件的一部分
part 'app_global_info_repo.g.dart';

/// @DriftDatabase 注解说明：
/// 1. 声明这是一个 Drift 数据库类
/// 2. tables: [AppGlobalInfoTable] 指定数据库包含哪些表
/// 3. 自动生成：
///    - 数据库连接代码
///    - 表的 CRUD 操作
///    - 类型安全的查询方法
///    - 数据库迁移代码
/// 具体功能：
/// 自动创建数据库文件
/// 管理数据库连接
/// 提供类型安全的 API 来操作 AppGlobalInfo 表
/// 处理数据库版本和迁移
/// 生成必要的辅助代码（在 app_global_info_repo.g.dart 中）
@DriftDatabase(tables: [AppGlobalInfoTable])
class AppGlobalInfoRepo extends _$AppGlobalInfoRepo implements IAppGlobalInfoRepository {
  AppGlobalInfoRepo(super.db);

  /// 数据库版本号
  /// 每次修改数据库结构时，需要增加版本号
  /// 例如：添加新表、修改表结构等
  @override  // @override 表示重写父类的方法
  int get schemaVersion => 2;  // 当前数据库版本为 2，与其他数据库保持一致

  /// 数据库迁移策略
  /// 用于处理数据库版本升级时的数据迁移
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // 数据库创建时的回调
      onCreate: (Migrator m) async {
        // 创建所有表
        await m.createAll();
      },
      // 数据库升级时的回调
      onUpgrade: (Migrator m, int from, int to) async {
        // from: 当前版本
        // to: 目标版本
        // 在这里处理数据库升级逻辑
        if (from < 2) {
          // 版本 1 到 2：确保表结构是最新的
          // AppGlobalInfo表结构没有变化，但需要保持版本一致性
        }
      },
    );
  }

  /// 创建 App Global Info
  @override
  Future<AppGlobalInfoData> createAppGlobalInfo(AppGlobalInfoData info) async {
    final id = await into(appGlobalInfoTable).insert(info.toCompanion());
    return info.copyWith(id: id);
  }

  /// 批量创建 App Global Info
  @override
  Future<List<AppGlobalInfoData>> createAppGlobalInfos(List<AppGlobalInfoData> infos) async {
    return transaction(() async {
      final results = <AppGlobalInfoData>[];
      for (final info in infos) {
        final id = await into(appGlobalInfoTable).insert(info.toCompanion());
        results.add(info.copyWith(id: id));
      }
      return results;
    });
  }

  /// 查询 App Global Info
  @override
  Future<List<AppGlobalInfoData>> queryAppGlobalInfos(AppGlobalInfoQuery query) async {
    var selectQuery = select(appGlobalInfoTable);

    // 应用过滤条件
    selectQuery.where((t) => query.toWhereClause(t));

    // 应用排序
    if (query.orderBy != null) {
      Expression<Object> Function(AppGlobalInfoTable) getOrderColumn() {
        switch (query.orderBy!) {
          case 'id':
            return (t) => t.id;
          case 'appVersion':
            return (t) => t.appVersion;
          case 'dbVersion':
            return (t) => t.dbVersion;
          case 'launchCount':
            return (t) => t.launchCount;
          case 'lastLaunchTime':
            return (t) => t.lastLaunchTime;
          case 'createdAt':
            return (t) => t.createdAt;
          case 'updatedAt':
            return (t) => t.updatedAt;
          default:
            return (t) => t.createdAt;  // 默认按创建时间排序
        }
      }

      final orderColumn = getOrderColumn();
      final orderMode = query.orderDesc == true
          ? OrderingMode.desc
          : OrderingMode.asc;
      selectQuery = selectQuery
        ..orderBy([
          (t) => orderMode == OrderingMode.desc 
            ? OrderingTerm.desc(orderColumn(t))
            : OrderingTerm.asc(orderColumn(t))
        ]);
    }

    // 应用分页
    if (query.limit != null && query.offset != null) {
      final offset = (query.limit! - 1) * query.offset!;
      selectQuery = selectQuery
        ..limit(query.limit!, offset: offset);
    }

    final infos = await selectQuery.get();
    return infos.map(AppGlobalInfoData.fromDb).toList();
  }

  /// 更新 App Global Info
  @override
  Future<int> updateAppGlobalInfo(int id, AppGlobalInfoData info) async {
    return (update(appGlobalInfoTable)
          ..where((t) => t.id.equals(id)))
        .write(info.toCompanion());
  }

  /// 删除 App Global Info
  @override
  Future<int> deleteAppGlobalInfo(int id) async {
    return (delete(appGlobalInfoTable)..where((t) => t.id.equals(id))).go();
  }

  /// 获取 App Global Info 数量
  @override
  Future<int> getAppGlobalInfoCount() async {
    final query = selectOnly(appGlobalInfoTable)
      ..addColumns([appGlobalInfoTable.id.count()]);
    final result = await query.getSingle();
    return result.read(appGlobalInfoTable.id.count()) ?? 0;
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action, {bool requireNew = false}) async {
    return await super.transaction(action, requireNew: requireNew);
  }
} 