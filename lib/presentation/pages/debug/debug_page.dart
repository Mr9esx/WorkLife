import 'package:flutter/material.dart';
import 'package:WeekLife/presentation/widgets/debug/debug_panel.dart';
import 'package:WeekLife/core/debug/app_debugger.dart';

/// 调试页面
/// 用于开发和测试阶段的调试功能
class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐛 调试工具'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showDebugInfo(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            _buildInfoCard(),
            
            const SizedBox(height: 20),
            
            // 调试面板
            const DebugPanel(),
            
            const SizedBox(height: 20),
            
            // 快捷操作
            _buildQuickActions(context),
            
            const SizedBox(height: 20),
            
            // 使用说明
            _buildUsageGuide(),
          ],
        ),
      ),
      floatingActionButton: const DebugFloatingButton(),
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  '调试工具说明',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '这个调试工具可以帮助开发者快速获取应用的各种信息，包括：\n'
              '• 设备信息（型号、系统版本等）\n'
              '• 应用信息（版本、包名等）\n'
              '• 文件系统路径\n'
              '• 数据库信息（路径、大小、记录数等）\n'
              '• 内存和存储使用情况\n'
              '• 网络连接状态',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建快捷操作
  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚡ 快捷操作',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppDebugger.printAllDebugInfo();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('调试信息已输出到控制台'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.terminal),
                    label: const Text('输出到控制台'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      DebugBottomSheet.show(context);
                    },
                    icon: const Icon(Icons.dashboard),
                    label: const Text('打开面板'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建使用说明
  Widget _buildUsageGuide() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  '使用说明',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGuideItem('1. 点击调试面板标题栏展开/收起面板'),
            _buildGuideItem('2. 使用"输出所有调试信息"获取完整的系统信息'),
            _buildGuideItem('3. 使用分类按钮获取特定类型的信息'),
            _buildGuideItem('4. "复制调试信息"可将基本信息复制到剪贴板'),
            _buildGuideItem('5. "导出调试日志"可将日志保存到文件'),
            _buildGuideItem('6. 调试信息会输出到 IDE 的 Debug Console'),
            _buildGuideItem('7. 右下角的浮动按钮可快速打开调试面板'),
          ],
        ),
      ),
    );
  }

  /// 构建指南项目
  Widget _buildGuideItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示调试信息对话框
  void _showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于调试工具'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '版本信息',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('调试工具版本: 1.0.0'),
              Text('支持的功能: 设备信息、应用信息、数据库信息等'),
              SizedBox(height: 16),
              Text(
                '注意事项',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 此工具仅在开发模式下使用'),
              Text('• 调试信息包含敏感数据，请勿在生产环境使用'),
              Text('• 部分功能需要相应的系统权限'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 