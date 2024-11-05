import 'package:flutter/material.dart';
import 'customWidgets/date_picker.dart';
import 'customWidgets/time_picker.dart';
import 'customWidgets/alert_slider.dart';
import 'screens/task_screens/task_repeat_screen.dart';
import 'screens/task_screens/task_reminders_screen.dart';
import 'screens/task_screens/task_stop_repeat_screen.dart';
import 'CustomFont.dart';

class TimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetDateTimeScreen();
  }
}

class SetDateTimeScreen extends StatefulWidget {
  @override
  _SetDateTimeScreenState createState() => _SetDateTimeScreenState();
}

class _SetDateTimeScreenState extends State<SetDateTimeScreen> {
  String selectedDate = 'Sun, 8 Sept'; 
  String selectedTime = '11:30 AM'; 
  bool isAlarmOn = true;
  String selectedRepeatOption = "Never"; 
  String selectedStopRepeatOption = "Never"; 
  String reminderText = '5 minutes before the task'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1329),
        title: Text(
          'Set Date/time',
          style: appBarHeadingStyle(),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Set',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildListTile('Date', selectedDate, context, _selectDate),
            buildListTile('Time', selectedTime, context, _selectTime),
            buildListTile('Repeat', selectedRepeatOption, context,
                _navigateToRepeatScreen),
            buildListTile('Stop repeating after', selectedStopRepeatOption,
                context, _navigateToStopRepeatingAfterScreen),
            buildDivider(),
            buildListTile(
                'Reminders', reminderText, context, _navigateToRemindersScreen),
            buildAlarmTile(),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String title, String value, BuildContext context,
      [VoidCallback? onTap]) {
    return ListTile(
      title: Text(
        title,
        style: TimeLeftContent(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TimeContentRight(),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Divider buildDivider() {
    return Divider(color: Colors.grey);
  }

  void _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(),
    );

    setState(() {
      selectedDate =
          "${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}";
    });
    }

  void _selectTime() async {
    String? pickedTime = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => CustomTimePicker(),
    );

    setState(() {
      selectedTime = pickedTime;
    });
    }

  String _getMonthName(int month) {
    const monthNames = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month];
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
              selectedStopRepeatOption = selectedOption;
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
            reminderText = selectedOptions.join(', ');
          });
        }),
      ),
    );
  }

  Widget buildAlarmTile() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0A1A2A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Alarm',
            style: TimeLeftContent(),
          ),
          CustomSlider(
            onValueChanged: (value) {
              print("Slider value changed to: $value");
            },
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
