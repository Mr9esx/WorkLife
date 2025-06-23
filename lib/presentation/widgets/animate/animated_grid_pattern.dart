import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGridPattern extends StatefulWidget {
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

  const AnimatedGridPattern({
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
  });

  @override
  State<AnimatedGridPattern> createState() => _AnimatedGridPatternState();
}

class _AnimatedGridPatternState extends State<AnimatedGridPattern>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final math.Random _random = math.Random();
  
  final List<List<int>> _tapSquares = [];
  final List<AnimationController> _tapControllers = [];
  final List<Animation<double>> _tapAnimations = [];

  @override
  void initState() {
    super.initState();
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

  void _handleTap(Offset localPosition, Size size) {
    if (!widget.enableTapInteraction) return;
    
    final gridX = (localPosition.dx / widget.gridSize).floor();
    final gridY = (localPosition.dy / widget.gridSize).floor();
    
    if (gridX >= 0 && gridY >= 0 && 
        gridX < (size.width / widget.gridSize).floor() && 
        gridY < (size.height / widget.gridSize).floor()) {
      
      setState(() {
        _tapSquares.add([gridX, gridY]);
      });
      
      final tapController = AnimationController(
        duration: Duration(milliseconds: 800),
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
      
      _tapControllers.add(tapController);
      _tapAnimations.add(tapAnimation);
      
      tapController.forward().then((_) {
        if (mounted) {
          setState(() {
            final index = _tapControllers.indexOf(tapController);
            if (index != -1) {
              _tapSquares.removeAt(index);
              _tapControllers.removeAt(index);
              _tapAnimations.removeAt(index);
              tapController.dispose();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var controller in _tapControllers) {
      controller.dispose();
    }
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
              child: CustomPaint(
                size: Size(constraints.maxWidth * 1.4, constraints.maxHeight * 1.4),
                painter: GridPatternPainter(
                  squares: widget.squares,
                  gridSize: widget.gridSize,
                  animations: _animations,
                  tapSquares: _tapSquares,
                  tapAnimations: _tapAnimations,
                  gridLineColor: widget.gridLineColor,
                  squareColor: widget.squareColor,
                  tapSquareColor: widget.tapSquareColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final List<List<int>> squares;
  final double gridSize;
  final List<Animation<double>> animations;
  final List<List<int>> tapSquares;
  final List<Animation<double>> tapAnimations;
  final Color gridLineColor;
  final Color squareColor;
  final Color tapSquareColor;

  GridPatternPainter({
    required this.squares,
    required this.gridSize,
    required this.animations,
    required this.tapSquares,
    required this.tapAnimations,
    required this.gridLineColor,
    required this.squareColor,
    required this.tapSquareColor,
  }) : super(repaint: Listenable.merge(animations));

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = gridLineColor
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width * 1.8; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height * 1.5),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height * 1.5; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final fillPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < squares.length && i < animations.length; i++) {
      final square = squares[i];

      final Rect squareRect = Rect.fromLTWH(
        square[0] * gridSize,
        square[1] * gridSize,
        gridSize,
        gridSize,
      );

      fillPaint.color = squareColor.withOpacity(animations[i].value);
      canvas.drawRect(squareRect, fillPaint);
    }

    final tapFillPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < tapSquares.length && i < tapAnimations.length; i++) {
      final tapSquare = tapSquares[i];

      final Rect tapSquareRect = Rect.fromLTWH(
        tapSquare[0] * gridSize,
        tapSquare[1] * gridSize,
        gridSize,
        gridSize,
      );

      tapFillPaint.color = tapSquareColor.withOpacity(tapAnimations[i].value);
      canvas.drawRect(tapSquareRect, tapFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Demo implementation with more squares
class GridBlinkerDemo extends StatelessWidget {
  const GridBlinkerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate more random squares for a more interesting pattern
    final random = math.Random();
    final squares = List.generate(
      20,
      (index) => [random.nextInt(20), random.nextInt(20)],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -100), // Adjust this value to move up
                child: AnimatedGridPattern(
                  squares: squares,
                  gridSize: 30, // Smaller grid size for more squares
                  skewAngle: 15, // Slightly more pronounced skew
                  blinkFrequency: 1.5, // 1.5秒一个周期
                  blinkRange: 0.7, // 闪动范围
                  minOpacity: 0.2, // 最小透明度
                  maxOpacity: 0.8, // 最大透明度
                  enableTapInteraction: true, // 启用点击交互
                  gridLineColor: Colors.white.withOpacity(0.5), // 网格线条颜色
                  squareColor: Colors.white, // 方块颜色
                  tapSquareColor: Colors.yellow, // 点击方块颜色
                ),
              ),
              Text(
                'GRID PATTERN',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
} 