import 'package:flutter/material.dart';

import '../model/task_modal.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key , required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.3), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white, // White outline
                  ),
                  child: Checkbox(
                    value: task.status,
                    onChanged: (val) {
                      // onChecked(widget.task);
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    side: BorderSide(
                      color: Colors.white, // Outline color
                      width: 2.0, // Outline width
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white, // Use black text to contrast
                              ),
                            ),
                          ],
                        ),
                        if (task.date != null)
                          Row(
                            children: [
                              Text(
                                task.date!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                  Colors.white, // Use black text to contrast
                                ),
                              ),
                              if (task.time != null)
                                Text(
                                  task.time!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .white, // Use black text to contrast
                                  ),
                                ),
                              if (task.repeatPattern != null)
                                Text(
                                  task.repeatPattern.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .white, // Use black text to contrast
                                  ),
                                ),
                            ],
                          ),
                      ],
                    )
                ),
                if (task.subTasks != null)
                  IconButton(
                      onPressed: () {
                        // setState(() {
                        //   _toggleExpansion();
                        // });
                      },
                      icon: const Icon(Icons.expand_more)),
                const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white ,
                      radius: 10,)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
