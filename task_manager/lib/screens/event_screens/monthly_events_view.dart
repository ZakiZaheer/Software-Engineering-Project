import 'package:flutter/material.dart';
import 'customWidgets/event_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _currentMonth = DateTime.now().month;

  final List<String> _months = [
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

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime(2024, 11, 23): [
      {
        "title": "Event 1",
        "date": "23 November 2024",
        "description": "This is a description of Event 1.",
        "color": Colors.orange,
      },
      {
        "title": "Event 2",
        "date": "23 November 2024",
        "description": "This is a description of Event 2.",
        "color": Colors.blue,
      },
    ],
    DateTime(2024, 11, 25): [
      {
        "title": "Meeting",
        "date": "25 November 2024",
        "description": "Team meeting at 10 AM.",
        "color": Colors.purple,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1329),
        elevation: 0,
        leading: PopupMenuButton<String>(
          color: Color(0xFF0A1A2A),
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == "Calendar View") {
              // Handle Calendar View
            } else if (value == "Week View") {
              // Handle Week View
            } else if (value == "Day View") {
              // Handle Day View
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "Calendar View",
                child: Text("Calendar View",
                    style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: "Week View",
                child: Text("Week View", style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: "Day View",
                child: Text("Day View", style: TextStyle(color: Colors.white)),
              ),
            ];
          },
        ),
        title: Row(
          children: [
            Text(
              _months[_currentMonth - 1],
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              onPressed: _showMonthPicker,
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx < 0) {
            _goToNextMonth();
          } else if (details.velocity.pixelsPerSecond.dx > 0) {
            _goToPreviousMonth();
          }
        },
        child: Column(
          children: [
            _buildWeekdaysRow(),
            _buildCalendarGrid(),
            if (_events[_selectedDay]?.isNotEmpty ?? false)
              _buildEventsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaysRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
              child: Center(
                  child: Text("S",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("M",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("T",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("W",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("T",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("F",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
          Expanded(
              child: Center(
                  child: Text("S",
                      style: TextStyle(color: Colors.grey, fontSize: 16)))),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 0.6,
        ),
        itemCount: _daysInMonth(_focusedDay.year, _currentMonth),
        itemBuilder: (context, index) {
          final day = index + 1;
          DateTime currentDate = DateTime(_focusedDay.year, _currentMonth, day);
          bool isToday = currentDate == DateTime.now();
          bool isSelected = currentDate == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = currentDate;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orange.withOpacity(0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: Colors.green, width: 2)
                    : Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_events[currentDate] != null)
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _events[currentDate]!.take(3).map((event) {
                          return Container(
                            margin: const EdgeInsets.only(top: 2.0),
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            decoration: BoxDecoration(
                              color: event['color'].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event['title'],
                              style: TextStyle(
                                fontSize: 10,
                                color: event['color'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsSection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Events on ${_selectedDay.day} ${_months[_selectedDay.month - 1]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: _events[_selectedDay]!.map((event) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogExample(
                          eventTitle: event['title'],
                          eventDate: event['date'],
                          description: event['description'],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: event['color'].withOpacity(0.2),
                        border: Border.all(color: event['color']),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        event['title'],
                        style: TextStyle(
                          color: event['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthPicker() {
    int selectedYear = _focusedDay.year; // Initialize with the current year

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF0A1A2A),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A2A),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year and Month Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedYear--; // Decrement the year
                          });
                        },
                      ),
                      Text(
                        "$selectedYear",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedYear++; // Increment the year
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Months Grid
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _months.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentMonth = index + 1;
                            _focusedDay =
                                DateTime(selectedYear, _currentMonth, 1);
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: index + 1 == _currentMonth &&
                                    selectedYear == _focusedDay.year
                                ? Colors.orange
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _months[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0), // Extra space at the bottom
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showViewsDialog(BuildContext context, Offset offset) {
    final buttonHeight = kToolbarHeight;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy + buttonHeight,
              left: offset.dx,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3E3E3E), Color(0xFF1E1E1E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _buildDialogOption(
                            Icons.calendar_today, 'Calendar View'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _buildDialogOption(Icons.view_week, 'Week View'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _buildDialogOption(Icons.view_day, 'Day View'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogOption(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _goToNextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _focusedDay = DateTime(_focusedDay.year + 1, _currentMonth, 1);
      } else {
        _currentMonth++;
        _focusedDay = DateTime(_focusedDay.year, _currentMonth, 1);
      }
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _focusedDay = DateTime(_focusedDay.year - 1, _currentMonth, 1);
      } else {
        _currentMonth--;
        _focusedDay = DateTime(_focusedDay.year, _currentMonth, 1);
      }
    });
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
