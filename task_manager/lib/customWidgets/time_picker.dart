import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final String? initialTime;

  const CustomTimePicker({super.key, this.initialTime});

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

  // Scroll controllers for each picker
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController periodController;

  @override
  void initState() {
    super.initState();
    _initializeTime();
    // Initialize controllers with calculated initial index
    hourController =
        FixedExtentScrollController(initialItem: hours.indexOf(selectedHour));
    minuteController = FixedExtentScrollController(
        initialItem: minutes.indexOf(selectedMinute));
    periodController = FixedExtentScrollController(
        initialItem: periods.indexOf(selectedPeriod));
  }

  void _initializeTime() {
    TimeOfDay currentTime;
    if (widget.initialTime != null) {
      final timeParts = widget.initialTime!.split(":");
      currentTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    } else {
      currentTime = TimeOfDay.now();
    }
    selectedHour = currentTime.hour > 12
        ? currentTime.hour - 12
        : (currentTime.hour == 0
            ? 12
            : currentTime.hour); // Convert to 12-hour format
    selectedMinute = currentTime.minute;
    selectedPeriod = currentTime.hour >= 12 ? 'PM' : 'AM'; // Determine AM or PM
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
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Set time',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$selectedHour:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod',
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
              // Hour Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: hourController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = hours[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: hours.map((hour) {
                        bool isSelected = hour == selectedHour;
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
              const SizedBox(width: 8),

              // Minute Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: minuteController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = minutes[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: minutes.map((minute) {
                        bool isSelected = minute == selectedMinute;
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
              const SizedBox(width: 8),

              // Period Picker (AM/PM)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    controller: periodController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedPeriod = periods[index];
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: periods.length,
                      builder: (context, index) {
                        bool isSelected = periods[index] == selectedPeriod;
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
          const SizedBox(height: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text('Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              // OK Button
              ElevatedButton(
                onPressed: () {
                  int hour24 = selectedPeriod == 'PM' && selectedHour != 12
                      ? selectedHour + 12
                      : (selectedPeriod == 'AM' && selectedHour == 12
                          ? 0
                          : selectedHour);

                  String formattedTime =
                      '${hour24.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                  Navigator.of(context).pop(formattedTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF081c3d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
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
