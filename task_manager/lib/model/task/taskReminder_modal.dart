class TaskReminder{
  int reminderInterval;
  String reminderUnit;
  String reminderType;
  int? taskId;

  TaskReminder({
    required this.reminderInterval,
    required this.reminderUnit,
    this.reminderType = "Default",
    this.taskId,
  });

  Map<String,dynamic> toMap(){
    return {
      "reminder_interval":reminderInterval,
      "reminder_unit":reminderUnit,
      "reminder_type" : reminderType,
      "task_id" : taskId,
    };
  }

  static TaskReminder fromMap(Map<String,dynamic> map){
    return TaskReminder(
      reminderInterval: map["reminder_interval"],
      reminderUnit: map["reminder_unit"],
      reminderType: map["reminder_type"],
      taskId: map["task_id"],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}