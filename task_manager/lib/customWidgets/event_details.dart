import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/event/event_reminder_modal.dart';

import '../model/event/event_modal.dart';

class CustomDialogExample extends StatefulWidget {
  final Event event;

  CustomDialogExample({
    required this.event
  });

  @override
  _CustomDialogExampleState createState() => _CustomDialogExampleState();
}

class _CustomDialogExampleState extends State<CustomDialogExample> {
  final db = SqfLiteService();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogHeight = screenSize.height * 0.55; // Adjusted height
    final dialogWidth = screenSize.width * 0.9; // Adjusted width

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: const Color(0xFF1A2B45),
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
                      widget.event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${formatDateTime(widget.event.startTime)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,

                      ),
                      maxLines: 2,

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
              widget.event.description ?? "No Description",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Location Section
            const Text(
              "Location",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.location ?? "Not Available",
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/eventSetRemindersScreen',arguments: widget.event).then((value){
                        if(value != null){
                          widget.event.reminders = value as List<EventReminder>;
                        }
                        else{
                          widget.event.reminders = null;
                        }
                        setState(() {

                        });
                      });
                    },
                    child: Row(
                      children:  [
                        Text(
                          widget.event.reminders!= null ? "Active" : "Disabled",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.white70),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.white38),

            // Smart Suggestion Section
            if(widget.event.eventType == "Birthday" ||  widget.event.eventType == "Anniversary")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Smart suggestion",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: widget.event.smartSuggestion,
                  onChanged: (value) async {
                    await db.toggleSmartSuggestion(widget.event);
                    widget.event.smartSuggestion = !widget.event.smartSuggestion;
                    setState(() {
                    });
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white38,
                ),
              ],
            ),
            const Spacer(),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    await db.deleteEvent(widget.event);
                    Navigator.pushNamed(context, '/eventScreen');
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF284366),
                    child:
                    const Icon(Icons.delete, color: Colors.white, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/eventModificationScreen' , arguments: widget.event);

                  },
                  child: CircleAvatar(
                    radius: 25,
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
}String formatDateTime(DateTime date){
  return DateFormat('EEE, d MMM, yyyy, hh:mm a').format(date);
}
