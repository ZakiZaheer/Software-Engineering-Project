import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/footer.dart';
import 'create_class.dart';
import 'perticularclass.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClassroomPage(),
    );
  }
}

class ClassroomPage extends StatelessWidget {
  // Sample data


  

  bool is_cr=true;
  final List<Map<String, String>> classData = [
    {
      'className': 'Software Engineering',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },
    {
      'className': 'Advance Data Structure',
      'teacherName': 'Mrs. Sapna Grover',
      'subject': 'DSC',
      'semester': 'Sem 2'
    },
    {
      'className': 'Software Engineering',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },
    {
      'className': 'Software Engineering',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },
    {
      'className': 'Software Engineering',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },
    {
      'className': 'Software Engineering hasbuhasbxuasbxubsabyi',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },
    {
      'className': 'Software Engineering diaushdbashjdshjadasndnsa',
      'teacherName': 'Prof. Anita Goel',
      'subject': 'DSC',
      'semester': 'Sem 5'
    },

    // Add more classes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF091F40) ,
        leading: IconButton(
          icon: Icon(Icons.people_alt_rounded), // or use Image for a custom icon
          onPressed: () {
            // Handle menu icon action
          },
        ),
        title: Text('Classroom',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification click
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                
                itemCount: classData.length,
                itemBuilder: (context, index) {
                  return ClassroomCard(
                    className: classData[index]['className']!,
                    teacherName: classData[index]['teacherName']!,
                    subject: classData[index]['subject']!,
                    semester: classData[index]['semester']!,
                  );
                
                },



                            ),
              ),
              is_cr?Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> CreateClassPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Updated to use backgroundColor
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Square-like shape with slight rounded corners
                    ),
                    minimumSize: Size(40, 60), // Sets size to make it square
                  ),
                  child: Icon(
                    Icons.add, // "+" icon
                    color: Colors.white,
                    size: 30,// Icon color
                  ),
                ),
              )
                  :SizedBox.fromSize()
            ]
          ),
        ),
      ),
      bottomNavigationBar: const MainFooter(index: 2),
    );
  }
}

class ClassroomCard extends StatelessWidget {
  final String className;
  final String teacherName;
  final String subject;
  final String semester;

  const ClassroomCard({
    Key? key,
    required this.className,
    required this.teacherName,
    required this.subject,
    required this.semester,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: (){
          print('lol $className');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> SoftwareEngineeringPage(classaName: className)),
          );
        },
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white),
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        className,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        teacherName,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.grey, Color(0xFF091F40)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        subject,
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        semester,
                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

