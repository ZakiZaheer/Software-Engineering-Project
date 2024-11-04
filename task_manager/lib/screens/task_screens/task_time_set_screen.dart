import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/customWidgets/ErrorDialog.dart';
import 'package:task_manager/customWidgets/SelectionField.dart';
import 'package:task_manager/customWidgets/date_picker.dart';
import 'package:task_manager/customWidgets/time_picker.dart';
import 'package:task_manager/customWidgets/alert_slider.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';
import 'package:task_manager/Custom_Fonts.dart';
import '../../model/task_modal.dart';

class TaskDateTimeSelectionScreen extends StatefulWidget {
  final Task task;

  const TaskDateTimeSelectionScreen({super.key, required this.task});

  @override
  State<TaskDateTimeSelectionScreen> createState() =>
      _TaskDateTimeSelectionScreenState();
}

class _TaskDateTimeSelectionScreenState
    extends State<TaskDateTimeSelectionScreen> {

  String _reminderType = "Default";

  @override
  void initState() {
    _reminderType = widget.task.reminders != null ? widget.task.reminders![0].reminderType : "Default";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1329),
        title: Text(
          'Set Date/time',
          style: appBarHeadingStyle(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(widget.task.reminders != null){
                for(TaskReminder reminder in widget.task.reminders!){
                  reminder.reminderType = _reminderType;
                }
              }
              Navigator.pop(context, widget.task);
            },
            child: Text(
              'Set',
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
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SelectionField(
              title: "Date",
              initialValue:widget.task.date != null ? formatDate(widget.task.date!)  : "none",
              onTap: () async {
                String? pickedDate = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) => CustomDatePicker(
                    initialDate: widget.task.date,
                  ),
                );

                if (pickedDate != null) {
                  final pickedDateTime = DateTime.parse(pickedDate.toString());
                  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

                  if (pickedDateTime.isBefore(today)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ErrorDialog(title: "Invalid Date Selected!");
                      },
                    );
                    return null;
                  }

                  setState(() {
                    widget.task.date = pickedDate.toString();
                  });
                  return formatDate(pickedDate);
                }
                return pickedDate;

              },
            ),
            SelectionField(
                title: "Time",
                initialValue: widget.task.time != null ? formatTime(widget.task.time!) : "none",
                onTap: widget.task.date != null
                    ? () async {
                        String? pickedTime = await showModalBottomSheet<String>(
                          context: context,
                          builder: (context) => CustomTimePicker(
                            initialTime: widget.task.time,
                          ),
                        );

                        if (pickedTime != null) {
                          final DateTime datePart = DateTime.parse(widget.task.date!);
                          final splitTime = pickedTime.split(":");
                          final DateTime pickedDateTime = DateTime(
                            datePart.year,
                            datePart.month,
                            datePart.day,
                            int.parse(splitTime[0]),
                            int.parse(splitTime[1]),
                          );

                          DateTime today = DateTime.now();

                          if (pickedDateTime.isBefore(today)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorDialog(title: "Invalid Time Selected!");
                              },
                            );
                            return null;
                          }

                          setState(() {
                            widget.task.time = pickedTime;
                          });
                          return formatTime(pickedTime);
                        }
                        return pickedTime;
                      }
                    : null),
            SelectionField(
              title: "Repeat",
              initialValue: widget.task.repeatPattern != null
                  ? "Every ${widget.task.repeatPattern!.repeatInterval} ${widget.task.repeatPattern!.repeatUnit}"
                  : "Never",
              onTap: widget.task.date != null
                  ? () async {
                      final repeatPattern = await Navigator.pushNamed(
                        context,
                        '/taskRepeatScreen',
                        arguments: widget.task.repeatPattern,
                      );

                      if (repeatPattern != null) {
                        if (repeatPattern == "Never") {
                          setState(() {
                            widget.task.repeatPattern = null;
                          });
                        } else {
                          final newRepeatPattern =
                              repeatPattern as TaskRepetition;
                          setState(() {
                            if (widget.task.repeatPattern != null) {
                              widget.task.repeatPattern!.repeatInterval =
                                  newRepeatPattern.repeatInterval;
                              widget.task.repeatPattern!.repeatUnit =
                                  newRepeatPattern.repeatUnit;
                            } else {
                              widget.task.repeatPattern = newRepeatPattern;
                            }
                          });
                        }
                      }
                      // Returns the formatted repeat pattern string
                      return widget.task.repeatPattern != null
                          ? "Every ${widget.task.repeatPattern!.repeatInterval} ${widget.task.repeatPattern!.repeatUnit}"
                          : "Never";
                    }
                  : null,
            ),
            SelectionField(
              title: "Stop Repeating After",
              initialValue: widget.task.repeatPattern != null ? _checkRepeatType(widget.task.repeatPattern!) : "Never",
              onTap: widget.task.repeatPattern != null
                  ? () async {
                      final data = await Navigator.pushNamed(context, '/taskRepeatUntilScreen', arguments: widget.task.repeatPattern) as List?;
                        if (data != null) {
                          if (data[1] == "Never") {

                            setState(() {
                              widget.task.repeatPattern!.repeatType =
                              "Never";
                            });
                            return data[0];
                          } else if (data[1] == "Time") {

                            setState(() {
                              widget.task.repeatPattern!.repeatType = "Time";
                              widget.task.repeatPattern!.repeatUntil = data[0];
                            });
                            return formatDate(data[0]);
                          } else {

                            setState(() {
                              widget.task.repeatPattern!.repeatType =
                              "Count";
                              widget.task.repeatPattern!.numOccurrence = data[0];
                            });
                            return "${data[0]} Occurrences";
                          }
                        }

                    }
                  : null,
            ),
            const Divider(color: Colors.grey),
            SelectionField(
              title: "Reminders",
              initialValue: widget.task.reminders != null ? "Active" : "Disabled",
              onTap: widget.task.date != null ? () async {
                final reminderList = await Navigator.pushNamed(context, '/taskRemindersScreen' , arguments: widget.task.reminders);
                if(reminderList != null){
                  final newRemindersList = reminderList as List<TaskReminder>;
                  if(reminderList.isNotEmpty ){
                    setState(() {
                      widget.task.reminders = newRemindersList;
                    });
                    return "Active";
                  }
                  widget.task.reminders = null;
                  return "Disabled";
                }
              } : null,
            ),
            buildAlarmTile(),
          ],
        ),
      ),
    );
  }

  Widget buildAlarmTile() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Alarm',
            style: TimeLeftContent(),
          ),
          CustomSlider(
            onValueChanged: (value) {
                if(value == -1){
                  _reminderType = "Alarm";
                }
                else if(value == 1){
                  _reminderType = "Voice";
                }
                else{
                  _reminderType = "Default";
                }

            },
            initialValue: widget.task.reminders == null ? 0 : _checkReminderType(widget.task.reminders![0]),
          ),
          Text(
            'Voice',
            style: TimeLeftContent(),
          ),
        ],
      ),
    );
  }
}
String formatDate(String dateInput) {
  DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateInput);
  return DateFormat('d MMM yyyy').format(parsedDate);
}

String formatTime(String timeInput) {
  DateTime parsedTime = DateFormat('HH:mm').parse(timeInput);
  return DateFormat('h:mm a').format(parsedTime);
}

double _checkReminderType(TaskReminder reminder){
  if(reminder.reminderType == "Voice"){
    return 1;
  }
  else if(reminder.reminderType == "Alarm"){
    return -1;
  }
  return 0;
}


String _checkRepeatType(TaskRepetition repeatPattern){
  if (repeatPattern.repeatType == "Time"){
    return formatDate(repeatPattern.repeatUntil!);
  }
  else if(repeatPattern.repeatType == "Count"){
    return "${repeatPattern.numOccurrence} Occurrences";
  }
  return "Never";
}