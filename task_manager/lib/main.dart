import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:task_manager/database_service/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(MainApp());
=======
import 'screens/task_screens/task_creation_screen.dart';
import 'customWidgets/NewList.dart';
import 'customWidgets/Taskdiscription.dart'; // Import your custom task description dialog

void main() {
  runApp(MyApp());
>>>>>>> abhay
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<TaskItem> tasks = [
    TaskItem('Drink Water', 'Every 1 hour', Status.low, false, []),
    TaskItem('Meeting in afternoon', 'At 16:30 PM', Status.low, false, []),
    TaskItem('SE Assignment', 'On 3rd Oct', Status.normal, false, [
      SubTask('Research topic', false),
      SubTask('Write report', false),
      SubTask('Submit final draft', false)
    ]),
    TaskItem('Electricity Bill', 'On 15th Oct', Status.high, false, []),
    TaskItem('Check-out the nursery', 'On 6th Nov', Status.low, false, []),
    TaskItem('Try the new dosa place', '', Status.low, false, []),
  ];

  List<TaskItem> completedTasks = [];
  bool isCompletedExpanded = false;
  String listName = "To-do list"; // Default List Name
  List<String> categories = [
    'Groceries',
    'Bucket list',
    'Workout',
    'To-do list',
    'College'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1E26),
      appBar: AppBar(
        title: Text('$listName', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0A1329),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _showCustomPopupMenu(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'Rename list':
                  _renameListDialog(context);
                  break;
                case 'Delete list':
                  _deleteList();
                  break;
                case 'Delete all completed tasks':
                  _deleteCompletedTasks();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Rename list',
                child: Text('Rename list'),
              ),
              PopupMenuItem<String>(
                value: 'Delete list',
                child: Text('Delete list'),
              ),
              PopupMenuItem<String>(
                value: 'Delete all completed tasks',
                child: Text('Delete all completed tasks'),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: tasks
                  .map((task) => TaskWidget(
                        task: task,
                        onTaskChanged: (isChecked) {
                          setState(() {
                            task.isChecked = isChecked ?? false;
                            if (task.isChecked &&
                                (task.areAllSubtasksCompleted() ||
                                    task.subtasks.isEmpty)) {
                              completedTasks.add(task);
                              tasks.remove(
                                  task); // Move checked tasks to completed
                            }
                          });
                        },
                        onTaskExpandCollapse: () {
                          setState(() {
                            task.isExpanded =
                                !task.isExpanded; // Toggle expand/collapse
                          });
                        },
                        onTaskDescription: () {
                          // Call the custom task description dialog here
                          showCustomTaskDialog(
                            context,
                            task.name, // Task title
                            task.details, // Task details
                            task.subtasks.isNotEmpty
                                ? 'Subtasks:\n' +
                                    task.subtasks
                                        .map((subtask) =>
                                            '${subtask.isCompleted ? '[x]' : '[ ]'} ${subtask.name}')
                                        .join('\n')
                                : 'No additional details.', // Show subtasks or default description
                          );
                        },
                        onSubTaskChanged: (subtaskIndex, isChecked) {
                          setState(() {
                            task.subtasks[subtaskIndex].isCompleted =
                                isChecked ?? false;
                            if (task.areAllSubtasksCompleted()) {
                              task.isChecked = true;
                              completedTasks.add(task);
                              tasks.remove(task);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),

            // Completed Task List with Collapse/Expand functionality
            GestureDetector(
              onTap: () {
                setState(() {
                  isCompletedExpanded = !isCompletedExpanded;
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      isCompletedExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Completed',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            if (isCompletedExpanded)
              Column(
                children: completedTasks
                    .map((task) => CompletedTaskWidget(task: task))
                    .toList(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFBBD3B),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTask()));
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showCustomPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
                    Text(
                      'Lists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup first
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:
                                  CreateNewListWidget(), // Open the CreateNewListWidget
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                ...categories.map((category) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          category,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            listName = category;
                          });
                          Navigator.of(context)
                              .pop(); // Close dialog after selection
                        },
                      ),
                      Divider(color: Colors.white),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _renameListDialog(BuildContext context) {
    // Implement rename logic
  }

  void _deleteList() {
    // Implement delete list logic
  }

  void _deleteCompletedTasks() {
    setState(() {
      completedTasks.clear();
    });
  }
}

class TaskWidget extends StatelessWidget {
  final TaskItem task;
  final Function(bool?) onTaskChanged;
  final Function() onTaskExpandCollapse;
  final Function() onTaskDescription;
  final Function(int, bool?) onSubTaskChanged;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onTaskChanged,
    required this.onTaskExpandCollapse,
    required this.onTaskDescription,
    required this.onSubTaskChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.3), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white, // White outline
                ),
                child: Checkbox(
                  value: task.isChecked,
                  onChanged: onTaskChanged,
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  side: BorderSide(
                    color: Colors.white, // Outline color
                    width: 2.0, // Outline width
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onTaskDescription,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Use black text to contrast
                          ),
                        ),
                        if (task.details.isNotEmpty)
                          Text(
                            task.details,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (task.subtasks.isNotEmpty)
                GestureDetector(
                  onTap: onTaskExpandCollapse,
                  child: Icon(
                    task.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: task.status.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          if (task.isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 40.0), // Indent subtasks
              child: Column(
                children: task.subtasks
                    .asMap()
                    .entries
                    .map((entry) => SubTaskWidget(
                          subtask: entry.value,
                          onSubTaskChanged: (isChecked) {
                            onSubTaskChanged(entry.key, isChecked);
                          },
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class SubTaskWidget extends StatelessWidget {
  final SubTask subtask;
  final Function(bool?) onSubTaskChanged;

  const SubTaskWidget({
    Key? key,
    required this.subtask,
    required this.onSubTaskChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.white, // White outline when unchecked
          ),
          child: Checkbox(
            value: subtask.isCompleted,
            onChanged: onSubTaskChanged,
            activeColor: Colors.white, // White fill when checked
            checkColor: Colors.black, // Black tick inside when checked
            side: BorderSide(
              color: Colors.white, // White outline for the checkbox
              width: 2.0, // Adjust the outline width as needed
            ),
          ),
        ),
        Text(
          subtask.name,
          style: TextStyle(
            color: Colors.white, // Ensure matching color for subtasks
          ),
        ),
      ],
    );
  }
}

class CompletedTaskWidget extends StatelessWidget {
  final TaskItem task;

  const CompletedTaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          '✔ ${task.name}', // Adding a tick mark before the task name
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          task.details,
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

class TaskItem {
  final String name;
  final String details;
  final Status status;
  bool isChecked;
  bool isExpanded;
  final List<SubTask> subtasks;

  TaskItem(this.name, this.details, this.status, this.isChecked, this.subtasks,
      {this.isExpanded = false});

  bool areAllSubtasksCompleted() {
    return subtasks.every((subtask) => subtask.isCompleted);
  }
}

class SubTask {
  final String name;
  bool isCompleted;

  SubTask(this.name, this.isCompleted);
}

enum Status { low, normal, high }

extension StatusExtension on Status {
  Color get color {
    switch (this) {
      case Status.low:
        return Colors.green;
      case Status.normal:
        return Colors.orange;
      case Status.high:
        return Colors.red;
    }
  }
}
