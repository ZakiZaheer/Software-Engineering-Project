import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import '../../model/event/event_modal.dart';
import '/../../customWidgets/event_details.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _currentMonth = DateTime.now().month;
  final db = SqfLiteService();
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

  Future<Map<DateTime, List<Event>>> generateEventsForMonth(int year, int month) async {
    Map<DateTime, List<Event>> events = {};
    // Get the number of days in the specified month
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    int daysInMonth = firstDayOfNextMonth.difference(firstDayOfMonth).inDays;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(year, month, day);
      List<Event>  currentEvents= await db.getDailyEvents(currentDate);
      events[currentDate] = currentEvents;
    }

    return events;
  }

  Map<DateTime,List<Event>> _events = {};



  Future<void> loadEvents()async{
    _events = await generateEventsForMonth(_selectedDay.year, _selectedDay.month);
    setState(() {

    });
  }


  @override
  void initState() {
    loadEvents();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const  Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor:const  Color(0xFF0A1329),
        elevation: 0,
        leading: PopupMenuButton<String>(
          color:const Color(0xFF0A1A2A),
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
        onHorizontalDragEnd: (details) async {
          if (details.velocity.pixelsPerSecond.dx < 0) {
            _goToNextMonth();
          } else if (details.velocity.pixelsPerSecond.dx > 0) {
            _goToPreviousMonth();
          }
          await loadEvents();
          print("Month changed $_selectedDay");
          setState(() {
          });
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/eventCreationScreen').then((value)async{
          await loadEvents();
          setState(() {

          });
        });
      },child: Icon(Icons.add),),
      bottomNavigationBar: const MainFooter(index: 1),
    );
  }

  Widget _buildWeekdaysRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
    final firstDayOfMonth = DateTime(_focusedDay.year, _currentMonth, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _currentMonth + 1, 0);


    int startPadding =
        firstDayOfMonth.weekday % 7;
    DateTime firstDayInGrid =
    firstDayOfMonth.subtract(Duration(days: startPadding));


    List<DateTime> visibleDays = List.generate(35, (index) {
      return firstDayInGrid.add(Duration(days: index));
    });

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
        itemCount: visibleDays.length,
        itemBuilder: (context, index) {
          final currentDate = visibleDays[index];


          bool isCurrentMonth = currentDate.month == _currentMonth;

          bool isToday = isCurrentMonth &&
              currentDate.year == DateTime.now().year &&
              currentDate.month == DateTime.now().month &&
              currentDate.day == DateTime.now().day;

          bool isSelected = isCurrentMonth &&
              currentDate.year == _selectedDay.year &&
              currentDate.month == _selectedDay.month &&
              currentDate.day == _selectedDay.day;

          return GestureDetector(
            onTap: () {
              if (isCurrentMonth) {
                setState(() {
                  _selectedDay = currentDate;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.orange.withOpacity(0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: Colors.green, width: 2)
                    : Border.all(
                  color: isCurrentMonth
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                ),
              ),
              padding: const EdgeInsets.all(4.0),
              child: isCurrentMonth
                  ? Column(
                children: [
                  Text(
                    "${currentDate.day}",
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
                        children:
                        _events[currentDate]!.take(3).map((event) {
                          return Container(
                            margin: const EdgeInsets.only(top: 2.0),
                            padding:
                            const EdgeInsets.symmetric(vertical: 2.0),
                            decoration: BoxDecoration(
                              color: _getEventColor(event.eventType).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 10,
                                color: _getEventColor(event.eventType),
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              )
                  : const SizedBox.shrink(), // Empty cell for non-month days
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
                          event: event,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _getEventColor(event.eventType).withOpacity(0.2),
                        border: Border.all(color: _getEventColor(event.eventType)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        event.title,
                        style: TextStyle(
                          color: _getEventColor(event.eventType),
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
    int selectedYear = _focusedDay.year;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF0A1A2A),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  // Year Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon:
                        const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: () {
                          setModalState(() {
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
                          setModalState(() {
                            selectedYear++; // Increment the year
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Month Selector
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
                        onTap: () async {
                          _currentMonth = index + 1;
                          _focusedDay =
                              DateTime(selectedYear, _currentMonth, 1);

                          // Check if the current date is in the selected month
                          if (_currentMonth == DateTime.now().month &&
                              selectedYear == DateTime.now().year) {
                            _selectedDay =
                                DateTime.now(); // Highlight current date
                          } else {
                            _selectedDay = DateTime(selectedYear,
                                _currentMonth, 1); // Default to the first day
                          }
                          await loadEvents();
                          setState(() {

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


  void _goToNextMonth() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _focusedDay = DateTime(_focusedDay.year + 1, _currentMonth, 1);
      } else {
        _currentMonth++;
        _focusedDay = DateTime(_focusedDay.year, _currentMonth, 1);
      }
      _selectedDay = _focusedDay;
  }

  void _goToPreviousMonth() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _focusedDay = DateTime(_focusedDay.year - 1, _currentMonth, 1);
      } else {
        _currentMonth--;
        _focusedDay = DateTime(_focusedDay.year, _currentMonth, 1);
      }
      _selectedDay = _focusedDay;
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}


_getEventColor(String type){
  if(type == "General"){
    return Colors.yellow;
  }
  else if(type == "Birthday"){
    return Colors.purple;
  }
  else if(type == "Anniversary"){
    return Colors.green;
  }
  else{
    return Colors.blue;
  }
}