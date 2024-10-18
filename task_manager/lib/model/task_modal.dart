import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';

class Task{
  int? id;
  String title;
  String? description;
  int priority;
  String category;
  String? date;
  String? time;
  bool status;
  TaskRepetition? repeatPattern;
  List<TaskReminder>? reminders;
  List<SubTask>? subTasks;
  Task({
    this.id,
    required this.title,
    this.description,
    this.priority = 1,
    this.category = "To-Do",
    this.date,
    this.time,
    this.status = false,
    this.repeatPattern,
    this.reminders,
    this.subTasks,
  });


  Map<String,dynamic> toMap(){
    return {
      "title": title,
      "description": description,
      "priority" : priority ,
      "category" : category,
      "date" : date,
      "time" : time,
      "status" : status ==  true ? 1 : 0,
    };
  }

  static Task fromMap(Map<String,dynamic> map){
    return Task(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      priority: map["priority"],
      category: map["category"],
      date: map["date"],
      time: map["time"],
      status: map["status"]  == 1 ? true : false,
    );
  }

  @override
  String toString() {
    return '''{
      title : $title,
      description : $description,
      priority : $priority,
      category : $category,
      date : $date,
      time : $time,
      status : $status,
      repeatPattern : $repeatPattern,
      reminders : $reminders,
      subtasks : $subTasks
    }''';
  }
}