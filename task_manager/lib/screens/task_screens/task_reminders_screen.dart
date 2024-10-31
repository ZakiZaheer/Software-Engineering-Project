import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/custom_picker.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/model/taskReminder_modal.dart';

import '../../customWidgets/GraadientCheckBox.dart';

class TaskRemindersScreen extends StatefulWidget {
  final List<TaskReminder>? reminders;

  const TaskRemindersScreen(
      {super.key, required this.reminders});

  @override
  _TaskRemindersScreenState createState() => _TaskRemindersScreenState();
}

class _TaskRemindersScreenState extends State<TaskRemindersScreen> {
  List<String> options = [
    "5 minutes",
    "1 hour",
    "1 day",
    "1 week",
  ];

  List<String> selectedOptions = [];
  bool remindersEnabled = true; // Toggle for reminders switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: appBarHeadingStyle(),
        ),
        backgroundColor: const Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              List<TaskReminder> reminderList = List.generate(selectedOptions.length - 1, (index){
                final parts = selectedOptions[index + 1].split(" ");
                return TaskReminder(reminderInterval: int.parse(parts[0]), reminderUnit: parts[1]);
              });
              if(selectedOptions.contains("At Time Of Task")){
                reminderList.insert(0, TaskReminder(reminderInterval: 0, reminderUnit: "Minute"));
              }
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: appBarHeadingButton(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
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
                const Expanded(
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
            const SizedBox(height: 16),
            Opacity(
              opacity: remindersEnabled ? 1.0 : 0.5, // Dim options if disabled
              child: Column(
                children: [
                  GradientCheckBox(
                      text: "At Time Of Task",
                      isSelected: selectedOptions.contains("At Time Of Task"),
                      onSelect: () {
                        setState(() {
                          if (selectedOptions.contains("At Time Of Task")) {
                            selectedOptions.remove("At Time Of Task");
                          } else {
                            selectedOptions.add("At Time Of Task");
                          }
                        });
                      }),
                  ...options.map((option) {
                    bool isSelected = selectedOptions.contains(option);
                    return IgnorePointer(
                      ignoring: !remindersEnabled,
                      // Disable interactions if toggle is off
                      child: GradientCheckBox(
                        text: "$option Before Task",
                        isSelected: isSelected,
                        onSelect: () {
                            setState(() {
                              if (isSelected) {
                                selectedOptions.remove(option);
                              } else {
                                selectedOptions.add(option);
                              }
                            });
                        },
                      ),
                    );
                  }),
                  GradientCheckBox(
                    text: "Custom",
                    isSelected: false,
                    onSelect: () {
                      showCustomRepeatPicker(
                        context,
                        title: 'Custom Reminder',
                        onConfirm: (interval, unit) {
                          final option = "$interval $unit";
                          if (!options.contains(option)){
                            options.add(option);
                            selectedOptions.add(option);
                            setState(() {

                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
