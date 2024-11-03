import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import '../model/task_modal.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final Function(Task) onTap;
  final Function(Task) onChecked;
  final Function(SubTask) onSubTaskChecked;

  const TaskTile(
      {super.key,
      required this.task,
      required this.onTap,
      required this.onChecked,
      required this.onSubTaskChecked});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  TextDecoration decoration = TextDecoration.none;
  Widget checkBox = const Placeholder();
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task.status == true) {
      setState(() {
        decoration = TextDecoration.lineThrough;
        checkBox = IconButton(
            onPressed: () async {
              await widget.onChecked(widget.task);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ));
      });
    } else {
      setState(() {
        checkBox = Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.white, // White outline
          ),
          child: Checkbox(
            value: widget.task.status,
            onChanged: (val) async {
              await widget.onChecked(widget.task);
              // await NotificationService.cancelTaskReminders(widget.task);
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
            side: const BorderSide(
              color: Colors.white, // Outline color
              width: 2.0, // Outline width
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.task);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                checkBox,
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.task.title,
                          style: TextStyle(
                              decorationColor: Colors.white,
                              decorationThickness: 1.5,
                              fontSize: 16,
                              color: Colors.white,
                              decoration: decoration
                              // Use black text to contrast
                              ),
                        ),
                      ],
                    ),
                    if (widget.task.date != null)
                      Wrap(
                        children: [
                          const Icon(Icons.timer),
                          Text(
                            " ${_formatDate(widget.task.date!)}, ",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white, // Use black text to contrast
                            ),
                          ),
                          if (widget.task.time != null)
                            Text(
                              "${_formatTime(widget.task.time!)} ",
                              style: const TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.white, // Use black text to contrast
                              ),
                            ),
                          if (widget.task.repeatPattern != null) Wrap(
                            children: [
                              const Icon(Icons.repeat),
                              Text(
                                " Every ${widget.task.repeatPattern!.repeatInterval} ${widget.task.repeatPattern!.repeatUnit}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                  Colors.white, // Use black text to contrast
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                  ],
                )),
                if (widget.task.subTasks != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more),
                  ),
                Center(
                    child: CircleAvatar(
                  backgroundColor: _selectTaskColor(widget.task),
                  radius: 10,
                )),
              ],
            ),
          ),
          if (isExpanded)
            if(widget.task.subTasks!=null)
            ...[
            const Divider(
              color: Colors.white,
              indent: 15,
            ),

            ...List.generate(widget.task.subTasks!.length, (index) {
              return SubTaskTile(
                subTask: widget.task.subTasks![index],
                onChecked: (subTask) {
                  widget.onSubTaskChecked(subTask);
                  setState(() {});
                },
              );
            }),
            const Divider(
              color: Colors.white,
              indent: 15,
            ),
          ]
        ],
      ),
    );
  }
}

class SubTaskTile extends StatelessWidget {
  final SubTask subTask;
  final Function(SubTask) onChecked;

  const SubTaskTile(
      {super.key, required this.subTask, required this.onChecked});

  @override
  Widget build(BuildContext context) {
    TextDecoration decoration = TextDecoration.none;
    Widget checkBox = Theme(
      data: ThemeData(
        unselectedWidgetColor: Colors.white, // White outline
      ),
      child: Checkbox(
        value: subTask.status,
        onChanged: (val) async {
          await onChecked(subTask);
        },
        activeColor: Colors.white,
        checkColor: Colors.black,
        side: const BorderSide(
          color: Colors.white, // Outline color
          width: 2.0, // Outline width
        ),
      ),
    );

    if (subTask.status == true) {
      decoration = TextDecoration.lineThrough;
      checkBox = IconButton(
          onPressed: () async {
            await onChecked(subTask);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ));
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
        child: Row(children: [
          checkBox,
          const SizedBox(width: 10),
          Text(subTask.title,
              style: TextStyle(
                decoration: decoration,
                decorationColor: Colors.white,
                fontSize: 16,
                color: Colors.white, // Use black text to contrast
              )),
        ]));
  }
}

_selectTaskColor(Task task) {
  if (task.priority == 1) {
    return Colors.red;
  } else if (task.priority == 0) {
    return Colors.yellow;
  }
  return Colors.green;
}

String _formatTime(String timeString) {
  final DateFormat inputFormat = DateFormat('HH:mm');
  final DateFormat outputFormat = DateFormat('hh:mm a');

  DateTime time = inputFormat.parse(timeString);
  String formattedTime = outputFormat.format(time);

  return 'At $formattedTime';
}

String _formatDate(String dateString) {
  final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
  final DateFormat outputFormat = DateFormat('dd MMM');

  DateTime dateTime = inputFormat.parse(dateString);
  String formattedDate = outputFormat.format(dateTime);

  return 'On $formattedDate';
}
