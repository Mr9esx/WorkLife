import 'package:flutter/material.dart';
import 'package:WeekLife/core/services/simple_permission_service.dart';

/// 简化的权限处理对话框
class SimplePermissionDialog {
  /// 显示定位权限对话框
  static Future<bool> showLocationPermissionDialog(
    BuildContext context,
    LocationPermissionResult result,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('定位权限'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildPermissionStatusInfo(result),
                  if (result.status == 'deniedForever') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 如何开启定位权限：',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('1. 点击"前往设置"按钮'),
                          Text('2. 找到"权限"或"应用权限"选项'),
                          Text('3. 点击"位置信息"或"定位"'),
                          Text('4. 选择"始终允许"或"使用应用时允许"'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (result.status != 'deniedForever')
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('取消'),
                  ),
                if (result.status == 'deniedForever' && result.canOpenSettings)
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(false);
                      await SimplePermissionService().openAppSettings();
                    },
                    child: const Text('前往设置'),
                  ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    result.status == 'deniedForever' ? '我已设置' : '重试',
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// 构建权限状态信息
  static Widget _buildPermissionStatusInfo(LocationPermissionResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '权限状态：',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            '基础定位权限',
            result.isGranted,
            result.isGranted ? '已授权' : '未授权',
          ),
          if (result.permissionLevel != null)
            _buildStatusRow(
              '权限级别',
              result.isGranted,
              result.permissionLevel!,
            ),
          _buildStatusRow(
            '后台定位权限',
            result.hasBackgroundPermission,
            result.hasBackgroundPermission ? '已授权' : '未授权',
          ),
        ],
      ),
    );
  }

  /// 构建状态行
  static Widget _buildStatusRow(String label, bool isGranted, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isGranted ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text('$label: '),
          Text(
            status,
            style: TextStyle(
              color: isGranted ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示权限说明对话框
  static Future<void> showPermissionExplanationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text('为什么需要定位权限？'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WeekLife 需要定位权限来：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('📍 自动记录您的生活轨迹'),
              Text('📝 为日记添加位置信息'),
              Text('📊 生成位置统计报告'),
              Text('🗺️ 在地图上展示您的足迹'),
              SizedBox(height: 16),
              Text(
                '我们承诺：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('✅ 所有数据仅存储在本地'),
              Text('✅ 不会上传到任何服务器'),
              Text('✅ 您可以随时关闭定位功能'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('我知道了'),
            ),
          ],
        );
      },
    );
  }
}
