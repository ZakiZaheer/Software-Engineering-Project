import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/SelectionField.dart';
import 'package:task_manager/customWidgets/date_picker.dart';
import 'package:task_manager/customWidgets/time_picker.dart';
import 'package:task_manager/customWidgets/alert_slider.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';
import 'package:task_manager/Custom_Fonts.dart';
import '../../model/task_modal.dart';

class TaskDateTimeSelectionScreen extends StatefulWidget {
  final Task task;

  const TaskDateTimeSelectionScreen({super.key, required this.task});

  @override
  State<TaskDateTimeSelectionScreen> createState() =>
      _TaskDateTimeSelectionScreenState();
}

class _TaskDateTimeSelectionScreenState
    extends State<TaskDateTimeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1329),
        title: Text(
          'Set Date/time',
          style: appBarHeadingStyle(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, widget.task);
            },
            child: Text(
              'Set',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectionField(
              title: "Date",
              initialValue: widget.task.date ?? "none",
              onTap: () async {
                String? pickedDate = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) => CustomDatePicker(
                    initialDate: widget.task.date,
                  ),
                );

                if (pickedDate != null) {
                  setState(() {
                    widget.task.date = pickedDate.toString();
                  });
                }
                return pickedDate;
              },
            ),
            SelectionField(
                title: "Time",
                initialValue: widget.task.time ?? "none",
                onTap: widget.task.date != null
                    ? () async {
                        String? pickedTime = await showModalBottomSheet<String>(
                          context: context,
                          builder: (context) => CustomTimePicker(
                            initialTime: widget.task.time,
                          ),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            widget.task.time = pickedTime;
                          });
                        }
                        return pickedTime;
                      }
                    : null),
            SelectionField(
              title: "Repeat",
              initialValue: widget.task.repeatPattern != null
                  ? "Every ${widget.task.repeatPattern!.repeatInterval} ${widget.task.repeatPattern!.repeatUnit}"
                  : "Never",
              onTap: widget.task.date != null
                  ? () async {
                      final repeatPattern = await Navigator.pushNamed(
                        context,
                        '/taskRepeatScreen',
                        arguments: widget.task.repeatPattern,
                      );

                      if (repeatPattern != null) {
                        if (repeatPattern == "Never") {
                          setState(() {
                            widget.task.repeatPattern = null;
                          });
                        } else {
                          final newRepeatPattern =
                              repeatPattern as TaskRepetition;
                          setState(() {
                            if (widget.task.repeatPattern != null) {
                              widget.task.repeatPattern!.repeatInterval =
                                  newRepeatPattern.repeatInterval;
                              widget.task.repeatPattern!.repeatUnit =
                                  newRepeatPattern.repeatUnit;
                            } else {
                              widget.task.repeatPattern = newRepeatPattern;
                            }
                          });
                        }
                      }
                      // Returns the formatted repeat pattern string
                      return widget.task.repeatPattern != null
                          ? "Every ${widget.task.repeatPattern!.repeatInterval} ${widget.task.repeatPattern!.repeatUnit}"
                          : "Never";
                    }
                  : null,
            ),
            SelectionField(
              title: "Stop Repeating After",
              initialValue: "Never",
              onTap: widget.task.repeatPattern != null
                  ? () async {
                      final data = await Navigator.pushNamed(context, '/taskRepeatUntilScreen', arguments: widget.task.repeatPattern) as List?;
                        if (data != null) {
                          if (data[1] == "Never") {

                            setState(() {
                              widget.task.repeatPattern!.repeatUntilType =
                              "Never";
                            });
                            return data[0];
                          } else if (data[1] == "Time") {

                            setState(() {
                              widget.task.repeatPattern!.repeatUntilType = "Time";
                              widget.task.repeatPattern!.repeatUntil = data[0];
                            });
                            return data[0];
                          } else {

                            setState(() {
                              widget.task.repeatPattern!.repeatUntilType =
                              "Count";
                              widget.task.repeatPattern!.numOccurrence = data[0];
                            });
                            return "${data[0]} Iterations";
                          }
                        }

                    }
                  : null,
            ),
            const Divider(color: Colors.grey),
            SelectionField(
              title: "Reminders",
              initialValue: "At Task Time",
              onTap: () {
                Navigator.pushNamed(context, '/taskRemindersScreen');
              },
            ),
            buildAlarmTile(),
          ],
        ),
      ),
    );
  }

  Widget buildAlarmTile() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Alarm',
            style: TimeLeftContent(),
          ),
          CustomSlider(
            onValueChanged: (value) {
              print("Slider value changed to: $value");
            },
          ),
          Text(
            'Voice',
            style: TimeLeftContent(),
          ),
        ],
      ),
    );
  }
}
//
// class SetDateTimeScreen extends StatefulWidget {
//   @override
//   _SetDateTimeScreenState createState() => _SetDateTimeScreenState();
// }
//
// class _SetDateTimeScreenState extends State<SetDateTimeScreen> {
//   String selectedDate = 'Sun, 8 Sept';
//   String selectedTime = '11:30 AM';
//   bool isAlarmOn = true;
//   String selectedRepeatOption = "Never";
//   String selectedStopRepeatOption = "Never";
//   String reminderText = '5 minutes before the task';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0A1A2A),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0A1329),
//         title: Text(
//           'Set Date/time',
//           style: appBarHeadingStyle(),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.close, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               'Set',
//               style: appBarHeadingButton(),
//             ),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(2),
//           child: Container(
//             color: Colors.white.withOpacity(0.6),
//             height: 2,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildListTile('Date', selectedDate, context, _selectDate),
//             buildListTile('Time', selectedTime, context, _selectTime),
//             // buildListTile('Repeat', selectedRepeatOption, context,
//             //     _navigateToRepeatScreen),
//             buildListTile('Stop repeating after', selectedStopRepeatOption,
//                 context, _navigateToStopRepeatingAfterScreen),
//             buildDivider(),
//             buildListTile(
//                 'Reminders', reminderText, context, _navigateToRemindersScreen),
//             buildAlarmTile(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildListTile(String title, String value, BuildContext context,
//       [VoidCallback? onTap]) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TimeLeftContent(),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             value,
//             style: TimeContentRight(),
//           ),
//           Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//         ],
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Divider buildDivider() {
//     return Divider(color: Colors.grey);
//   }
//
//   void _selectDate() async {
//     DateTime? pickedDate = await showModalBottomSheet<DateTime>(
//       context: context,
//       builder: (context) => Placeholder(),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         selectedDate =
//             "${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}";
//       });
//     }
//   }
//
//   void _selectTime() async {
//     String? pickedTime = await showModalBottomSheet<String>(
//       context: context,
//       builder: (context) => CustomTimePicker(),
//     );
//
//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//       });
//     }
//   }
//
//   String _getMonthName(int month) {
//     const monthNames = [
//       "",
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];
//     return monthNames[month];
//   }
//
//   // void _navigateToRepeatScreen() {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => TaskRepeatScreen(
//   //         onSave: (selectedOption) {
//   //           setState(() {
//   //             selectedRepeatOption = selectedOption;
//   //           });
//   //         },
//   //       ),
//   //     ),
//   //   );
//   }
//
//   void _navigateToStopRepeatingAfterScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StopRepeatScreen(
//           onOptionSelected: (String selectedOption, [int? countValue]) {
//             setState(() {
//               selectedStopRepeatOption = selectedOption;
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   void _navigateToRemindersScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RemindersScreen(onSave: (selectedOptions) {
//           setState(() {
//             reminderText = selectedOptions.join(', ');
//           });
//         }),
//       ),
//     );
//   }
//
//   Widget buildAlarmTile() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF0A1A2A),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey, width: 1.0),
//       ),
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Alarm',
//             style: TimeLeftContent(),
//           ),
//           CustomSlider(
//             onValueChanged: (value) {
//               print("Slider value changed to: $value");
//             },
//           ),
//           Text(
//             'Voice',
//             style: TimeLeftContent(),
//           ),
//         ],
//       ),
//     );
//   }
// }
