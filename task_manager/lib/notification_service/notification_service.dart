import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/task_modal.dart';
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

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> cancelTaskReminders(Task task) async {
    for(int i = 0 ; i < task.reminders!.length  ; i++ ){
      await notificationsPlugin.cancel(task.id! * 100 + i);
    }
  }


  static Future<void> scheduleTaskReminder(Task task) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'BeBetter',
          'taskManager',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails()
    );

    final DateTime taskDateTime = DateFormat("yyyy-MM-dd HH:mm").parse("${task.date} ${task.time ?? "00:00 AM"}");
    DateTime reminderTime;
    for(int i = 0 ; i < task.reminders!.length  ; i++ ){
      final reminder = task.reminders![i];
      if(reminder.reminderUnit == 'Minute'){
        int minutes = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(minutes:minutes));
      }
      else if(reminder.reminderUnit == "Hour"){
        int hours = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(hours:hours));
      }
      else if(reminder.reminderUnit == "Day"){
        int days = reminder.reminderInterval;
        reminderTime = taskDateTime.subtract(Duration(days:days));
      }
      else if(reminder.reminderUnit == "Week"){
        int days = reminder.reminderInterval * 7;
        reminderTime = taskDateTime.subtract(Duration(days:days));
      }
      else if(reminder.reminderUnit == "Month"){
        int month = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year,
          taskDateTime.month - month,
          taskDateTime.day,
        );
      }
      else{
        int year = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year - year,
          taskDateTime.month,
          taskDateTime.day,
        );
      }
      if(reminderTime.isAfter(DateTime.now())){
        await notificationsPlugin.zonedSchedule((task.id! * 100 + i) , task.title, task.description, tz.TZDateTime.from(reminderTime, tz.local), notificationDetails, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
      }
    }

  }
}
