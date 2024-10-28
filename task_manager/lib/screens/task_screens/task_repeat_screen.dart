import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/custom_picker.dart';
import 'package:task_manager/Custom_Fonts.dart';

class RepeatScreen extends StatefulWidget {
  final Function(String) onSave; // Callback to pass selected option to parent

  RepeatScreen({required this.onSave});

  @override
  _RepeatScreenState createState() => _RepeatScreenState();
}

class _RepeatScreenState extends State<RepeatScreen> {
  List<String> options = [
    "Never",
    "Every 1 hour",
    "Everyday",
    "Every week",
    "Every month",
    "Every year",
    "Custom",
  ];

  String? selectedOption = "Never"; // Initial selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A), 
      appBar: AppBar(
        title: Text(
          'Repeat',
          style: appBarHeadingStyle(),
        ),
        backgroundColor: Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(selectedOption!);
              Navigator.of(context).pop(); // Pass data to parent

              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: appBarHeadingButton(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), 
          child: Container(
            color: Colors.white.withOpacity(0.6), 
            height: 2, 
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ...options.map((option) {
              bool isSelected = selectedOption == option;
              return GradientBorderBox(
                text: option,
                isSelected: isSelected,
                onSelect: () {
                  if (option == "Custom") {
                    showCustomRepeatPicker(
                      context,
                      title: 'Custom Repeat',
                      onConfirm: (number, unit) {
                        print('Selected Repeat: Every $number $unit(s)');
                      },
                    );
                  } else {
                    setState(() {
                      selectedOption = option;
                    });
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class GradientBorderBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onSelect;

  GradientBorderBox({
    required this.text,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: isSelected
            ? EdgeInsets.all(2)
            : EdgeInsets.all(1), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              12), 
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isSelected
                ? [
                    Color(0xFFE8E8D5), // #E8E8D5
                    Color(0xFFB0E0E6), // #B0E0E6
                    Color(0xFF051A33), // #051A33
                  ]
                : [
                    Color(0xFFE2E2E2), // #E2E2E2
                    Color(0xFF051A33), // #051A33
                  ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12), 
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
            color: isSelected ? null : Color(0xFF0A1A2A),
          ),
          child: Row(
            children: [
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 24),
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
