import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/task_modal.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {
    // Handle the notification tap
    final String notificationTitle = notificationResponse.payload!;

    // Call TTS to speak the notification content
    // TtsService ttsService = TtsService();
    // print("Playing Title");
    // await ttsService.speak(notificationTitle); // or you can read notificationBody
  }
  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
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
  static Future<void> cancelModifiedTaskReminders(List<TaskReminder>? reminders)async{
    if(reminders != null){
      int taskId = reminders[0].taskId!;
      for (int i = 0; i < reminders.length; i++) {
        await notificationsPlugin.cancel(taskId * 100 + i);
      }
    }

  }



  static Future<void> scheduleTaskReminder(Task task) async {
    // Define notification details based on reminder type
    NotificationDetails notificationDetails;

    if (task.reminders![0].reminderType == "Default") {
      notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'BeBetter',
          'taskManager',
          importance: Importance.high,
          priority: Priority.high,
          playSound: false, // No sound for default type
        ),
        iOS: DarwinNotificationDetails(presentSound: false), // No sound for iOS
      );
    } else if(task.reminders![0].reminderType == "Alarm") {
      print("ALarm Scheduled");
      notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'BeBetter',
          'taskManager',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm'), // Custom sound file
        ),
      );
    }
    else{
      notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'BeBetter',
          'taskManager',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm'), // Custom sound file
        ),
      );
    }


    final DateTime taskDateTime =
    DateFormat("yyyy-MM-dd HH:mm").parse("${task.date} ${task.time ?? "00:00 AM"}");
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
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // New scheduling mode
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }



  static Future<void> instantNotification(
      String title, String body,) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'BeBetter', // Channel ID
        'taskManager', // Channel name
        importance: Importance.high,
        priority: Priority.high,
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


//
//
// class TtsService {
//   final FlutterTts _flutterTts;
//
//   TtsService() : _flutterTts = FlutterTts();
//
//   // Initialize TTS settings
//   Future<void> initialize() async {
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//   }
//
//   // Speak a given text
//   Future<void> speak(String text) async {
//     if (text.isNotEmpty) {
//       await _flutterTts.speak(text);
//     }
//   }
//
//   // Stop speaking
//   Future<void> stop() async {
//     await _flutterTts.stop();
//   }
//
//   // Pause speech
//   Future<void> pause() async {
//     await _flutterTts.pause();
//   }
//
//
//
//   // Get available languages
//   Future<List<dynamic>> getLanguages() async {
//     return await _flutterTts.getLanguages;
//   }
//
//   // Get available voices
//   Future<List<dynamic>> getVoices() async {
//     return await _flutterTts.getVoices;
//   }
//
//   // Clean up resources
//   Future<void> dispose() async {
//     await _flutterTts.stop();
//   }
// }
