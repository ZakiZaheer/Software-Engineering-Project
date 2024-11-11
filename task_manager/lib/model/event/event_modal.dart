import 'event_reminder_modal.dart';
import 'event_repetition_modal.dart';

class Event {
  int? id;
  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String eventType;
  String? location;
  bool smartSuggestion;
  EventRepetition? repeatPattern;
  List<EventReminder>? reminders;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.eventType = "General",
    this.location,
    this.smartSuggestion = false,
    this.repeatPattern,
    this.reminders,
  });

  // Convert an Event object into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'category': eventType,
      'location': location,
      'smartSuggestion': smartSuggestion == true ? 1 : 0,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: map['startTime'] ?? "00:00",
      endTime: map['endTime'] ?? "23:59",
      eventType: map['category'] ?? "Normal",
      location: map['location'],
      smartSuggestion: map['smartSuggestion'] == 1 ? true : false ,
    );
  }

  // Provide a string representation of the Event object
  @override
  String toString() {
    return 'Event{id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, category: $eventType, location: $location, smartSuggestion: $smartSuggestion, repeatPattern: $repeatPattern, reminders: $reminders}';
  }
}