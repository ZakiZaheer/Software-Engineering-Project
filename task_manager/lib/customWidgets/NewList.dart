import 'package:flutter/material.dart';

class UpdateListPopUp extends StatelessWidget {
  final String title;
  final Function(String category) onSaved;
  const UpdateListPopUp({super.key, required this.title , required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final textContl = TextEditingController();
    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.5, // Limit height to 50% of screen height
            maxWidth: 500, // Limit width to 500 pixels
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3A8FDC),
                  Color(0xFF16607A),
                ], // Gradient colors from screenshot
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            padding: const EdgeInsets.all(16.0), // Padding for the entire container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Ensure the column takes minimum space
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row with close icon and title text
                    Row(
                      children: [
                        // Close Icon (X)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close dialog on tap
                          },
                          child:const Icon(Icons.close, color: Colors.black),
                        ),
                        const SizedBox(
                            width: 8), // Spacing between close icon and text
                        // Title
                         Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        onSaved(textContl.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF081c3d), // Dark blue color for Save button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0), // Increased button width
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 20), // Spacing between title row and input field

                // Input field for the list name
                TextField(
                  controller: textContl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // White background for input
                    hintText: title,
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, // No border
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
