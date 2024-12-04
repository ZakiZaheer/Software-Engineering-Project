import 'package:flutter/material.dart';

class JoinRequestsPage extends StatefulWidget {
  const JoinRequestsPage({Key? key}) : super(key: key);

  @override
  State<JoinRequestsPage> createState() => _JoinRequestsPageState();
}

class _JoinRequestsPageState extends State<JoinRequestsPage> {

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

  @override
  Widget build(BuildContext context) {
    var Width=(MediaQuery.of(context).size.width)-18;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Requests',
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: Color(0xFF091F40), // AppBar background color
        iconTheme: IconThemeData(color: Colors.white), // Back icon color
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

              return Container(
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

                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(
                          width: Width-49,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Circular container with initials
                              SizedBox(width: 10),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent[100],
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
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),

                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 95,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                                colors: [Colors.white,Colors.transparent]
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: IconButton(
                                    onPressed: ()=> print("Accepted"),
                                    icon: Icon(Icons.check, color: Colors.white),
                                ),

                              ),

                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: ()=> print("Rejected"),
                                  icon: Icon(Icons.close, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
