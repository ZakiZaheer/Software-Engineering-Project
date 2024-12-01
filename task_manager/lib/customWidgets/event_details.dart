import 'package:flutter/material.dart';

class CustomDialogExample extends StatelessWidget {
  final String eventTitle;
  final String eventDate;
  final String description;

  CustomDialogExample({
    required this.eventTitle,
    required this.eventDate,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogHeight = screenSize.height * 0.55; // Adjusted height
    final dialogWidth = screenSize.width * 0.9; // Adjusted width

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: const Color(0xFF1A2B45), // Dialog background color
      child: Container(
        height: dialogHeight,
        width: dialogWidth,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E4977), Color(0xFF12284B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      eventDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description Section
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Reminders Section
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reminders",
                    style: TextStyle(
                      fontSize: 16, // Matches the design's section title size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        "5 minutes before the event",
                        style: TextStyle(
                          fontSize: 12, // Matches the design's metadata size
                          color: Colors.white70,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.white38),

            // Smart Suggestion Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Smart suggestion",
                  style: TextStyle(
                    fontSize: 16, // Matches the design's section title size
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    // Handle switch logic
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle delete action
                  },
                  child: CircleAvatar(
                    radius: 25, // Matches the design's button size
                    backgroundColor: const Color(0xFF284366),
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle edit action
                  },
                  child: CircleAvatar(
                    radius: 25, // Matches the design's button size
                    backgroundColor: const Color(0xFF284366),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
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
