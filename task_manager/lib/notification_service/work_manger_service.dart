import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/event/event_modal.dart';
import 'package:workmanager/workmanager.dart';
import '../model/event/event_reminder_modal.dart';
import '../model/task/task_modal.dart';
import 'notification_service.dart';




@pragma('vm:entry-point')
void workManagerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {

    String textToSpeak = inputData!['title'] ?? "Hello Human!";
    String? notificationDescription = inputData['body'];
    await NotificationService.instantNotification(textToSpeak, notificationDescription!);
    FlutterTts tts = FlutterTts();
    await tts.setVolume(1.0);
    Completer<void> ttsCompleter = Completer<void>();
    tts.setCompletionHandler(() {
      ttsCompleter.complete();
    });
    await tts.speak(textToSpeak);
    await ttsCompleter.future;
    return Future.value(true);
  });
}

class WorkManagerService {
  static const String ttsTaskName = "ttsTask";

  // Initializes WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      workManagerCallbackDispatcher, // Updated to reference the top-level function
      isInDebugMode: false,
    );
  }

  static Future<void> cancelTaskVoiceNotification(Task task)async{
    for (int i = 0; i < task.reminders!.length; i++) {
      await Workmanager().cancelByUniqueName("${(task.id! * 100 + i)}");
    }

  }


  // Schedules a voice notification for each reminder of a task
  static Future<void> scheduleTaskVoiceNotification(Task task) async {
    final DateTime taskDateTime = DateFormat("yyyy-MM-dd HH:mm")
        .parse("${task.date} ${task.time ?? "00:00 AM"}");
    DateTime reminderTime;

    for (int i = 0; i < (task.reminders?.length ?? 0); i++) {
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
        int months = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year,
          taskDateTime.month - months,
          taskDateTime.day,
          taskDateTime.hour,
          taskDateTime.minute,
        );
      } else {
        int years = reminder.reminderInterval;
        reminderTime = DateTime(
          taskDateTime.year - years,
          taskDateTime.month,
          taskDateTime.day,
          taskDateTime.hour,
          taskDateTime.minute,
        );
      }
      // Calculate initial delay as the difference from the current time
      if (reminderTime.isAfter(DateTime.now())) {
        Duration initialDelay = reminderTime.difference(DateTime.now());

        await Workmanager().registerOneOffTask(
          '${task.id! * 100 + i}', // Unique task ID
          ttsTaskName, // Task name matches in callback dispatcher
          initialDelay: initialDelay, // Calculated delay
          inputData: {
            'title': task.title,
            'body' : task.description ?? ""// Text to speak
          },
        );
      }
    }
  }

  static Future<void> cancelEventVoiceNotification(Event event)async{
    for (int i = 0; i < event.reminders!.length; i++) {
      await Workmanager().cancelByUniqueName("${(event.id! * 100 + i)}");
    }

  }


  static Future<void> scheduleEventVoiceNotification(Event event) async {
    print("Scheduling Event Voice Reminders");
    final DateTime eventDateTime = event.startTime;
    DateTime reminderTime;

    for (int i = 0; i < (event.reminders?.length ?? 0); i++) {
      final EventReminder reminder = event.reminders![i];

      // Calculate reminder time based on reminder unit and interval
      if (reminder.reminderUnit == 'Minute') {
        int minutes = reminder.reminderInterval;
        reminderTime = eventDateTime.subtract(Duration(minutes: minutes));
      } else if (reminder.reminderUnit == "Hour") {
        int hours = reminder.reminderInterval;
        reminderTime = eventDateTime.subtract(Duration(hours: hours));
      } else if (reminder.reminderUnit == "Day") {
        int days = reminder.reminderInterval;
        reminderTime = eventDateTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Week") {
        int days = reminder.reminderInterval * 7;
        reminderTime = eventDateTime.subtract(Duration(days: days));
      } else if (reminder.reminderUnit == "Month") {
        int months = reminder.reminderInterval;
        reminderTime = DateTime(
          eventDateTime.year,
          eventDateTime.month - months,
          eventDateTime.day,
          eventDateTime.hour,
          eventDateTime.minute,
        );
      } else {
        int years = reminder.reminderInterval;
        reminderTime = DateTime(
          eventDateTime.year - years,
          eventDateTime.month,
          eventDateTime.day,
          eventDateTime.hour,
          eventDateTime.minute,
        );
      }
      // Calculate initial delay as the difference from the current time
      if (reminderTime.isAfter(DateTime.now())) {
        Duration initialDelay = reminderTime.difference(DateTime.now());
        print("Reminder Scheduled For $reminderTime");

        await Workmanager().registerOneOffTask(
          '${event.id! * 100 + i}', // Unique task ID
          ttsTaskName, // Task name matches in callback dispatcher
          initialDelay: initialDelay, // Calculated delay
          inputData: {
            'title': event.title,
            'body' : event.description ?? ""// Text to speak
          },
        );
      }
    }
  }


}
