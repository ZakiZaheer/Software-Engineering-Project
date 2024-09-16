class Task {
  String title;
  String? status;
  String? description;
  String? priority;
  String? date;
  String? time;
  String? category;
  List<String>? subtasks;

  Task({
    required this.title,
    this.status,
    this.description,
    this.priority,
    this.date,
    this.time,
    this.subtasks,
    this.category,
  });

  // Factory constructor to create a Task from a map (for example, when decoding JSON)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      category: map['category'] ?? '',
      subtasks: List<String>.from(map['subtasks'] ?? []),
    );
  }

  // Convert a Task instance to a map (for example, when encoding to JSON)
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

  // Optionally, you can override toString to make it easier to print the Task
  @override
  String toString() {
    return 'Task{title: $title, status: $status, description: $description, priority: $priority, date: $date, time: $time, category: $category, subtasks: $subtasks}';
  }
}
