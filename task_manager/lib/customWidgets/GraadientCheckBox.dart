import 'package:flutter/material.dart';

class GradientCheckBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onSelect;

  const GradientCheckBox({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: isSelected ? const EdgeInsets.all(2) : const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isSelected
                ? [
              const Color(0xFFE8E8D5), // #E8E8D5
              const Color(0xFFB0E0E6), // #B0E0E6
              const Color(0xFF051A33), // #051A33
            ]
                : [
              const Color(0xFFE2E2E2), // #E2E2E2
              const Color(0xFF051A33), // #051A33
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.transparent,
              ],
            )
                : null,
            color: isSelected ? null : const Color(0xFF0A1A2A),
          ),
          child: Row(
            children: [
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
