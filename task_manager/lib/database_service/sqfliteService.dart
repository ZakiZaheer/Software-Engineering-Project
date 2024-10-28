import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';

import '../model/task_modal.dart';

class SqfLiteService {
  static final _instance = SqfLiteService._internal();

  factory SqfLiteService() => _instance;

  SqfLiteService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'TaskManager1.db');
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE category(
        name TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE task (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          status INTEGER NOT NULL,
          description TEXT,
          priority INTEGER NOT NULL,
          date DATE,
          time TIME,
          category TEXT NOT NULL,
          FOREIGN KEY (category) REFERENCES category(name) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE task_repetition(
          task_id INTEGER,
          repeat_interval INTEGER NOT NULL,
          repeat_unit TEXT NOT NULL,
          repeat_until DATE,
          num_occurrence INTEGER,
          PRIMARY KEY(task_id)
          FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_tasks(
        title TEXT,
        status INTEGER NOT NULL,
        task_id INTEGER,
        PRIMARY KEY(title,task_id),
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE task_reminder(
        task_id INTEGER,
        reminder_interval INTEGER,
        reminder_unit TEXT,
        reminder_type TEXT NOT NULL,
        PRIMARY KEY(reminder_interval,reminder_unit,task_id),
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
    await db.insert('category', {"name":"To-Do"});
  }

  Future<void> addTestTasks() async{
    for(int i =0 ; i < tasks.length ; i++ ){
      await insertTask(tasks[i]);
    }
  }

  Future<void> addCategory(String category)async{
    final db = await database;
    await db.insert('category', {"name":category});
  }

  Future<List<String>> getCategories()async{
    final db = await database;
    List<Map<String,dynamic>> map = await db.query('category');
    return List.generate(map.length, (i){
      return map[i]['name'];
    });
  }

  Future<void> renameCategory({required String category,required String newName})async{
    final db = await database;
    await db.update('category',{'name':newName} ,where: 'name = ?',whereArgs: [category]);
  }

  Future<void> deleteCategory({required String category})async{
    final db = await database;
    await db.delete('category',where: 'name = ?',whereArgs: [category]);
  }

  Future<void> insertTask(Task task)async{
    final db = await database;
    int taskId = await db.insert('task', task.toMap());

    if(task.repeatPattern != null){
      task.repeatPattern!.taskId = taskId;
      await insertTaskRepetition(task.repeatPattern!);
    }

    if(task.subTasks != null){
      for(int i = 0 ; i < task.subTasks!.length ; i++){
        task.subTasks![i].taskId = taskId;
        await insertSubTask(task.subTasks![i]);
      }
    }

    if(task.reminders!= null){
      for(int i = 0 ; i < task.reminders!.length ; i++){
        task.reminders![i].taskId = taskId;
        await insertTaskReminder(task.reminders![i]);
      }
    }

  }

  Future<List<Task>> getTasks(String category)async{
    //Further Optimize
    final db = await database;
    String curDate = DateTime.now().toString().split(" ")[0];
    String curTime = "${TimeOfDay.now().hour.toString().padLeft(2,'0')}:${TimeOfDay.now().minute.toString().padLeft(2,'0')}";
    List<Map<String,dynamic>> map = await db.query('task',where: 'category = ? AND status = ? AND (date IS NULL OR (date > ? OR ( date = ? AND time >= ? ) ) )',whereArgs: [category,0 , curDate , curDate ,curTime] , orderBy: 'priority DESC , date ' );
    List<Task> tasks = List.generate(map.length, (index){
      Task task =  Task.fromMap(map[index]);
      return task;
    });

    for(int i = 0 ; i < tasks.length ; i++){
        tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
        tasks[i].subTasks = await getSubTasks(tasks[i].id!);
        tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }

    return tasks;

  }

  Future<List<Task>> getCompletedTasks(String category)async{
    //Further Optimize
    final db = await database;
    List<Map<String,dynamic>> map = await db.query('task' , where: 'category = ? AND status = ?',whereArgs: [category , 1], orderBy: 'priority DESC , date ');
    List<Task> tasks = List.generate(map.length, (index){
      Task task =  Task.fromMap(map[index]);
      return task;
    });

    for(int i = 0 ; i < tasks.length ; i++){
      tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
      tasks[i].subTasks = await getSubTasks(tasks[i].id!);
      tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }

    return tasks;
  }

  Future<List<Task>> getUnfinishedTasks(String category)async{
    //Further Optimize
    final db = await database;
    String curDate = DateTime.now().toString().split(" ")[0];
    String curTime = "${TimeOfDay.now().hour.toString().padLeft(2,'0')}:${TimeOfDay.now().minute.toString().padLeft(2,'0')}";
    List<Map<String,dynamic>> map = await db.query('task' , where: 'category = ? AND status = ? AND date IS NOT NULL AND ( date < ? OR (date = ? AND time IS NOT NULL AND time < ?) )',whereArgs: [category , 0 , curDate ,curDate , curTime], orderBy: 'priority DESC , date ');
    List<Task> tasks = List.generate(map.length, (index){
      Task task =  Task.fromMap(map[index]);
      return task;
    });

    for(int i = 0 ; i < tasks.length ; i++){
      tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
      tasks[i].subTasks = await getSubTasks(tasks[i].id!);
      tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }

    return tasks;
  }

  Future<void> deleteTask(Task task)async{
    final db = await database;
    await db.delete('task', where: 'id = ?',whereArgs: [task.id!]);
  }

  Future<void> updateTaskStatus(Task task)async{
    final db = await database;
    int status = task.status == true ? 0 : 1;

    await db.update('task', {'status' : status },where: 'id = ?',whereArgs: [task.id!]);

    if(task.subTasks != null){
      await db.update('sub_tasks', {"status" : status } , where: "task_id = ?" , whereArgs: [task.id!]);
    }

  }

  Future<void> deleteAllCompletedTasks(String category) async{
    final db = await database;
    await db.delete('task' , where: 'status = ? AND category = ?',whereArgs: [1 , category]);
  }

  Future<void> deleteAllUnfinishedTasks(String category) async{
    final db = await database;
    String curDate = DateTime.now().toString().split(" ")[0];
    String curTime = "${TimeOfDay.now().hour.toString().padLeft(2,'0')}:${TimeOfDay.now().minute.toString().padLeft(2,'0')}";
    await db.delete('task' , where: 'category = ? AND status = ? AND date IS NOT NULL AND ( date < ? OR (date = ? AND time IS NOT NULL AND time < ?) )',whereArgs: [category , 0 , curDate ,curDate , curTime]);
  }

  Future<void> insertSubTask(SubTask subTask)async{
    final db = await database;
    await db.insert('sub_tasks',subTask.toMap());
  }

  Future<List<SubTask>?> getSubTasks(int taskId)async{
    final db = await database;
    List<Map<String,dynamic>> map = await db.query('sub_tasks',where: 'task_id = ?',whereArgs: [taskId]);
    List<SubTask> subTasks = List.generate(map.length, (index){
      return SubTask.fromMap(map[index]);
    });
    return subTasks.isNotEmpty ? subTasks : null;
  }

  Future<void> deleteSubTask(int taskId)async{
    final db = await database;
    await db.delete('sub_tasks',where: "task_id = ?",whereArgs: [taskId]);
  }

  Future<void> updateSubTaskStatus(SubTask subTask)async{
    final db = await database;
    int status = subTask.status == true ? 0 : 1;
    await db.update('sub_tasks',{"status" : status } , where: "task_id = ? and title = ?" , whereArgs: [subTask.taskId! , subTask.title] );
    if(status == 0){
      await db.update('task',{"status" : status } , where: "id = ?" , whereArgs: [subTask.taskId!] );
    }
  }

  Future<void> insertTaskRepetition(TaskRepetition repetition)async{
    final db = await database;
    await db.insert('task_repetition', repetition.toMap());
  }

  Future<TaskRepetition?> getTaskRepetition(int taskId)async{
    final db = await database;
    List<Map<String,dynamic>> map = await db.query('task_repetition',where: 'task_id = ?',whereArgs: [taskId]);
    if (map.isNotEmpty){
      return TaskRepetition.fromMap(map[0]);
    }
    return null;
  }

  Future<void> deleteTaskRepetation(int taskId)async{
    final db= await database;
    await db.delete('task_repetition',where: 'task_id = ?',whereArgs: [taskId]);
  }

  Future<void> insertTaskReminder(TaskReminder reminder)async{
    final db = await database;
    await db.insert("task_reminder", reminder.toMap());
  }

  Future<List<TaskReminder>?> getTaskReminders(int taskId)async{
    final db = await database;
    List<Map<String,dynamic>> map = await db.query('task_reminder',where: 'task_id = ?',whereArgs: [taskId]);
    List<TaskReminder> reminders = List.generate(map.length, (index){
      return TaskReminder.fromMap(map[index]);
    }) ;
    return reminders.isNotEmpty ? reminders : null;
  }

  Future<void> deleteTaskReminders(int taskId)async{
    final db= await database;
    await db.delete('task_reminder',where: 'task_id = ?',whereArgs: [taskId]);
  }

}
List<Task> tasks = [
  // Task with Reminder and Subtask
  Task(
    id: 1,
    title: "Complete Flutter Project",
    description: "Finish the remaining modules and fix bugs.",
    priority: 1,
    category: "To-Do",
    date: "2024-11-18",
    time: "14:00",
    status: false,
    reminders: [
      TaskReminder(reminderInterval: 1, reminderUnit: "Hour"),
      TaskReminder(reminderInterval: 1, reminderUnit: "Day")
    ],
    subTasks: [
      SubTask(title: "Fix layout bugs", status: false),
      SubTask(title: "Implement login system", status: false)
    ],
  ),

  // Task with Repeat and Subtask
  Task(
    id: 2,
    title: "Morning Workout",
    priority: 3,
    category: "To-Do",
    date: "2024-11-18",
    time: "06:00",
    status: true,
    repeatPattern: TaskRepetition(repeatInterval: 1, repeatUnit: "Day"),
    subTasks: [
      SubTask(title: "Stretching", status: true),
      SubTask(title: "Cardio", status: false),
    ],
  ),

  // Task with Repeat and Reminder
  Task(
    id: 3,
    title: "Take Vitamins",
    description: "Daily health routine.",
    priority: 2,
    category: "To-Do",
    date: "2024-11-18",
    time: "08:00",
    status: false,
    repeatPattern: TaskRepetition(repeatInterval: 1, repeatUnit: "Day"),
    reminders: [
      TaskReminder(reminderInterval: 30, reminderUnit: "Minute", reminderType: "Notification"),
    ],
  ),

  // Task with Subtasks Only
  Task(
    id: 4,
    title: "Plan Vacation",
    description: "Look for flights and accommodation options.",
    priority: 2,
    date: "2024-11-18",
    category: "To-Do",
    status: false,
    subTasks: [
      SubTask(title: "Search for hotels", status: false),
      SubTask(title: "Book tickets", status: false),
      SubTask(title: "Plan itinerary", status: false),
    ],
  ),

  // Task with Reminder Only
  Task(
    id: 5,
    title: "Team Meeting",
    description: "Discuss Q4 targets.",
    priority: 1,
    category: "To-Do",
    date: "2024-11-20",
    time: "09:00",
    status: false,
    reminders: [
      TaskReminder(reminderInterval: 15, reminderUnit: "Minute", reminderType: "Popup")
    ],
  ),

  // Task with Repeat Pattern Only
  Task(
    id: 6,
    title: "Yoga Session",
    priority: 3,
    category: "To-Do",
    time: "07:30",
    status: true,
    repeatPattern: TaskRepetition(repeatInterval: 2, repeatUnit: "Day"),
  ),

  // Task with Repeat, Reminder, and Subtasks
  Task(
    id: 7,
    title: "Weekly Report",
    description: "Prepare and submit the weekly report.",
    priority: 1,
    category: "To-Do",
    date: "2024-10-22",
    time: "16:00",
    status: false,
    repeatPattern: TaskRepetition(repeatInterval: 1, repeatUnit: "Week"),
    reminders: [
      TaskReminder(reminderInterval: 2, reminderUnit: "Hour")
    ],
    subTasks: [
      SubTask(title: "Collect data", status: false),
      SubTask(title: "Analyze results", status: false),
      SubTask(title: "Write summary", status: false),
    ],
  ),

  // Task with Subtasks and Reminder
  Task(
    id: 8,
    title: "Prepare for Presentation",
    description: "Prepare slides and talking points.",
    priority: 1,
    category: "Test",
    date: "2024-10-23",
    time: "10:00",
    status: false,
    reminders: [
      TaskReminder(reminderInterval: 1, reminderUnit: "Day")
    ],
    subTasks: [
      SubTask(title: "Create slides", status: false),
      SubTask(title: "Practice speaking points", status: false),
    ],
  ),

  // Task with Repeat Pattern Only
  Task(
    id: 9,
    title: "Call Parents",
    description: "Weekly call to check in.",
    priority: 2,
    category: "Test",
    date: "2024-10-18",
    time: "19:00",
    status: false,
    repeatPattern: TaskRepetition(repeatInterval: 1, repeatUnit: "Week"),
  ),

  // Task with Reminder and Repeat Pattern
  Task(
    id: 10,
    title: "Water the Plants",
    priority: 3,
    category: "Test",
    time: "08:00",
    status: false,
    repeatPattern: TaskRepetition(repeatInterval: 2, repeatUnit: "Day"),
    reminders: [
      TaskReminder(reminderInterval: 30, reminderUnit: "Minute")
    ],
  ),
];
