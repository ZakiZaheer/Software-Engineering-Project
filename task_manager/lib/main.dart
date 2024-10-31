import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'screens/login_screens/logni.dart';

void main() {
  runApp(SignUpApp());
}

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for handling user input
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _r1 = TextEditingController();
  final TextEditingController _r2 = TextEditingController();
  final TextEditingController _r3 = TextEditingController();
  final TextEditingController _r4 = TextEditingController();
  final TextEditingController _r5 = TextEditingController();
  final TextEditingController _r6 = TextEditingController();
  final TextEditingController _r7 = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _rollNumber;
  String? _selectedCourse;
  List<String> _courses = ['CS', 'Math', 'ECO'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: Text('Sign Up'),
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Email input
                Text("Email"),
                _email(),
                SizedBox(height: 16),

                // Roll Number input
                Text("Roll number"),
                /*TextFormField(
                  controller: _rollNumberController,
                  decoration: InputDecoration(
                    labelText: 'Roll number',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),*/
                _rollNum('roll no', 'roll no'),
                SizedBox(height: 16),

                // Full Name input
                Text("Name"),
                _buildTextField('Full Name','Full Name',_nameController),
                SizedBox(height: 16),

                // Course dropdown
                Text("Course"),
                _Courses(),
                SizedBox(height: 16),

                // Date of Birth input (optional)
                Text("Date of Birth"),
                _DoB('DOB', 'Date of Birth(Optional)'),


                SizedBox(height: 16),

                // Password input
                Text("Set Password"),
                _passWord("Set Password"),
                SizedBox(height: 32),

                // Sign Up button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(width: 0.8, color: Colors.transparent),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data
                        print('Sign Up Successful');
                      }
                    },
                    child: Text('Sign up'),
                  ),
                ),

                // Already have an account
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> loginPage()),
                    );
                  },
                  child: Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }






  Widget _Courses( {bool isDropdown = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
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
            child:DropdownButtonFormField<String>(
              value: _selectedCourse,
              decoration: const InputDecoration(
                hintText: "Select your course",
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              items: _courses.map((String course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCourse = newValue;
                });
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _email() {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
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
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: '@gmail.com',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _passWord(String hintText, {bool isDropdown = false}) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
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
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,

              ),
              controller: _passwordController,
              obscureText: true,
              obscuringCharacter: '*',
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _DoB(String label,String hintText, {bool isDropdown = false}) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
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
              controller: _dobController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.calendar_today),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 250,
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime(2000),
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  _dobController.text =
                                  "${newDate.year}-${newDate.month}-${newDate.day}";
                                });
                              },
                            ),
                          ),
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context,_dobController.text);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _dobController.text =
                      "${value.year}-${value.month}-${value.day}";
                    });
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }



  Widget _rollNum(String label,String hintText, {bool isDropdown = false}) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF091F40),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r1,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r2,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("/",style: TextStyle(fontSize: 30),),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r3,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r4,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r5,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r6,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(width: 1.5, color: Colors.transparent),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF091F40)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TextFormField(
                        controller: _r7,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




}





Widget _buildTextField(String label,String hintText,TextEditingController cont, {bool isDropdown = false}) {
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
              hintText: hintText,
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






