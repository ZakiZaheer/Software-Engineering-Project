import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:const MainFooter(index: 1,),
    );
  }
}
