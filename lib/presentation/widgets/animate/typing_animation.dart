import 'package:flutter/material.dart';
import 'dart:async';

class TypingAnimation extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration delay; // 延时开始动画的时间
  final TextStyle? style;
  final bool animate;
  final VoidCallback? onCharacterTyped; // 每次打印字符时的回调函数
  final VoidCallback? onAnimationComplete; // 动画完成时的回调函数
  final VoidCallback? onAnimationStart; // 动画开始时的回调函数

  const TypingAnimation({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 100),
    this.delay = Duration.zero, // 默认无延时
    this.style,
    this.animate = false,
    this.onCharacterTyped,
    this.onAnimationComplete,
    this.onAnimationStart,
  });

  @override
  _TypingAnimationState createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _timer;
  Timer? _delayTimer;
  bool _isDelaying = false; // 是否正在延时中
  bool _hasStarted = false; // 动画是否已经开始

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _startWithDelay();
    }
  }

  @override
  void didUpdateWidget(TypingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _startWithDelay();
    } else if (!widget.animate && oldWidget.animate) {
      _stopAnimation();
    }
  }

  void _startWithDelay() {
    _hasStarted = false;
    _isDelaying = true;
    
    if (widget.delay.inMilliseconds > 0) {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) {
          setState(() {
            _isDelaying = false;
          });
          _startAnimation();
        }
      });
    } else {
      _isDelaying = false;
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (!_hasStarted) {
      _hasStarted = true;
      widget.onAnimationStart?.call(); // 调用动画开始回调
    }
    
    _charIndex = 0;
    _displayedText = '';
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _charIndex + 1);
          _charIndex++;
        });
        
        // 调用每次打印字符的回调函数
        widget.onCharacterTyped?.call();
      } else {
        _stopAnimation();
        // 调用动画完成的回调函数
        widget.onAnimationComplete?.call();
      }
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
    _delayTimer?.cancel();
    _delayTimer = null;
    _isDelaying = false;
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果正在延时中，显示空文本或者可以显示一个光标
    String displayText = '';
    if (_isDelaying) {
      displayText = ''; // 延时期间显示空文本
    } else if (widget.animate) {
      displayText = _displayedText;
    } else {
      displayText = widget.text;
    }

    return Text(
      displayText,
      textAlign: TextAlign.center,
      style: widget.style ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
    );
  }
} 