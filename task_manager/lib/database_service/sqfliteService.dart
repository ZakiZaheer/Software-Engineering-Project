import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/event/event_reminder_modal.dart';
import 'package:task_manager/model/task/subTask_modal.dart';
import 'package:task_manager/model/task/taskReminder_modal.dart';
import 'package:task_manager/model/task/taskRepetition_modal.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/notification_service/work_manger_service.dart';
import '../model/event/event_modal.dart';
import '../model/event/event_repetition_modal.dart';
import '../model/task/task_modal.dart';

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
    final path = join(await getDatabasesPath(), 'TaskManager12.db');
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE category(
        name TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE task(
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
          FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_task(
        title TEXT,
        status INTEGER NOT NULL,
        task_id INTEGER,
        PRIMARY KEY(title,task_id),
        FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE task_reminder(
        task_id INTEGER,
        reminder_interval INTEGER,
        reminder_unit TEXT,
        reminder_type TEXT NOT NULL,
        PRIMARY KEY(reminder_interval,reminder_unit,task_id),
        FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        category TEXT NOT NULL,
        location TEXT,
        repeat_id INTEGER,
        is_smart_suggested INTEGER NOT NULL,
        FOREIGN KEY (repeat_id) REFERENCES event_repetition(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE event_reminder(
        event_id INTEGER,
        reminder_interval INTEGER,
        reminder_unit TEXT,
        reminder_type TEXT NOT NULL,
        PRIMARY KEY(reminder_interval,reminder_unit,event_id),
        FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE event_repetition(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          repeat_interval INTEGER NOT NULL,
          repeat_unit TEXT NOT NULL,
          repeat_type TEXT NOT NULL,
          repeat_until DATE,
          num_occurrence INTEGER,
          repeat_on TEXT
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
      if (task.reminders![0].reminderType == "Voice") {
        await WorkManagerService.scheduleTaskVoiceNotification(task);
      } else if (task.reminders![0].reminderType == "Alarm") {
        await NotificationService.scheduleTaskAlarmReminder(task);
      } else {
        await NotificationService.scheduleTaskDefaultReminder(task);
      }
    }
  }

  Future<List<Task>> getTasks(String category) async {
    //Further Optimize
    final db = await database;
    String curDate = formatDate(DateTime.now());
    String curTime =
        "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
    List<Map<String, dynamic>> map = await db.query('task',
        where: '''
    category = ? 
    AND status = ? 
    AND (date IS NULL 
         OR date > ? 
         OR (date = ? AND (time IS NULL OR time >= ?)))
  ''',
        whereArgs: [category, 0, curDate, curDate, curTime],
        orderBy: 'priority DESC, date');

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
    if (task.reminders != null) {
      if (task.reminders![0].reminderType == "Voice") {
        await WorkManagerService.cancelTaskVoiceNotification(task);
      } else {
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
      if (task.reminders![0].reminderType == "Voice") {
        await WorkManagerService.scheduleTaskVoiceNotification(task);
      } else if (task.reminders![0].reminderType == "Alarm") {
        await NotificationService.scheduleTaskAlarmReminder(task);
      } else {
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
    if (task.reminders != null) {
      if (status == 1) {
        if (task.reminders![0].reminderType == "Voice") {
          await WorkManagerService.cancelTaskVoiceNotification(task);
        } else {
          await NotificationService.cancelTaskReminders(task);
        }
      } else {
        if (task.reminders![0].reminderType == "Voice") {
          await WorkManagerService.scheduleTaskVoiceNotification(task);
        } else if (task.reminders![0].reminderType == "Alarm") {
          await NotificationService.scheduleTaskAlarmReminder(task);
        } else {
          await NotificationService.scheduleTaskDefaultReminder(task);
        }
      }
    }

    if (task.repeatPattern != null) {
      await insertRepeatedTask(task);
    }
  }

  Future<void> insertRepeatedTask(Task parentTask) async {
    Task task = Task(
        title: parentTask.title,
        description: parentTask.description,
        priority: parentTask.priority,
        category: parentTask.category,
        date: parentTask.date,
        time: parentTask.time,
        repeatPattern: parentTask.repeatPattern,
        reminders: parentTask.reminders,
        subTasks: parentTask.subTasks);
    await deleteTaskRepetition(parentTask.id!);
    if (task.subTasks != null) {
      for (SubTask subTask in task.subTasks!) {
        subTask.status = false;
      }
    }
    DateTime taskDate = DateTime.parse(task.date!);
    if (task.time != null) {
      final splitTime = task.time!.split(":");
      taskDate = taskDate.add(Duration(
          hours: int.parse(splitTime[0]), minutes: int.parse(splitTime[1])));
    }
    taskDate = _addTaskTime(taskDate, task.repeatPattern!);
    if (task.repeatPattern!.repeatType == "Count") {
      task.repeatPattern!.numOccurrence =
          task.repeatPattern!.numOccurrence! - 1;
      if (task.repeatPattern!.numOccurrence != 0) {
        if (task.repeatPattern!.repeatUnit == "Hour") {
          task.time =
              "${taskDate.hour.toString().padLeft(2, "0")}:${taskDate.minute.toString().padLeft(2, "0")}";
        }
        task.date = formatDate(taskDate);
        print("Parent Task $parentTask");
        print("newTask $task");
        await insertTask(task);
      }
    } else if (task.repeatPattern!.repeatType == "Time") {
      final stopDate = DateTime.parse(task.date!);

      if (taskDate.isBefore(stopDate)) {
        if (task.repeatPattern!.repeatUnit == "Hour") {
          task.time =
              "${taskDate.hour.toString().padLeft(2, "0")}:${taskDate.minute.toString().padLeft(2, "0")}";
        }
        task.date = formatDate(taskDate);
        await insertTask(task);
      }
    } else {
      if (task.repeatPattern!.repeatUnit == "Hour") {
        task.time =
            "${taskDate.hour.toString().padLeft(2, "0")}:${taskDate.minute.toString().padLeft(2, "0")}";
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

  Future<void> addEvent(Event event) async {
    final db = await database;
    if (event.repeatPattern != null) {
      event.repeatId =
          await db.insert("event_repetition", event.repeatPattern!.toMap());
    }
    event.id = await db.insert('event', event.toMap());
    if (event.reminders != null) {
      for (EventReminder reminder in event.reminders!) {
        reminder.eventId = event.id;
        await db.insert("event_reminder", reminder.toMap());
      }
    }
    if (event.repeatId != null) {
      await insertRepeatedEvent(event);
    }
  }

  Future<void> insertRepeatedEvent(Event event) async {
    final db = await database;
    if (event.repeatPattern!.repeatType == "Time") {
      while (true) {
        Duration eventDuration = event.endTime.difference(event.startTime);
        event.startTime = _newEventTime(event.startTime, event.repeatPattern!);
        if(event.startTime
            .isAfter(DateTime.parse(event.repeatPattern!.repeatUntil!))){
          break;
        }
        event.endTime = event.startTime.add(eventDuration);
        event.id = await db.insert('event', event.toMap());
        for (EventReminder reminder in event.reminders ?? []) {
          reminder.eventId = event.id;
          await db.insert("event_reminder", reminder.toMap());
        }
      }
    } else {
      late int i;
      if (event.repeatPattern!.repeatType == "Count") {
        i = event.repeatPattern!.numOccurrence!;
      } else {
        i = 100;
      }
      while (i > 0) {
        Duration eventDuration = event.endTime.difference(event.startTime);
        event.startTime = _newEventTime(event.startTime, event.repeatPattern!);
        event.endTime = event.startTime.add(eventDuration);
        event.id = await db.insert('event', event.toMap());
        for (EventReminder reminder in event.reminders ?? []) {
          reminder.eventId = event.id;
          db.insert("event_reminder", reminder.toMap());
        }
        i--;
      }
    }
  }

  Future<void> deleteEvent(Event event) async {
    final db = await database;
    if(event.repeatId!=null){
      await db.delete("event_repetition", where: "id = ?", whereArgs: [event.repeatId]);
      await db.delete("event" ,where: "repeat_id = ?", whereArgs: [event.repeatId]);
    }
    else{
      print("Deleting nonREpeated Event");
      await db.delete("event", where: "id = ?", whereArgs: [event.id!]);
    }
  }

  Future<void> modifyEvent(Event event) async {
    final db = await database;
    if(event.repeatId != null){
      await deleteRepeatedEvent(event);
      await addEvent(event);
    }
    else{
      if(event.repeatPattern != null){
        event.repeatId = await db.insert("event_repetition", event.repeatPattern!.toMap());
      }
      await db.update("event", event.toMap(),
          where: "id = ?", whereArgs: [event.id!]);

      await db.delete("event_reminder",
          where: "event_id = ?", whereArgs: [event.id!]);

      if (event.reminders != null) {
        for (EventReminder reminder in event.reminders!) {
          reminder.eventId = event.id;
          await db.insert("event_reminder", reminder.toMap());
        }
      }
      if(event.repeatId!= null){
        await insertRepeatedEvent(event);
      }
    }



  }

  Future<List<Event>> getDailyEvents(DateTime date) async {
    final db = await database;
    final date1 = date.toString();
    final date2 = date.add(const Duration(days: 1)).toString();
    final map = await db.query('event',
        where: 'start_time < ? AND end_time >= ?', whereArgs: [date2, date1]);
    List<Event> events = List.generate(map.length, (index) {
      return Event.fromMap(map[index]);
    });

    for (Event event in events) {
      event.reminders = await getEventReminders(event.id!);
      if(event.repeatId != null){
        event.repeatPattern = await getEventRepetition(event.repeatId!);
      }
      print(event);

    }
    return events;
  }

  Future<List<EventReminder>?> getEventReminders(int eventId) async {
    final db = await database;
    List<Map<String, dynamic>> map = await db
        .query('event_reminder', where: 'event_id = ?', whereArgs: [eventId]);
    List<EventReminder> reminders = List.generate(map.length, (index) {
      return EventReminder.fromMap(map[index]);
    });
    return reminders.isNotEmpty ? reminders : null;
  }

  Future<EventRepetition?> getEventRepetition(int id) async {
    final db = await database;
    List<Map<String, dynamic>> map = await db
        .query('event_repetition', where: 'id = ?', whereArgs: [id]);
    if (map.isNotEmpty) {
      return EventRepetition.fromMap(map[0]);
    }
    return null;
  }

  Future<Event> getEventById(int id) async {
    final db = await database;
    final map = await db.query("event", where: "id = ?", whereArgs: [id]);
    final event = Event.fromMap(map[0]);
    event.reminders = await getEventReminders(event.id!);
    event.repeatPattern = await getEventRepetition(event.id!);
    return event;
  }

  Future<void> toggleSmartSuggestion(Event event) async {
    final db = await database;
    await db.update(
        'event', {'is_smart_suggested': event.smartSuggestion == true ? 0 : 1},
        where: 'id = ?', whereArgs: [event.id!]);
  }

  Future<void> deleteRepeatedEvent(Event event)async{
    final db = await database;
    await db.delete('event' ,where: 'repeat_id = ? AND start_time >= ?' ,   whereArgs: [event.repeatId , event.startTime.toIso8601String()]);
    await db.delete('event' , where: 'id = ?',whereArgs: [event.id!]);
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
    return DateTime(taskTime.year,
        taskTime.month + repeatPattern.repeatInterval, taskTime.day);
  } else {
    return DateTime(taskTime.year + repeatPattern.repeatInterval,
        taskTime.month, taskTime.day);
  }
}

DateTime _newEventTime(DateTime startTime, EventRepetition repeatPattern) {
  if (repeatPattern.repeatUnit == "Hour") {
    return startTime.add(Duration(hours: repeatPattern.repeatInterval));
  } else if (repeatPattern.repeatUnit == "Day") {
    return startTime.add(Duration(days: repeatPattern.repeatInterval));
  } else if (repeatPattern.repeatUnit == "Week") {
    List<int> repeatOn = [startTime.weekday];
    if (repeatPattern.repeatOn != null) {
      repeatOn = mapRepeatOnToDays(repeatPattern.repeatOn!);
    }
    int i = 0;
    for (; i < repeatOn.length; i++) {
      if (startTime.weekday < repeatOn[i]) {
        break;
      }
    }
    late int nextDayDuration;
    if (i == repeatOn.length) {
      nextDayDuration = 7 - (startTime.weekday - repeatOn[0]);
      if (repeatPattern.repeatInterval > 1) {
        nextDayDuration =
            nextDayDuration + (repeatPattern.repeatInterval - 1) * 7;
      }
    } else {
      nextDayDuration = repeatOn[i] - startTime.weekday;
    }
    return startTime.add(Duration(days: nextDayDuration));
  } else if (repeatPattern.repeatUnit == "Month") {
    List<int> repeatOn = [startTime.day];
    if (repeatPattern.repeatOn != null) {
      repeatOn = mapRepeatOnToMonthDates(repeatPattern.repeatOn!);
    }
    int i = 0;
    for (; i < repeatOn.length; i++) {
      if (startTime.day < repeatOn[i]) {
        break;
      }
    }
    DateTime newDate = startTime;
    while (true) {
      if (i == repeatOn.length) {
        i = 0;
        newDate = DateTime(
            newDate.year,
            newDate.month + repeatPattern.repeatInterval,
            repeatOn[i],
            newDate.hour,
            newDate.minute);
      } else {
        newDate = DateTime(newDate.year, newDate.month, repeatOn[i],
            newDate.hour, newDate.minute);
      }

      if (newDate.day != repeatOn[i]) {
        newDate = DateTime(
            newDate.year, newDate.month, 0, newDate.hour, newDate.minute);
        i = (i + 1) % (repeatOn.length + 1);
      } else {
        return newDate;
      }
    }
  } else {
    List<int> repeatOn = [startTime.month];
    if (repeatPattern.repeatOn != null) {
      repeatOn = mapRepeatOnToMonthNumbers(repeatPattern.repeatOn!);
    }
    print("RepeatOn: $repeatOn");
    int i = 0;
    for (; i < repeatOn.length; i++) {
      if (startTime.month < repeatOn[i]) {
        break;
      }
    }
    DateTime newDate = startTime;
    while (true) {

      if (i == repeatOn.length) {
        i = 0;
        newDate = DateTime(newDate.year + repeatPattern.repeatInterval,
            repeatOn[i], startTime.day, newDate.hour, newDate.minute);
      } else {
        newDate = DateTime(newDate.year, repeatOn[i], startTime.day,
            newDate.hour, newDate.minute);
      }
      if (newDate.day != startTime.day) {
        newDate = DateTime(newDate.year, repeatOn[i], startTime.day,
            newDate.hour, newDate.minute);
        i = (i + 1) % (repeatOn.length + 1);
      } else {
        return newDate;
      }
    }
  }
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String getWeekdayName(DateTime date) {
  // Map weekdays to names
  const weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // DateTime.weekday starts from 1 (Monday) to 7 (Sunday)
  return weekdayNames[date.weekday - 1];
}

String getMonthName(DateTime date) {
  // Map months to names
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // DateTime.month starts from 1 (January) to 12 (December)
  return monthNames[date.month - 1];
}

List<int> mapRepeatOnToDays(String repeatOn) {
  // Map of weekday names to their corresponding numbers
  const Map<String, int> weekdayMap = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  // Split the repeatOn string by '/' and map each day to its number
  List<String> days = repeatOn.split('/');
  List<int> repeatDays = [];

  for (String day in days) {
    day = day.trim(); // Trim any whitespace
    if (weekdayMap.containsKey(day)) {
      repeatDays.add(weekdayMap[day]!);
    }
  }

  return repeatDays;
}

List<int> mapRepeatOnToMonthDates(String repeatOn) {
  // Split the repeatOn string by '/' and map each date to an integer
  List<String> dateStrings = repeatOn.split('/');
  List<int> monthDates = [];

  for (String date in dateStrings) {
    date = date.trim(); // Trim any whitespace
    int? day = int.tryParse(date); // Convert to an integer
    if (day != null && day > 0 && day <= 31) {
      // Ensure valid month date
      monthDates.add(day);
    }
  }

  return monthDates;
}

List<int> mapRepeatOnToMonthNumbers(String repeatOn) {
  // Map of month names to their corresponding numbers
  const Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  // Split the repeatOn string by '/' and map each month to its number
  List<String> monthStrings = repeatOn.split('/');
  List<int> monthNumbers = [];

  for (String month in monthStrings) {
    month = month.trim(); // Trim any whitespace
    if (monthMap.containsKey(month)) {
      monthNumbers.add(monthMap[month]!);
    }
  }

  return monthNumbers;
}
