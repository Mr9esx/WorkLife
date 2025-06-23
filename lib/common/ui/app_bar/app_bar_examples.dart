import 'package:flutter/material.dart';
import 'package:WeekLife/common/ui/app_bar/custom_app_bar.dart';

/// CustomAppBar 使用示例
/// 展示不同的配置方式和使用场景
class AppBarExamples {
  /// 示例1：基础 Logo AppBar（Home 页面使用）
  static PreferredSizeWidget basicLogoAppBar() {
    return const CustomAppBar(
      showLogo: true,
    );
  }

  /// 示例2：带标题的 AppBar
  static PreferredSizeWidget titleAppBar({required String title}) {
    return CustomAppBar(
      leftWidget: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 示例3：带返回按钮和标题的 AppBar
  static PreferredSizeWidget backTitleAppBar({
    required BuildContext context,
    required String title,
  }) {
    return CustomAppBar(
      leftWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 示例4：带右侧操作按钮的 AppBar
  static PreferredSizeWidget actionAppBar({
    required String title,
    required List<Widget> actions,
  }) {
    return CustomAppBar(
      leftWidget: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      rightWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );
  }

  /// 示例5：自定义背景色的 AppBar
  static PreferredSizeWidget customColorAppBar({
    required String title,
    required Color backgroundColor,
  }) {
    return CustomAppBar(
      backgroundColor: backgroundColor,
      leftWidget: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 示例6：搜索页面 AppBar
  static PreferredSizeWidget searchAppBar({
    required BuildContext context,
    required TextEditingController searchController,
    required VoidCallback onSearch,
  }) {
    return CustomAppBar(
      leftWidget: Expanded(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: '搜索...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
      ),
      rightWidget: IconButton(
        onPressed: onSearch,
        icon: const Icon(Icons.search),
      ),
    );
  }

  /// 示例7：设置页面 AppBar
  static PreferredSizeWidget settingsAppBar({required BuildContext context}) {
    return CustomAppBar(
      leftWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const SizedBox(width: 8),
          const Text(
            '设置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      rightWidget: IconButton(
        onPressed: () {
          // 保存设置逻辑
        },
        icon: const Icon(Icons.check),
      ),
    );
  }
}
