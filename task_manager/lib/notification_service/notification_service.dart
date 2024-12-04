import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_manager/model/event/event_reminder_modal.dart';
import 'package:task_manager/model/task/taskReminder_modal.dart';
import 'package:task_manager/model/task/task_modal.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/event/event_modal.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse response) async {
    if (response.payload == 'anniversary' || response.payload == 'birthday') {
      final file = await saveImageToCache(
          '${response.payload}.png'); // Replace with the actual path
      await shareImage(file);
    }
  }

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


  static Future<File> saveImageToCache(String assetName) async {
    final byteData = await rootBundle.load('assets/$assetName');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/anniversary.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  static Future<void> shareImage(File imageFile) async {
    await Share.shareXFiles([XFile(imageFile.path)],
        text: 'Check out this image!');
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

  static Future<void> cancelEventReminders(Event event) async {
    for (int i = 0; i < event.reminders!.length; i++) {
      await notificationsPlugin.cancel(event.id! * 100 + i);
    }
  }

  static Future<void> cancelModifiedEventReminders(
      List<EventReminder> reminders) async {
    for (int i = 0; i < reminders.length; i++) {
      await notificationsPlugin.cancel(reminders[0].eventId! * 100 + i);
    }
  }

  static Future<void> scheduleEventDefaultReminder(Event event) async {
    print("Scheduling Event Default Reminders");
    BigPictureStyleInformation? bigPictureStyleInformation;
    String? payload;
    if ((event.eventType == "Birthday" || event.eventType == "Anniversary") &&
        event.smartSuggestion) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(
            '@mipmap/${event.eventType == "Birthday" ? "birthday" : "anniversary"}'),
        // Replace with your image name
        largeIcon: DrawableResourceAndroidBitmap(
            '@mipmap/${event.eventType == "Birthday" ? "birthday" : "anniversary"}'),
        contentTitle:
            'Wish Happy  ${event.eventType == "Birthday" ? 'birthday' : "anniversary"} to ${event.title}',
        summaryText: 'Click to share',
      );
      payload = event.eventType == "Birthday" ? 'birthday' : "anniversary";
    }
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter_defaultas',
        'taskManager_defaultas',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        // styleInformation: bigPictureStyleInformation,
      ),
      iOS: DarwinNotificationDetails(), // No sound for iOS
    );
    await scheduleEventReminder(event, notificationDetails,payload);
  }

  static Future<void> scheduleEventAlarmReminder(Event event) async {
    print("Scheduling Event Alarm Reminders");
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    BigPictureStyleInformation? bigPictureStyleInformation;
    String? payload;
    if ((event.eventType == "Birthday" || event.eventType == "Anniversary") &&
        event.smartSuggestion) {

      bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(
            '@mipmap/${event.eventType == "Birthday" ? "birthday" : "anniversary"}'),
        // Replace with your image name
        largeIcon: DrawableResourceAndroidBitmap(
            '@mipmap/${event.eventType == "Birthday" ? "birthday" : "anniversary"}'),
        contentTitle:
            'Wish Happy  ${event.eventType == "Birthday" ? 'birthday' : "anniversary"} to ${event.title}',
        summaryText: 'Click to share',
      );
      event.eventType == "Birthday" ? 'birthday' : "anniversary";

    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('BeasBetter_sound', 'taskManasager_sound',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('b'),
          vibrationPattern: vibrationPattern,
          // Vibration pattern
          enableVibration: true,
          // styleInformation: bigPictureStyleInformation // Enable vibration
          ),
      iOS: const DarwinNotificationDetails(),
    );
    await scheduleEventReminder(event, notificationDetails,payload);
  }

  static Future<void> scheduleEventReminder(
      Event event, NotificationDetails notificationDetails,String? payload) async {
    final DateTime eventStartTime = event.startTime;
    DateTime reminderTime;
    for (int i = 0; i < event.reminders!.length; i++) {
      final EventReminder reminder = event.reminders![i];
      // Calculate reminder time based on reminder unit and interval
      if (reminder.reminderUnit == 'Minute') {
        int minutes = reminder.reminderInterval;
        reminderTime = eventStartTime.subtract(Duration(minutes: minutes));
      } else if (reminder.reminderUnit == "Hour") {
        int hours = reminder.reminderInterval;
        reminderTime = eventStartTime.subtract(Duration(hours: hours));
      } else if (reminder.reminderUnit == "Day") {
        int days = reminder.reminderInterval;
        reminderTime = eventStartTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Week") {
        int days = reminder.reminderInterval * 7;
        reminderTime = eventStartTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Month") {
        int month = reminder.reminderInterval;
        reminderTime = DateTime(
          eventStartTime.year,
          eventStartTime.month - month,
          eventStartTime.day,
        );
      } else {
        int year = reminder.reminderInterval;
        reminderTime = DateTime(
          eventStartTime.year - year,
          eventStartTime.month,
          eventStartTime.day,
        );
      }

      // Schedule notification if reminder time is in the future
      if (reminderTime.isAfter(DateTime.now())) {
        print("Reminder Scheduled For $reminderTime");
        await notificationsPlugin.zonedSchedule(
          (event.id! * 100 + i),
          event.title,
          event.description,
          tz.TZDateTime.from(reminderTime, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // New scheduling mode
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // payload: payload
        );
      }
    }
  }

  static Future<void> instantNotification(
    String title,
    String body,
    String type,
  ) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    BigPictureStyleInformation? bigPictureStyleInformation;
    String? payload;
    if ((type == "Birthday" || type == "Anniversary")) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(
            '@mipmap/${type == "Birthday" ? "birthday" : "anniversary"}'),
        // Replace with your image name
        largeIcon: DrawableResourceAndroidBitmap(
            '@mipmap/${type == "Birthday" ? "birthday" : "anniversary"}'),
        contentTitle: 'Notification with Image',
        summaryText: 'This is an example of a notification with an image.',
      );
      payload = type == "Birthday" ? 'birthday' : "anniversary";
    }
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter_voice', // Channel ID
        'taskManager_voice', // Channel name
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        vibrationPattern: vibrationPattern,
        styleInformation: bigPictureStyleInformation,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await notificationsPlugin.show(
      0, // Notification ID (can be any integer)
      title, // Notification title
      body, // Notification body
      notificationDetails,
      payload: payload, // Optional payload to send with the notification
    );
  }
}
