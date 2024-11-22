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
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'category': eventType,
      'location': location,
      'is_smart_suggested': smartSuggestion == true ? 1 : 0,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['start_time']) ,
      endTime: DateTime.parse(map['end_time']),
      eventType: map['category'],
      location: map['location'],
      smartSuggestion: map['is_smart_suggested'] == 1 ? true : false ,
    );
  }

  // Provide a string representation of the Event object
  @override
  String toString() {
    return 'Event{id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, category: $eventType, location: $location, smartSuggestion: $smartSuggestion, repeatPattern: $repeatPattern, reminders: $reminders}';
  }
}