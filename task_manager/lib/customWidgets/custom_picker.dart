import 'package:flutter/material.dart';

// Custom Repeat Picker Function
void showCustomRepeatPicker(
  BuildContext context, {
  required String title,
  required void Function(int number, String unit) onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return CustomRepeatPicker(
        title: title,
        onConfirm: onConfirm,
      );
    },
  );
}

class CustomRepeatPicker extends StatefulWidget {
  final String title;
  final void Function(int number, String unit) onConfirm;

  CustomRepeatPicker({required this.title, required this.onConfirm});

  @override
  _CustomRepeatPickerState createState() => _CustomRepeatPickerState();
}

class _CustomRepeatPickerState extends State<CustomRepeatPicker> {
  int selectedNumber = 1;
  String selectedUnit = 'minute';

  List<int> numbers = List<int>.generate(99, (i) => i + 1);
  List<String> units = ['minute', 'hour', 'day'];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Every $selectedNumber $selectedUnit(s)',
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
              // Number Picker
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedNumber = numbers[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: numbers.map((number) {
                        final bool isSelected = number == selectedNumber;
                        return Center(
                          child: Text(
                            number.toString(),
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

              // Unit Picker (minute, hour, day)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    physics: FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedUnit = units[index];
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: units.map((unit) {
                        final bool isSelected = unit == selectedUnit;
                        return Center(
                          child: Text(
                            unit,
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
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
                  widget.onConfirm(selectedNumber, selectedUnit);
                  Navigator.of(context).pop();
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
