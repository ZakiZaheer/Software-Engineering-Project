import 'package:flutter/material.dart';

class TaskAlert extends StatelessWidget {
  final String title;
  final String? body;
  final String button1Text;
  final String button2Text;
  final Function() onPressedButton1;
  final Function() onPressedButton2;
  const TaskAlert({
    super.key ,
    required this.title ,
    required this.body ,
    required this.onPressedButton1,
    required this.button1Text ,
    required this.button2Text ,
    required this.onPressedButton2
    });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor:
      Colors.transparent, // Transparent background for gradient effect
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
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align details with task title
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Task description
                if(body != null)
                  ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        body!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,

                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]

              ],
            ),
            const SizedBox(height: 20), // Space between title/details and buttons
            // Row for Delete and Edit buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Delete button
                ElevatedButton(
                  onPressed: () {
                    onPressedButton1();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    padding:const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    button1Text,
                    style:const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                // Edit button
                ElevatedButton(
                  onPressed: () async {
                    await onPressedButton2();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const
                    Color(0xFF0A1329), // Dark blue for Edit button
                    padding:const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    button2Text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
