import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String type; // Post type: "Test", "Notice", "Class Cancellation", "Poll", "Material"
  final String title; // Title of the post
  final String postedOn; // Date when the post was created
  final String? description; // Description of the post (nullable)
  final String? time; // Time details (nullable, for "Test", "Class Cancellation")
  final bool isCr; // Indicates if the user is a Class Representative (CR)
  final String className; // Name of the class
  final List<String>? pollOptions; // Poll options (nullable, for "Poll")
  final String? materialName; // Material name (nullable, for "Material")

  const DetailsScreen({
    super.key,
    required this.type,
    required this.title,
    required this.postedOn,
    this.description,
    this.time,
    required this.isCr,
    required this.className,
    this.pollOptions,
    this.materialName,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF091F40),
        title: Text(
          widget.type,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF091F40),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: MediaQuery.of(context).size.height - 296,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.type,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.className}\nPosted On: ${widget.postedOn}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Body Section
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C3D63),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time Section (for Test and Class Cancellation)
                          if (widget.time != null)
                            Row(
                              children: [
                                Text(
                                  "Time: ${widget.time}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),

                          // Poll Options
                          if (widget.type == "Poll" && widget.pollOptions != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Options",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...widget.pollOptions!.map((option) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle_outlined, color: Colors.white70, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        option,
                                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),

                          // Material Name Section
                          if (widget.type == "Material" && widget.materialName != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Material",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.materialName!,
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            ),

                          // Description Section
                          if (widget.description != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
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
                                  widget.description!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                          const Spacer(),

                          // CR Buttons (Delete and Edit)
                          if (widget.isCr)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                                  onPressed: () {
                                    // Show Delete Confirmation Dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: const Color(0xFF0B223D),
                                          title: const Text(
                                            "Remove",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          content: const Text(
                                            "Are you sure you want to delete this post?",
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                            TextButton(
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                // Confirm delete action
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                                  onPressed: () {
                                    // Handle edit action
                                    print("Edit pressed");
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
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
