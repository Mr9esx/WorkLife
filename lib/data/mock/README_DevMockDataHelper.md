# DevMockDataHelper - 开发模式测试数据生成助手

## 概述

`DevMockDataHelper` 是专门为开发模式设计的测试数据生成工具，用于快速生成 `AppGlobalInfo` 和 `JournalWriter` 的测试数据。

## 主要功能

### 1. 测试场景支持
- **默认场景** (`defaultScenario`): 新应用，创建默认AppGlobalInfo和一个默认用户
- **已使用场景** (`existingUserScenario`): 模拟已使用过的应用，有历史数据
- **多用户场景** (`multipleUsersScenario`): 创建多个测试用户
- **空场景** (`emptyScenario`): 只创建AppGlobalInfo，不创建用户

### 2. 核心方法

#### main.dart 专用方法（推荐）
```dart
// 专门为 main.dart 设计，自动检查初次启动
await DevMockDataHelper.initializeForMain(
  journalWriterDao: journalWriterDao,
  appGlobalInfoDao: appGlobalInfoDao,
  appVersion: '1.0.0',
  dbVersion: 1,
  scenario: DevMockScenario.defaultScenario, // 可选
);
```

#### 主要生成方法
```dart
// 生成指定场景的测试数据
await DevMockDataHelper.generateDevMockData(
  journalWriterDao: journalWriterDao,
  appGlobalInfoDao: appGlobalInfoDao,
  appVersion: '1.0.0',
  dbVersion: 1,
  scenario: DevMockScenario.defaultScenario,
  forceReset: false,
  checkFirstLaunch: true, // 是否检查初次启动
);
```

#### 便捷方法
```dart
// 快速生成默认测试数据
await DevMockDataHelper.generateDefaultTestData(
  journalWriterDao: journalWriterDao,
  appGlobalInfoDao: appGlobalInfoDao,
  appVersion: '1.0.0',
  dbVersion: 1,
  forceReset: false,
  checkFirstLaunch: true, // 是否检查初次启动
);

// 快速生成多用户测试数据
await DevMockDataHelper.generateMultiUserTestData(
  journalWriterDao: journalWriterDao,
  appGlobalInfoDao: appGlobalInfoDao,
  appVersion: '1.0.0',
  dbVersion: 1,
  forceReset: false,
  checkFirstLaunch: true, // 是否检查初次启动
);
```

#### 工具方法
```dart
// 检查应用状态
final status = await DevMockDataHelper.checkAppStatus(
  appGlobalInfoDao,
  journalWriterDao,
);

// 清理所有测试数据
await DevMockDataHelper.clearAllTestData(
  journalWriterDao: journalWriterDao,
  appGlobalInfoDao: appGlobalInfoDao,
);
```

## 在 main.dart 中的使用

### 推荐使用方式（自动检查初次启动）
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库和DAO
  final database = AppDatabase();
  final journalWriterDao = JournalWriterDao(database.journalWriterRepo);
  final appGlobalInfoDao = AppGlobalInfoDao(database.appGlobalInfoRepo);
  
  // 推荐：使用专门为 main.dart 设计的方法
  // 自动检查初次启动，只在初次启动时生成测试数据
  await DevMockDataHelper.initializeForMain(
    journalWriterDao: journalWriterDao,
    appGlobalInfoDao: appGlobalInfoDao,
    appVersion: '1.0.0',
    dbVersion: 1,
    scenario: DevMockScenario.defaultScenario, // 可选择不同场景
  );
  
  runApp(MyApp());
}
```

### 手动控制调试模式
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库和DAO
  final database = AppDatabase();
  final journalWriterDao = JournalWriterDao(database.journalWriterRepo);
  final appGlobalInfoDao = AppGlobalInfoDao(database.appGlobalInfoRepo);
  
  // 手动检查调试模式
  if (kDebugMode) {
    await DevMockDataHelper.generateDefaultTestData(
      journalWriterDao: journalWriterDao,
      appGlobalInfoDao: appGlobalInfoDao,
      appVersion: '1.0.0',
      dbVersion: 1,
      checkFirstLaunch: true, // 检查初次启动
    );
  }
  
  runApp(MyApp());
}
```

### 高级使用
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库和DAO
  final database = AppDatabase();
  final journalWriterDao = JournalWriterDao(database.journalWriterRepo);
  final appGlobalInfoDao = AppGlobalInfoDao(database.appGlobalInfoRepo);
  
  // 在开发模式下根据场景生成测试数据
  if (kDebugMode) {
    await DevMockDataHelper.generateDevMockData(
      journalWriterDao: journalWriterDao,
      appGlobalInfoDao: appGlobalInfoDao,
      appVersion: '1.0.0',
      dbVersion: 1,
      scenario: DevMockScenario.multipleUsersScenario, // 选择场景
      forceReset: true, // 开发模式下通常需要重置数据
    );
  }
  
  runApp(MyApp());
}
```

## 测试场景详解

### 1. 默认场景 (defaultScenario)
- 创建全新的 AppGlobalInfo（首次启动状态）
- 创建一个默认用户
- 适用于：测试新用户体验

### 2. 已使用场景 (existingUserScenario)
- 创建已使用过的 AppGlobalInfo（非首次启动，有启动历史）
- 创建一个默认用户
- 适用于：测试老用户体验

### 3. 多用户场景 (multipleUsersScenario)
- 创建已使用过的 AppGlobalInfo
- 创建多个测试用户（默认3个）
- 适用于：测试多用户功能

### 4. 空场景 (emptyScenario)
- 只创建 AppGlobalInfo
- 不创建任何用户
- 适用于：测试无用户状态

## 参数说明

### 必需参数
- `journalWriterDao`: JournalWriter 数据访问对象
- `appGlobalInfoDao`: AppGlobalInfo 数据访问对象
- `appVersion`: 应用版本号
- `dbVersion`: 数据库版本号

### 可选参数
- `scenario`: 测试场景（默认为 defaultScenario）
- `forceReset`: 是否强制重置现有数据（默认为 false）
- `checkFirstLaunch`: 是否检查初次启动（默认为 true）
- `enableInDebugMode`: 是否仅在调试模式下启用（默认为 true）

## 注意事项

1. **仅在开发模式使用**: 这个工具专门为开发模式设计，不应在生产环境中使用
2. **初次启动检查**: 默认只在初次启动时生成测试数据，避免重复生成
3. **数据重置**: 使用 `forceReset: true` 会清空所有现有数据
4. **错误处理**: 所有方法都包含完整的错误处理和日志输出
5. **数据验证**: 生成的数据会经过验证确保有效性
6. **main.dart 集成**: 推荐使用 `initializeForMain()` 方法，专门为应用启动设计

## 示例代码

详细的使用示例请参考 `dev_mock_data_usage_example.dart` 文件，其中包含：
- 基本使用示例
- 高级使用示例
- 多场景测试示例
- 数据管理示例
- main.dart 集成示例

## 依赖关系

- `journal_writer_mock_generator.dart`: JournalWriter 数据生成器
- `app_global_info_mock_generator.dart`: AppGlobalInfo 数据生成器
- `journal_writer_dao.dart`: JournalWriter 数据访问对象
- `app_global_info_dao.dart`: AppGlobalInfo 数据访问对象 