import 'package:flutter/material.dart';

class SubTaskInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconButton iconButton;
  const SubTaskInputField({super.key , required this.controller , required this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style:const  TextStyle(color: Colors.white),
                  decoration:const  InputDecoration(
                    hintText: "Add subtask",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              iconButton,
            ],
          ),
        ),
      ),
    );;
  }
}
