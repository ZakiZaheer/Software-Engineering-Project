import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late String selectedPeriod;

  List<int> hours = List<int>.generate(12, (i) => i + 1); // 1 to 12
  List<int> minutes = List<int>.generate(60, (i) => i); // 0 to 59
  List<String> periods = ['AM', 'PM']; // AM and PM

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  void _initializeTime() {
    DateTime now = DateTime.now();
    selectedHour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour); // Convert to 12-hour format
    selectedMinute = now.minute;
    selectedPeriod = now.hour >= 12 ? 'PM' : 'AM'; // Determine AM or PM
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.teal],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Set time',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$selectedHour:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Hour Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = hours[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: hours.map((hour) {
                        bool isSelected =
                            hour == selectedHour && selectedHour != -1;
                        return Center(
                          child: Text(
                            hour.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),

              // Minute Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = minutes[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: minutes.map((minute) {
                        bool isSelected =
                            minute == selectedMinute && selectedMinute != -1;
                        return Center(
                          child: Text(
                            minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),

              // Period Picker (AM/PM)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedPeriod = periods[index];
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: periods.length,
                      builder: (context, index) {
                        bool isSelected = periods[index] == selectedPeriod &&
                            selectedPeriod.isNotEmpty;
                        return Center(
                          child: Text(
                            periods[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Cancel button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text('Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              // OK Button
              ElevatedButton(
                onPressed: () {
                  String formattedTime =
                      '$selectedHour:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod';
                  print('Selected Time: $formattedTime');
                  Navigator.of(context).pop(formattedTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF081c3d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: Text('OK',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
