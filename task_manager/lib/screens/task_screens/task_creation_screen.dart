import 'package:flutter/material.dart';
import 'screens/task_screens/task_time_set_screen.dart';
import 'Custom_Fonts.dart';
import 'customWidgets/alert_slider.dart';
import 'customWidgets/NewList.dart';

class CreateTask extends StatelessWidget {
  final List<String> categories;

  CreateTask({required this.categories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0A1A2A),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A1329),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
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
              onPressed: () {},
              child: Text(
                'Create',
                style: appBarHeadingButton(),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2),
            child: Container(
              color: Colors.white.withOpacity(0.6),
              height: 2,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateTaskForm(categories: categories),
        ),
      ),
    );
  }
}

class CreateTaskForm extends StatefulWidget {
  final List<String> categories;

  CreateTaskForm({required this.categories});

  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  List<String> subtasks = [];
  String? selectedCategory;
  TextEditingController subtaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("New Task"),
        SizedBox(height: 16),
        _buildCategoryDropdownField(),
        SizedBox(height: 16),
        _buildTextField("Description (optional)"),
        SizedBox(height: 16),
        CustomAlertSlider(
          onValueChanged: (value) {
            print("Priority Slider value: $value");
          },
        ),
        SizedBox(height: 16),
        ListTile(
          title: Text('Date/time',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white)),
          trailing: Text(
            'None',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
                fontSize: 13,
                color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TimeScreen()));
          },
        ),
        SizedBox(height: 16),
        _buildSubtaskInputField(),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: subtasks.length,
            itemBuilder: (context, index) {
              return _buildSubtaskTile(subtasks[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubtaskInputField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: subtaskController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Add subtask",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: _addSubtask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdownField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: Color(0xFF0A1A2A),
            value: selectedCategory,
            items: [
              ...widget.categories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              DropdownMenuItem(
                value: 'New List',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New List',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'New List') {
                _showNewListDialog();
              } else {
                setState(() {
                  selectedCategory = value;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Category',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void _showNewListDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: CreateNewListWidget(),
      ),
    ).then((newCategory) {
      if (newCategory != null) {
        setState(() {
          widget.categories.add(newCategory);
          selectedCategory = newCategory;
        });
      }
    });
  }

  void _addSubtask() {
    if (subtaskController.text.isNotEmpty) {
      setState(() {
        subtasks.add(subtaskController.text);
        subtaskController.clear();
      });
    }
  }

  Widget _buildSubtaskTile(String subtask, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              subtask,
              style: TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _removeSubtask(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _removeSubtask(int index) {
    setState(() {
      subtasks.removeAt(index);
    });
  }

  Widget _buildTextField(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
