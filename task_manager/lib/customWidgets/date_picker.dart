import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String? initialDate;

  const CustomDatePicker({super.key, this.initialDate});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  void initializeDate() {
    DateTime currentDate;
    if (widget.initialDate != null) {
      currentDate = DateTime.parse(widget.initialDate!);
    } else {
      currentDate = DateTime.now();
    }

    selectedDay = currentDate.day;
    selectedMonth = currentDate.month;
    selectedYear = currentDate.year;

    // Initialize controllers with the initial index
    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: years.indexOf(selectedYear));
  }

  List<int> days = List<int>.generate(31, (i) => i + 1);
  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];
  List<int> years = List<int>.generate(100, (i) => 2020 + i);

  @override
  void initState() {
    super.initState();
    initializeDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
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
          const Text(
            'Set date',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${selectedDay.toString().padLeft(2, '0')} ${months[selectedMonth - 1]}, $selectedYear',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Day Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: dayController,
                    physics: const FixedExtentScrollPhysics(),
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
              const SizedBox(width: 8),

              // Month Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: monthController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = index + 1;
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: months.map((month) {
                        final bool isSelected = month == months[selectedMonth - 1];
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
              const SizedBox(width: 8),

              // Year Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: yearController,
                    physics: const FixedExtentScrollPhysics(),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Just close the picker
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text('Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              // OK Button
              ElevatedButton(
                onPressed: () {
                  final selecteedDate = DateTime(selectedYear,selectedMonth,selectedDay);
                  Navigator.of(context)
                      .pop(DateFormat('yyyy-MM-dd').format(selecteedDate)); // Return selected date
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF081c3d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: const Text('OK',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
