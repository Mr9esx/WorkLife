import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:WeekLife/common/ui/color/color_light.dart';
import 'package:WeekLife/theme/button_style.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:WeekLife/routes/route_name.dart';
import 'dart:ui';
import 'dart:math';

class IntroCreate extends StatefulWidget {
  final Map<String, dynamic>? params;

  const IntroCreate({super.key, this.params});

  @override
  State<IntroCreate> createState() => _IntroCreateState();
}

class AnimationPreset {
  final String name;
  final TextAnimationStrategy strategy;
  final String description;

  const AnimationPreset({
    required this.name,
    required this.strategy,
    required this.description,
  });
}

class FlyingCharactersStrategy extends BaseAnimationStrategy {
  final double maxOffset;
  final bool randomDirection;
  final double angle;
  final bool enableBlur; // New property for blur effect
  final double maxBlur; // Maximum blur amount

  const FlyingCharactersStrategy({
    this.maxOffset = 100.0,
    this.randomDirection = true,
    this.angle = pi / 2,
    this.enableBlur = false, // Disabled by default
    this.maxBlur = 8.0, // Default blur amount
  }) : super();

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) {
        final actualAngle = randomDirection ? (Random().nextDouble() * 2 * pi) : angle;
        final offset = maxOffset * (1 - value);

        Widget child = Text(character, style: style);

        // Apply blur if enabled
        if (enableBlur) {
          child = ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: (1 - value) * maxBlur,
              sigmaY: (1 - value) * maxBlur,
            ),
            child: child,
          );
        }

        // Apply translation and opacity
        return Transform.translate(
          offset: Offset(
            cos(actualAngle) * offset,
            sin(actualAngle) * offset,
          ),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}

class _IntroCreateState extends State<IntroCreate> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final FDateFieldController _brithDateController;
  DateTime? birthDate;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late List<int> _years;
  late List<int> _months;
  late List<int> _days;
  late FPickerController _pickerController;

  @override
  void initState() {
    super.initState();
    _brithDateController = FDateFieldController(
      vsync: this,
      validator: _validateStartDate,
    );
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _selectedDay = now.day;
    _years = List.generate(now.year - 1900 + 1, (i) => 1900 + i);
    _months = List.generate(12, (i) => i + 1);
    _days = _getDaysInMonth(_selectedYear, _selectedMonth);
    _pickerController = FPickerController(
      initialIndexes: [
        _years.indexOf(_selectedYear),
        _months.indexOf(_selectedMonth),
        _days.indexOf(_selectedDay),
      ],
    );
  }

  List<int> _getDaysInMonth(int year, int month) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return List.generate(29, (i) => i + 1);
      } else {
        return List.generate(28, (i) => i + 1);
      }
    }
    if ([4, 6, 9, 11].contains(month)) return List.generate(30, (i) => i + 1);
    return List.generate(31, (i) => i + 1);
  }

  String? _validateStartDate(DateTime? date) {
    if (date == null) {
      return 'Please select a start date';
    }
    if (date.isBefore(DateTime.now())) {
      return 'Start date must be in the future';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    bool isAnimating = true;
    String demoText = "Flutter is pure magic! ✨";
    AnimationUnit selectedUnit = AnimationUnit.character;
    AnimationDirection direction = AnimationDirection.forward;
    late AnimationPreset selectedPreset = AnimationPreset(
      name: "Chaos Scatter with Blur",
      strategy: FlyingCharactersStrategy(
        maxOffset: 50,
        randomDirection: true,
        enableBlur: true,
      ),
      description: "Characters scatter in random directions",
    );
    TextEditingController textController = TextEditingController();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4), // APP-背景色
        body: Stack(
          children: <Widget>[
            // 底部渐变效果
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.15, // 渐变高度
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFFF4F4F4).withAlpha((0.8 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.6 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.4 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0.2 * 255).round()),
                      const Color(0xFFF4F4F4).withAlpha((0 * 255).round()),
                    ],
                    stops: const [0, 0.4, 0.6, 0.8, 1],
                  ),
                ),
              ),
            ),

            // 主要内容
            SafeArea(
              child: Column(
                children: [
                  // 顶部空间
                  SizedBox(height: screenHeight * 0.05),

                  // 主要内容区域
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 100.0,
                            ),
                            child: EnhancedTextRevealEffect(
                              text: demoText,
                              trigger: isAnimating,
                              // strategy: _selectedPreset.strategy,
                              unit: selectedUnit,
                              direction: direction,
                              style:
                                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primary),
                            ), // Replace with your actual widget
                          ),

                          const SizedBox(height: 16), // 固定16px间距

                          // SizedBox(
                          //   width: 300,
                          //   height: 180,
                          //   child: FPicker(
                          //     controller: _pickerController,
                          //     onChange: (indexes) {
                          //       setState(() {
                          //         _selectedYear = _years[indexes[0]];
                          //         _selectedMonth = _months[indexes[1]];
                          //         _days = _getDaysInMonth(_selectedYear, _selectedMonth);
                          //         // 防止天数越界
                          //         if (_selectedDay > _days.length) _selectedDay = _days.length;
                          //         _selectedDay = _days[indexes[2].clamp(0, _days.length - 1)];
                          //       });
                          //     },
                          //     children: [
                          //       FPickerWheel.builder(
                          //         flex: 3,
                          //         builder: (context, index) => Text('${_years[index]}年'),
                          //       ),
                          //       FPickerWheel.builder(
                          //         flex: 2,
                          //         builder: (context, index) => Text('${_months[index]}月'),
                          //       ),
                          //       FPickerWheel.builder(
                          //         flex: 2,
                          //         builder: (context, index) => Text('${_days[index]}日'),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // const SizedBox(height: 16), // 固定16px间距

                          // FButton(onPress: onPress, child: child)
                          SizedBox(
                            height: 60,
                            child: FButton(
                              onPress: () {
                                HapticFeedback.selectionClick();
                                // 跳转到主应用，并直接显示周记页面（index: 1）
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteName.appMain,
                                  arguments: {'pageId': 1}, // 1 对应周记 tab
                                );
                              },
                              style: buttonStyle(
                                colors: context.theme.colors,
                                typography: context.theme.typography,
                                style: context.theme.style,
                                color: AppColors.primary,
                                foregroundColor: AppColors.cardBackground,
                              ),
                              child: Text(
                                '然后呢？',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SourceHanSerif',
                                  fontVariations: [
                                    FontVariation('wght', 700), // 字重：700 (bold)
                                    // 如果字体支持其他轴，可以继续添加
                                    // FontVariation('wdth', 100), // 宽度
                                    // FontVariation('slnt', 0),   // 倾斜度
                                  ],
                                  height: 1,
                                ),
                              ),
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 1500.ms, color: AppColors.secondary.withOpacity(0.3), size: 3)
                              .animate() // this wraps the previous Animate in another Animate
                              .fadeIn(duration: 300.ms, curve: Curves.easeOutQuad)
                              .slide(),

                          SizedBox(height: 16),

                          SizedBox(height: screenHeight * 0.04), // 底部安全距离
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: FDateField.calendar(
    //       // label: Text('Appointment'),
    //       description: Text('Select a date for your appointment'),
    //     ),
    //   ),
    // );
  }
}

abstract class TextAnimationStrategy {
  final bool synchronizeAnimation;
  const TextAnimationStrategy({
    this.synchronizeAnimation = false,
  });

  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  });

  Animation<double> createAnimation({
    required AnimationController controller,
    required double startTime,
    required double endTime,
    required Curve curve,
  });
}

// Base Animation Strategy
class BaseAnimationStrategy extends TextAnimationStrategy {
  const BaseAnimationStrategy({
    super.synchronizeAnimation,
  });

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) => Text(character, style: style),
    );
  }

  @override
  Animation<double> createAnimation({
    required AnimationController controller,
    required double startTime,
    required double endTime,
    required Curve curve,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startTime, endTime, curve: curve),
      ),
    );
  }
}

// Animation Direction
enum AnimationDirection {
  forward,
  reverse,
}

// Animation Unit
enum AnimationUnit {
  character,
  word,
}

// Enhanced Animation Manager
class EnhancedTextAnimationManager {
  final AnimationController controller;
  final String text;
  final Curve curve;
  final AnimationUnit unit;
  final TextAnimationStrategy strategy;

  late final List<Animation<double>> _animations;
  late final List<String> _units;

  EnhancedTextAnimationManager({
    required this.controller,
    required this.text,
    required this.curve,
    required this.strategy,
    this.unit = AnimationUnit.character,
  }) {
    _units = _splitTextIntoUnits();
    _initializeAnimations();
  }

  List<String> _splitTextIntoUnits() {
    switch (unit) {
      case AnimationUnit.character:
        return text.split('');
      case AnimationUnit.word:
        // Early return for empty text
        if (text.isEmpty) return [];

        // Split text keeping spaces with words
        final List<String> words = [];
        final RegExp pattern = RegExp(r'\S+\s*');

        for (final match in pattern.allMatches(text)) {
          words.add(match.group(0)!);
        }

        return words;
    }
  }

  void _initializeAnimations() {
    if (_units.isEmpty) {
      _animations = [];
      return;
    }

    const double animationDuration = 0.8;
    const double totalAnimationTime = 1.0 + animationDuration;

    if (strategy.synchronizeAnimation) {
      // When synchronized, all characters use the same timing
      _animations = List.generate(_units.length, (index) {
        return strategy.createAnimation(
          controller: controller,
          startTime: 0.0, // All start together
          endTime: animationDuration, // All end together
          curve: curve,
        );
      });
    } else {
      final double staggerOffset =
          _units.length > 1 ? (totalAnimationTime - animationDuration) / (_units.length - 1) : 0.0;

      _animations = List.generate(_units.length, (index) {
        final double start = (index * staggerOffset / totalAnimationTime).clamp(0.0, 1.0);
        final double end = ((index * staggerOffset + animationDuration) / totalAnimationTime).clamp(0.0, 1.0);

        return strategy.createAnimation(
          controller: controller,
          startTime: start,
          endTime: end,
          curve: curve,
        );
      });
    }
  }

  Animation<double> getAnimationForIndex(int index) => _animations[index];
  String getUnitAtIndex(int index) => _units[index];
  int get unitCount => _units.length;

  void dispose() {
    _animations.clear();
  }
}

// Enhanced Text Reveal Widget
class EnhancedTextRevealEffect extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final bool trigger;
  final AnimationUnit unit;
  final TextAnimationStrategy strategy;
  final AnimationDirection direction;

  const EnhancedTextRevealEffect({
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    required this.trigger,
    this.unit = AnimationUnit.character,
    // Now this is const-correct!
    this.strategy = const FadeBlurStrategy(),
    this.direction = AnimationDirection.forward,
    super.key,
  });

  @override
  State<EnhancedTextRevealEffect> createState() => _EnhancedTextRevealEffectState();
}

class _EnhancedTextRevealEffectState extends State<EnhancedTextRevealEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late EnhancedTextAnimationManager _animationManager;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addStatusListener(_handleAnimationStatus);
    _initializeAnimationManager();

    // If trigger is true initially, show the animation
    if (widget.trigger) {
      _isVisible = true;
      _controller.forward();
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        _isVisible = false;
      });
    } else if (status == AnimationStatus.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  void _initializeAnimationManager() {
    _animationManager = EnhancedTextAnimationManager(
      controller: _controller,
      text: widget.text,
      curve: widget.curve,
      unit: widget.unit,
      strategy: widget.strategy,
    );
  }

  @override
  void didUpdateWidget(EnhancedTextRevealEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle trigger changes
    if (widget.trigger != oldWidget.trigger) {
      if (widget.trigger) {
        setState(() {
          _isVisible = true;
        });
        if (widget.direction == AnimationDirection.forward) {
          _controller.forward(from: 0);
        } else {
          _controller.reverse(from: 1);
        }
      } else {
        if (widget.direction == AnimationDirection.forward) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      }
    }

    // Handle content or strategy changes
    if (widget.text != oldWidget.text || widget.unit != oldWidget.unit || widget.strategy != oldWidget.strategy) {
      _animationManager.dispose();
      _initializeAnimationManager();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink(); // Hide when not visible

    return Wrap(
      children: List.generate(
        _animationManager.unitCount,
        (index) => widget.strategy.buildAnimatedCharacter(
          character: _animationManager.getUnitAtIndex(index),
          animation: _animationManager.getAnimationForIndex(index),
          style: widget.style,
        ),
      ),
    );
  }
}

class FadeBlurStrategy extends BaseAnimationStrategy {
  final double maxBlur;

  const FadeBlurStrategy({this.maxBlur = 8.0}) : super(); // Make constructor const

  @override
  Widget buildAnimatedCharacter({
    required String character,
    required Animation<double> animation,
    TextStyle? style,
  }) {
    return ValueListenableBuilder<double>(
      valueListenable: animation,
      builder: (context, value, _) => Opacity(
        opacity: value,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: (1 - value) * maxBlur,
            sigmaY: (1 - value) * maxBlur,
          ),
          child: Text(character, style: style),
        ),
      ),
    );
  }
}
