import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Future<DateTime?> showCustomDateTimePicker({
  required BuildContext context,
  required String title,
  DateTime? initialDateTime,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return CustomDateTimePicker(
        title: title,
        initialDateTime: initialDateTime,
      );
    },
  );
}

class CustomDateTimePicker extends StatefulWidget {
  final String title;
  final DateTime? initialDateTime;

  const CustomDateTimePicker({super.key, required this.title , this.initialDateTime});

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late DateTime selectedDate;
  late int selectedHour;
  late int selectedMinute;
  late bool isAM;

  @override
  void initState() {
    super.initState();
    if(widget.initialDateTime != null){
      selectedDate = widget.initialDateTime!;
    }
    else{
      DateTime now = DateTime.now();
      selectedDate = now;
    }
    selectedHour = selectedDate.hour > 12 ? selectedDate.hour - 12 : (selectedDate.hour == 0 ? 12 : selectedDate.hour);
    selectedMinute = selectedDate.minute;
    isAM = selectedDate.hour < 12;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A8CC7), Color(0xFF63B8E2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEE, d MMM, yyyy, hh:mm a').format(selectedDate),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Date Picker Wheel
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 70,
                    controller: FixedExtentScrollController(
                      initialItem: selectedDate.difference(DateTime.now()).inDays, // Calculate relative days difference
                    ),                    onSelectedItemChanged: (index) {
                      setState(() {
                        final DateTime date =
                            DateTime.now().add(Duration(days: index));
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          isAM ? selectedHour : selectedHour + 12,
                          selectedMinute,
                        );
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List<DateTime>.generate(
                        365 * 5, // Approximate days for 5 years
                        (index) => DateTime.now().add(Duration(days: index)),
                      ).map((date) {
                        final bool isSelected = date.day == selectedDate.day &&
                            date.month == selectedDate.month &&
                            date.year == selectedDate.year;
                        return Center(
                          child: Text(
                            DateFormat('EEE, MMM d, yyyy').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: isSelected ? 24 : 20,
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
              // Hour Picker Wheel (12-hour format)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    controller: FixedExtentScrollController(
                        initialItem: selectedHour - 1),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = index + 1;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          isAM ? selectedHour : (selectedHour % 12) + 12,
                          selectedMinute,
                        );
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(12, (index) {
                        final hour = index + 1;
                        final bool isSelected = hour == selectedHour;
                        return Center(
                          child: Text(
                            hour.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Minute Picker Wheel
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    controller: FixedExtentScrollController(
                        initialItem: selectedMinute),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = index;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          isAM ? selectedHour : (selectedHour % 12) + 12,
                          selectedMinute,
                        );
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(60, (index) {
                        final bool isSelected = index == selectedMinute;
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // AM/PM Picker Wheel with only two values (no looping)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    controller: FixedExtentScrollController(
                        initialItem: isAM ? 0 : 1),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        isAM = index == 0;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          isAM ? selectedHour : (selectedHour % 12) + 12,
                          selectedMinute,
                        );
                      });
                    },
                    children: [
                      Center(
                        child: Text(
                          "AM",
                          style: TextStyle(
                            color: isAM ? Colors.white : Colors.black54,
                            fontSize: isAM ? 20 : 16,
                            fontWeight:
                                isAM ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "PM",
                          style: TextStyle(
                            color: !isAM ? Colors.white : Colors.black54,
                            fontSize: !isAM ? 20 : 16,
                            fontWeight:
                                !isAM ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                      selectedDate); // Pass the selected date back to parent
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
