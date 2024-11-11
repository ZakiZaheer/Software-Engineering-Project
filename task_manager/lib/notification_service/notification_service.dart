import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task/taskReminder_modal.dart';
import 'package:task_manager/model/task/task_modal.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    // Request permission for notifications
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Request permission for exact alarms (needed for Android 13+)
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> cancelTaskReminders(Task task) async {
    for (int i = 0; i < task.reminders!.length; i++) {
      await notificationsPlugin.cancel(task.id! * 100 + i);
    }
  }

  static Future<void> cancelModifiedTaskReminders(
      List<TaskReminder> reminders) async {
    for (int i = 0; i < reminders.length; i++) {
      await notificationsPlugin.cancel(reminders[0].taskId! * 100 + i);
    }
    }

  static Future<void> scheduleTaskAlarmReminder(Task task) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter_sound',
        'taskManager_sound',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('b'),
        vibrationPattern: vibrationPattern,
        // Vibration pattern
        enableVibration: true, // Enable vibration
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await scheduleTaskReminder(task, notificationDetails);
  }

  static Future<void> scheduleTaskDefaultReminder(Task task) async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter_default',
        'taskManager_default',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(), // No sound for iOS
    );
    await scheduleTaskReminder(task, notificationDetails);
  }

  static Future<void> scheduleTaskReminder(
      Task task, NotificationDetails notificationDetails) async {
    final DateTime taskDateTime = DateFormat("yyyy-MM-dd HH:mm")
        .parse("${task.date} ${task.time ?? "00:00 AM"}");
    DateTime reminderTime;
    for (int i = 0; i < task.reminders!.length; i++) {
      final reminder = task.reminders![i];
      // Calculate reminder time based on reminder unit and interval
      if (reminder.reminderUnit == 'Minute') {
        int minutes = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(minutes: minutes));
      } else if (reminder.reminderUnit == "Hour") {
        int hours = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(hours: hours));
      } else if (reminder.reminderUnit == "Day") {
        int days = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Week") {
        int days = reminder.reminderInterval * 7;
        reminderTime = taskDateTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Month") {
        int month = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year,
          taskDateTime.month - month,
          taskDateTime.day,
        );
      } else {
        int year = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year - year,
          taskDateTime.month,
          taskDateTime.day,
        );
      }

      // Schedule notification if reminder time is in the future
      if (reminderTime.isAfter(DateTime.now())) {
        await notificationsPlugin.zonedSchedule(
          (task.id! * 100 + i),
          task.title,
          task.description,
          tz.TZDateTime.from(reminderTime, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // New scheduling mode
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }



  static Future<void> instantNotification(
    String title,
    String body,
  ) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter_voice', // Channel ID
        'taskManager_voice', // Channel name
        importance: Importance.high,
        priority: Priority.high,
        enableVibration:true,
        playSound: true,
        vibrationPattern: vibrationPattern,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await notificationsPlugin.show(
      0, // Notification ID (can be any integer)
      title, // Notification title
      body, // Notification body
      notificationDetails,
      payload: title, // Optional payload to send with the notification
    );
  }
}
