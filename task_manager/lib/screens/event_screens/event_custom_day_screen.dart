import 'package:flutter/material.dart';
import 'package:task_manager/model/event/event_repetition_modal.dart';
import '../../customWidgets/event_counter.dart';

class CustomFrequencyPage extends StatefulWidget {
  final String selectedOption;
  CustomFrequencyPage({super.key, required this.selectedOption});
  @override
  _CustomFrequencyPageState createState() => _CustomFrequencyPageState();
}

class _CustomFrequencyPageState extends State<CustomFrequencyPage> {
  String selectedUnit = "Day";
  int selectedInterval = 2;
  List<bool> selectedMonths = List.generate(12, (_) => false);
  List<bool> selectedDates = List.generate(31, (_) => false);
  List<bool> selectedDays = List.generate(7, (_) => false);
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
        width: 120,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-65, 0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
                        selectedUnit = option;
                      });
                      _toggleDropdown();

                      switch (option) {
                        case "Week":
                          setState(() {
                            selectedUnit = "Week";
                          });
                          break;
                        case "Month":
                          setState(() {
                            selectedUnit = "Month";
                          });
                          break;
                        case "Year":
                          setState(() {
                            selectedUnit = "Year";
                          });
                          break;
                        default:
                          setState(() {
                            selectedUnit = "Day";
                          });
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
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          if (option == selectedUnit)
                            const Icon(
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
  void initState() {
    if(widget.selectedOption != "Never"){
      final optionSplit = widget.selectedOption.trim().split(" ");
      selectedUnit = optionSplit[1];
      selectedInterval = int.parse(optionSplit[0]);
      if(optionSplit.length > 2){
        List<String> repeatOn = optionSplit[3].replaceAll(")", "").split("/");
        if(selectedUnit == "Week"){
          List<String> days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
          for(int i =0 ; i < repeatOn.length ; i++){
            int index = days.indexOf(repeatOn[i]);
            selectedDays[index] = true;
          }
        }
        else if(selectedUnit == "Month"){
          List<String> dates = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
            "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
            "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
          ];
          for(int i =0 ; i < repeatOn.length ; i++){
            int index = dates.indexOf(repeatOn[i]);
            selectedDates[index] = true;
          }
        }
        else{
          List<String> months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
          ];
          for(int i =0 ; i < repeatOn.length ; i++){
            int index = months.indexOf(repeatOn[i]);
            selectedMonths[index] = true;
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Custom",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              EventRepetition repeatPattern = EventRepetition(repeatInterval: selectedInterval, repeatUnit: selectedUnit);
              List<String> repeatOn = [];
              if(repeatPattern.repeatUnit == "Week"){
                List<String> days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
                for(int i =0 ; i < 7 ; i++){
                  if(selectedDays[i]){
                    repeatOn.add(days[i]);
                  }
                }
              }
              else if(repeatPattern.repeatUnit == "Month"){
                List<String> dates = [
                  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                  "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                  "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
                ];
                for(int i =0 ; i < 31 ; i++){
                  if(selectedDates[i]){
                    repeatOn.add(dates[i]);
                  }
                }
              }
              else if(repeatPattern.repeatUnit == "Year"){
                List<String> months = [
                  "January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"
                ];

                for(int i =0 ; i < 12 ; i++){
                  if(selectedMonths[i]){
                    repeatOn.add(months[i]);
                  }
                }
              }
              else{
                repeatOn = [];
              }
              repeatPattern.repeatOn = repeatOn.isNotEmpty ? repeatOn.join("/") : null;
              print(repeatPattern);
              Navigator.pop(context, repeatPattern);
            },
            child: const Text(
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
                const Text(
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
                          selectedUnit,
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final selectedCount = await showModalBottomSheet<int>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return CounterWidget(
                      title: 'Select Quantity',
                      minCount: 1,
                      maxCount: 50,
                      cancelButtonText: 'Dismiss',
                      okButtonText: 'Confirm',
                    );
                  },
                );

                if (selectedCount != null) {
                  setState(() {
                    selectedInterval = selectedCount;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Every",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "$selectedInterval",
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
            const SizedBox(height: 15),
            if (selectedUnit != "Day")
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Choose Reminder Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Event will repeat every $selectedInterval days',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectionFields(),
          ],
        ),
      ),
    );
  }

  _buildSelectionFields(){
    if(selectedUnit == "Week"){
      return _buildDaySelector();
    }
    else if(selectedUnit == "Month"){
      return _buildDateSelector();
    }
    else if(selectedUnit == "Year"){
      return _buildMonthSelector();
    }
    return const SizedBox();
  }

  Widget _buildDaySelector() {
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDays[index] = !selectedDays[index];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color:
              selectedDays[index] ? const Color(0xFFFFA500) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              days[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              style:const  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
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
      gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              selectedMonths[index] ?const Color(0xFFFFA500) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              months[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
