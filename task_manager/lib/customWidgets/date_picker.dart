import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  void initializeDate() {
    DateTime currentDate = DateTime.now();
    selectedDay = currentDate.day;
    selectedMonth = currentDate.month;
    selectedYear = currentDate.year;
  }

  List<int> days = List<int>.generate(31, (i) => i + 1);
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<int> years = List<int>.generate(10, (i) => 2020 + i);

  @override
  void initState() {
    super.initState();
    initializeDate();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Set date',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${months[selectedMonth - 1]} ${selectedDay.toString().padLeft(2, '0')} $selectedYear',
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
              // Day Picker
              Expanded(
                child: SizedBox(
                  height: 120,
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

              // Month Picker
              Expanded(
                child: SizedBox(
                  height: 120,
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

              // Year Picker
              Expanded(
                child: SizedBox(
                  height: 120,
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
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Just close the picker
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Changed from 'primary'
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
                  DateTime selectedDate =
                      DateTime(selectedYear, selectedMonth, selectedDay);
                  Navigator.of(context)
                      .pop(selectedDate); // Return selected date
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
