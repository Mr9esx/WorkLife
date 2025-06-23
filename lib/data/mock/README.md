# Mock 数据生成器

这个目录包含了用于生成应用默认数据的工具，主要用于调试模式下避免模拟器重启导致数据丢失的问题。

## 文件说明

### 1. `journal_writer_mock_generator.dart`
Journal Writer 的mock数据生成器，提供以下功能：
- 生成默认用户数据
- 生成多个测试用户数据
- 生成自定义用户数据
- 数据验证功能
- 性别显示文本转换

### 2. `app_global_info_mock_generator.dart`
App Global Info 的mock数据生成器，提供以下功能：
- 生成默认应用全局信息
- 生成已使用过的应用信息
- 生成自定义应用配置
- 多种测试场景数据
- 主题和语言显示文本转换

### 3. `app_initialization_helper.dart`
应用初始化助手，提供完整的应用初始化流程：
- 检查和初始化应用全局信息
- 检查和初始化默认用户数据
- 管理应用启动状态
- 提供调试模式下的数据管理功能

### 4. `journal_writer_mock_usage_example.dart`
Journal Writer 使用示例文件，展示如何在实际项目中使用mock数据生成器：
- 应用启动时初始化默认用户
- 批量创建测试用户
- 创建自定义用户
- 清理测试数据
- 显示所有用户信息

### 5. `j.txt`
原有的数据格式参考文件

## 使用方法

### 基本使用

```dart
import 'package:WeekLife/data/mock/journal_writer_mock_generator.dart';

// 生成默认用户数据
final defaultWriter = JournalWriterMockGenerator.generateDefaultWriter();

// 生成多个测试用户
final testWriters = JournalWriterMockGenerator.generateMultipleWriters(count: 5);

// 生成自定义用户
final customWriter = JournalWriterMockGenerator.generateCustomWriter(
  username: '张三',
  gender: 1,
  birthYear: 1990,
  birthMonth: 5,
  birthDay: 15,
  birthPlace: '北京',
);
```

### 在应用启动时初始化默认数据

推荐使用 `AppInitializationHelper` 进行完整的应用初始化：

```dart
import 'package:WeekLife/data/mock/app_initialization_helper.dart';

// 在应用启动时调用
void initializeApp() async {
  final journalWriterDao = JournalWriterDao(database);
  final appGlobalInfoDao = AppGlobalInfoDao(database);
  
  // 完整的应用初始化流程
  await AppInitializationHelper.initializeApp(
    journalWriterDao: journalWriterDao,
    appGlobalInfoDao: appGlobalInfoDao,
    appVersion: '1.0.0',
    dbVersion: 1,
  );
}
```

或者单独初始化用户数据：

```dart
import 'package:WeekLife/data/mock/journal_writer_mock_usage_example.dart';

// 仅初始化用户数据
void initializeUserData() async {
  final dao = JournalWriterDao(database);
  
  // 检查并创建默认用户（如果不存在）
  await JournalWriterMockUsageExample.initializeDefaultUserIfNeeded(dao);
}
```

### 开发环境下创建测试数据

```dart
// 创建多个测试用户
await JournalWriterMockUsageExample.createTestUsers(dao, count: 3);

// 创建自定义用户
await JournalWriterMockUsageExample.createCustomUserExample(dao);

// 查看所有用户
await JournalWriterMockUsageExample.displayAllUsers(dao);
```

### 清理测试数据

```dart
// 清理所有测试数据
await JournalWriterMockUsageExample.cleanupTestData(dao);
```

## 数据结构说明

### JournalWriterData 字段

| 字段名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | int? | 否 | 用户ID（数据库自动生成） |
| username | String | 是 | 用户名（唯一） |
| currentWriter | int | 是 | 当前用户标识（唯一） |
| gender | int | 是 | 性别（1:男，2:女） |
| birthDay | DateTime | 是 | 生日 |
| avatar | String? | 否 | 头像 |
| birthPlace | String? | 否 | 出生地 |
| createdAt | DateTime | 是 | 创建时间 |
| updatedAt | DateTime? | 否 | 更新时间 |

### AppGlobalInfoData 字段

| 字段名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | int? | 否 | 记录ID（数据库自动生成） |
| appVersion | String | 是 | 应用版本号 |
| dbVersion | int | 是 | 数据库版本号 |
| isFirstLaunch | bool | 是 | 是否首次启动 |
| isDefaultDataInitialized | bool | 是 | 是否已初始化默认数据 |
| lastLaunchTime | DateTime? | 否 | 最后启动时间 |
| launchCount | int | 是 | 启动次数 |
| privacyPolicyVersion | String? | 否 | 用户协议版本 |
| isPrivacyPolicyAccepted | bool | 是 | 是否同意用户协议 |
| appLanguage | String | 是 | 应用语言设置 |
| themeMode | String | 是 | 主题设置 |
| extendedConfig | String? | 否 | 扩展配置（JSON格式） |
| createdAt | DateTime | 是 | 创建时间 |
| updatedAt | DateTime? | 否 | 更新时间 |

## 默认数据说明

### 默认用户数据
- 用户名：默认用户
- 性别：男（1）
- 生日：1990年1月1日
- 出生地：北京
- 当前用户标识：1

### 测试用户数据
包含5个预设的测试用户：
1. 张三（男，1985-03-15，上海）
2. 李四（女，1992-07-22，广州）
3. 王五（男，1988-11-08，深圳）
4. 赵六（女，1995-05-12，杭州）
5. 钱七（男，1987-09-30，南京）

## 注意事项

1. **调试模式专用**：这些工具主要用于调试和开发环境，不建议在生产环境中使用。

2. **数据唯一性**：`username` 和 `currentWriter` 字段具有唯一约束，重复创建会失败。

3. **数据验证**：所有生成的数据都会经过验证，确保符合业务规则。

4. **错误处理**：使用示例中包含了完整的错误处理逻辑，可以安全地在生产代码中使用。

5. **性能考虑**：批量操作时建议使用事务来提高性能和数据一致性。

## 集成建议

### 在 main.dart 中集成

推荐的完整集成方式：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库
  final database = AppDatabase();
  final journalWriterDao = JournalWriterDao(database);
  final appGlobalInfoDao = AppGlobalInfoDao(database);
  
  // 仅在调试模式下初始化默认数据
  if (kDebugMode) {
    await AppInitializationHelper.initializeApp(
      journalWriterDao: journalWriterDao,
      appGlobalInfoDao: appGlobalInfoDao,
      appVersion: '1.0.0', // 从 package_info_plus 获取
      dbVersion: 1,
    );
  }
  
  runApp(MyApp());
}
```

简化版本（仅初始化用户数据）：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库
  final database = AppDatabase();
  final dao = JournalWriterDao(database);
  
  // 仅在调试模式下初始化默认数据
  if (kDebugMode) {
    await JournalWriterMockUsageExample.initializeDefaultUserIfNeeded(dao);
  }
  
  runApp(MyApp());
}
```

### 在设置页面中添加开发者选项

```dart
// 仅在调试模式下显示
if (kDebugMode) {
  ListTile(
    title: Text('创建测试用户'),
    onTap: () async {
      await JournalWriterMockUsageExample.createTestUsers(dao);
    },
  ),
  ListTile(
    title: Text('清理测试数据'),
    onTap: () async {
      await JournalWriterMockUsageExample.cleanupTestData(dao);
    },
  ),
}
```

这样就可以在调试模式下方便地管理测试数据，避免模拟器重启导致的数据丢失问题。 