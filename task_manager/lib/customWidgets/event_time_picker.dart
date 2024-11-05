import 'package:flutter/material.dart';


class CustomDatePicker extends StatefulWidget {
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  int selectedDay = 8;
  int selectedMonth = 9;
  int selectedYear = 2024;

  // Lists for day, month, and year
  List<int> days = List<int>.generate(31, (i) => i + 1);
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<int> years = List<int>.generate(10, (i) => 2020 + i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.blue[400]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Set date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Show the currently selected date
              Text(
                '${selectedDay.toString().padLeft(2, '0')} ${months[selectedMonth - 1]} $selectedYear',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Day Picker
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        physics: FixedExtentScrollPhysics(),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedDay = days[index];
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: days.map((day) {
                            final bool isSelected = day == selectedDay;
                            return Center(
                              child: Text(
                                day.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 18,
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
                  // Month Picker
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        physics: FixedExtentScrollPhysics(),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMonth = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: months.map((month) {
                            final bool isSelected =
                                month == months[selectedMonth - 1];
                            return Center(
                              child: Text(
                                month,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 18,
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
                  // Year Picker
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        physics: FixedExtentScrollPhysics(),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedYear = years[index];
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: years.map((year) {
                            final bool isSelected = year == selectedYear;
                            return Center(
                              child: Text(
                                year.toString(),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 18,
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
                      backgroundColor: Colors.grey, // Cancel button color
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text('Cancel'),
                  ),
                  // OK Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle OK action
                      print(
                          'Selected Date: $selectedDay/$selectedMonth/$selectedYear');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800], // OK button color
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
