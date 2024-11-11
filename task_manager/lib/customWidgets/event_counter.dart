import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final String title;
  final int minCount;
  final int maxCount;
  final String cancelButtonText;
  final String okButtonText;

  CounterWidget({
    required this.title,
    this.minCount = 1,
    this.maxCount = 99,
    this.cancelButtonText = 'Cancel',
    this.okButtonText = 'OK',
  });

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int selectedCount;
  late List<int> numbers;

  @override
  void initState() {
    super.initState();
    selectedCount = widget.minCount;
    numbers = List<int>.generate(
        widget.maxCount - widget.minCount + 1, (i) => widget.minCount + i);
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
          // Heading with customizable title
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
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
              // Cancel Button with customizable label
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
                  widget.cancelButtonText,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              // OK Button with customizable label
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedCount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF081c3d),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: Text(
                  widget.okButtonText,
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
