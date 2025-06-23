import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/presentation/widgets/debug/debug_content.dart';

/// 调试面板组件
/// 提供可视化的调试功能界面
class DebugPanel extends StatelessWidget {
  const DebugPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 内容区域 - 使用 DebugContent
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: DebugContent(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 调试面板的浮动按钮
class DebugFloatingButton extends StatelessWidget {
  const DebugFloatingButton({super.key});

  // 静态变量跟踪对话框状态
  static bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        // 防止重复弹出
        if (_isDialogShowing) return;

        _isDialogShowing = true;
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: const DebugPanel(),
          ),
        ).then((_) {
          // 对话框关闭时重置状态
          _isDialogShowing = false;
        });
      },
      backgroundColor: Colors.green,
      child: const Icon(
        Icons.bug_report,
        color: Colors.white,
      ),
    );
  }
}

/// 调试面板的底部弹窗
class DebugBottomSheet extends StatelessWidget {
  const DebugBottomSheet({super.key});

  // 静态变量跟踪底部弹窗状态
  static bool _isBottomSheetShowing = false;

  static void show(BuildContext context) {
    // 防止重复弹出
    if (_isBottomSheetShowing) return;

    _isBottomSheetShowing = true;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const DebugBottomSheet(),
    ).then((_) {
      // 底部弹窗关闭时重置状态
      _isBottomSheetShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Modal 顶部拖拽条
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Modal 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              children: [
                const Text(
                  '🐛 调试面板',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // 调试面板内容
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: DebugContent(),
            ),
          ),
        ],
      ),
    );
  }
}
