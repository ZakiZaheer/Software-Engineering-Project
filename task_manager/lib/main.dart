import 'package:flutter/material.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/screens/task_screens/task_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initNotification();
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
