import 'package:flutter/material.dart';

import '../../customWidgets/footer.dart';


class ClassroomMembersPage extends StatefulWidget {
  final bool isCr; // Accepts `is_cr` variable from the navigator

  const ClassroomMembersPage({Key? key, required this.isCr}) : super(key: key);

  @override
  State<ClassroomMembersPage> createState() => _ClassroomMembersPageState();
}

class _ClassroomMembersPageState extends State<ClassroomMembersPage> {
  // Dummy list of students
  final List<Map<String, String>> students = [
    {
      'name': 'Zaki Zaheer',
      'email': 'zaki2232004@gmail.com',
      'course': 'B.Sc(H) Computer Science',
      'rollNumber': '22/19021'
    },
    {
      'name': 'Ketan Bisht',
      'email': 'ketan42069@gmail.com',
      'course': 'B.Sc(H) Computer Science',
      'rollNumber': '22/19059'
    },
    {
      'name': 'Mehul Soni',
      'email': 'mehulsoni0409@gmail.com',
      'course': 'B.Sc(H) Computer Science',
      'rollNumber': '22/19044'
    },
  ];

  // Method to delete a student
  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var Width=(MediaQuery.of(context).size.width)-18;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Classroom Members',
          style: TextStyle(color: Colors.white), // White AppBar Text
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White Back Arrow and Icons
        ),
        backgroundColor: Color(0xFF091F40),
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final initials = student['name']!
                  .split(' ')
                  .map((word) => word[0].toUpperCase())
                  .join();

              return GestureDetector(
                onTap: () {
                  showStudentProfilePopup(
                    context,
                    student['name']!,
                    '3rd Feb, 2004',//Fetch DOB from database
                    student['rollNumber']!,
                    student['course']!,
                    student['email']!,
                  );
                },
                child: Container(
                  height: 95,
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(width: 0.8, color: Colors.transparent),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Container(
                            width: widget.isCr?Width-49:Width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Circular container with initials
                                SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                                // Column for name, email, and course
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          student['name']!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          " "+student['email']!,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${student['course']}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Roll number and optional delete button
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    Text(
                                      student['rollNumber']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),

                              ],
                            ),
                          ),
                          if (widget.isCr)...[
                            Container(
                              width: 48,
                              height: 95,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 4,right: 4),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      showDeleteMemberPopup(
                                        context,
                                        student['name']!,
                                        student['course']!,
                                        student['rollNumber']!,
                                        student['email']!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const MainFooter(index: 2),

    );
  }
}



void showDeleteMemberPopup(BuildContext context, String name, String course, String rollNo, String email) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
         // To eliminate default padding around content
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: [
              // Title Container
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12, // 30% of the popup height
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Background color for the container
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15), // Rounded corners for the top part
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      child: Text(
                        name.split(" ").map((e) => e[0]).join(), // Initials from the name
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              // Content Below Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Course: ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                            Text(course, style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Roll No: ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                            Text(rollNo, style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Email:    ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                            Text(email, style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white, // Grey button for Cancel
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add delete logic here
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey[800], // Deep blue button for OK
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("OK"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



void showStudentProfilePopup(BuildContext context, String name, String dob, String rollNo, String course, String email) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: AspectRatio(
          aspectRatio: 1.24, // To maintain square-like dialog (height == width)
          child: Column(
            children: [
              // Title Container (fills width and takes 30% of height)
              Container(
                height: MediaQuery.of(context).size.height * 0.12, // 30% of popup height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Background color for the container
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15), // Rounded corners for the top part
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 30,
                          child: Text(
                            name.split(" ").map((e) => e[0]).join(), // Initials from name
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content Section
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("DOB:     ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                Text(dob, style: const TextStyle(color: Colors.black)),
                              ],
                            ),

                            Row(
                              children: [
                                Text("Roll no: ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                Text(rollNo, style: const TextStyle(color: Colors.black)),
                              ],
                            ),

                            Row(
                              children: [
                                Text("Course: ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                Text(course, style: const TextStyle(color: Colors.black)),
                              ],
                            ),

                            Row(
                              children: [
                                Text("Email:    ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                Text(email, style: const TextStyle(color: Colors.black)),
                              ],
                            ),



                          ],
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: ()=>print('lol'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Add Birthday to Calender",style: TextStyle(color: Colors.white),),
                            Icon(Icons.calendar_month,color: Colors.white,)
                          ],
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
