import 'package:flutter/material.dart';
import 'customWidgets/input_field.dart';
import 'customWidgets/alarm_tile.dart';
import 'screens/event_screens/event_anniversarycreation_screen.dart';
import 'screens/event_screens/event_Birthdaycreation_screen.dart';
import 'customWidgets/date_time_picker.dart';
import 'screens/event_screens/event_repeat_screen.dart';
import 'screens/task_screens/task_stop_repeat_screen.dart';
import 'screens/event_screens/event_reminder.dart';
import 'package:intl/intl.dart';
void main() => runApp(EventApp());

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddEventScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  bool isAllDay = false;
  bool isAlarmOn = false;
  String selectedRepeatOption = "Never";
  String selectedStopRepeatOption = "Never";
  String reminderOptions = "5 minutes before the event";

  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now().add(Duration(hours: 1));
  final DateFormat dateFormat = DateFormat("E, d MMM, yyyy hh:mm a");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Add Event", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Create", style: TextStyle(color: Colors.white)),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEventTypeIcon(Icons.event, "Event", true),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BirthdayEventScreen()),
                    );
                  },
                  child: _buildEventTypeIcon(Icons.cake, "Birthday", false),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnniversaryEventScreen()),
                    );
                  },
                  child: _buildEventTypeIcon(Icons.flag, "Anniversary", false),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildTextField("Event Name"),
            SizedBox(height: 20),
            _buildSwitchTile("All Day", isAllDay, (value) {
              setState(() {
                isAllDay = value;
              });
            }),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showCustomDateTimePicker(
                  context: context,
                  title: 'From',
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedFromDate = pickedDate;
                  });
                }
              },
              child: _buildDateTimePicker(
                "From",
                dateFormat.format(selectedFromDate),
              ),
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showCustomDateTimePicker(
                  context: context,
                  title: 'To',
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedToDate = pickedDate;
                  });
                }
              },
              child: _buildDateTimePicker(
                "To",
                dateFormat.format(selectedToDate),
              ),
            ),
            buildListTile('Repeat', selectedRepeatOption, context,
                _navigateToRepeatScreen),
            buildListTile('Stop repeating after', selectedStopRepeatOption,
                context, _navigateToStopRepeatingAfterScreen),
            buildListTile('Reminders', reminderOptions, context,
                _navigateToRemindersScreen),
            buildAlarmTile(),
            SizedBox(height: 20),
            buildTextField("Location"),
            SizedBox(height: 20),
            buildTextField("Description"),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeIcon(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Icon(icon, color: isSelected ? Colors.amber : Colors.white, size: 40),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged,
      {Widget? trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
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

  Widget buildListTile(String title, String value, BuildContext context,
      [VoidCallback? onTap]) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.grey),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  void _navigateToRepeatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepeatScreen(
          onSave: (selectedOption) {
            setState(() {
              selectedRepeatOption = selectedOption;
            });
          },
        ),
      ),
    );
  }

  void _navigateToStopRepeatingAfterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StopRepeatScreen(
          onOptionSelected: (String selectedOption, [int? countValue]) {
            setState(() {
              selectedStopRepeatOption = countValue != null
                  ? "$selectedOption after $countValue times"
                  : selectedOption;
            });
          },
        ),
      ),
    );
  }

  void _navigateToRemindersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemindersScreen(onSave: (selectedOptions) {
          setState(() {
            reminderOptions = selectedOptions.join(', ');
          });
        }),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          Row(
            children: [
              Text(date, style: TextStyle(color: Colors.white70)),
              Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ],
      ),
    );
  }
}
