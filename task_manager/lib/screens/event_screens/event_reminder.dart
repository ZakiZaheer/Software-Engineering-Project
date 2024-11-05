import 'package:flutter/material.dart';
import 'customWidgets/Custom_picker.dart';

class RemindersScreen extends StatefulWidget {
  final Function(List<String>) onSave; // Callback to pass selected options

  RemindersScreen({required this.onSave}); // Constructor to receive callback

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<String> options = [
    "When event starts",
    "5 minutes before the event",
    "1 hour before the event",
    "1 day before the event",
    "1 week before the event",
    "Custom",
  ];

  List<String> selectedOptions = [];
  bool remindersEnabled = true; // Toggle for reminders switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: TextStyle(color: Colors.white),
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
              _sendToBackend(selectedOptions);
              widget.onSave(
                  selectedOptions); // Call the callback with selected options
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    "No reminders",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Switch(
                  value: remindersEnabled,
                  onChanged: (value) {
                    setState(() {
                      remindersEnabled = value;
                    });
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[600],
                ),
              ],
            ),
            SizedBox(height: 16),
            Opacity(
              opacity: remindersEnabled ? 1.0 : 0.5, // Dim options if disabled
              child: Column(
                children: options.map((option) {
                  bool isSelected = selectedOptions.contains(option);
                  return IgnorePointer(
                    ignoring:
                        !remindersEnabled, // Disable interactions if toggle is off
                    child: GradientBorderBox(
                      text: option,
                      isSelected: isSelected,
                      onSelect: () {
                        if (option == "Custom") {
                          showCustomRepeatPicker(
                            context,
                            title: 'Custom Reminder',
                            onConfirm: (number, unit) {
                              print('Selected Repeat: Every $number $unit(s)');
                            },
                          );
                        } else {
                          setState(() {
                            if (isSelected) {
                              selectedOptions.remove(option);
                            } else {
                              selectedOptions.add(option);
                            }
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendToBackend(List<String> selectedOptions) {
    // Simulate backend communication
    print("Sending to backend: $selectedOptions");
    // Here you would implement the actual API call
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
            : EdgeInsets.all(1), // Reduced padding for unselected
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              12), // Increased border radius for both states
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
                BorderRadius.circular(12), // Same radius for inner container
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
