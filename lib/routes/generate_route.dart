import 'package:flutter/material.dart';
import 'package:WeekLife/presentation/pages/error_page/error_page.dart';
import 'package:WeekLife/routes/routes_data.dart'; // 路由页面定义
import 'package:WeekLife/routes/route_name.dart'; // 路由名称

typedef RouterDataV = StatefulWidget Function(BuildContext context,
    {dynamic params});

/// 路由动画类型枚举
enum RouteAnimationType {
  /// 无动画
  none,
  /// 默认Material动画（滑动）
  material,
  /// 淡入淡出
  fade,
  /// 从右侧滑入
  slideFromRight,
  /// 从左侧滑入
  slideFromLeft,
  /// 从上方滑入
  slideFromTop,
  /// 从下方滑入
  slideFromBottom,
  /// 缩放动画
  scale,
  /// 旋转动画
  rotation,
  /// 淡入+缩放组合
  fadeScale,
}

/// 路由动画配置类
class RouteAnimationConfig {
  final RouteAnimationType animationType;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;

  const RouteAnimationConfig({
    this.animationType = RouteAnimationType.material,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });
}

/// 页面路由动画配置映射
/// 可以为每个页面单独配置动画效果
final Map<String, RouteAnimationConfig> pageAnimationConfigs = {
  // intro 页面使用无动画
  RouteName.intro: const RouteAnimationConfig(
    animationType: RouteAnimationType.none,
  ),
  
  // 登录页面使用淡入淡出
  RouteName.login: const RouteAnimationConfig(
    animationType: RouteAnimationType.fade,
    duration: Duration(milliseconds: 400),
  ),
  
  // 注册页面使用从下方滑入
  RouteName.register: const RouteAnimationConfig(
    animationType: RouteAnimationType.slideFromBottom,
    duration: Duration(milliseconds: 350),
  ),
  
  // 错误页面使用缩放动画
  RouteName.error: const RouteAnimationConfig(
    animationType: RouteAnimationType.scale,
    duration: Duration(milliseconds: 250),
  ),
  
  // 测试页面使用淡入+缩放组合
  RouteName.testDemo: const RouteAnimationConfig(
    animationType: RouteAnimationType.fadeScale,
    duration: Duration(milliseconds: 400),
  ),
  
  // 主页面使用默认动画
  RouteName.appMain: const RouteAnimationConfig(
    animationType: RouteAnimationType.fade,
    duration: Duration(milliseconds: 300),
  ),
  
  // 闪屏页使用淡入淡出
  RouteName.splashPage: const RouteAnimationConfig(
    animationType: RouteAnimationType.fade,
    duration: Duration(milliseconds: 500),
  ),
};

/// 路由动画构建器
class RouteAnimationBuilder {
  /// 根据动画类型创建对应的动画
  static Widget buildTransition(
    RouteAnimationType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
    
    switch (type) {
      case RouteAnimationType.none:
        return child;
        
      case RouteAnimationType.material:
        // 使用默认的Material动画，这里返回child让MaterialPageRoute处理
        return child;
        
      case RouteAnimationType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
        
      case RouteAnimationType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        );
        
      case RouteAnimationType.fadeScale:
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
    }
  }
}

// 统一封装路由传递参数
Route<dynamic> generateRoute(RouteSettings settings) {
  final String? name = settings.name; // 当前传入的路由名称
  final Object? args = settings.arguments; // 路由参数
  final RouterDataV? pageContentBuilder = routesData[name]; // 获取路由指定组件函数
  final RouteSettings settingsData = RouteSettings(
    name: name,
    arguments: args,
  );

  // 容错路由
  if (pageContentBuilder == null) {
    return MaterialPageRoute(
      builder: (BuildContext context) => ErrorPage(params: args),
      settings: settingsData,
    );
  }

  // 获取页面动画配置，如果没有配置则使用默认Material动画
  final animationConfig = pageAnimationConfigs[name] ?? 
      const RouteAnimationConfig(animationType: RouteAnimationType.material);

  // 如果是Material动画类型，使用MaterialPageRoute
  if (animationConfig.animationType == RouteAnimationType.material) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return pageContentBuilder(context, params: args);
      },
      settings: settingsData,
    );
  }

  // 使用自定义动画的PageRouteBuilder
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return pageContentBuilder(context, params: args);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return RouteAnimationBuilder.buildTransition(
        animationConfig.animationType,
        animation,
        secondaryAnimation,
        child,
        animationConfig.curve,
      );
    },
    transitionDuration: animationConfig.duration,
    reverseTransitionDuration: animationConfig.reverseDuration,
    settings: settingsData,
  );
}
