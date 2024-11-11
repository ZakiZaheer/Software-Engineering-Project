class EventRepetition{
  int? eventId;
  int repeatInterval;
  String repeatUnit;
  String? repeatUntil;
  String repeatType;
  int? numOccurrence;
  String? repeatOn;
  EventRepetition({
    required this.repeatInterval,
    required this.repeatUnit,
    this.repeatUntil,
    this.repeatType = "Never",
    this.numOccurrence,
    this.eventId,
    this.repeatOn,
  });

  Map<String,dynamic> toMap(){
    return {
      "event_id":eventId,
      "repeat_interval":repeatInterval,
      "repeat_unit":repeatUnit,
      "repeat_type": repeatType,
      "repeat_until":repeatUntil,
      "num_occurrence":numOccurrence,
      "repeat_on":repeatOn,
    };
  }

  static EventRepetition fromMap(Map<String,dynamic> map){
    return EventRepetition(
      eventId: map["event_id"],
      repeatInterval: map["repeat_interval"],
      repeatUnit: map["repeat_unit"],
      repeatType:map['repeat_type'],
      repeatUntil: map["repeat_until"],
      numOccurrence: map["num_occurrence"],
      repeatOn: map["repeat_on"]
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}









