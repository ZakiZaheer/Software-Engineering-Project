import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int selectedCount = 1;

  // List for numbers from 1 to 99
  List<int> numbers = List<int>.generate(99, (i) => i + 1); // 1 to 99

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
          // Heading 'Count'
          Text(
            'Count',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22, // Heading size
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16),

          // Number Picker
          SizedBox(
            height: 120,
            child: ListWheelScrollView.useDelegate(
              physics: FixedExtentScrollPhysics(),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedCount = numbers[index];
                });
              },
              childDelegate: ListWheelChildLoopingListDelegate(
                children: numbers.map((number) {
                  final bool isSelected = number == selectedCount;
                  return Center(
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: isSelected ? 20 : 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                  backgroundColor: Colors.grey[300], // Cancel button color
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
                  // Return selected count when "OK" is pressed
                  Navigator.of(context).pop(selectedCount);
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
