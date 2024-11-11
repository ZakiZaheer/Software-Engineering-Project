class EventReminder{
  int reminderInterval;
  String reminderUnit;
  String reminderType;
  int? eventId;

  EventReminder({
    required this.reminderInterval,
    required this.reminderUnit,
    this.reminderType = "Default",
    this.eventId,
  });

  Map<String,dynamic> toMap(){
    return {
      "reminder_interval":reminderInterval,
      "reminder_unit":reminderUnit,
      "reminder_type" : reminderType,
      "event_id" : eventId,
    };
  }

  static EventReminder fromMap(Map<String,dynamic> map){
    return EventReminder(
      reminderInterval: map["reminder_interval"],
      reminderUnit: map["reminder_unit"],
      reminderType: map["reminder_type"],
      eventId: map["event_id"],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}