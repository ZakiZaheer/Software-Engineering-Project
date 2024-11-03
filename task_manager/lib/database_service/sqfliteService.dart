import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import 'package:task_manager/model/taskRepetition_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/notification_service/work_manger_service.dart';
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
    final path = join(await getDatabasesPath(), 'TaskManager4.db');
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
          repeat_type TEXT NOT NULL,
          repeat_until DATE,
          num_occurrence INTEGER,
          PRIMARY KEY(task_id),
          FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_task(
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
    await db.insert('category', {"name": "To-Do"});
  }

  Future<void> addCategory(String category) async {
    final db = await database;
    await db.insert('category', {"name": category});
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    List<Map<String, dynamic>> map = await db.query('category');
    return List.generate(map.length, (i) {
      return map[i]['name'];
    });
  }

  Future<void> renameCategory(
      {required String category, required String newName}) async {
    final db = await database;
    await db.update('category', {'name': newName},
        where: 'name = ?', whereArgs: [category]);
  }

  Future<void> deleteCategory({required String category}) async {
    final db = await database;
    await db.delete('category', where: 'name = ?', whereArgs: [category]);
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    int taskId = await db.insert('task', task.toMap());
    task.id = taskId;
    if (task.repeatPattern != null) {
      task.repeatPattern!.taskId = taskId;
      await insertTaskRepetition(task.repeatPattern!);
    }

    if (task.subTasks != null) {
      for (int i = 0; i < task.subTasks!.length; i++) {
        task.subTasks![i].taskId = taskId;
        await insertSubTask(task.subTasks![i]);
      }
    }

    if (task.reminders != null) {
      for (int i = 0; i < task.reminders!.length; i++) {
        task.reminders![i].taskId = taskId;
        await insertTaskReminder(task.reminders![i]);
      }
      if(task.reminders![0].reminderType == "Voice"){
        await WorkManagerService.scheduleTaskVoiceNotification(task);
      }
      else if(task.reminders![0].reminderType == "Alarm"){
        await NotificationService.scheduleTaskAlarmReminder(task);
      }
      else{
        await NotificationService.scheduleTaskDefaultReminder(task);
      }
    }


  }

  Future<List<Task>> getTasks(String category) async {
    //Further Optimize
    final db = await database;
    String curDate =formatDate(DateTime.now());
    String curTime =
        "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
    List<Map<String, dynamic>> map = await db.query(
        'task',
        where: '''
    category = ? 
    AND status = ? 
    AND (date IS NULL 
         OR date > ? 
         OR (date = ? AND (time IS NULL OR time >= ?)))
  ''',
        whereArgs: [category, 0, curDate, curDate, curTime],
        orderBy: 'priority DESC, date'
    );

    List<Task> tasks = List.generate(map.length, (index) {
      Task task = Task.fromMap(map[index]);
      return task;
    });

    for (int i = 0; i < tasks.length; i++) {
      tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
      tasks[i].subTasks = await getSubTasks(tasks[i].id!);
      tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }

    return tasks;
  }

  Future<List<Task>> getCompletedTasks(String category) async {
    //Further Optimize
    final db = await database;
    List<Map<String, dynamic>> map = await db.query('task',
        where: 'category = ? AND status = ?',
        whereArgs: [category, 1],
        orderBy: 'priority DESC , date ');
    List<Task> tasks = List.generate(map.length, (index) {
      Task task = Task.fromMap(map[index]);
      return task;
    });

    for (int i = 0; i < tasks.length; i++) {
      tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
      tasks[i].subTasks = await getSubTasks(tasks[i].id!);
      tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }

    return tasks;
  }

  Future<List<Task>> getUnfinishedTasks(String category) async {
    //Further Optimize
    final db = await database;
    String curDate = formatDate(DateTime.now());
    String curTime =
        "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
    List<Map<String, dynamic>> map = await db.query('task',
        where:
            'category = ? AND status = ? AND date IS NOT NULL AND ( date < ? OR (date = ? AND time IS NOT NULL AND time < ?) )',
        whereArgs: [category, 0, curDate, curDate, curTime],
        orderBy: 'priority DESC , date ');
    List<Task> tasks = List.generate(map.length, (index) {
      Task task = Task.fromMap(map[index]);
      return task;
    });

    for (int i = 0; i < tasks.length; i++) {
      tasks[i].repeatPattern = await getTaskRepetition(tasks[i].id!);
      tasks[i].subTasks = await getSubTasks(tasks[i].id!);
      tasks[i].reminders = await getTaskReminders(tasks[i].id!);
    }
    for (Task task in tasks) {
      if (task.repeatPattern != null) {
        await insertRepeatedTask(task);
        task.repeatPattern = null;
      }
    }

    return tasks;
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete('task', where: 'id = ?', whereArgs: [task.id!]);
    if(task.reminders != null){
        if(task.reminders![0].reminderType == "Voice"){
          await WorkManagerService.cancelTaskVoiceNotification(task);
        }
        else{
          await NotificationService.cancelTaskReminders(task);
        }
    }
  }

  Future<void> modifyTask(Task task) async {
    final db = await database;
    await db
        .update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id!]);
    await deleteSubTask(task.id!);
    await deleteTaskReminders(task.id!);
    await deleteTaskRepetition(task.id!);

    if (task.repeatPattern != null) {
      task.repeatPattern!.taskId = task.id!;
      await insertTaskRepetition(task.repeatPattern!);
    }

    if (task.subTasks != null) {
      for (int i = 0; i < task.subTasks!.length; i++) {
        task.subTasks![i].taskId = task.id!;
        await insertSubTask(task.subTasks![i]);
      }
    }
    if (task.reminders != null) {
      for (int i = 0; i < task.reminders!.length; i++) {
        task.reminders![i].taskId = task.id!;
        await insertTaskReminder(task.reminders![i]);
      }
      if(task.reminders![0].reminderType == "Voice"){
        await WorkManagerService.scheduleTaskVoiceNotification(task);
      }
      else if(task.reminders![0].reminderType == "Alarm"){
        await NotificationService.scheduleTaskAlarmReminder(task);
      }
      else{
        NotificationService.scheduleTaskDefaultReminder(task);
      }
    }

  }

  Future<void> updateTaskStatus(Task task) async {
    final db = await database;
    int status = task.status == true ? 0 : 1;

    await db.update('task', {'status': status},
        where: 'id = ?', whereArgs: [task.id!]);

    if (task.subTasks != null) {
      await db.update('sub_task', {"status": status},
          where: "task_id = ?", whereArgs: [task.id!]);
    }
    if(task.reminders != null){
      if(status == 1){
        if(task.reminders![0].reminderType == "Voice"){
          await WorkManagerService.cancelTaskVoiceNotification(task);
        }
        else{
          await NotificationService.cancelTaskReminders(task);
        }

      }
      else{
        if(task.reminders![0].reminderType == "Voice"){
          await WorkManagerService.scheduleTaskVoiceNotification(task);
        }
        else if(task.reminders![0].reminderType == "Alarm") {
          await NotificationService.scheduleTaskAlarmReminder(task);
        }
        else{
          await NotificationService.scheduleTaskDefaultReminder(task);
        }
      }
    }



    if (task.repeatPattern != null) {
      await insertRepeatedTask(task);
    }
  }

  Future<void> insertRepeatedTask(Task parentTask)async{
    Task task = Task(
      title: parentTask.title,
      description: parentTask.description,
      priority: parentTask.priority,
      category: parentTask.category,
      date: parentTask.date,
      time: parentTask.time,
      repeatPattern: parentTask.repeatPattern,
      reminders: parentTask.reminders,
      subTasks: parentTask.subTasks
    );
    await deleteTaskRepetition(parentTask.id!);
    if(task.subTasks != null){
      for(SubTask subTask in task.subTasks!){
        subTask.status =false;
      }
    }
    DateTime taskDate = DateTime.parse(task.date!);
    if (task.time != null){
      final splitTime = task.time!.split(":");
      taskDate = taskDate.add(Duration(hours: int.parse(splitTime[0]) , minutes: int.parse(splitTime[1])));
    }
    taskDate = _addTaskTime(taskDate, task.repeatPattern!);
    if (task.repeatPattern!.repeatType == "Count") {
      task.repeatPattern!.numOccurrence =
          task.repeatPattern!.numOccurrence! - 1;
      if(task.repeatPattern!.numOccurrence != 0){
        if(task.repeatPattern!.repeatUnit == "Hour"){
            task.time = "${taskDate.hour.toString().padLeft(2,"0")}:${taskDate.minute.toString().padLeft(2,"0")}";
        }
        task.date = formatDate(taskDate);
        print("Parent Task $parentTask");
        print("newTask $task");
        await insertTask(task);
      }
    }
    else if (task.repeatPattern!.repeatType == "Time") {
      final splitStopDate = task.repeatPattern!.repeatUntil!.split("-");
      final stopDate = DateTime.parse(task.date!);

      if (taskDate.isBefore(stopDate)) {
        if(task.repeatPattern!.repeatUnit == "Hour"){
          task.time = "${taskDate.hour.toString().padLeft(2,"0")}:${taskDate.minute.toString().padLeft(2,"0")}";
        }
        task.date = formatDate(taskDate);
        await insertTask(task);
      }
    }
    else {
      if(task.repeatPattern!.repeatUnit == "Hour"){
        task.time = "${taskDate.hour.toString().padLeft(2,"0")}:${taskDate.minute.toString().padLeft(2,"0")}";
      }
      task.date = formatDate(taskDate);
      await insertTask(task);
    }
  }

  Future<void> deleteAllCompletedTasks(String category) async {
    final db = await database;
    await db.delete('task',
        where: 'status = ? AND category = ?', whereArgs: [1, category]);
  }

  Future<void> deleteAllUnfinishedTasks(String category) async {
    final db = await database;
    String curDate = DateTime.now().toString().split(" ")[0];
    String curTime =
        "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
    await db.delete('task',
        where:
            'category = ? AND status = ? AND date IS NOT NULL AND ( date < ? OR (date = ? AND time IS NOT NULL AND time < ?) )',
        whereArgs: [category, 0, curDate, curDate, curTime]);
  }

  Future<void> insertSubTask(SubTask subTask) async {
    final db = await database;
    await db.insert('sub_task', subTask.toMap());
  }

  Future<List<SubTask>?> getSubTasks(int taskId) async {
    final db = await database;
    List<Map<String, dynamic>> map =
        await db.query('sub_task', where: 'task_id = ?', whereArgs: [taskId]);
    List<SubTask> subTasks = List.generate(map.length, (index) {
      return SubTask.fromMap(map[index]);
    });
    return subTasks.isNotEmpty ? subTasks : null;
  }

  Future<void> deleteSubTask(int taskId) async {
    final db = await database;
    await db.delete('sub_task', where: "task_id = ?", whereArgs: [taskId]);
  }

  Future<void> updateSubTaskStatus(SubTask subTask) async {
    final db = await database;
    int status = subTask.status == true ? 0 : 1;
    await db.update('sub_task', {"status": status},
        where: "task_id = ? and title = ?",
        whereArgs: [subTask.taskId!, subTask.title]);
    if (status == 0) {
      await db.update('task', {"status": status},
          where: "id = ?", whereArgs: [subTask.taskId!]);
    }
  }

  Future<void> insertTaskRepetition(TaskRepetition repetition) async {
    final db = await database;
    await db.insert('task_repetition', repetition.toMap());
  }

  Future<TaskRepetition?> getTaskRepetition(int taskId) async {
    final db = await database;
    List<Map<String, dynamic>> map = await db
        .query('task_repetition', where: 'task_id = ?', whereArgs: [taskId]);
    if (map.isNotEmpty) {
      return TaskRepetition.fromMap(map[0]);
    }
    return null;
  }

  Future<void> deleteTaskRepetition(int taskId) async {
    final db = await database;
    await db
        .delete('task_repetition', where: 'task_id = ?', whereArgs: [taskId]);
  }

  Future<void> insertTaskReminder(TaskReminder reminder) async {
    final db = await database;
    await db.insert("task_reminder", reminder.toMap());
  }

  Future<List<TaskReminder>?> getTaskReminders(int taskId) async {
    final db = await database;
    List<Map<String, dynamic>> map = await db
        .query('task_reminder', where: 'task_id = ?', whereArgs: [taskId]);
    List<TaskReminder> reminders = List.generate(map.length, (index) {
      return TaskReminder.fromMap(map[index]);
    });
    return reminders.isNotEmpty ? reminders : null;
  }

  Future<void> deleteTaskReminders(int taskId) async {
    final db = await database;
    await db.delete('task_reminder', where: 'task_id = ?', whereArgs: [taskId]);
  }
}

DateTime _addTaskTime(DateTime taskTime, TaskRepetition repeatPattern) {
  if (repeatPattern.repeatUnit == "Hour") {
    return taskTime.add(Duration(hours: repeatPattern.repeatInterval));
  } else if (repeatPattern.repeatUnit == "Day") {
    return taskTime.add(Duration(days: repeatPattern.repeatInterval));
  } else if (repeatPattern.repeatUnit == "Week") {
    return taskTime.add(Duration(days: repeatPattern.repeatInterval * 7));
  } else if (repeatPattern.repeatUnit == "Month") {
    return DateTime(
      taskTime.year,
      taskTime.month + repeatPattern.repeatInterval,
      taskTime.day
    );
  } else{
    return DateTime(
        taskTime.year + repeatPattern.repeatInterval,
        taskTime.month,
        taskTime.day
    );  }

}


String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}