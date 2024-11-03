import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task_modal.dart';

class TaskDescription extends StatelessWidget {
  final Task task;
  final Function(Task) onDelete;

  const TaskDescription(
      {super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor:
          Colors.transparent, // Transparent background for gradient effect
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Set width to 80% of screen width
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3DA2DB), // Light blue color
                Color(0xFF16667A) // Teal color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the left
            children: [
              // First Row with Title, Close button and Red Circle
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close (X) button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  const SizedBox(width: 10),
                  // Task title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align details with task title
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Space between title and details
                        if(task.date!=null)...[
                        Wrap(
                          children: [
                            const Icon(Icons.timer),
                            Text(
                              " ${_formatDate(task.date!)}, ",
                              style: const TextStyle(
                                fontSize: 12,
                                color:
                                Colors.white, // Use black text to contrast
                              ),
                            ),
                            if (task.time != null)
                              Text(
                                "${_formatTime(task.time!)} ",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .white, // Use black text to contrast
                                ),
                              ),
                            if (task.repeatPattern != null)
                              Wrap(
                                children: [
                                  const Icon(Icons.repeat),
                                  Text(
                                    " Every ${task.repeatPattern!.repeatInterval} ${task.repeatPattern!.repeatUnit}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors
                                          .white, // Use black text to contrast
                                    ),
                                  ),
                                ],
                              )
        
                          ],
                        ),
                        const SizedBox(height: 5),],
                        // Task description
                        if(task.description != null)
                        Text(
                          task.description!,
                          style:const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Red status circle
                ],
              ),
              const SizedBox(height: 20),
              // Space between title/details and buttons
              // Row for Delete and Edit buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Delete button
                  ElevatedButton(
                    onPressed: () async {
                      await onDelete(task);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Larger button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  // Edit button
                  ElevatedButton(
                    onPressed: () async {
                      final category = await Navigator.pushNamed(context, '/taskModificationScreen' , arguments: task);
                      Navigator.pop(context , category);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF0A1329), // Dark blue for Edit button
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Larger button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


String _formatTime(String timeString) {
  final DateFormat inputFormat = DateFormat('HH:mm');
  final DateFormat outputFormat = DateFormat('hh:mm a');

  DateTime time = inputFormat.parse(timeString);
  String formattedTime = outputFormat.format(time);

  return 'At $formattedTime';
}

String _formatDate(String dateInput) {
  DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateInput);
  return "On ${DateFormat('d MMM').format(parsedDate)}";

}