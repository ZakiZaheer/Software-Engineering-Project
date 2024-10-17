import 'package:flutter/material.dart';

void showCustomTaskDialog(BuildContext context, String taskTitle,
    String dateTime, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor:
            Colors.transparent, // Transparent background for gradient effect
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Set width to 80% of screen width
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  SizedBox(width: 10),
                  // Task title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align details with task title
                      children: [
                        Text(
                          taskTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8), // Space between title and details
                        // Task date and time (details directly under title)
                        Text(
                          dateTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 5),
                        // Task description
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  // Red status circle
                ],
              ),
              SizedBox(height: 20), // Space between title/details and buttons
              // Row for Delete and Edit buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Delete button
                  ElevatedButton(
                    onPressed: () {
                      // Add delete functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Larger button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  // Edit button
                  ElevatedButton(
                    onPressed: () {
                      // Add edit functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF0A1329), // Dark blue for Edit button
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Larger button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class TaskDescriptionDialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Description Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCustomTaskDialog(context, 'Drink Water',
                'Sun, 8 Sep 2024, 11:00 AM', 'Stay hydrated!!');
          },
          child: Text('Show Task Description'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TaskDescriptionDialogExample()));
}
