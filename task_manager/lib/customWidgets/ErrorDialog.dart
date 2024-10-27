import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;

  const ErrorDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.transparent,
        // Transparent background for gradient effect
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Set width to 80% of screen width
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3DA2DB), // Light blue color
                Color(0xFF16667A) // Teal color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
        ));
    ;
  }
}
