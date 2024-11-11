import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:const MainFooter(index: 2,),
    );
  }
}
