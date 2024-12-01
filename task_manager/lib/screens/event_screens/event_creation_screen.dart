import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/CustomDivider.dart';
import 'package:task_manager/customWidgets/SelectionField.dart';
import 'package:task_manager/customWidgets/inputField.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/event/event_modal.dart';
import '../../customWidgets/ErrorDialog.dart';
import '../../customWidgets/alert_slider.dart';
import '../../customWidgets/date_picker.dart';
import '../../customWidgets/date_time_picker.dart';
import 'package:intl/intl.dart';
import '../../customWidgets/footer.dart';
import '../../model/event/event_reminder_modal.dart';
import '../../model/event/event_repetition_modal.dart';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});
  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final Event event =
      Event(title: "", startTime: DateTime.now(), endTime: DateTime.now());
  bool isAllDay = false;
  bool isSmartSuggested = false;
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedReminderType = "Default";
  final db = SqfLiteService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: ()async {
            Navigator.pop(context);
          },
        ),
        title: Text(_titleText(), style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                if(_selectedStartTime != null){
                  if(_selectedEndTime != null){
                    event.title = _titleController.text;
                    event.startTime = _selectedStartTime!;
                    event.endTime = _selectedEndTime!;
                    if (_descriptionController.text.isNotEmpty) {
                      event.description = _descriptionController.text;
                    }
                    if (_locationController.text.isNotEmpty) {
                      event.location = _locationController.text;
                    }
                    if(event.reminders != null){
                      for(EventReminder reminder in event.reminders!){
                        reminder.reminderType = _selectedReminderType;
                      }
                    }
                    if(event.eventType != "General"){
                      event.repeatPattern = EventRepetition(repeatInterval: 1, repeatUnit: "Year");
                    }
                    await db.addEvent(event);
                  }
                  else{
                    _showErrorDialog(context, "EndTime Not Selected!");
                  }
                }
                else{
                  _showErrorDialog(context, "Start Time Not Selected!");
                }
                event.title = _titleController.text;
              } else {
                _showErrorDialog(context, "Empty Event Name Not Allowed");
              }
            },
            child: const Text("Create", style: TextStyle(color: Colors.white)),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        event.eventType = "General";
                      });
                    },
                    child: _buildEventTypeIcon(
                        Icons.event, "Event", event.eventType == "General"),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        event.eventType = "Birthday";
                      });
                    },
                    child: _buildEventTypeIcon(
                        Icons.cake, "Birthday", event.eventType == "Birthday"),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        event.eventType = "Anniversary";
                      });
                    },
                    child: _buildEventTypeIcon(Icons.flag, "Anniversary",
                        event.eventType == "Anniversary"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InputField(
              label: "Name",
              controller: _titleController,
            ),
            ..._eventTypeFields(),
          ],
        ),
      ),
      bottomNavigationBar:const  MainFooter(index: 1),
    );
  }

  Widget _buildEventTypeIcon(IconData icon, String label, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? Colors.amber : Colors.white, size: 40),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
  List<Widget> _eventTypeFields() {
    List<Widget> list = [];
    if (event.eventType == "General") {
      list.addAll([
        _buildSwitchTile(
          "All Day",
          isAllDay,
              (value) {
            setState(() {
              isAllDay = !isAllDay;
              if(_selectedStartTime != null){
                _selectedStartTime = DateTime(
                  _selectedStartTime!.year,
                  _selectedStartTime!.month,
                  _selectedStartTime!.day,
                );
                _selectedEndTime = _selectedStartTime!.add(Duration(days: 1));
              }
            });
          },
        ),
        if (!isAllDay) ...[
          SelectionField(
            key: UniqueKey(),  // Added UniqueKey to force widget recreation
            title: "From",
            initialValue: _selectedStartTime != null ? formatDateTime(_selectedStartTime!) : "none",
            onTap: () async {
              DateTime? pickedDate = await showCustomDateTimePicker(
                context: context,
                title: 'From',
                initialDateTime: _selectedStartTime,
              );
              if (pickedDate != null) {
                if (_selectedEndTime != null && _selectedEndTime!.isBefore(pickedDate)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ErrorDialog(
                            title: "Event cant end before it has Started!");
                      });
                } else {
                  setState(() {
                    _selectedStartTime = pickedDate;
                  });

                  return DateFormat('EEE, d MMM, yyyy, hh:mm a')
                      .format(pickedDate);
                }
              }
              return null;
            },
            isActive: true,
          ),
          SelectionField(
            key: UniqueKey(),  // Added UniqueKey to force widget recreation
            title: "To",
            initialValue: _selectedEndTime != null ? formatDateTime(_selectedEndTime!) : "none",
            onTap: () async {
              DateTime? pickedDate = await showCustomDateTimePicker(
                context: context,
                title: 'To',
                initialDateTime: _selectedEndTime,
              );
              if (pickedDate != null) {
                if (_selectedStartTime != null &&
                    _selectedStartTime!.isAfter(pickedDate)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ErrorDialog(
                            title: "Event can't end before it has Started!");
                      });
                } else {
                  setState(() {
                    _selectedEndTime = pickedDate;
                  });

                  return DateFormat('EEE, d MMM, yyyy, hh:mm a')
                      .format(pickedDate);
                }
              }
              return null;
            },
            isActive: true,
          ),
        ] else
          SelectionField(
            key: UniqueKey(),  // Added UniqueKey to force widget recreation
            title: "Date",
            initialValue: _selectedStartTime != null ? DateFormat('EEE, d MMM, yyyy, hh:mm a').format(_selectedStartTime!) : "none",
            onTap: () async {
              String? pickedDate = await showModalBottomSheet<String>(
                context: context,
                builder: (context) => CustomDatePicker(
                  initialDate: _selectedStartTime != null ? _selectedStartTime.toString().split(" ")[0] : null,
                ),
              );

              if (pickedDate != null) {
                final pickedDateTime = DateTime.parse(pickedDate.toString());
                DateTime today = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);

                if (pickedDateTime.isBefore(today)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ErrorDialog(
                          title: "Invalid Date Selected!");
                    },
                  );
                  return null;
                }
                setState(() {
                  _selectedStartTime = pickedDateTime;
                  _selectedEndTime = pickedDateTime.add(const Duration(days: 1));
                });

                return DateFormat('EEE, d MMM, yyyy, hh:mm a')
                    .format(pickedDateTime);
              }
              return null;
            },
            isActive: true,
          ),
        SelectionField(
          title: "Repeat",
          key: UniqueKey(),
          initialValue: event.repeatPattern != null ? "Every ${event.repeatPattern!.repeatInterval} ${event.repeatPattern!.repeatUnit}${event.repeatPattern!.repeatOn != null ? " On ${event.repeatPattern!.repeatOn}" : "" }" : "none",
          onTap: _setEventRepetition,
          isActive: _selectedEndTime != null && _selectedStartTime != null,
        ),
        SelectionField(
          title: "Stop Repeating After",
          key: UniqueKey(),
          initialValue: event.repeatPattern != null ?  _checkRepeatType(event.repeatPattern!) : "Never",
          onTap: _setRepeatUntil,
          isActive: event.repeatPattern != null,
        ),
        SelectionField(
          title: "Reminder",
          key: UniqueKey(),
          initialValue: event.reminders != null ?"Active" : "Disabled",
          onTap: _setEventReminders,
          isActive: _selectedEndTime != null && _selectedStartTime != null,
        ),
        buildAlarmTile(),
        const SizedBox(height: 20),
        InputField(label: "Location", controller: _locationController),
        const SizedBox(height: 20),
        InputField(label: "Description", controller: _descriptionController),
      ]);
    } else {
      list.addAll([
        SelectionField(
          key: UniqueKey(),  // Added UniqueKey to force widget recreation
          title: "When",
          initialValue: _selectedStartTime != null ? formatDateTime(_selectedStartTime!) : "none",
          onTap: () async {
            String? pickedDate = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => CustomDatePicker(
                initialDate: _selectedStartTime != null ? _selectedStartTime.toString().split(" ")[0] : null,
              ),
            );

            if (pickedDate != null) {
              final pickedDateTime = DateTime.parse(pickedDate.toString());
              DateTime today = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day);

              if (pickedDateTime.isBefore(today)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ErrorDialog(
                        title: "Invalid Date Selected!");
                  },
                );
                return null;
              }
              _selectedStartTime = pickedDateTime;
              _selectedEndTime = pickedDateTime.add(const Duration(days: 1));
              return DateFormat('EEE, d MMM, yyyy, hh:mm a')
                  .format(pickedDateTime);
            }
            return null;
          },
          isActive: true,
        ),
        SelectionField(
          title: "Reminder",
          key: UniqueKey(),
          initialValue: event.reminders != null ? "Active" : "Disabled",
            onTap: _setEventReminders,
          isActive: _selectedEndTime != null && _selectedStartTime != null,
        ),
        buildAlarmTile(),
        const CustomDivider(),
        _buildSwitchTile(
          "Smart Suggestion",
          event.smartSuggestion,
              (value) {
            setState(() {
              event.smartSuggestion = !event.smartSuggestion;
            });
          },
        ),
      ]);
    }
    return list;
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged,
      {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              if (trailing != null) trailing,
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.amber,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _titleText() {
    if (event.eventType == "General") {
      return "Add Event";
    } else if (event.eventType == "Birthday") {
      return "Add Birthday";
    } else {
      return "Add Anniversary";
    }
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
          const Text('Alarm',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFFFFFFFF),
              )),
          CustomSlider(
            onValueChanged: (value) {
              if (value == -1) {
                _selectedReminderType = "Alarm";
              } else if (value == 1) {
                _selectedReminderType = "Voice";
              } else {
                _selectedReminderType = "Default";
              }
            },
          ),
          const Text('Voice',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFFFFFFFF),
              )),
        ],
      ),
    );
  }


  _setEventReminders() async {
    final reminderList = await Navigator.pushNamed(context, '/eventRemindersScreen' , arguments: event.reminders);
    if(reminderList != null){
      final newRemindersList = reminderList as List<EventReminder>;
      if(reminderList.isNotEmpty ){
        setState(() {
          event.reminders = newRemindersList;
        });
        return "Active";
      }
      event.reminders = null;
      return "Disabled";
    }
  }

  _setEventRepetition() async {
    final repeatPattern = await Navigator.pushNamed(
      context,
      '/eventRepeatScreen',
      arguments: event.repeatPattern,
    );

    if (repeatPattern != null) {
      if (repeatPattern == "Never") {
        setState(() {
          event.repeatPattern = null;
        });
      } else {
        final newRepeatPattern =
        repeatPattern as EventRepetition;
        setState(() {
          event.repeatPattern = newRepeatPattern;
        });
      }
    }
    // Returns the formatted repeat pattern string
    return event.repeatPattern != null
        ? "Every ${event.repeatPattern!.repeatInterval} ${event.repeatPattern!.repeatUnit}${event.repeatPattern!.repeatOn != null ? " On ${event.repeatPattern!.repeatOn}" : "" }"
        : "Never";
  }


  _setRepeatUntil() async {
    final data = await Navigator.pushNamed(context, '/eventRepeatUntilScreen', arguments: event.repeatPattern) as List?;
    if (data != null) {
      print(data);
      if (data[1] == "Never") {
        setState(() {
          event.repeatPattern!.repeatType =
          "Never";
        });
        return data[0];
      } else if (data[1] == "Time") {

        setState(() {
          event.repeatPattern!.repeatType = "Time";
          event.repeatPattern!.repeatUntil = data[0];
        });
        return DateFormat('d MMM yyyy').format(DateTime.parse(data[0]));
      } else {

        setState(() {
          event.repeatPattern!.repeatType =
          "Count";
          event.repeatPattern!.numOccurrence = data[0];
        });
        return "${data[0]} Occurrences";
      }
    }

  }

}

String formatDateTime(DateTime date){
  return DateFormat('EEE, d MMM, yyyy, hh:mm a').format(date);
}


_showErrorDialog(BuildContext context , String title){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
            title: title);
      });
}

String _checkRepeatType(EventRepetition repeatPattern){
  if (repeatPattern.repeatType == "Time"){
    return DateFormat('d MMM yyyy').format(DateTime.parse(repeatPattern.repeatUntil!));
  }
  else if(repeatPattern.repeatType == "Count"){
    return "${repeatPattern.numOccurrence} Occurrences";
  }
  return "Never";
}