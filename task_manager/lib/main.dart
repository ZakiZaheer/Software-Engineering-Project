import 'package:flutter/material.dart';
import 'package:task_manager/model/event/event_modal.dart';
import 'package:task_manager/model/task/taskReminder_modal.dart';
import 'package:task_manager/model/task/taskRepetition_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/notification_service/work_manger_service.dart';
import 'package:task_manager/screens/event_screens/event_creation_screen.dart';
import 'package:task_manager/screens/event_screens/event_modification_screen.dart';
import 'package:task_manager/screens/event_screens/event_reminder.dart';
import 'package:task_manager/screens/event_screens/event_repeat_screen.dart';
import 'package:task_manager/screens/event_screens/event_stop_repeat_screen.dart';
import 'package:task_manager/screens/event_screens/monthly_events_view.dart';
import 'package:task_manager/screens/login_screens/SignUpScreen.dart';
import 'package:task_manager/screens/login_screens/splashScrren.dart';
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

import 'model/event/event_reminder_modal.dart';
import 'model/event/event_repetition_modal.dart';
import 'model/task/task_modal.dart';


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
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // Set icons in AppBar to white
        ),
      ),

      routes: {
        '/' : (context) => const TaskScreen(),
        '/taskCreationScreen' : (context) => const TaskCreationScreen(),
        '/taskDateTimeSelectionScreen' : (context) => TaskDateTimeSelectionScreen(task: ModalRoute.of(context)!.settings.arguments as Task),
        '/taskRepeatScreen' : (context) => TaskRepeatScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as TaskRepetition?,),
        '/taskRepeatUntilScreen' : (context) => TaskRepeatUntilScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as TaskRepetition?,),
        '/taskRemindersScreen' : (context) => TaskRemindersScreen(reminders: ModalRoute.of(context)!.settings.arguments as List<TaskReminder>?,),
        '/taskModificationScreen' : (context) => TaskModificationScreen(task: ModalRoute.of(context)!.settings.arguments as Task),
        '/eventScreen' : (context) => CalendarScreen(),
        '/eventCreationScreen' : (context) => EventCreationScreen(),
        '/eventRepeatScreen' : (context) => EventRepeatScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as EventRepetition?,),
        '/eventRepeatUntilScreen' : (context) => EventRepeatUntilScreen(repeatPattern: ModalRoute.of(context)!.settings.arguments as EventRepetition?,),
        '/eventRemindersScreen' : (context) => EventRemindersScreen(reminders: ModalRoute.of(context)!.settings.arguments as List<EventReminder>?,),
        '/eventModificationScreen' : (context) => EventModificationScreen(event: ModalRoute.of(context)!.settings.arguments as Event),
        '/classroomSplashScreen' : (context) => const SplashScreen(),
        '/signUpScreen' : (context) => SignUpPage(),
        '/settingsScreen' : (context) => const SettingScreen(),
      },
    );
  }
}

