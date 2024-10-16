import 'package:flutter/material.dart';
import 'timeset.dart';
import 'alertslider.dart'; // Import the alert slider

class CreateTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF091F40), // Background color
        appBar: AppBar(
          backgroundColor: Color(0xFF091F40),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Create Task'),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateTaskForm(),
        ),
      ),
    );
  }
}

class CreateTaskForm extends StatefulWidget {
  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("New Task"),
        SizedBox(height: 16),
        _buildTextField("Category", isDropdown: true),
        SizedBox(height: 16),
        _buildTextField("Description (optional)"),
        SizedBox(height: 16),

        // Using the custom slider here
        CustomAlertSlider(
          onValueChanged: (value) {
            print("Priority Slider value: $value");
          },
        ),
        SizedBox(height: 16),

        ListTile(
          title: Text('Date/time', style: TextStyle(color: Colors.white)),
          trailing: Text(
            'None',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TimeScreen()));
          },
        ),

        SizedBox(height: 16),

        _buildAddSubtaskButton(),
      ],
    );
  }

  Widget _buildTextField(String label, {bool isDropdown = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(width: 0.8, color: Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF091F40),
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
                suffixIcon: isDropdown
                    ? Icon(Icons.arrow_drop_down, color: Colors.grey)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddSubtaskButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Text('Add sub-task', style: TextStyle(color: Colors.grey)),
        trailing: Icon(Icons.add, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
