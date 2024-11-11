import 'package:flutter/material.dart';

Widget buildTextField(String label) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A1A2A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}
