# WeekLife 调试模式使用说明

## 问题背景

在使用 `jh_debug` 包进行调试时，由于与 `sqlite3` 包的兼容性问题，可能会出现以下编译错误：

```
Unsupported operation: Unsupported invalid type InvalidType(<invalid>) (InvalidType). 
Encountered while compiling file:///Users/xxx/.pub-cache/hosted/pub.dev/sqlite3-x.x.x/lib/src/ffi/implementation.dart
```

## 解决方案

我们采用了条件编译的方式来解决这个问题。默认情况下，应用会以正常模式启动，不使用 `jh_debug`。

### 正常调试模式（推荐）

```bash
flutter run --debug
```

这种方式可以正常使用 Flutter 的热重载、热重启等调试功能，但不会启用 `jh_debug` 的额外调试面板。

### 启用 jh_debug 调试模式

如果确实需要使用 `jh_debug` 的调试功能，可以通过环境变量启用：

```bash
flutter run --debug --dart-define=ENABLE_JH_DEBUG=true
```

**注意：** 启用此模式可能会遇到 sqlite3 兼容性问题，导致编译失败。

### 生产模式

```bash
flutter run --release
```

生产模式下会自动禁用所有调试功能。

## 调试功能说明

### 内置调试面板

应用仍然保留了原有的调试面板功能，可以通过以下方式访问：

1. **全局调试按钮**: 在调试模式下，屏幕右上角会显示红色的调试按钮
2. **个人页面调试按钮**: 在"我的"页面有专门的调试按钮

### 调试功能包括

- 📊 输出所有调试信息
- 📱 设备信息查看
- 🗄️ 数据库状态检查
- 💾 存储信息查看
- 🔧 权限状态管理
- 📤 调试日志导出

## 开发建议

1. **日常开发**: 使用正常调试模式 `flutter run --debug`
2. **特殊调试**: 需要 jh_debug 功能时才启用环境变量
3. **生产发布**: 使用 `flutter run --release` 或 `flutter build`

## 故障排除

如果遇到编译问题：

1. 确保使用正常调试模式而不是 jh_debug 模式
2. 清理构建缓存：`flutter clean && flutter pub get`
3. 重新生成代码：`flutter packages pub run build_runner build --delete-conflicting-outputs`

## 包版本信息

当前使用的关键包版本：
- `drift: ^2.26.1`
- `sqlite3_flutter_libs: ^0.5.32`
- `jh_debug: 2.0.1`

这些版本经过测试，在正常模式下可以稳定运行。 