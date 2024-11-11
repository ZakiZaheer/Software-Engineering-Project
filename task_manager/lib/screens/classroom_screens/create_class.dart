import 'package:flutter/material.dart';

class CreateClassPage extends StatefulWidget {
  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();


  String? _selectedSemester;
  List<String> _semesters = ['1st','2nd','3rd','4th','5th','6th','7th','8th'];
  String? _selectedCourse;
  List<String> _courses = ['DSC(core)','GE','SEC','VAC','AEC'];

  @override
  void dispose() {
    // Dispose controllers when not needed to free up resources
    classNameController.dispose();
    teacherNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: const Text('Create Class',style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
            onPressed: () {
              // Define the action when the "Create" button is pressed
            },
            child: Text(
              'Create',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text('Class name',
              style: TextStyle(
                color: Colors.white
              ),
              ),
              _buildTextField('Enter your class Name', classNameController),
              const SizedBox(height: 5),
              const Text('Semester',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              _builddropdown('Select your semester',_selectedSemester,_semesters, isDropdown: true),
              const SizedBox(height: 5),
              const Text('Teacher',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              _buildTextField("Enter the Teacher's Name", teacherNameController),
              const SizedBox(height: 5),
              const Text('Course',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              _builddropdown('Select your course',_selectedCourse,_courses, isDropdown: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builddropdown(String hintText,String? val,List<String> lis, {bool isDropdown = false}) {
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
            child: isDropdown
                ? DropdownButtonFormField<String>(
              value: val,
              onChanged: (newValue) {
                setState(() {
                  val = newValue;
                });
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              dropdownColor: Color(0xFF091F40),
              style: TextStyle(color: Colors.white),
              items: lis.map((semester) {
                return DropdownMenuItem(
                  value: semester,
                  child: Text(semester, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            )
                : TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController cont, {bool isDropdown = false}) {
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
              controller: cont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
