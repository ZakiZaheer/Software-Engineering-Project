import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/customWidgets/DropDownField.dart';
import 'package:task_manager/customWidgets/ErrorDialog.dart';
import 'package:task_manager/customWidgets/SubTaskInputField.dart';
import 'package:task_manager/customWidgets/inputField.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/customWidgets/alert_slider.dart';
import 'package:task_manager/model/taskReminder_modal.dart';
import '../../model/task_modal.dart';

class TaskModificationScreen extends StatefulWidget {
  final Task task;
  const TaskModificationScreen({super.key , required this.task});

  @override
  State<TaskModificationScreen> createState() => _TaskModificationScreenState();
}

class _TaskModificationScreenState extends State<TaskModificationScreen> {
  List<String> categories = [];
  List<TextEditingController> subTasksControllers = [];
  final db = SqfLiteService();
  String? _selectedCategory;
  int _selectedPriority = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();
  List<TaskReminder>? initialReminders;
  Future<void> loadCategories() async {
    categories = await db.getCategories();
    setState(() {});
  }



  Future<void> modifyTask() async {
    print(initialReminders);
    print(widget.task.reminders);
    if (_titleController.text.isNotEmpty) {
      widget.task.title = _titleController.text;
      if (_descriptionController.text.isNotEmpty) {
        widget.task.description = _descriptionController.text;
      }
      widget.task.category = _selectedCategory ?? "To-Do";
      widget.task.priority = _selectedPriority;
      if (subTasksControllers.isNotEmpty) {
        if (_checkDuplicatedSubTasks(subTasksControllers)) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ErrorDialog(
                    title: "Duplicate Subtask not allowed!");
              });
          return;
        }
        for(int i = 0 ; i < subTasksControllers.length ; i++){
          widget.task.subTasks![i].title = subTasksControllers[i].text;
        }
      }
      await db.modifyTask(widget.task);
      Navigator.pop(context, _selectedCategory ?? "To-Do");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(title: "Empty Task Title NOt Allowed!");
          });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description ?? "";
    _selectedCategory = widget.task.category;
    _selectedPriority = widget.task.priority;
    if(widget.task.subTasks != null){
      for(SubTask subTask in widget.task.subTasks!){
        subTasksControllers.add(TextEditingController(text: subTask.title));
      }
    }
    initialReminders = widget.task.reminders;
    loadCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Modify Task',
          style: appBarHeadingStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await modifyTask();
            },
            child: Text(
              'Modify',
              style: appBarHeadingButton(),
            ),
          ),
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
          const SizedBox(height: 16),
          InputField(
            label: "New Task",
            controller: _titleController,
          ),
          const SizedBox(height: 16),
          DropDownField(
            initialValue: widget.task.category,
            items: categories,
            onChanged: (value) {
              _selectedCategory = value;
            },
            onAddItem: (newCategory) async {
              await db.addCategory(newCategory);
              await loadCategories();
            },
          ),
          const SizedBox(height: 16),
          InputField(
            label: "Description(optional)",
            controller: _descriptionController,
          ),
          const SizedBox(height: 16),
          CustomAlertSlider(
            initialValue: widget.task.priority.toDouble(),
            onValueChanged: (value) {
              _selectedPriority = value.toInt();
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Date/time',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.task.date != null ? formatDate(widget.task.date!) : "None"}${widget.task.time != null ? " , ${formatTime(widget.task.time!)}" : ""} ",
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: Colors.grey),
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/taskDateTimeSelectionScreen',
                  arguments: widget.task)
                  .then((data) {
                if (data != null) {
                  Task newTask = data as Task;
                  widget.task.date = newTask.date;
                  widget.task.time = newTask.time;
                  widget.task.repeatPattern = newTask.repeatPattern;
                  widget.task.reminders = newTask.reminders;
                  setState(() {});
                }
              });
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> SetDateTimeScreen()));
            },
          ),
          const SizedBox(height: 16),
          SubTaskInputField(
            controller: _subTaskController,
            iconButton: IconButton(
              onPressed: () {
                if (_subTaskController.text.isNotEmpty) {
                  subTasksControllers.add(
                      TextEditingController(text: _subTaskController.text));
                  if(widget.task.subTasks!= null){
                    widget.task.subTasks!.add(SubTask(title:_subTaskController.text));
                  }
                  else{
                    widget.task.subTasks = [SubTask(title: _subTaskController.text)];
                  }
                  _subTaskController.clear();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(subTasksControllers.length, (index) {
            return Column(
              children: [
                SubTaskInputField(
                  controller: subTasksControllers[index],
                  iconButton: IconButton(
                    onPressed: () {
                      subTasksControllers.removeAt(index);
                      widget.task.subTasks!.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          })
        ],
      ),
    );
  }
}

bool _checkDuplicatedSubTasks(List<TextEditingController> subtasks) {
  Set<String> seen = <String>{};
  for (TextEditingController subTask in subtasks) {
    if (!seen.add(subTask.text)) {
      return true;
    }
  }
  return false;
}


String formatDate(String dateInput) {
  DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateInput);
  return DateFormat('d MMM').format(parsedDate);
}

String formatTime(String timeInput) {
  DateTime parsedTime = DateFormat('HH:mm').parse(timeInput);
  return DateFormat('h:mm a').format(parsedTime);
}
