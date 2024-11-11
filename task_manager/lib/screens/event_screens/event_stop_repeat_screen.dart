import 'package:flutter/material.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/customWidgets/counter.dart';
import 'package:task_manager/customWidgets/date_picker.dart';
import 'package:task_manager/model/task/taskRepetition_modal.dart';

import '../../customWidgets/GraadientCheckBox.dart';
import '../../model/event/event_repetition_modal.dart';

class EventRepeatUntilScreen extends StatefulWidget {
  final EventRepetition? repeatPattern;

  const EventRepeatUntilScreen({super.key, this.repeatPattern});

  @override
  _EventRepeatUntilScreenState createState() => _EventRepeatUntilScreenState();
}

class _EventRepeatUntilScreenState extends State<EventRepeatUntilScreen> {
  List<String> options = [
    "Never",
    "Time",
    "Count",
  ];

  String? selectedOption = "Time";
  int? countValue;
  String? date;// Stores the count if selected


  @override
  void initState() {
    if(widget.repeatPattern != null){
      if(widget.repeatPattern!.repeatType == "Time"){
        selectedOption = "Time";
        date = widget.repeatPattern!.repeatUntil!;
      }
      else if(widget.repeatPattern!.repeatType == "Count"){
        selectedOption = "Count";
        countValue = widget.repeatPattern!.numOccurrence!;
      }
      else{
        selectedOption = "Never";
      }
    }
    else{
      selectedOption ="Never";
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        title: Text(
          'Stop repeating after',
          style: appBarHeadingStyle(),
        ),
        backgroundColor: const Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if(selectedOption == "Never"){
                Navigator.pop(context , ["Never",selectedOption]);
              }
              else if(selectedOption == "Time"){
                Navigator.pop(context , [date,selectedOption]);
              }
              else{
                Navigator.pop(context , [countValue,selectedOption]);
              }
            },
            child: Text(
              "Save",
              style: appBarHeadingButton(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: Colors.white.withOpacity(0.6),
            height: 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            GradientCheckBox(
              text: "Never",
              isSelected: selectedOption == "Never",
              onSelect: () {
                setState(() {
                  selectedOption = "Never";
                });
              },
            ),
            GradientCheckBox(
              text: "Time",
              isSelected: selectedOption == "Time",
              onSelect: () async {

                final selectedDate = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return const CustomDatePicker();
                  },
                );
                if(selectedDate != null){
                  setState(() {
                    selectedOption = "Time";
                    date = selectedDate;
                  });
                }
              },
            ),
            GradientCheckBox(
              text: "Count",
              isSelected: selectedOption == "Count",
              onSelect: () async {

                final selectedCount = await showModalBottomSheet<int>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return CounterWidget();
                  },
                );
                if (selectedCount != null) {
                  setState(() {
                    selectedOption = "Count";
                    countValue = selectedCount;
                  });
                }
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            Text(
              "Selected : ${_selectedValue()}",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xFFFFFFFF),
              ),
            )
          ],
        ),
      ),
    );
  }
  _selectedValue(){
    if(selectedOption == "Time"){
      return "Until $date";
    }
    else if(selectedOption == "Count"){
      return "for $countValue Iterations";
    }
    else{
      return "Never";
    }
  }

}

