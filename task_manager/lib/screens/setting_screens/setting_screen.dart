import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:const MainFooter(index: 3,),
    );
  }
}
