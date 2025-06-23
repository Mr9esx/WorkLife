import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/common/ui/text_styles.dart';
import 'package:WeekLife/common/ui/size_styles.dart';
import 'package:WeekLife/data/models/location/location_data.dart';
import 'package:forui/forui.dart';

/// 定位记录组件
/// 负责显示和管理定位信息，支持地图展示、定位点显示和手动记录等功能
class LocationSection extends StatelessWidget {
  /// 是否启用定位
  final bool isLocationEnabled;

  /// 本周定位记录列表
  final List<LocationData> weeklyLocations;

  /// 当前位置数据
  final LocationData? currentLocation;

  /// 是否正在加载位置
  final bool isLoadingLocation;

  /// 是否处于编辑状态
  final bool isEditing;

  /// 定位状态切换回调
  final Function(bool enabled) onLocationToggle;

  /// 手动记录定位回调
  final VoidCallback? onManualRecord;

  /// 重试获取位置回调
  final VoidCallback? onRetryLocation;

  const LocationSection({
    super.key,
    required this.isLocationEnabled,
    this.weeklyLocations = const [],
    this.currentLocation,
    this.isLoadingLocation = false,
    this.isEditing = true,
    required this.onLocationToggle,
    this.onManualRecord,
    this.onRetryLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和开关
          Row(
            children: [
              Expanded(
                child: Text(
                  '定位',
                  style: AppTextStyles.editorTitle,
                ),
              ),
              if (isEditing)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onLocationToggle(!isLocationEnabled);
                  },
                  child: Container(
                    width: 32,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isLocationEnabled ? AppColors.primary : AppColors.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          left: isLocationEnabled ? 18 : 2,
                          top: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.cardBackground,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),

          const SizedBox(height: 16),

          // 定位内容区域
          _buildLocationContent(),
        ],
      ),
    );
  }

  /// 构建定位内容区域
  Widget _buildLocationContent() {
    if (!isLocationEnabled) {
      return _buildLocationDisabledState();
    }

    if (isLoadingLocation) {
      return _buildLocationLoadingState();
    }

    return _buildLocationMapState();
  }

  /// 构建定位关闭状态
  Widget _buildLocationDisabledState() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(GlobalSize.primaryPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 32,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 10),
          Text(
            '智能定位已关闭',
            style: AppTextStyles.emptyState,
          ),
        ],
      ),
    );
  }

  /// 构建定位加载状态
  Widget _buildLocationLoadingState() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(GlobalSize.primaryPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            '正在获取位置信息...',
            style: AppTextStyles.placeholderText,
          ),
        ],
      ),
    );
  }

  /// 构建定位地图状态
  Widget _buildLocationMapState() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // 地图背景（模拟地图）
            _buildMapBackground(),

            // 定位点
            _buildLocationPoints(),

            // 渐变遮罩
            _buildGradientOverlay(),

            // 位置信息展示
            _buildLocationInfo(),

            // 手动记录按钮
            _buildManualRecordButton(),
          ],
        ),
      ),
    );
  }

  /// 构建地图背景
  Widget _buildMapBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
        ),
      ),
      child: CustomPaint(
        painter: MapGridPainter(),
      ),
    );
  }

  /// 构建定位点
  Widget _buildLocationPoints() {
    if (weeklyLocations.isEmpty && currentLocation == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // 显示本周的定位点
        ...weeklyLocations.asMap().entries.map((entry) {
          final index = entry.key;
          final location = entry.value;
          return _buildLocationPoint(
            location,
            index,
            isCurrentLocation: false,
          );
        }),

        // 显示当前位置点（如果存在）
        if (currentLocation != null)
          _buildLocationPoint(
            currentLocation!,
            weeklyLocations.length,
            isCurrentLocation: true,
          ),
      ],
    );
  }

  /// 构建单个定位点
  Widget _buildLocationPoint(LocationData location, int index, {bool isCurrentLocation = false}) {
    // 根据索引计算位置（模拟在地图上的分布）
    // 使用更复杂的分布算法，避免重叠
    final double baseLeft = 20 + (index % 4) * 50.0;
    final double baseTop = 20 + (index ~/ 4) * 40.0;

    // 添加一些随机偏移，让相同位置的点也能区分
    final double offsetX = (index % 7) * 8.0;
    final double offsetY = ((index * 3) % 5) * 6.0;

    final double left = baseLeft + offsetX;
    final double top = baseTop + offsetY;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getLocationPointColor(index, isCurrentLocation),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建渐变遮罩
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2, 1.0],
            colors: [
              const Color(0x002F3036), // 顶部透明
              const Color(0xCC2F3036), // 20%处开始80%透明度
              const Color(0x0D2F3036), // 底部5%透明度
            ],
          ),
        ),
      ),
    );
  }

  /// 构建位置信息展示
  Widget _buildLocationInfo() {
    final displayLocation = currentLocation ?? (weeklyLocations.isNotEmpty ? weeklyLocations.last : null);

    if (displayLocation == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主要位置信息
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayLocation.shortAddress,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 时间信息
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _formatLocationTime(displayLocation.timestamp),
              style: AppTextStyles.placeholderText.copyWith(
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建手动记录按钮
  Widget _buildManualRecordButton() {
    if (!isEditing || onManualRecord == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 12,
      right: 12,
      child: GestureDetector(
        onTap: isLoadingLocation
            ? null
            : () {
                HapticFeedback.selectionClick();
                onManualRecord?.call();
              },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoadingLocation
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.cardBackground,
                      ),
                    ),
                  )
                : Text(
                    '手动记录',
                    style: TextStyle(
                      color: AppColors.cardBackground,
                      fontSize: 10,
                      fontFamily: 'MiSans',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }

  /// 获取定位点颜色
  Color _getLocationPointColor(int index, bool isCurrentLocation) {
    if (isCurrentLocation) {
      return const Color(0xFFFF6B6B); // 当前位置用红色
    }

    // 为不同的定位记录使用不同的颜色
    final colors = [
      const Color(0xFF4ECDC4), // 蓝绿色
      const Color(0xFF45B7D1), // 蓝色
      const Color(0xFF96CEB4), // 绿色
      const Color(0xFFFECEA8), // 橙色
      const Color(0xFFFF9FF3), // 粉色
      const Color(0xFFFFD93D), // 黄色
      const Color(0xFFBADC58), // 浅绿色
      const Color(0xFFEE5A6F), // 红色
    ];

    return colors[index % colors.length];
  }

  /// 格式化位置时间显示
  String _formatLocationTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else {
      return '${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 地图网格绘制器
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderColor.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // 绘制网格线
    const gridSize = 20.0;

    // 垂直线
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // 水平线
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // 绘制一些道路样式的线条
    final roadPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.4)
      ..strokeWidth = 2.0;

    // 模拟道路
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.8, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
