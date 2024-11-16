import 'package:flutter/material.dart';
import 'package:task_manager/model/event/event_repetition_modal.dart';
import '../../Custom_Fonts.dart';
import '../../customWidgets/GraadientCheckBox.dart';
import '../../customWidgets/footer.dart';
import 'event_custom_day_screen.dart';

class EventRepeatScreen extends StatefulWidget {
  final EventRepetition? repeatPattern;

  const EventRepeatScreen({super.key, required this.repeatPattern});

  @override
  _EventRepeatScreenState createState() => _EventRepeatScreenState();
}

class _EventRepeatScreenState extends State<EventRepeatScreen> {
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
      final option =
          "${widget.repeatPattern!.repeatInterval} ${widget.repeatPattern!.repeatUnit} ${widget.repeatPattern!.repeatOn != null ? "On ${widget.repeatPattern!.repeatOn}" : "" }";
      if (!options.contains(option)) {
        options.add(option);
      }
      selectedOption = option;
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
                String? repeatOn;
                if(optionSplit.length > 2){
                  repeatOn = optionSplit[3].replaceFirst(")", "");
                }
                Navigator.pop(context , EventRepetition(repeatInterval: int.parse(optionSplit[0]), repeatUnit: optionSplit[1] , repeatOn: repeatOn));
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
              onSelect: ()async {
                final customFrequency = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomFrequencyPage(selectedOption: selectedOption!,),
                  ),
                );

                if (customFrequency != null) {
                  setState(() {
                    final option = customFrequency as EventRepetition;
                    final newOption = "${option.repeatInterval} ${option.repeatUnit} ${option.repeatOn != null ? "(On ${option.repeatOn})" : ""}";
                    if(!options.contains(newOption)){
                      options.add(newOption);
                    }
                    selectedOption = newOption;
                  });
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainFooter(index: 1),
    );
  }
}
