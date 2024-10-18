import 'package:flutter/material.dart';
import 'package:task_manager/screens/task_screens/task_screen.dart';
// Import your custom task description dialog

void main() {
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
    );
  }
}

