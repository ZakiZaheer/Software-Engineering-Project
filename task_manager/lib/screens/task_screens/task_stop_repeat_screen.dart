import 'package:flutter/material.dart';
import 'CustomFont.dart';
import 'customWidgets/counter.dart';

class StopRepeatScreen extends StatefulWidget {
  final Function(String, [int?]) onOptionSelected; 

  StopRepeatScreen({required this.onOptionSelected});

  @override
  _StopRepeatScreenState createState() => _StopRepeatScreenState();
}

class _StopRepeatScreenState extends State<StopRepeatScreen> {
  List<String> options = [
    "Never",
    "Time",
    "Count",
  ];

  String? selectedOption = "Time";
  int? countValue; // Stores the count if selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        title: Text(
          'Stop repeating after',
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
              widget.onOptionSelected(
                  selectedOption!, countValue); 
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
                onSelect: () async {
                  setState(() {
                    selectedOption = option;
                    countValue = null; // Reset count value if option changes
                  });
                  if (option == "Count") {
                    final selectedCount = await showModalBottomSheet<int>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return CounterWidget();
                      },
                    );
                    if (selectedCount != null) {
                      setState(() {
                        countValue = selectedCount;
                      });
                    }
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
