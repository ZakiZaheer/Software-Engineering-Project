import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/DropDownField.dart';
import 'package:task_manager/customWidgets/ErrorDialog.dart';
import 'package:task_manager/customWidgets/SubTaskInputField.dart';
import 'package:task_manager/customWidgets/inputField.dart';
import 'package:task_manager/database_service/sqfliteService.dart';
import 'package:task_manager/model/subTask_modal.dart';
import 'package:task_manager/screens/task_screens/task_time_set_screen.dart';
import 'package:task_manager/Custom_Fonts.dart';
import 'package:task_manager/customWidgets/alert_slider.dart';
import 'package:task_manager/customWidgets/NewList.dart';

import '../../model/task_modal.dart';

class TaskCreationScreen extends StatefulWidget {
  const TaskCreationScreen({super.key});

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  Task task = Task(title: "");
  List<String> categories = [];
  List<TextEditingController> subTasksControllers = [];
  final db = SqfLiteService();
  String? _selectedCategory;
  int _selectedPriority = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();

  Future<void> loadCategories() async {
    categories = await db.getCategories();
    setState(() {});
  }

  Future<void> addTask()async{
    print("Task to be created:\n $task");
    if(_titleController.text.isNotEmpty){
      print("title: ${_titleController.text}");
      task.title = _titleController.text;
      if(_descriptionController.text.isNotEmpty){
        task.description = _descriptionController.text;
      }
      task.category = _selectedCategory ?? "To-Do";
      task.priority = _selectedPriority;
      if(subTasksControllers.isNotEmpty){
        if(_checkDuplicatedSubTasks(subTasksControllers)){
          showDialog(context: context, builder: (BuildContext context){
            return const ErrorDialog(title: "Duplicate Subtask not allowed!");
          });
          return;
        }
        task.subTasks = List.generate(subTasksControllers.length, (index){
          return SubTask(title: subTasksControllers[index].text);
        });
      }
      await db.insertTask(task);
      Navigator.pop(context,_selectedCategory ?? "To-Do");
    }
    else{
      showDialog(context: context, builder: (BuildContext context){
        return const ErrorDialog(title: "Empty Task Title NOt Allowed!");
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
          'Create Task',
          style: appBarHeadingStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await addTask();
            },
            child: Text(
              'Create',
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
            trailing: const Text(
              'None',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/taskDateTimeSelectionScreen' , arguments: task).then(
                  (data){
                    if(data != null){
                      Task newTask = data as Task;
                      task.date = newTask.date;
                      task.time = newTask.time;
                      task.repeatPattern = newTask.repeatPattern;
                      task.reminders = newTask.reminders;
                    }
                  }
              );
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


bool _checkDuplicatedSubTasks(List<TextEditingController> subtasks){
  Set<String> seen = <String>{};
  for(TextEditingController subTask in subtasks){
    if(!seen.add(subTask.text)){
      return true;
    }
  }
  return false;
}