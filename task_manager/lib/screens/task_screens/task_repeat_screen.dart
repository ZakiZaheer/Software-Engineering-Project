import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/custom_picker.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/model/task/taskRepetition_modal.dart';
import '../../customWidgets/GraadientCheckBox.dart';
import '../../customWidgets/footer.dart';
import '../../model/task/task_modal.dart';

class TaskRepeatScreen extends StatefulWidget {
  final TaskRepetition? repeatPattern;

  const TaskRepeatScreen({super.key, required this.repeatPattern});

  @override
  _TaskRepeatScreenState createState() => _TaskRepeatScreenState();
}

class _TaskRepeatScreenState extends State<TaskRepeatScreen> {
  List<String> options = [
    "1 Hour",
    "1 Day",
    "1 Week",
    "1 Month",
    "1 Year",
  ];
  String? selectedOption;


  @override
  void initState() {
    if (widget.repeatPattern != null) {
      final taskOption =
          "${widget.repeatPattern!.repeatInterval} ${widget.repeatPattern!.repeatUnit}";
      if (!options.contains(taskOption)) {
        options.add(taskOption);
      }
      selectedOption = taskOption;
    } else {
      selectedOption = "Never";
    }
    setState(() {});
    super.initState();
  }

  // Initial selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        title: Text(
          'Repeat',
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
            //Modify
            onPressed: () {
              if(selectedOption == "Never"){
                Navigator.pop(context , "Never");
              }
              else{
                final optionSplit = selectedOption!.split(" ");
                Navigator.pop(context , TaskRepetition(repeatInterval: int.parse(optionSplit[0]), repeatUnit: optionSplit[1]));
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
        child: ListView(
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
            ...options.map((option) {
              bool isSelected = selectedOption == option;
              return GradientCheckBox(
                text: "Every $option",
                isSelected: isSelected,
                onSelect: () {
                  setState(() {
                    selectedOption = option;
                  });
                },
              );
            }),
            GradientCheckBox(
              text: 'Custom',
              isSelected: false,
              onSelect: () {
                showCustomRepeatPicker(
                  context,
                  title: 'Custom Repeat',
                  onConfirm: (interval, unit) {
                    setState(() {
                      if(!options.contains("$interval $unit")){
                        options.add("$interval $unit");
                      }
                      selectedOption = "$interval $unit";
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainFooter(index: 0),
    );
  }
}
