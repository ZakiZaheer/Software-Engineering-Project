import 'package:flutter/material.dart';
import 'package:last_attempt/classroom/classmembers.dart';
import 'package:last_attempt/classroom/joinreqs.dart';
import 'package:last_attempt/classroom/create_post.dart';
import 'package:last_attempt/classroom/viewposts.dart';



class SoftwareEngineeringPage extends StatefulWidget {

  final classaName;
  const SoftwareEngineeringPage({Key? key, required this.classaName}) : super(key: key);


  @override
  _SoftwareEngineeringPageState createState() => _SoftwareEngineeringPageState();
}

class _SoftwareEngineeringPageState extends State<SoftwareEngineeringPage> {


  bool is_cr=true;

  // Track selected poll option for each poll
  final Map<int, String> selectedPollOptions = {};

  final List<Map<String, dynamic>> items = [
    {
      'type': 'Test',
      'title': 'Test On: 10 Nov',
      'postedOn': '26 Aug',
      'description': 'Theory, Unit 1-3. You need to prepare for the ---------------------',
      'time': '12:30-14:30',
    },
    {
      'type': 'Assignment',
      'title': 'Assignment Due: 5 Nov',
      'postedOn': '26 Aug',
      'description': 'Back exercise, chapter 1 section 1.2 an...',
      'time': 'By 23:59',
    },
    {
      'type': 'Class Cancellation',
      'title': 'Class Cancellation: 1 Dec',
      'postedOn': '26 Aug',
      'description': 'Theory class has been cancelled due to...',
      'time': '1:00-3:00',
    },
    {
      'type': 'Exam',
      'title': 'Exam On: 11 Dec',
      'postedOn': '26 Aug',
      'description': 'Practical external exam has been sched...',
      'time': '12:00-3:00',
    },
    {
      'type': 'Poll',
      'title': 'Will you attend the class (9-11)?',
      'postedOn': '26 Aug',
      'options': ['Yes', 'No'],
    },
    {
      'type': 'Material',
      'title': 'Guidelines NEP',
      'postedOn': '26 Aug',
      'file': 'Software_engineering_2024_guidelines_NE.pdf',
    },
    {
      'type': 'Notice',
      'title': 'Notice',
      'postedOn': '26 Aug',
      'description': 'This is a multiline notice text that g...',
    },
  ];



  void navigateToDetails(int index) {
    final item = items[index - 1]; // Adjust for 1-based indexing

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (item['type']) {
            case 'Test':
            case 'Assignment':
            case 'Exam':
              return DetailsScreen(
                type: item['type'],
                title: item['title'],
                postedOn: item['postedOn'],
                description: item['description'],
                time: item['time'],
                isCr: is_cr,
                className: widget.classaName,
              );
            case 'Class Cancellation':
              return DetailsScreen(
                type: item['type'],
                title: item['title'],
                postedOn: item['postedOn'],
                description: item['description'],
                time: item['time'],
                isCr: is_cr,
                className: widget.classaName,
              );
            case 'Poll':
              return DetailsScreen(
                type: item['type'],
                title: item['title'],
                postedOn: item['postedOn'],
                description: 'Please vote for one of the options below.',
                pollOptions: item['options'],
                isCr: is_cr,
                className: widget.classaName,
              );
            case 'Material':
              return DetailsScreen(
                type: item['type'],
                title: item['title'],
                postedOn: item['postedOn'],
                description: 'Material available: ${item['file']}',
                materialName: item['file'],
                isCr: is_cr,
                className: widget.classaName,
              );
            case 'Notice':
              return DetailsScreen(
                type: item['type'],
                title: item['title'],
                postedOn: item['postedOn'],
                description: item['description'],
                isCr: is_cr,
                className: widget.classaName,
              );
            default:
              return const Scaffold(
                body: Center(child: Text('Unknown type')),
              );
          }
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    var Width=(MediaQuery.of(context).size.width)-18;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: Text(widget.classaName, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Set back arrow color to white
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.blue,
            icon: Icon(Icons.more_vert_outlined, color: Colors.white),
            onSelected: (String value) {
              if (value == 'Delete Class') {
                // Handle Delete Class logic
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade700, Colors.blue.shade300], // Blue gradient background
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Delete this class?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 40),
                                    backgroundColor: Colors.grey, // Grey button for Cancel
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Perform Unenroll action
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 39),
                                    backgroundColor: Colors.blue.shade900, // Deep blue button for OK
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (value == 'Join Requests') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinRequestsPage()),
                );

                print("Navigate to Join Requests page");
              } else if (value == 'Share Invitation') {
                // Handle Share Invitation logic
                print("Share invitation link");
              } else if (value == 'View Members') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassroomMembersPage(isCr: is_cr), // or false
                  ),
                );

                print("Navigate to View Members page");
              }
              else if (value == 'Unenroll') {
                // Handle Unenroll logic here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade700, Colors.blue.shade300], // Blue gradient background
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Unenroll from this class?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 40),
                                    backgroundColor: Colors.grey, // Grey button for Cancel
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Perform Unenroll action
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 38),
                                    backgroundColor: Colors.blue.shade900, // Deep blue button for OK
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

              } else if (value == 'View Members') {
                // Handle View Members logic here
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewMembersPage(), // Replace with your View Members Page
                  ),
                );*/
              }
            },
            itemBuilder: (BuildContext context) {
              // Show different options based on is_cr
              if (is_cr) {
                return [
                  PopupMenuItem<String>(
                    value: 'Delete Class',
                    child: Text('Delete Class'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Join Requests',
                    child: Text('Join Requests'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Share Invitation',
                    child: Text('Share Invitation'),
                  ),
                  PopupMenuItem<String>(
                    value: 'View Members',
                    child: Text('View Members'),
                  ),
                ];
              } else {
                return [
                  PopupMenuItem<String>(
                    value: 'Unenroll',
                    child: Text('Unenroll'),
                  ),
                  PopupMenuItem<String>(
                    value: 'View Members',
                    child: Text('View Members'),
                  ),
                ];
              }
            },
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF091F40),
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Theme(
                              data: ThemeData(
                                textTheme: TextTheme(), // Provide an empty TextTheme (no defaults)
                              ),
                              child: createPost(), // Replace with your actual page
                            ),
                          ),
                        );



                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.transparent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.grey, Colors.transparent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              color: Color(0xFF091F40),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF091F40),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit_outlined, color: Colors.white),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Create a post for your class! ex: Tests, assignme...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final item = items[index - 1];
                  final bool showPlusButton = item['type'] == 'Test' ||
                      item['type'] == 'Assignment' ||
                      item['type'] == 'Exam';

                  return GestureDetector(
                    onTap: () {
                      navigateToDetails(index);
                      print(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.transparent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Container(
                                height: showPlusButton?92:null,
                                width: showPlusButton?Width-49:Width,
                                padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.purple, Colors.transparent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['title'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        if (item.containsKey('time'))
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "("+item['time']+")",
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Posted: ${item['postedOn']}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    if (item.containsKey('description'))
                                      Text(
                                        item['description'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    if (item['type'] == 'Poll')
                                      Column(
                                        children: (item['options'] as List<String>).map((option) {
                                          return Row(
                                            children: [
                                              Radio<String>(
                                                value: option,
                                                groupValue: selectedPollOptions[index - 1],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedPollOptions[index - 1] = value!;
                                                  });
                                                },
                                              ),
                                              Text(option, style: TextStyle(color: Colors.white)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    if (item['type'] == 'Material')
                                      Row(
                                        children: [
                                          Icon(Icons.picture_as_pdf, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(item['file'],style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (showPlusButton)
                              Container(
                                width: 48,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    showAddToCalendarDialog(context);
                                  }
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
          ],
        ),
      ),
    );
  }
}



void showAddToCalendarDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.purple, // Background color
        title: const Text(
          'Add to Calendar',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Do you want to add this event to your calendar?',
          style: TextStyle(
            color: Colors.white70, // Content text color
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.white, // No button text color
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle "Yes" action
              Navigator.of(context).pop(); // Close the dialog after action
              // Implement "Add to Calendar" logic here
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.blue, // Yes button text color
              ),
            ),
          ),
        ],
      );
    },
  );
}

