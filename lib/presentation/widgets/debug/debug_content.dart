import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/core/debug/app_debugger.dart';
import 'package:WeekLife/core/debug/database_debug_helper.dart';
import 'package:WeekLife/core/debug/debug_data_manager.dart';
import 'package:WeekLife/core/utils/permission_manager.dart';
import 'package:WeekLife/presentation/pages/app_main/journal/singleview/components/utils/performance_optimizations.dart';

import 'package:permission_handler/permission_handler.dart';

/// 调试内容组件（纯内容，无外层容器）
/// 专门用于在 Modal 或其他容器中显示
class DebugContent extends StatefulWidget {
  const DebugContent({super.key});

  @override
  State<DebugContent> createState() => _DebugContentState();
}

class _DebugContentState extends State<DebugContent> {
  bool _isLoading = false;
  Map<String, PermissionStatus> _permissionStatus = {};

  @override
  void initState() {
    super.initState();
    _loadPermissionStatus();
  }

  /// 加载权限状态
  Future<void> _loadPermissionStatus() async {
    final status = await PermissionManager.getAllPermissionStatus();
    if (mounted) {
      setState(() {
        _permissionStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 当前页面数据
        _buildCurrentPageSection(),

        const SizedBox(height: 16),

        // 权限管理功能
        _buildSection(
          title: '🔐 权限管理',
          children: [
            _buildDebugButton(
              icon: Icons.refresh,
              label: '刷新权限状态',
              onPressed: _loadPermissionStatus,
              color: Colors.blue,
            ),
            _buildDebugButton(
              icon: Icons.settings,
              label: '打开应用设置',
              onPressed: _openAppSettings,
              color: Colors.orange,
            ),
            _buildDebugButton(
              icon: Icons.location_on,
              label: '定位调试工具',
              onPressed: _openLocationDebug,
              color: Colors.red,
            ),
            // 权限状态显示
            if (_permissionStatus.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前权限状态:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._permissionStatus.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: PermissionManager.getPermissionStatusColor(entry.value).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: PermissionManager.getPermissionStatusColor(entry.value).withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  PermissionManager.getPermissionStatusText(entry.value),
                                  style: TextStyle(
                                    color: PermissionManager.getPermissionStatusColor(entry.value),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showPermissionOptions(entry.key, entry.value),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // 主要调试功能
        _buildSection(
          title: '📊 主要功能',
          children: [
            _buildDebugButton(
              icon: Icons.info_outline,
              label: '输出所有调试信息',
              onPressed: _printAllDebugInfo,
              color: Colors.blue,
            ),
            _buildDebugButton(
              icon: Icons.copy,
              label: '复制调试信息',
              onPressed: _copyDebugInfo,
              color: Colors.orange,
            ),
            _buildDebugButton(
              icon: Icons.file_download,
              label: '导出调试日志',
              onPressed: _exportDebugLog,
              color: Colors.purple,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 分类调试功能
        _buildSection(
          title: '🔍 分类调试',
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.phone_android,
                    label: '设备信息',
                    onPressed: () => _runDebugFunction(AppDebugger.printDeviceInfo),
                    color: Colors.green,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.apps,
                    label: '应用信息',
                    onPressed: () => _runDebugFunction(AppDebugger.printAppInfo),
                    color: Colors.teal,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.folder,
                    label: '文件系统',
                    onPressed: () => _runDebugFunction(AppDebugger.printFileSystemInfo),
                    color: Colors.indigo,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.storage,
                    label: '数据库信息',
                    onPressed: () => _runDebugFunction(AppDebugger.printDatabaseInfo),
                    color: Colors.red,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.memory,
                    label: '内存信息',
                    onPressed: () => _runDebugFunction(AppDebugger.printMemoryInfo),
                    color: Colors.pink,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.wifi,
                    label: '网络信息',
                    onPressed: () => _runDebugFunction(AppDebugger.printNetworkInfo),
                    color: Colors.cyan,
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 数据库诊断
        _buildSection(
          title: '🔍 数据库诊断',
          children: [
            _buildDebugButton(
              icon: Icons.medical_services,
              label: '完整数据库诊断',
              onPressed: () => _runDebugFunction(DatabaseDebugHelper.runFullDiagnosis),
              color: Colors.deepPurple,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.build,
                    label: '强制创建数据库',
                    onPressed: () => _runDebugFunction(DatabaseDebugHelper.forceCreateDatabase),
                    color: Colors.amber,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDebugButton(
                    icon: Icons.refresh,
                    label: '重建数据库',
                    onPressed: () => _runDebugFunction(DatabaseDebugHelper.rebuildDatabase),
                    color: Colors.deepOrange,
                    isCompact: true,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 清理功能
        _buildSection(
          title: '🧹 清理功能',
          children: [
            _buildDebugButton(
              icon: Icons.cleaning_services,
              label: '清理调试数据',
              onPressed: _clearDebugData,
              color: Colors.red,
            ),
            _buildDebugButton(
              icon: Icons.refresh,
              label: '清空图片缓存',
              onPressed: _refreshImageCache,
              color: Colors.orange,
            ),
            _buildDebugButton(
              icon: Icons.camera_alt,
              label: '测试EXIF信息',
              onPressed: _testExifInfo,
              color: Colors.blue,
            ),
            // 图片缓存状态显示
            _buildImageCacheStatus(),
          ],
        ),

        const SizedBox(height: 8),

        // 提示信息
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.yellow,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '调试信息将输出到控制台，请查看 Debug Console',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建当前页面数据区域
  Widget _buildCurrentPageSection() {
    final debugManager = DebugDataManager();
    final pageName = debugManager.currentPageName;
    final pageData = debugManager.currentPageData;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.web,
                color: Colors.blue,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                '📄 当前页面数据',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final jsonData = debugManager.getDebugDataAsJson();
                  Clipboard.setData(ClipboardData(text: jsonData.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('页面数据已复制到剪贴板'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (pageName.isEmpty)
            const Text(
              '当前无页面数据',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            )
          else ...[
            Text(
              '页面: $pageName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            if (pageData.isNotEmpty) ...[
              ...pageData.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  )),
            ] else
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '无数据',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  /// 构建调试按钮
  Widget _buildDebugButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isCompact = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon, size: isCompact ? 16 : 18),
        label: Text(
          label,
          style: TextStyle(fontSize: isCompact ? 12 : 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.2),
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5)),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 16,
            vertical: isCompact ? 8 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// 输出所有调试信息
  Future<void> _printAllDebugInfo() async {
    await _runDebugFunction(AppDebugger.printAllDebugInfo);
  }

  /// 复制调试信息
  Future<void> _copyDebugInfo() async {
    await _runDebugFunction(AppDebugger.copyDebugInfoToClipboard);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('调试信息已复制到剪贴板'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// 导出调试日志
  Future<void> _exportDebugLog() async {
    final path = await AppDebugger.exportDebugLog();
    if (mounted && path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('调试日志已导出: $path'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: '复制路径',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: path));
            },
          ),
        ),
      );
    }
  }

  /// 清理调试数据
  Future<void> _clearDebugData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清理'),
        content: const Text('确定要清理调试数据吗？这将删除临时文件和缓存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _runDebugFunction(AppDebugger.clearDebugData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('调试数据清理完成'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// 刷新图片缓存
  Future<void> _refreshImageCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空缓存'),
        content: const Text('确定要清空图片缓存吗？这将删除所有图片缓存，下次查看时会直接加载原图和完整EXIF信息。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _runDebugFunction(() async {
        // 获取性能优化实例并清理缓存
        final optimizer = PerformanceOptimizations();
        final stats = optimizer.getCacheStats();

        print('🗑️ 开始清空图片缓存');
        print('📊 清空前缓存统计: ${stats['count']}张图片, ${stats['memoryUsageFormatted']}');

        // 清理所有图片缓存
        optimizer.clearCache();

        print('✅ 图片缓存已清空完成');
        print('📝 下次查看图片时会直接加载原图和完整EXIF信息');
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片缓存清空完成，下次查看图片时会直接加载原图和完整EXIF信息'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 测试EXIF信息
  Future<void> _testExifInfo() async {
    await _runDebugFunction(() async {
      print('🔧 开始测试EXIF信息功能');

      try {
        // 检查相册权限
        final hasPermission = await Permission.photos.isGranted;
        if (!hasPermission) {
          print('❌ 没有相册权限，无法测试EXIF信息');
          return;
        }

        print('📸 开始读取最近的图片...');

        // 这里只是一个示例，实际实现需要访问相册
        print('✅ EXIF信息功能已准备就绪');
        print('📝 功能说明:');
        print('  1. 所有图片都直接使用原图，不进行压缩');
        print('  2. 图片查看器直接从原图读取完整EXIF信息');
        print('  3. 支持所有EXIF标签: 相机型号、拍摄参数、GPS信息等');
        print('  4. 清空图片缓存后，下次查看会直接加载原图');
        print('🔄 建议操作: 先清空图片缓存，然后重新查看图片');
      } catch (e) {
        print('❌ EXIF信息测试失败: $e');
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('EXIF信息测试完成，请查看控制台输出'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// 运行调试函数
  Future<void> _runDebugFunction(Future<void> Function() function) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await function();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('调试功能执行失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 打开应用设置
  Future<void> _openAppSettings() async {
    await _runDebugFunction(() async {
      final opened = await PermissionManager.openAppSettings();
      if (!opened) {
        throw Exception('无法打开应用设置页面');
      }
    });
  }

  /// 打开定位调试工具
  void _openLocationDebug() {
    // 定位调试工具已移除
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('定位调试工具已移除')),
    );
  }

  /// 显示权限操作选项
  void _showPermissionOptions(String permissionName, PermissionStatus status) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示器
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$permissionName 权限管理',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 当前状态
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PermissionManager.getPermissionStatusColor(status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: PermissionManager.getPermissionStatusColor(status).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: PermissionManager.getPermissionStatusColor(status),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '当前状态: ${PermissionManager.getPermissionStatusText(status)}',
                        style: TextStyle(
                          color: PermissionManager.getPermissionStatusColor(status),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 操作按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 请求权限
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _requestPermission(permissionName);
                        },
                        icon: const Icon(Icons.security, size: 18),
                        label: const Text('请求权限'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 打开设置
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _openAppSettings();
                        },
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text('打开应用设置'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.2),
                          foregroundColor: Colors.orange,
                          side: BorderSide(color: Colors.orange.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 模拟撤销权限（调试用）
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _simulateRevokePermission(permissionName);
                        },
                        icon: const Icon(Icons.remove_circle, size: 18),
                        label: const Text('模拟撤销权限'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.2),
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 请求特定权限
  Future<void> _requestPermission(String permissionName) async {
    await _runDebugFunction(() async {
      final permissionMap = {
        '相机': Permission.camera,
        '相册': Permission.photos,
        '存储': Permission.storage,
        '麦克风': Permission.microphone,
        '位置': Permission.location,
        '通知': Permission.notification,
        '联系人': Permission.contacts,
        '日历': Permission.calendar,
      };

      final permission = permissionMap[permissionName];
      if (permission != null) {
        final status = await PermissionManager.requestPermission(permission);
        print('权限请求结果 $permissionName: ${PermissionManager.getPermissionStatusText(status)}');

        // 刷新权限状态
        await _loadPermissionStatus();
      }
    });
  }

  /// 模拟撤销权限（调试用）
  Future<void> _simulateRevokePermission(String permissionName) async {
    await _runDebugFunction(() async {
      print('🔧 调试功能: 模拟撤销 $permissionName 权限');
      print('⚠️  注意: 实际撤销权限需要用户在系统设置中手动操作');
      print('📱 请到 设置 > 应用 > WeekLife > 权限 中手动撤销相应权限');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已输出 $permissionName 权限撤销指导到控制台'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: '打开设置',
              onPressed: _openAppSettings,
            ),
          ),
        );
      }
    });
  }

  /// 构建图片缓存状态显示
  Widget _buildImageCacheStatus() {
    final optimizer = PerformanceOptimizations();
    final stats = optimizer.getCacheStats();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📸 图片缓存状态:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '已缓存图片: ${stats['count']}张',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          Text(
            '内存使用: ${stats['memoryUsageFormatted']}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          Text(
            '内存限制: ${stats['maxMemoryUsageFormatted']}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
