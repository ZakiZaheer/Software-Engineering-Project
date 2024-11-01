class TaskRepetition{
  int? taskId;
  int repeatInterval;
  String repeatUnit;
  String? repeatUntil;
  String repeatType;
  int? numOccurrence;

  TaskRepetition({
    required this.repeatInterval,
    required this.repeatUnit,
    this.repeatUntil,
    this.repeatType = "Never",
    this.numOccurrence,
    this.taskId,
  });

  Map<String,dynamic> toMap(){
    return {
      "task_id":taskId,
      "repeat_interval":repeatInterval,
      "repeat_unit":repeatUnit,
      "repeat_type": repeatType,
      "repeat_until":repeatUntil,
      "num_occurrence":numOccurrence,
    };
  }

  static TaskRepetition fromMap(Map<String,dynamic> map){
    return TaskRepetition(
      taskId: map["task_id"],
      repeatInterval: map["repeat_interval"],
      repeatUnit: map["repeat_unit"],
      repeatType:map['repeat_type'],
      repeatUntil: map["repeat_until"],
      numOccurrence: map["num_occurrence"],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}









