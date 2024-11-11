import 'package:flutter/material.dart';
import 'event_custom_day_screen.dart';
import 'event_custom_week_screen.dart';
import 'event_custom_year_screen.dart';
import '../../customWidgets/event_counter.dart';

class Month_Screen extends StatefulWidget {
  @override
  _Month_ScreenState createState() => _Month_ScreenState();
}

class _Month_ScreenState extends State<Month_Screen> {
  String selectedFrequency = "Month";
  int frequencyMonths = 2;
  List<bool> selectedDates = List.generate(31, (_) => false);

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

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
        width: 120, // Width of the dropdown
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-65, 0), // Adjust the offset to align below "Day"
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

                      // Navigate to the appropriate page based on the selected option
                      switch (option) {
                        case "Day":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomFrequencyPage()));
                          break;
                        case "Week":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Week_Screen()),
                          );
                          break;
                        case "Year":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YearScreen()),
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
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, frequencyMonths);
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
                      maxCount: 50,
                      cancelButtonText: 'Cancel',
                      okButtonText: 'OK',
                    );
                  },
                );

                if (selectedCount != null) {
                  setState(() {
                    frequencyMonths = selectedCount;
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
                        "2",
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
                'Event will repeat every $frequencyMonths months on ${_getSelectedDates()}',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            SizedBox(height: 8),
            _buildDateSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 31,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDates[index] = !selectedDates[index];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  selectedDates[index] ? Color(0xFFFFA500) : Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
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

  String _getSelectedDates() {
    List<String> selected = [];
    for (int i = 0; i < selectedDates.length; i++) {
      if (selectedDates[i]) selected.add('${i + 1}');
    }
    return selected.join(', ');
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
