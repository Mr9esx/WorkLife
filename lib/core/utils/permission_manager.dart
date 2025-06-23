import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';

/// 权限管理工具类
///
/// 使用示例：
///
/// 1. 智能请求定位权限（自动处理永久拒绝情况）：
/// ```dart
/// final granted = await PermissionManager.smartRequestPermission(
///   context,
///   permission: Permission.location,
///   permissionName: '定位',
///   description: '为了提供基于位置的服务，我们需要访问您的位置信息。',
/// );
/// if (granted) {
///   // 权限已授权，可以使用定位功能
/// } else {
///   // 权限被拒绝或用户取消
/// }
/// ```
///
/// 2. 智能请求相册权限：
/// ```dart
/// final granted = await PermissionManager.smartRequestPhotoPermission(context);
/// if (granted) {
///   // 权限已授权，可以访问相册
/// }
/// ```
///
/// 3. 检查权限状态：
/// ```dart
/// final status = await PermissionManager.checkPermissionStatus(Permission.location);
/// if (status == PermissionStatus.permanentlyDenied) {
///   // 权限被永久拒绝，需要引导用户到设置页面
/// }
/// ```
class PermissionManager {
  /// 权限类型枚举
  static const Map<String, Permission> _permissions = {
    '相机': Permission.camera,
    '相册': Permission.photos,
    '存储': Permission.storage,
    '麦克风': Permission.microphone,
    '位置': Permission.location,
    '通知': Permission.notification,
    '联系人': Permission.contacts,
    '日历': Permission.calendar,
  };

  /// 获取所有权限状态
  static Future<Map<String, PermissionStatus>> getAllPermissionStatus() async {
    final Map<String, PermissionStatus> result = {};

    for (final entry in _permissions.entries) {
      try {
        final status = await entry.value.status;
        result[entry.key] = status;
      } catch (e) {
        print('获取权限状态失败 ${entry.key}: $e');
        result[entry.key] = PermissionStatus.denied;
      }
    }

    return result;
  }

  /// 检查特定权限状态
  static Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    try {
      return await permission.status;
    } catch (e) {
      print('检查权限状态失败: $e');
      return PermissionStatus.denied;
    }
  }

  /// 请求权限
  static Future<PermissionStatus> requestPermission(Permission permission) async {
    try {
      print('🔐 开始请求权限: ${permission.toString()}');
      final status = await permission.request();
      print('🔐 权限请求结果: ${getPermissionStatusText(status)}');
      return status;
    } catch (e) {
      print('🔐 请求权限失败: $e');
      return PermissionStatus.denied;
    }
  }

  /// 检查相册权限（使用photo_manager）
  static Future<bool> checkPhotoPermission() async {
    try {
      final state = await PhotoManager.requestPermissionExtend();
      return state.isAuth || state.hasAccess;
    } catch (e) {
      print('检查相册权限失败: $e');
      return false;
    }
  }

  /// 请求相册权限（使用photo_manager）
  static Future<bool> requestPhotoPermission() async {
    try {
      final state = await PhotoManager.requestPermissionExtend();
      return state.isAuth || state.hasAccess;
    } catch (e) {
      print('请求相册权限失败: $e');
      return false;
    }
  }

  /// 打开应用设置页面
  static Future<bool> openAppSettings() async {
    try {
      return await permission_handler.openAppSettings();
    } catch (e) {
      print('打开设置页面失败: $e');
      return false;
    }
  }

  /// 移除权限（仅限调试，实际需要用户在设置中手动操作）
  static Future<void> revokePermission(Permission permission) async {
    // 注意：Android/iOS 不允许应用程序直接撤销权限
    // 这个方法主要用于调试目的，实际上会指导用户到设置页面
    print('权限撤销提示: 请到设置页面手动撤销 ${permission.toString()} 权限');
  }

  /// 获取权限状态的中文描述
  static String getPermissionStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return '已授权';
      case PermissionStatus.denied:
        return '被拒绝';
      case PermissionStatus.restricted:
        return '受限制';
      case PermissionStatus.limited:
        return '部分授权';
      case PermissionStatus.permanentlyDenied:
        return '永久拒绝';
      case PermissionStatus.provisional:
        return '临时授权';
      default:
        return '未知状态';
    }
  }

  /// 获取权限状态颜色
  static Color getPermissionStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.restricted:
        return Colors.purple;
      case PermissionStatus.limited:
        return Colors.blue;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.provisional:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// 显示权限授权弹窗
  static Future<bool?> showPermissionDialog(
    BuildContext context, {
    required String permissionName,
    required String description,
    required Permission permission,
  }) async {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return PermissionAuthorizationSheet(
          permissionName: permissionName,
          description: description,
          permission: permission,
        );
      },
    );
  }

  /// 显示相册权限授权弹窗
  static Future<bool?> showPhotoPermissionDialog(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return const PhotoPermissionAuthorizationSheet();
      },
    );
  }

  /// 显示权限被永久拒绝的弹窗
  static Future<bool?> showPermanentlyDeniedDialog(
    BuildContext context, {
    required String permissionName,
    required String description,
  }) async {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return PermanentlyDeniedPermissionSheet(
          permissionName: permissionName,
          description: description,
        );
      },
    );
  }

  /// 智能权限请求方法 - 根据权限状态选择合适的处理方式
  static Future<bool> smartRequestPermission(
    BuildContext context, {
    required Permission permission,
    required String permissionName,
    required String description,
  }) async {
    // 首先检查当前权限状态
    final currentStatus = await checkPermissionStatus(permission);

    print('🔐 当前权限状态: ${getPermissionStatusText(currentStatus)}');

    switch (currentStatus) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.permanentlyDenied:
        // 权限被永久拒绝，引导用户到设置页面
        final result = await showPermanentlyDeniedDialog(
          context,
          permissionName: permissionName,
          description: description,
        );
        return result ?? false;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        // 权限被拒绝但可以再次请求，显示授权弹窗
        final result = await showPermissionDialog(
          context,
          permissionName: permissionName,
          description: description,
          permission: permission,
        );
        return result ?? false;

      default:
        // 其他状态，尝试直接请求
        final status = await requestPermission(permission);
        return status == PermissionStatus.granted;
    }
  }

  /// 智能相册权限请求方法
  static Future<bool> smartRequestPhotoPermission(BuildContext context) async {
    // 首先检查当前权限状态
    final hasPermission = await checkPhotoPermission();

    if (hasPermission) {
      return true;
    }

    // 检查系统权限状态
    final systemStatus = await checkPermissionStatus(Permission.photos);

    if (systemStatus == PermissionStatus.permanentlyDenied) {
      // 权限被永久拒绝，引导用户到设置页面
      final result = await showPermanentlyDeniedDialog(
        context,
        permissionName: '相册',
        description: '为了让您能够选择和保存照片，我们需要访问您的相册。您的照片将只用于记录周记内容。',
      );
      return result ?? false;
    }

    // 其他情况显示普通授权弹窗
    final result = await showPhotoPermissionDialog(context);
    return result ?? false;
  }
}

/// 权限授权弹窗组件
class PermissionAuthorizationSheet extends StatefulWidget {
  final String permissionName;
  final String description;
  final Permission permission;

  const PermissionAuthorizationSheet({
    super.key,
    required this.permissionName,
    required this.description,
    required this.permission,
  });

  @override
  State<PermissionAuthorizationSheet> createState() => _PermissionAuthorizationSheetState();
}

class _PermissionAuthorizationSheetState extends State<PermissionAuthorizationSheet> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.appBackground,
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
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 内容区域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 图标和标题
                  Icon(
                    Icons.security,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '需要${widget.permissionName}权限',
                    style: AppTextStyles.editorTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: AppTextStyles.placeholderText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // 按钮区域
                  Row(
                    children: [
                      // 取消按钮
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop(false);
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '取消',
                                style: AppTextStyles.buttonSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 授权按钮
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _isRequesting
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  _requestPermission();
                                },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isRequesting ? AppColors.secondary.withOpacity(0.3) : AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_isRequesting
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: _isRequesting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      '授权',
                                      style: AppTextStyles.buttonPrimary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final status = await PermissionManager.requestPermission(widget.permission);

      if (mounted) {
        Navigator.of(context).pop(status == PermissionStatus.granted);
      }
    } catch (e) {
      print('请求权限失败: $e');
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }
}

/// 相册权限授权弹窗组件
class PhotoPermissionAuthorizationSheet extends StatefulWidget {
  const PhotoPermissionAuthorizationSheet({super.key});

  @override
  State<PhotoPermissionAuthorizationSheet> createState() => _PhotoPermissionAuthorizationSheetState();
}

class _PhotoPermissionAuthorizationSheetState extends State<PhotoPermissionAuthorizationSheet> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.appBackground,
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
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 内容区域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 图标和标题
                  Icon(
                    Icons.photo_library,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '需要相册访问权限',
                    style: AppTextStyles.editorTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '为了让您能够选择和保存照片，我们需要访问您的相册。您的照片将只用于记录周记内容。',
                    style: AppTextStyles.placeholderText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // 按钮区域
                  Row(
                    children: [
                      // 取消按钮
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop(false);
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '取消',
                                style: AppTextStyles.buttonSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 授权按钮
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _isRequesting
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  _requestPhotoPermission();
                                },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isRequesting ? AppColors.secondary.withOpacity(0.3) : AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_isRequesting
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: _isRequesting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      '授权',
                                      style: AppTextStyles.buttonPrimary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPhotoPermission() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final granted = await PermissionManager.requestPhotoPermission();

      if (mounted) {
        Navigator.of(context).pop(granted);
      }
    } catch (e) {
      print('请求相册权限失败: $e');
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }
}

/// 权限被永久拒绝的弹窗组件
class PermanentlyDeniedPermissionSheet extends StatefulWidget {
  final String permissionName;
  final String description;

  const PermanentlyDeniedPermissionSheet({
    super.key,
    required this.permissionName,
    required this.description,
  });

  @override
  State<PermanentlyDeniedPermissionSheet> createState() => _PermanentlyDeniedPermissionSheetState();
}

class _PermanentlyDeniedPermissionSheetState extends State<PermanentlyDeniedPermissionSheet> {
  bool _isOpening = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.appBackground,
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
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 内容区域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 图标和标题
                  Icon(
                    Icons.settings,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '需要在设置中开启${widget.permissionName}权限',
                    style: AppTextStyles.editorTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.description}\n\n由于权限已被拒绝，请前往系统设置手动开启权限。',
                    style: AppTextStyles.placeholderText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // 操作步骤说明
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '操作步骤：',
                          style: AppTextStyles.editorTitle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '1. 点击下方"前往设置"按钮\n2. 找到"${widget.permissionName}"权限选项\n3. 开启权限后返回应用',
                          style: AppTextStyles.placeholderText.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 按钮区域
                  Row(
                    children: [
                      // 取消按钮
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop(false);
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '取消',
                                style: AppTextStyles.buttonSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 前往设置按钮
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _isOpening
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  _openAppSettings();
                                },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isOpening ? Colors.orange.withOpacity(0.3) : Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: !_isOpening
                                  ? [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: _isOpening
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      '前往设置',
                                      style: AppTextStyles.buttonPrimary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAppSettings() async {
    setState(() {
      _isOpening = true;
    });

    try {
      final opened = await PermissionManager.openAppSettings();

      if (mounted) {
        if (opened) {
          // 成功打开设置页面，返回 true 表示用户已被引导到设置
          Navigator.of(context).pop(true);
        } else {
          // 无法打开设置页面
          Navigator.of(context).pop(false);
        }
      }
    } catch (e) {
      print('打开设置页面失败: $e');
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpening = false;
        });
      }
    }
  }
}
