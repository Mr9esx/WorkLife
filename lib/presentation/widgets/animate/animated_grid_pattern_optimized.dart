import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGridPatternOptimized extends StatefulWidget {
  final List<List<int>> squares;
  final double gridSize;
  final double skewAngle;
  final double blinkFrequency;
  final double blinkRange;
  final double minOpacity;
  final double maxOpacity;
  final bool enableTapInteraction;
  final Color gridLineColor;
  final Color squareColor;
  final Color tapSquareColor;
  final int maxTapSquares; // 限制点击方块数量

  const AnimatedGridPatternOptimized({
    super.key,
    required this.squares,
    this.gridSize = 40,
    this.skewAngle = 12,
    this.blinkFrequency = 2.0,
    this.blinkRange = 0.8,
    this.minOpacity = 0.1,
    this.maxOpacity = 0.9,
    this.enableTapInteraction = true,
    this.gridLineColor = Colors.grey,
    this.squareColor = Colors.grey,
    this.tapSquareColor = Colors.blue,
    this.maxTapSquares = 10, // 限制最大点击方块数量
  });

  @override
  State<AnimatedGridPatternOptimized> createState() => _AnimatedGridPatternOptimizedState();
}

class _AnimatedGridPatternOptimizedState extends State<AnimatedGridPatternOptimized>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final math.Random _random = math.Random();
  
  // 使用 ValueNotifier 减少重建
  late ValueNotifier<List<TapSquareData>> _tapSquaresNotifier;
  
  // 缓存网格线路径
  Path? _gridLinesPath;
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _tapSquaresNotifier = ValueNotifier<List<TapSquareData>>([]);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.squares.length,
      (index) {
        final baseDuration = (widget.blinkFrequency * 1000).round();
        final randomVariation = _random.nextInt(1000);
        final controller = AnimationController(
          duration: Duration(milliseconds: baseDuration + randomVariation),
          vsync: this,
        );

        final startDelay = _random.nextInt(2000);
        Future.delayed(Duration(milliseconds: startDelay), () {
          if (mounted) {
            controller.repeat(reverse: true);
          }
        });

        return controller;
      },
    );

    _animations = _controllers.asMap().entries.map((entry) {
      final controller = entry.value;
      
      final curves = [
        Curves.easeInOutSine,
        Curves.easeInOutQuad,
        Curves.easeInOutCubic,
        Curves.fastOutSlowIn,
        Curves.slowMiddle,
      ];
      final randomCurve = curves[_random.nextInt(curves.length)];
      
      return Tween<double>(
        begin: widget.minOpacity, 
        end: widget.maxOpacity,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: randomCurve,
        ),
      );
    }).toList();
  }

  // 优化：使用对象池模式管理点击方块
  void _handleTap(Offset localPosition, Size size) {
    if (!widget.enableTapInteraction) return;
    
    final gridX = (localPosition.dx / widget.gridSize).floor();
    final gridY = (localPosition.dy / widget.gridSize).floor();
    
    if (gridX >= 0 && gridY >= 0 && 
        gridX < (size.width / widget.gridSize).floor() && 
        gridY < (size.height / widget.gridSize).floor()) {
      
      final currentTapSquares = _tapSquaresNotifier.value;
      
      // 限制最大点击方块数量，移除最旧的
      if (currentTapSquares.length >= widget.maxTapSquares) {
        final oldestSquare = currentTapSquares.first;
        oldestSquare.controller.dispose();
        currentTapSquares.removeAt(0);
      }
      
      final tapController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      
      final tapAnimation = Tween<double>(
        begin: widget.maxOpacity,
        end: widget.minOpacity,
      ).animate(
        CurvedAnimation(
          parent: tapController,
          curve: Curves.easeOutQuart,
        ),
      );
      
      final tapSquareData = TapSquareData(
        gridX: gridX,
        gridY: gridY,
        controller: tapController,
        animation: tapAnimation,
      );
      
      currentTapSquares.add(tapSquareData);
      _tapSquaresNotifier.value = List.from(currentTapSquares);
      
      // 启动动画，完成后自动移除
      tapController.forward().then((_) {
        if (mounted) {
          final updatedSquares = _tapSquaresNotifier.value;
          updatedSquares.remove(tapSquareData);
          _tapSquaresNotifier.value = List.from(updatedSquares);
          tapController.dispose();
        }
      });
    }
  }

  // 缓存网格线路径
  Path _buildGridLinesPath(Size size) {
    if (_gridLinesPath != null && _lastSize == size) {
      return _gridLinesPath!;
    }
    
    final path = Path();
    
    // 垂直线
    for (double x = 0; x <= size.width * 1.8; x += widget.gridSize) {
      path.moveTo(x, 0);
      path.lineTo(x, size.height * 1.5);
    }
    
    // 水平线
    for (double y = 0; y <= size.height * 1.5; y += widget.gridSize) {
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    
    _gridLinesPath = path;
    _lastSize = size;
    return path;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var tapSquare in _tapSquaresNotifier.value) {
      tapSquare.controller.dispose();
    }
    _tapSquaresNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Transform(
            transform: Matrix4.skewY(widget.skewAngle * math.pi / 400),
            child: GestureDetector(
              onTapDown: widget.enableTapInteraction 
                ? (details) => _handleTap(details.localPosition, Size(constraints.maxWidth * 1.4, constraints.maxHeight * 1.4))
                : null,
              child: ValueListenableBuilder<List<TapSquareData>>(
                valueListenable: _tapSquaresNotifier,
                builder: (context, tapSquares, child) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth * 1.4, constraints.maxHeight * 1.4),
                    painter: OptimizedGridPatternPainter(
                      squares: widget.squares,
                      gridSize: widget.gridSize,
                      animations: _animations,
                      tapSquares: tapSquares,
                      gridLineColor: widget.gridLineColor,
                      squareColor: widget.squareColor,
                      tapSquareColor: widget.tapSquareColor,
                      gridLinesPathBuilder: _buildGridLinesPath,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// 数据类，封装点击方块信息
class TapSquareData {
  final int gridX;
  final int gridY;
  final AnimationController controller;
  final Animation<double> animation;

  TapSquareData({
    required this.gridX,
    required this.gridY,
    required this.controller,
    required this.animation,
  });
}

class OptimizedGridPatternPainter extends CustomPainter {
  final List<List<int>> squares;
  final double gridSize;
  final List<Animation<double>> animations;
  final List<TapSquareData> tapSquares;
  final Color gridLineColor;
  final Color squareColor;
  final Color tapSquareColor;
  final Path Function(Size) gridLinesPathBuilder;

  OptimizedGridPatternPainter({
    required this.squares,
    required this.gridSize,
    required this.animations,
    required this.tapSquares,
    required this.gridLineColor,
    required this.squareColor,
    required this.tapSquareColor,
    required this.gridLinesPathBuilder,
  }) : super(repaint: Listenable.merge([
    ...animations,
    ...tapSquares.map((e) => e.animation),
  ]));

  @override
  void paint(Canvas canvas, Size size) {
    // 使用缓存的网格线路径
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = gridLineColor
      ..strokeWidth = 0.5;

    final gridPath = gridLinesPathBuilder(size);
    canvas.drawPath(gridPath, gridPaint);

    // 绘制动画方块 - 批量处理
    final fillPaint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < squares.length && i < animations.length; i++) {
      final square = squares[i];
      final opacity = animations[i].value;
      
      // 跳过完全透明的方块
      if (opacity <= 0.01) continue;

      final rect = Rect.fromLTWH(
        square[0] * gridSize,
        square[1] * gridSize,
        gridSize,
        gridSize,
      );

      fillPaint.color = squareColor.withOpacity(opacity);
      canvas.drawRect(rect, fillPaint);
    }

    // 绘制点击方块
    final tapFillPaint = Paint()..style = PaintingStyle.fill;
    
    for (final tapSquare in tapSquares) {
      final opacity = tapSquare.animation.value;
      
      // 跳过完全透明的方块
      if (opacity <= 0.01) continue;

      final rect = Rect.fromLTWH(
        tapSquare.gridX * gridSize,
        tapSquare.gridY * gridSize,
        gridSize,
        gridSize,
      );

      tapFillPaint.color = tapSquareColor.withOpacity(opacity);
      canvas.drawRect(rect, tapFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OptimizedGridPatternPainter oldDelegate) {
    // 只在必要时重绘
    return oldDelegate.squares != squares ||
           oldDelegate.gridSize != gridSize ||
           oldDelegate.tapSquares.length != tapSquares.length ||
           oldDelegate.gridLineColor != gridLineColor ||
           oldDelegate.squareColor != squareColor ||
           oldDelegate.tapSquareColor != tapSquareColor;
  }
}

// 优化的随机方块生成函数 - 使用缓存
class SquareGenerator {
  static final Map<String, List<List<int>>> _cache = {};
  
  static List<List<int>> generateRandomSquares(
    double screenWidth, 
    double screenHeight, {
    double gridSizeRatio = 0.1,
    int? seed,
  }) {
    final cacheKey = '${screenWidth}_${screenHeight}_${gridSizeRatio}_${seed ?? 'random'}';
    
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final random = seed != null ? math.Random(seed) : math.Random();
    final squares = <List<int>>[];
    final gridSize = screenWidth * gridSizeRatio;
    
    final maxGridX = (screenWidth * 1.5 / gridSize).floor();
    final maxGridY = (screenHeight * 1.5 / gridSize).floor();
    
    final squareCount = 20 + random.nextInt(11);
    
    for (int i = 0; i < squareCount; i++) {
      squares.add([
        random.nextInt(maxGridX),
        random.nextInt(maxGridY),
      ]);
    }
    
    // 限制缓存大小
    if (_cache.length > 10) {
      _cache.clear();
    }
    
    _cache[cacheKey] = squares;
    return squares;
  }
} 