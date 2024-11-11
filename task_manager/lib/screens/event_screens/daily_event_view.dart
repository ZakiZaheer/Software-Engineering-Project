import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFBBD3B),
        onPressed: ()async {
          Navigator.pushNamed(context, '/eventCreationScreen');

        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar:const MainFooter(index: 1,),
    );
  }
}
