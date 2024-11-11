import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_attempt/Widgets/date_picker.dart';
import 'package:last_attempt/Widgets/time_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(CreatePost());
}

class CreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Post',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: createPost(),
    );
  }
}

class createPost extends StatefulWidget {
  @override
  _postState createState() => _postState();
}

class _postState extends State<createPost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _starttime = TextEditingController();
  final TextEditingController _endtime = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _title = TextEditingController();

  String filename='Attach a file';

  String? _selectedType;
  final List<String> _postTypes = [
    'Test', 'Assignment', 'Class cancellation','Exam',
    'Poll','Material','Notice'
  ];


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // File selected, you can get the file path or file name
      PlatformFile file = result.files.first;
      setState(() {
        filename = file.name; // Display the file name after selection
      });
    }
  }






  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF091F40),
          title: const Text('Create Post'),
          actions: [
            // IconButton in the AppBar
            TextButton(
              onPressed: () {
                // Action for the button

              },
              child: Text(
                'Create', // Text on the button
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
          ],
        ),
        body:Container(
          color: Color(0xFF091F40),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children:  [
                    Text("Post type"),
                    _PostsType(),
                    if (_selectedType=='Test')...[
                      SizedBox(height: 3),
                      Text("Date of test"),
                      SizedBox(height: 3),
                      dateandtimefield("DD-MM-YYYY"),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Start time'),
                          SizedBox(width: 100),
                          Text('End time')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          timefield('00:00', _starttime),
                          SizedBox(width: 10),
                          timefield('00:00', _endtime)
                        ],
                      ),
                      SizedBox(height: 3),
                      Text("Description"),
                      SizedBox(height: 3),
                      description('Write the description related to the test for like syllabus and units that are to be covered for the test...', _description)
                    ]
                    else if(_selectedType=='Assignment')...[
                      SizedBox(height: 3),
                      Text("Due by"),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          dateandtimefield('DD-MM-YYYY',width: 220),
                          timefield('00:00', _starttime)
                        ],
                      ),
                      SizedBox(height: 3),
                      Text("Description"),
                      SizedBox(height: 3),
                      description('Write the description related to the Assignment for like the questions of the exercise and examples to be.', _description)
                    ]
                    else if(_selectedType=='Class cancellation')...[
                        SizedBox(height: 3),
                        Text("Date"),
                        SizedBox(height: 3),
                        dateandtimefield("DD-MM-YYYY"),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Start time'),
                            SizedBox(width: 100),
                            Text('End time')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            timefield('00:00', _starttime),
                            SizedBox(width: 10),
                            timefield('00:00', _endtime)
                          ],
                        ),
                        SizedBox(height: 3),
                        Text("Description"),
                        SizedBox(height: 3),
                        description('Write the description to state the reason leading to cancellation of the class.', _description)
                    ]
                    else if(_selectedType=='Exam')...[
                          SizedBox(height: 3),
                          Text("Date of exam"),
                          SizedBox(height: 3),
                          dateandtimefield("DD-MM-YYYY"),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Start time'),
                              SizedBox(width: 100),
                              Text('End time')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              timefield('00:00', _starttime),
                              SizedBox(width: 10),
                              timefield('00:00', _endtime)
                            ],
                          ),
                          SizedBox(height: 3),
                          Text("Description"),
                          SizedBox(height: 3),
                          description('Write the description related to the test for like syllabus and unit that are to be covered for the test...', _description)
                    ]
                    else if(_selectedType=='Material')...[
                            SizedBox(height: 3),
                            Text("Title"),
                            SizedBox(height: 3),
                            description('Enter title of the poll', _title),
                            SizedBox(height: 3),
                            Text("Description"),
                            SizedBox(height: 3),
                            description('Write the description related to the file attached.', _description),
                            SizedBox(height: 3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                icon: Icon(Icons.add),          // Icon for the button
                                label: Text(filename),         // Text for the button
                                onPressed: () {
                                  _pickFile();
                                  print("Button pressed!");
                                },
                              ),
                            ),
                    ]
                    else if(_selectedType=="Notice")...[
                              SizedBox(height: 3),
                              Text("Title"),
                              SizedBox(height: 3),
                              description('Enter title', _title),
                              SizedBox(height: 3),
                              Text("Description"),
                              SizedBox(height: 3),
                              description('Write the description for the notice', _description),
                    ]
                    else if(_selectedType=='Poll')...[

                    ]
                  ],
                )
            ),
          ),
        )
    );
  }


  Widget description(String hintText,TextEditingController _cont) {
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
              controller: _cont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows unlimited lines (grows dynamically)
              minLines: 1,
            ),
          ),
        ),
      ),
    );
  }


  Widget timefield(String hintText,TextEditingController cont) {

    return Container(
      width: 150,
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
              controller: cont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.watch_later_outlined),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomTimePicker();
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      cont.text = value;
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

  Widget dateandtimefield(String hintText,{double width=0}) {

    return Container(
      width: width==0?MediaQuery.of(context).size.width:width,
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
              controller: _datecontroller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.calendar_month),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDatePicker();
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _datecontroller.text =
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


  Widget _PostsType() {
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
            child:Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: Colors.blue,
                decoration: const InputDecoration(
                  hintText: "Select Post Type",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: InputBorder.none,
                ),
                items: _postTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(growable: true),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}










