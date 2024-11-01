import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/TaskAlert.dart';
import 'package:task_manager/customWidgets/TaskTile.dart';
import 'package:task_manager/customWidgets/Taskdiscription.dart';
import 'package:task_manager/customWidgets/taskExpansionTile.dart';
import 'package:task_manager/notification_service/notification_service.dart';
import 'package:task_manager/customWidgets/NewList.dart';
import '../../database_service/sqfliteService.dart';
import '../../model/subTask_modal.dart';
import '../../model/taskReminder_modal.dart';
import '../../model/task_modal.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  SqfLiteService db = SqfLiteService();
  String _currentCategory = "To-Do";
  List<String> categories = [];
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  List<Task> unfinishedTasks = [];

  Future<void> loadTasks() async {
    categories = await db.getCategories();
    unfinishedTasks = await db.getUnfinishedTasks(_currentCategory);
    tasks = await db.getTasks(_currentCategory);
    completedTasks = await db.getCompletedTasks(_currentCategory);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A33),
      appBar: AppBar(
        title: Text(
          _currentCategory,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A1329),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _showCategoryMenu();
          },
        ),
        actions: [
          _popUpButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: Colors.white.withOpacity(0.6),
            height: 2,
          ),
        ),
      ),
      body: ListView(
        children: [
          ...List.generate(tasks.length, (index) {
            return TaskTile(
              task: tasks[index],
              onTap: (task) async {
                final category = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskDescription(
                        task: task,
                        onDelete: (task) async {
                          await db.deleteTask(task);
                          await loadTasks();
                        },
                      );
                    });
                if (category != null) {
                  _currentCategory = category as String;
                  await loadTasks();
                }
              },
              onChecked: (task) async {
                await db.updateTaskStatus(task);
                await loadTasks();
              },
              onSubTaskChecked: (subTask) async {
                await db.updateSubTaskStatus(subTask);
                await loadTasks();
              },
            );
          }),
          TaskExpansionTile(
            title: "Completed",
            tasks: completedTasks,
            onTap: (task) async {
              final category = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TaskDescription(
                      task: task,
                      onDelete: (task) async {
                        await db.deleteTask(task);
                        await loadTasks();
                      },
                    );
                  });
              if (category != null) {
                _currentCategory = category as String;
                await loadTasks();
              }
            },
            onChecked: (task) async {
              await db.updateTaskStatus(task);
              await loadTasks();
            },
            onSubTaskChecked: (subTask) async {
              await db.updateSubTaskStatus(subTask);
              await loadTasks();
            },
          ),
          TaskExpansionTile(
            title: "Unfinished",
            tasks: unfinishedTasks,
            onTap: (task) async {
              final category = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TaskDescription(
                      task: task,
                      onDelete: (task) async {
                        await db.deleteTask(task);
                        await loadTasks();
                      },
                    );
                  });
              if (category != null) {
                _currentCategory = category as String;
                await loadTasks();
              }
            },
            onChecked: (task) async {
              await db.updateTaskStatus(task);
              await loadTasks();
            },
            onSubTaskChecked: (subTask) async {
              await db.updateSubTaskStatus(subTask);
              await loadTasks();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFBBD3B),
        onPressed: () {
          // Navigator.pushNamed(context, '/taskCreationScreen')
          //     .then((data) async {
          //   _currentCategory = data as String;
          //   await loadTasks();
          // });
          NotificationService.instantNotification("Testing I am", "HAhahaha");
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  _popUpButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (String result) {
        switch (result) {
          case 'Rename list':
            _renameListDialog();
            break;
          case 'Delete list':
            _deleteList();
            break;
          case 'Delete all completed tasks':
            _deleteCompletedTask();
            break;
          case 'Delete all unfinished tasks':
            _deleteUnfinishedTask();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (_currentCategory != "To-Do") ...[
          const PopupMenuItem<String>(
            value: 'Rename list',
            child: Text('Rename list'),
          ),
          const PopupMenuItem<String>(
            value: 'Delete list',
            child: Text('Delete list'),
          ),
        ],
        const PopupMenuItem<String>(
          value: 'Delete all completed tasks',
          child: Text('Delete all completed tasks'),
        ),
        const PopupMenuItem<String>(
          value: 'Delete all unfinished tasks',
          child: Text('Delete all unfinished tasks'),
        ),
      ],
    );
  }

  _deleteList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskAlert(
            title: "Delete",
            body: "Delete this List?",
            button1Text: "Cancel",
            onPressedButton1: () {
              Navigator.pop(context);
            },
            button2Text: "Ok",
            onPressedButton2: () async {
              await db.deleteCategory(category: _currentCategory);
              _currentCategory = "To-Do";
              await loadTasks();
            },
          );
        });
  }

  _deleteCompletedTask() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskAlert(
            title: "Delete All Completed Tasks",
            body: "All Completed Tasks in this list will be deleted!",
            button1Text: "Cancel",
            onPressedButton1: () {
              Navigator.pop(context);
            },
            button2Text: "Ok",
            onPressedButton2: () async {
              await db.deleteAllCompletedTasks(_currentCategory);
              await loadTasks();
            },
          );
        });
  }

  _deleteUnfinishedTask() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskAlert(
            title: "Delete All Unfinished Tasks?",
            body: "All unfinished tasks in this list will be deleted!",
            button1Text: "Cancel",
            onPressedButton1: () {
              Navigator.pop(context);
            },
            button2Text: "Ok",
            onPressedButton2: () async {
              await db.deleteAllUnfinishedTasks(_currentCategory);
              await loadTasks();
            },
          );
        });
  }

  _renameListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
            title: "Rename List",
            hintText: "Enter New Name",
            errorText: "List Name Already Taken",
            onSaved: (newName) async {
              await db.renameCategory(
                  category: _currentCategory, newName: newName);
              _currentCategory = newName;
              await loadTasks();
            });
      },
    );
  }

  void _showCategoryMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategoryDialog(
                                title: "Create New List",
                                hintText: "New List",
                                errorText: "List Name Already Taken",
                                onSaved: (newCategory) async {
                                  await db.addCategory(newCategory);
                                  await loadTasks();
                                });
                          },
                        );
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white),
                ...categories.map((category) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          setState(() {
                            _currentCategory = category;
                          });
                          await loadTasks();
                          Navigator.of(context)
                              .pop(); // Close dialog after selection
                        },
                      ),
                      const Divider(color: Colors.white),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  _scheduleTask() async {
    Task task = Task(
      id: 1,
      title: "Complete Flutter Project",
      description: null,
      priority: 1,
      category: "To-Do",
      date: "2024-10-28",
      time: "20:00",
      status: false,
      reminders: [
        TaskReminder(reminderInterval: 0, reminderUnit: "Minute"),
        TaskReminder(reminderInterval: 1, reminderUnit: "Minute"),
        TaskReminder(reminderInterval: 2, reminderUnit: "Minute")
      ],
      subTasks: [
        SubTask(title: "Fix layout bugs", status: false),
        SubTask(title: "Implement login system", status: false)
      ],
    );

    await NotificationService.scheduleTaskReminder(task);
  }
}
