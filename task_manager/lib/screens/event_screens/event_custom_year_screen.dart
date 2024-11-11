import 'package:flutter/material.dart';
import 'event_custom_day_screen.dart';
import 'event_custom_month_screen.dart';
import 'event_custom_week_screen.dart';
import '../../customWidgets/event_counter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: YearScreen(),
    );
  }
}

class YearScreen extends StatefulWidget {
  @override
  _YearScreenState createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  String selectedFrequency = "Year";
  int frequencyYears = 2;
  List<bool> selectedMonths = List.generate(12, (_) => false);
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 120,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-65, 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.tealAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ["Day", "Week", "Month", "Year"].map((option) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFrequency = option;
                      });
                      _toggleDropdown();

                      switch (option) {
                        case "Week":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Week_Screen()),
                          );
                          break;
                        case "Month":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Month_Screen()),
                          );
                          break;
                        case "Day":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomFrequencyPage()),
                          );
                          break;
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          if (option == selectedFrequency)
                            Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Custom",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, frequencyYears);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: Colors.white.withOpacity(0.6),
            height: 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Frequency",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: _toggleDropdown,
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: Row(
                      children: [
                        Text(
                          selectedFrequency,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final selectedCount = await showModalBottomSheet<int>(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return CounterWidget(
                      title: 'Select Quantity',
                      minCount: 1,
                      maxCount: 99,
                      cancelButtonText: 'Cancel',
                      okButtonText: 'OK',
                    );
                  },
                );

                if (selectedCount != null) {
                  setState(() {
                    frequencyYears = selectedCount;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Every",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "$frequencyYears",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Choose Reminder Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Event will repeat every $frequencyYears years on ${_getSelectedMonths()}',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            SizedBox(height: 8),
            _buildMonthSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMonths[index] = !selectedMonths[index];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  selectedMonths[index] ? Color(0xFFFFA500) : Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              months[index],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSelectedMonths() {
    List<String> selected = [];
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    for (int i = 0; i < selectedMonths.length; i++) {
      if (selectedMonths[i]) selected.add(months[i]);
    }
    return selected.join(', ');
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
