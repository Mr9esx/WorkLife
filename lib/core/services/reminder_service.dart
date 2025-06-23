import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:WeekLife/data/models/todo_record/todo_record_data.dart';

/// TODO提醒服务
/// 负责处理TODO的本地通知和系统日历同步
class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isInitialized = false;

  /// 初始化提醒服务
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 初始化时区数据
    tz.initializeTimeZones();

    // 初始化本地通知插件
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android初始化设置
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS初始化设置
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 请求权限
    await _requestPermissions();

    _isInitialized = true;
  }

  /// 请求通知权限
  Future<void> _requestPermissions() async {
    if (_flutterLocalNotificationsPlugin == null) return;

    // Android权限请求
    await _flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS权限请求
    await _flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// 处理通知点击事件
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    debugPrint('通知被点击: ${notificationResponse.payload}');
    // 这里可以添加导航到具体TODO的逻辑
  }

  /// 为TODO设置提醒
  Future<void> setTodoReminder(TodoRecordData todo) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (todo.reminderTime == null || _flutterLocalNotificationsPlugin == null) {
      return;
    }

    final notificationId = todo.id ?? DateTime.now().millisecondsSinceEpoch;

    // 设置本地通知
    await _scheduleNotification(
      notificationId,
      '待办事项提醒',
      todo.content,
      todo.reminderTime!,
      payload: 'todo_${todo.id}',
    );

    // 添加到系统日历
    await _addToCalendar(todo);
  }

  /// 取消TODO提醒
  Future<void> cancelTodoReminder(int todoId) async {
    if (!_isInitialized || _flutterLocalNotificationsPlugin == null) return;

    await _flutterLocalNotificationsPlugin!.cancel(todoId);
  }

  /// 安排本地通知
  Future<void> _scheduleNotification(int id, String title, String body, DateTime scheduledDate,
      {String? payload}) async {
    if (_flutterLocalNotificationsPlugin == null) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'todo_reminders',
      'TODO提醒',
      channelDescription: 'WeekLife待办事项提醒通知',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // 转换为时区时间
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    // 只有未来时间才能安排通知
    if (tzScheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await _flutterLocalNotificationsPlugin!.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }

  /// 添加到系统日历
  Future<void> _addToCalendar(TodoRecordData todo) async {
    if (todo.reminderTime == null) return;

    try {
      final Event event = Event(
        title: '待办事项: ${todo.content}',
        description: '来自WeekLife的待办事项提醒',
        location: '',
        startDate: todo.reminderTime!,
        endDate: todo.reminderTime!.add(const Duration(hours: 1)), // 默认1小时时长
        allDay: false,
      );

      await Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      debugPrint('添加到日历失败: $e');
    }
  }

  /// 更新TODO提醒
  Future<void> updateTodoReminder(TodoRecordData todo) async {
    // 先取消旧的提醒
    if (todo.id != null) {
      await cancelTodoReminder(todo.id!);
    }

    // 设置新的提醒
    await setTodoReminder(todo);
  }

  /// 格式化提醒时间显示
  static String formatReminderTime(DateTime reminderTime) {
    return '${reminderTime.year}-${reminderTime.month.toString().padLeft(2, '0')}-${reminderTime.day.toString().padLeft(2, '0')} ${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';
  }

  /// 检查是否有权限
  Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_flutterLocalNotificationsPlugin == null) return false;

    // 检查Android权限
    final androidImplementation = _flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.areNotificationsEnabled();
      return granted ?? false;
    }

    // iOS默认返回true，因为权限在初始化时已经请求
    return true;
  }
}
