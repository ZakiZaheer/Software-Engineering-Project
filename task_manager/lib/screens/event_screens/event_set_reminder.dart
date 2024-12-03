import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/custom_picker.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/task/taskReminder_modal.dart';

import '../../customWidgets/GraadientCheckBox.dart';
import '../../model/event/event_modal.dart';
import '../../model/event/event_reminder_modal.dart';

class EventSetRemindersScreen extends StatefulWidget {
  final Event event;

  const EventSetRemindersScreen(
      {super.key, required this.event});

  @override
  _EventSetRemindersScreenState createState() => _EventSetRemindersScreenState();
}

class _EventSetRemindersScreenState extends State<EventSetRemindersScreen> {
  List<String> options = [
    "5 Minutes",
    "1 Hour",
    "1 Day",
    "1 Week",
  ];

  @override
  void initState() {
    if(widget.event.reminders != null){
      for(EventReminder reminder in widget.event.reminders!) {
        final option = "${reminder.reminderInterval} ${reminder.reminderUnit}";
        if (option == "0 Minute") {
          selectedOptions.add("At Time Of Task");
        }
        else {
          if (!options.contains(option)) {
            options.add(option);
          }
          selectedOptions.add(option);
        }
      }
    }
    super.initState();
  }

  List<String> selectedOptions = [
  ];
  bool remindersEnabled = false; // Toggle for reminders switch

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
            onPressed: () async {
              List<EventReminder> reminderList = [];
              if(selectedOptions.contains("At Time Of Event")){
                selectedOptions.remove("At Time Of Event");
                reminderList.add(EventReminder(reminderInterval: 0, reminderUnit: "Minute"));
              }
              reminderList = reminderList + List.generate(selectedOptions.length, (index){
                final parts = selectedOptions[index].split(" ");
                return EventReminder(reminderInterval: int.parse(parts[0]), reminderUnit: parts[1]);
              });
              final db = SqfLiteService();
              widget.event.reminders = reminderList;
              await db.modifyEvent(widget.event);
              Navigator.pop(context ,reminderList);
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
        child: ListView(
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
                      selectedOptions = [];
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
              opacity: !remindersEnabled ? 1.0 : 0.5, // Dim options if disabled
              child: Column(
                children: [
                  IgnorePointer(
                    ignoring: remindersEnabled,
                    child: GradientCheckBox(
                        text: "At Time Of Event",
                        isSelected: selectedOptions.contains("At Time Of Event"),
                        onSelect: () {
                          setState(() {
                            if (selectedOptions.contains("At Time Of Event")) {
                              selectedOptions.remove("At Time Of Event");
                            } else {
                              selectedOptions.add("At Time Of Event");
                            }
                          });
                        }),
                  ),
                  ...options.map((option) {
                    bool isSelected = selectedOptions.contains(option);
                    return IgnorePointer(
                      ignoring: remindersEnabled,
                      // Disable interactions if toggle is off
                      child: GradientCheckBox(
                        text: "$option Before Event",
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
                  IgnorePointer(
                    ignoring: remindersEnabled,
                    child: GradientCheckBox(
                      text: "Custom",
                      isSelected: false,
                      onSelect: () {
                        showCustomRepeatPicker(
                          context,
                          title: 'Custom Reminder',
                          forReminder: true,
                          forEvent: true,
                          onConfirm: (interval, unit) {
                            final option = "$interval $unit";
                            if (!options.contains(option)){
                              options.add(option);

                            }
                            if(!selectedOptions.contains(option)){
                              selectedOptions.add(option);
                            }
                            setState(() {

                            });
                          },
                        );
                      },
                    ),
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
