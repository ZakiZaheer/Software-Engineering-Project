import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../customWidgets/date_picker.dart';
import '../../customWidgets/footer.dart';
import '../../customWidgets/time_picker.dart';
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

  List<String> pollOptions = ['Yes', 'No'];

  void _addOption() {
    setState(() {
      pollOptions.add('');
    });
  }

  // Remove an option from the poll
  void _removeOption(int index) {
    setState(() {
      pollOptions.removeAt(index);
    });
  }

  // Update the text of an option
  void _updateOption(String value, int index) {
    setState(() {
      pollOptions[index] = value;
    });
  }


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
          title: const Text('Create Post',style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(
            color: Colors.white, // White Back Arrow and Icons
          ),
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
                    Text("Post type",style: TextStyle(
                    color: Colors.white)),
                    _PostsType(),
                    if (_selectedType=='Test')...[
                      SizedBox(height: 3),
                      Text("Date of test",style: TextStyle(
                          color: Colors.white)),
                      SizedBox(height: 3),
                      dateandtimefield("DD-MM-YYYY"),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Start time',style: TextStyle(
                              color: Colors.white)),
                          SizedBox(width: 100),
                          Text('End time',style: TextStyle(
                              color: Colors.white))
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
                      Text("Description",style: TextStyle(
                          color: Colors.white)),
                      SizedBox(height: 3),
                      description('Write the description related to the test for like syllabus and units that are to be covered for the test...', _description)
                    ]
                    else if(_selectedType=='Assignment')...[
                      SizedBox(height: 3),
                      Text("Due by",style: TextStyle(
                          color: Colors.white)),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          dateandtimefield('DD-MM-YYYY',width: 220),
                          timefield('00:00', _starttime)
                        ],
                      ),
                      SizedBox(height: 3),
                      Text("Description",style: TextStyle(
                          color: Colors.white)),
                      SizedBox(height: 3),
                      description('Write the description related to the Assignment for like the questions of the exercise and examples to be.', _description)
                    ]
                    else if(_selectedType=='Class cancellation')...[
                        SizedBox(height: 3),
                        Text("Date",style: TextStyle(
                            color: Colors.white)),
                        SizedBox(height: 3),
                        dateandtimefield("DD-MM-YYYY"),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Start time',style: TextStyle(
                                color: Colors.white)),
                            SizedBox(width: 100),
                            Text('End time',style: TextStyle(
                                color: Colors.white))
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
                        Text("Description",style: TextStyle(
                            color: Colors.white)),
                        SizedBox(height: 3),
                        description('Write the description to state the reason leading to cancellation of the class.', _description)
                    ]
                    else if(_selectedType=='Exam')...[
                          SizedBox(height: 3),
                          Text("Date of exam",style: TextStyle(
                              color: Colors.white)),
                          SizedBox(height: 3),
                          dateandtimefield("DD-MM-YYYY"),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Start time',style: TextStyle(
                                  color: Colors.white)),
                              SizedBox(width: 100),
                              Text('End time',style: TextStyle(
                                  color: Colors.white))
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
                          Text("Description",style: TextStyle(
                              color: Colors.white)),
                          SizedBox(height: 3),
                          description('Write the description related to the test for like syllabus and unit that are to be covered for the test...', _description)
                    ]
                    else if(_selectedType=='Material')...[
                            SizedBox(height: 3),
                            Text("Title",style: TextStyle(
                                color: Colors.white)),
                            SizedBox(height: 3),
                            description('Enter title of the poll', _title),
                            SizedBox(height: 3),
                            Text("Description",style: TextStyle(
                                color: Colors.white)),
                            SizedBox(height: 3),
                            description('Write the description related to the file attached.', _description),
                            SizedBox(height: 3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                icon: Icon(Icons.add,color: Colors.white,),          // Icon for the button
                                label: Text(filename,style: TextStyle(
                                    color: Colors.white)),         // Text for the button
                                onPressed: () {
                                  _pickFile();
                                  print("Button pressed!");
                                },
                              ),
                            ),
                    ]
                    else if(_selectedType=="Notice")...[
                              SizedBox(height: 3),
                              Text("Title",style: TextStyle(
                                  color: Colors.white)),
                              SizedBox(height: 3),
                              description('Enter title', _title),
                              SizedBox(height: 3),
                              Text("Description",style: TextStyle(
                                  color: Colors.white)),
                              SizedBox(height: 3),
                              description('Write the description for the notice', _description),
                    ]
                            else if (_selectedType == 'Poll') ...[
                                const SizedBox(height: 5),
                                const Text(
                                  "Title",
                                  style: TextStyle(color: Colors.white),
                                ),

                                description('Enter the title of the poll', _title),
                                const SizedBox(height: 5),
                                const Text(
                                  "Description",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                description(
                                  'Write the description for the poll (optional)',
                                  _description,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Options",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                ...pollOptions.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String option = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: null, // Can be updated for selection handling.
                                          onChanged: (int? value) {
                                            // Logic to handle radio selection (if needed).
                                          },
                                          activeColor: Colors.white,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: option,
                                            onChanged: (value) => _updateOption(value, index),
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              hintText: "Option ${index + 1}",
                                              hintStyle: const TextStyle(color: Colors.grey),
                                              filled: true,
                                              fillColor: Colors.transparent, // Custom background for input

                                              contentPadding:
                                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _removeOption(index),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    label: const Text("Add an option", style: TextStyle(color: Colors.white)),
                                    onPressed: _addOption,
                                  ),
                                ),
                              ]

                  ],
                )
            ),
          ),
        ),
        bottomNavigationBar: const MainFooter(index: 2),

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
                suffixIcon: Icon(Icons.watch_later_outlined,color: Colors.white,),
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
                suffixIcon: Icon(Icons.calendar_month,color: Colors.white,),
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
                style: TextStyle(
                  color: Colors.white, // Set the color of the selected text
                  fontSize: 16,       // Optional: Adjust font size
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










