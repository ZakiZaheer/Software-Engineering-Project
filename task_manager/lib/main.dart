import 'package:flutter/material.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/notification_service/work_manger_service.dart';
import 'package:task_manager/screens/classroom_screens/splashScrren.dart';
import 'package:task_manager/screens/event_screens/daily_event_view.dart';
import 'package:task_manager/screens/setting_screens/setting_screen.dart';
import 'package:task_manager/screens/task_screens/task_creation_screen.dart';
import 'package:task_manager/screens/task_screens/task_modification_screen.dart';
import 'package:task_manager/screens/task_screens/task_reminders_screen.dart';
import 'package:task_manager/screens/task_screens/task_repeat_screen.dart';
import 'package:task_manager/screens/task_screens/task_screen.dart';
import 'package:task_manager/screens/task_screens/task_stop_repeat_screen.dart';
import 'package:task_manager/screens/task_screens/task_time_set_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/task_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initNotification();
  await WorkManagerService.initialize();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => const TaskScreen(),
        '/taskCreationScreen' : (context) => const TaskCreationScreen(),
        '/taskDateTimeSelectionScreen' : (context) => TaskDateTimeSelectionScreen(task: ModalRoute.of(context)!.settings.arguments as Task),
        '/taskRepeatScreen' : (context) => TaskRepeatScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as TaskRepetition?,),
        '/taskRepeatUntilScreen' : (context) => TaskRepeatUntilScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as TaskRepetition?,),
        '/taskRemindersScreen' : (context) => TaskRemindersScreen(reminders: ModalRoute.of(context)!.settings.arguments as List<TaskReminder>?,),
        '/taskModificationScreen' : (context) => TaskModificationScreen(task: ModalRoute.of(context)!.settings.arguments as Task),
        '/eventScreen' : (context) => const EventScreen(),
        '/classroomSplashScreen' : (context) => const SplashScreen(),
        '/settingsScreen' : (context) => const SettingScreen(),
      },
      // home: Scaffold(
      //   body: Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         DateTime scheduledTime = DateTime.now().add(Duration(seconds: 5));
      //         NotificationService.scheduleNotification('ScheduledNotif', 'AHHAHAHAHA', scheduledTime);
      //       },
      //       child: Text("Schedule Notification"),
      //     ),
      //   ),
      // ),
    );
  }
}

