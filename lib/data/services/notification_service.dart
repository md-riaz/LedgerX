import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/reminder.dart';
import '../../utils/platform_utils.dart';

const _windowsAppName = 'LedgerX';
const _windowsAppUserModelId = 'com.ledgerx.app';
const _windowsGuid = '5a829a22-59c3-4b8f-a8d5-28c8a4630bd8';

class NotificationService {
  NotificationService() {
    _logWebWarning();
  }

  final FlutterLocalNotificationsPlugin? _notifications =
      PlatformUtils.isWeb ? null : FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (PlatformUtils.isWeb) {
      _logWebWarning('initialize');
      return;
    }

    final notifications = _notifications!;
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const windowsSettings = WindowsInitializationSettings(
      appName: _windowsAppName,
      appUserModelId: _windowsAppUserModelId,
      guid: _windowsGuid,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
      windows: windowsSettings,
    );

    await notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Apple platforms
    await notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await notifications
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request permissions for Android 13+
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to a specific page based on the payload
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    if (PlatformUtils.isWeb) {
      _logWebWarning('scheduleReminder');
      return;
    }

    if (reminder.isCompleted) return;

    const androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const macDetails = DarwinNotificationDetails();
    const linuxDetails = LinuxNotificationDetails();
    const windowsDetails = WindowsNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    final scheduledDate = tz.TZDateTime.from(reminder.dueDate, tz.local);

    await _notifications!.zonedSchedule(
      reminder.id!,
      reminder.title,
      reminder.description ?? 'Reminder notification',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id.toString(),
    );
  }

  Future<void> cancelReminder(int reminderId) async {
    if (PlatformUtils.isWeb) {
      _logWebWarning('cancelReminder');
      return;
    }

    await _notifications!.cancel(reminderId);
  }

  Future<void> cancelAllReminders() async {
    if (PlatformUtils.isWeb) {
      _logWebWarning('cancelAllReminders');
      return;
    }

    await _notifications!.cancelAll();
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (PlatformUtils.isWeb) {
      _logWebWarning('showInstantNotification');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Channel for instant notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const macDetails = DarwinNotificationDetails();
    const linuxDetails = LinuxNotificationDetails();
    const windowsDetails = WindowsNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macDetails,
      linux: linuxDetails,
      windows: windowsDetails,
    );

    await _notifications!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _logWebWarning([String? context]) {
    if (!PlatformUtils.isWeb) {
      return;
    }

    final buffer = StringBuffer(
      'LedgerX: Local notifications are not supported on the web yet.',
    );
    if (context != null) {
      buffer.write(' (Called: $context)');
    }
    debugPrint(buffer.toString());
  }
}
