import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/event/event_modal.dart';

import '../../model/event/event_reminder_modal.dart';
import '../../model/event/event_repetition_modal.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFBBD3B),
        onPressed: () async {
          final db = SqfLiteService();
          Navigator.pushNamed(context, '/eventCreationScreen');
          // Event event = await db.getEventById(8);
          // Navigator.pushNamed(context, '/eventModificationScreen' , arguments: event);
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: const MainFooter(
        index: 1,
      ),
    );
  }
}
