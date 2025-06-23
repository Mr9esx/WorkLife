import 'package:WeekLife/presentation/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/common/ui/icon/app_icon.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'package:WeekLife/theme/button_style.dart';
import 'package:forui/forui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WeekLife/presentation/blocs/journal/journal_edit_bloc.dart';

/// 常量定义类
/// 集中管理所有UI相关的常量，便于统一修改和维护
class _Constants {
  // 视图类型列表
  static const List<String> viewTypes = ['单周视角', '全年视角', '人生视角'];
}

/// 自定义底部导航栏组件
/// 包含左侧编辑按钮和右侧的视图切换、AI功能按钮
class CustomBottomBar extends StatefulWidget {
  /// 当前选中的索引
  final int currentIndex;

  /// 按钮点击回调
  final Function(int) onTap;

  /// 视图类型切换回调
  final Function(String) onViewTypeChanged;

  /// 背景颜色，默认为透明
  final Color backgroundColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onViewTypeChanged,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> with WidgetsBindingObserver, TickerProviderStateMixin {
  /// 菜单是否打开的状态
  bool _isViewChangeMenuOpen = false;

  /// 当前选中的视图类型
  String _selectedViewType = _Constants.viewTypes[0];

  /// 用于获取网格按钮的位置和尺寸
  final GlobalKey _viewChangeButtonKey = GlobalKey();

  /// 当前显示的菜单
  OverlayEntry? _menuOverlay;

  late AnimationController _menuAnimationController;
  late Animation<double> _menuOpacityAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _menuOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 如果菜单是打开状态，重新计算位置
    if (_isViewChangeMenuOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _menuAnimationController.dispose();
    _closeMenu();
    super.dispose();
  }

  /// 处理屏幕旋转和尺寸变化
  @override
  void didChangeMetrics() {
    // 屏幕旋转时直接关闭菜单
    _closeMenu();
  }

  /// 关闭菜单的通用方法
  void _closeMenu() async {
    if (_isViewChangeMenuOpen) {
      await _menuAnimationController.reverse();
      _menuOverlay?.remove();
      _menuOverlay = null;
      setState(() => _isViewChangeMenuOpen = false);
    }
  }

  /// 显示视图选择菜单
  void _showViewMenu(BuildContext context) {
    if (_isViewChangeMenuOpen) {
      _closeMenu();
      return;
    }

    setState(() => _isViewChangeMenuOpen = true);

    final RenderBox? buttonBox = _viewChangeButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonBox == null) return;

    final buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final buttonSize = buttonBox.size;
    final screenSize = MediaQuery.of(context).size;

    // 使用封装的尺寸计算方法，ViewMenu 的宽度等于 ViewButton
    final menuWidth = MenuSize.getMenuWidth(buttonSize.width);
    final menuLeft = MenuSize.getMenuLeft(buttonPosition.dx);
    final menuBottom = MenuSize.getMenuBottom(
      screenSize.height,
      buttonPosition.dy,
      buttonSize.height,
    );

    // 创建菜单
    _menuOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 背景点击区域 - 不覆盖底部导航栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 120, // 预留底部导航栏空间
            child: GestureDetector(
              onTap: _closeMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 菜单内容
          Positioned(
            left: menuLeft,
            bottom: menuBottom,
            child: FadeTransition(
              opacity: _menuOpacityAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: menuWidth,
                  padding: MenuSize.containerPadding,
                  decoration: ShapeDecoration(
                    color: AppColors.unselectedBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: MenuSize.borderRadius,
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x195F5F5F),
                        blurRadius: 16,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _Constants.viewTypes
                        .map(
                          (viewType) => Padding(
                            padding: MenuSize.getItemBottomPadding(viewType == _Constants.viewTypes.last),
                            child: _buildViewOption(
                              viewType,
                              _selectedViewType == viewType,
                              () => _handleViewTypeChange(viewType),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // 显示菜单
    Overlay.of(context).insert(_menuOverlay!);
    _menuAnimationController.forward();
  }

  /// 处理视图类型切换
  /// [viewType] 新的视图类型
  void _handleViewTypeChange(String viewType) {
    setState(() => _selectedViewType = viewType);
    widget.onViewTypeChanged(viewType);
    _closeMenu();

    // 获取当前路由名称并尝试导航
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != RouteName.appMain) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.appMain,
          (route) => false,
        );
      }
    });
  }

  /// 构建菜单项
  /// [title] 菜单项标题
  /// [isSelected] 是否选中
  /// [onTap] 点击回调
  Widget _buildViewOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: MenuSize.itemHeight,
        padding: MenuSize.menuItemPadding,
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.appBackground : AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: MenuSize.borderRadius,
          ),
        ),
        child: Row(
          children: [
            AppIcon(
              assetName: _getViewTypeIcon(title),
              isSelected: isSelected,
              size: 36,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  fontSize: 14,
                  fontFamily: 'MiSans',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 根据视图类型获取对应的图标名称
  String _getViewTypeIcon(String viewType) {
    switch (viewType) {
      case '单周视角':
        return 'book-01';
      case '全年视角':
        return 'book-02';
      case '人生视角':
        return 'globe-01-1';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 渐变背景
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            widget.backgroundColor,
            widget.backgroundColor,
            widget.backgroundColor.withAlpha((0.6 * 255).round()),
            widget.backgroundColor.withAlpha((0.4 * 255).round()),
            widget.backgroundColor.withAlpha((0 * 255).round()),
          ],
          stops: const [0, 0.4, 0.6, 0.8, 1],
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: Padding(
            padding: BottomBarSize.containerPadding,
            child: BlocBuilder<JournalEditBloc, JournalEditState>(
              builder: (context, state) {
                // 在编辑状态下，只显示保存/取消按钮
                if (widget.currentIndex == 1 && state is JournalSavingState) {
                  return _buildMainOperationButton();
                }

                // 其他状态下显示正常布局
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildMainOperationButton(), // 左侧编辑按钮
                    const SizedBox(width: 8),
                    _buildRightButtonContainer(), // 右侧容器（包含视图切换和AI按钮）
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 构建左侧编辑按钮
  Widget _buildMainOperationButton() {
    // 只在周记页面（index: 1）显示编辑功能
    if (widget.currentIndex != 1) {
      return SizedBox(
        width: 60,
        height: 52,
        child: FButton(
          onPress: () {
            HapticFeedback.selectionClick();
            ToastManager.show(context, title: '此页面暂无编辑功能', position: ToastPosition.bottom, showIcon: false);
          },
          style: buttonStyle(
            colors: context.theme.colors,
            typography: context.theme.typography,
            style: context.theme.style,
            color: AppColors.secondary.withOpacity(0.3),
            foregroundColor: AppColors.cardBackground,
          ),
          child: const AppIcon(
            assetName: 'pencil-01',
            color: AppColors.cardBackground,
            size: 22,
          ),
        ),
      );
    }

    // 周记页面：现在没有编辑模式，显示保存状态指示器
    return BlocBuilder<JournalEditBloc, JournalEditState>(
      builder: (context, state) {
        if (state is JournalSavingState) {
          // 保存中状态：显示加载指示器
          return SizedBox(
            width: 60,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.cardBackground),
                  ),
                ),
              ),
            ),
          );
        } else {
          // 默认状态：显示保存成功图标
          return SizedBox(
            width: 60,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: AppIcon(
                  assetName: 'check-01',
                  color: AppColors.cardBackground,
                  size: 22,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// 构建右侧容器
  /// 包含视图切换按钮和AI按钮
  Widget _buildRightButtonContainer() {
    return Expanded(
      child: Container(
        height: BottomBarSize.height,
        padding: BottomBarSize.rightContainerPadding,
        decoration: ShapeDecoration(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: MenuSize.borderRadius,
          ),
          shadows: [Shadows.softShadow, Shadows.defaultShadow],
        ),
        child: Row(
          children: [
            _buildViewChangeButton(), // 视图切换按钮
            const SizedBox(width: 4),
            _buildAIButton(), // AI按钮
          ],
        ),
      ),
    );
  }

  /// 构建视图切换按钮
  Widget _buildViewChangeButton() {
    return Expanded(
        child: FButton(
      key: _viewChangeButtonKey,
      style: buttonStyle(
        colors: context.theme.colors,
        typography: FThemes.zinc.light.typography
            .copyWith(
              defaultFontFamily: 'Roboto',
            )
            .scale(sizeScalar: 0.8),
        style: context.theme.style,
        color: AppColors.cardBackground,
        foregroundColor: AppColors.primary,
      ),
      onPress: () {
        HapticFeedback.selectionClick();
        _showViewMenu(context);
      },
      child: AppIcon(
        assetName: 'glasses-01-1',
        size: IconSize.aiIconSize,
      ),
    ));
  }

  /// 构建AI按钮
  Widget _buildAIButton() {
    return Expanded(
      child: FButton(
        style: buttonStyle(
          colors: context.theme.colors,
          typography: context.theme.typography,
          style: context.theme.style,
          color: context.theme.colors.destructive,
          foregroundColor: AppColors.cardBackground,
        ),
        onPress: () {
          HapticFeedback.selectionClick();
          // 如果ViewMenu是打开状态，先关闭它
          if (_isViewChangeMenuOpen) {
            _closeMenu();
          }
          // 无论菜单是否打开，都显示Toast
          ToastManager.show(context, title: 'AI功能开发中...');
        },
        child: Center(
          child: AppIcon(
            assetName: 'atom',
            size: IconSize.aiIconSize,
          ),
        ),
      ),
    );
  }
}
