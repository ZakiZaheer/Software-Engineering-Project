import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/TaskTile.dart';

import '../model/subTask_modal.dart';
import '../model/task_modal.dart';

class TaskExpansionTile extends StatefulWidget {
  final String title;
  final List<Task> tasks;
  final Function(Task) onChecked;
  final Function(Task) onTap;
  final Function(SubTask) onSubTaskChecked;
  const TaskExpansionTile(
      {super.key, required this.title, required this.tasks , required this.onTap , required this.onChecked , required this.onSubTaskChecked});

  @override
  State<TaskExpansionTile> createState() => _TaskExpansionTileState();
}

class _TaskExpansionTileState extends State<TaskExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // Use black text to contrast
            ),
          ),
          leading: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ),
        if (isExpanded)
          ...List.generate(widget.tasks.length, (index) {
            return TaskTile(
                task: widget.tasks[index],
                onTap: widget.onTap,
                onChecked: widget.onChecked,
                onSubTaskChecked: widget.onSubTaskChecked);
          })
      ],
    );
  }
}
