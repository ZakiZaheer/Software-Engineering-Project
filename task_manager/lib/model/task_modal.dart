class Task {
  String title;
  bool status;
  String? description;
  int? priority;
  String? date;
  String? time;
  String? category;
  List<String>? subtasks;

  Task({
    required this.title,
    this.status = false,
    this.description,
    this.priority,
    this.date,
    this.time,
    this.subtasks,
    this.category,
  });

 
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
      'description': description,
      'priority': priority,
      'date': date,
      'time': time,
      'category': category,
      'subtasks': subtasks,
    };
  }

  @override
  String toString() {
    return 'Task{title: $title, status: $status, description: $description, priority: $priority, date: $date, time: $time, category: $category, subtasks: $subtasks}';
  }
}
