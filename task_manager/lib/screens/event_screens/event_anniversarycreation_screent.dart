import 'package:flutter/material.dart';
import 'customWidgets/alarm_tile.dart';
import 'screens/event_screens/event_Birthdaycreation_screen.dart';
import 'screens/event_screens/event_creation_screen.dart';
import 'customWidgets/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'screens/event_screens/event_reminder.dart';

class AnniversaryEventScreen extends StatefulWidget {
  @override
  _AnniversaryEventScreenState createState() => _AnniversaryEventScreenState();
}

class _AnniversaryEventScreenState extends State<AnniversaryEventScreen> {
  bool issmartsuggestion = false;
  DateTime selectedFromDate = DateTime.now();
  final DateFormat dateFormat = DateFormat("E, d MMM, yyyy hh:mm a");
  String reminderOptions = "5 minutes before the event";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A), // Dark background color
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Add anniversary", style: TextStyle(color: Colors.white)),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEventScreen()),
                    );
                  },
                  child: _buildEventTypeIcon(Icons.event, "Event", false),
                ),
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
                _buildEventTypeIcon(Icons.flag, "Anniversary", true),
              ],
            ),
            SizedBox(height: 20),
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
                "When",
                dateFormat.format(selectedFromDate),
              ),
            ),
            buildListTile('Reminders', reminderOptions, context,
                _navigateToRemindersScreen),
            buildAlarmTile(),
            SizedBox(height: 20),
            Container(
              height: 2, // Height of the line
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Optional spacing after the line
            _buildSwitchTile("Smart Suggestion", issmartsuggestion, (value) {
              setState(() {
                issmartsuggestion = value;
              });
            }),
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
}
