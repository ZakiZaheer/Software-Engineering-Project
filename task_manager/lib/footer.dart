import 'package:flutter/material.dart';
import 'login.dart';
import 'package:last_attempt/Widgets/gradient_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  bool hold=false;
  int duration=1;
  int _x=0;

  TextEditingController vctext = TextEditingController();
  String s="";

  late final Gradient gradient;




  // List of widgets for each tab
  final List<Widget> _pages = [
    const Center(child: Text('Tasks',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Events',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Mic',style: TextStyle(fontSize: 100))),
    SignUpApp(),
    const Center(child: Text('Settings',style: TextStyle(fontSize: 100))),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pages[_currentIndex], // Show the current page


      bottomNavigationBar: Stack(
        children:[
          Container(
            height: 120+(_x*120),
            decoration: BoxDecoration(
                color: Color(0xFF091F40)
            ),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: hold? Colors.black : Color(0xFF091F40),
                gradient: hold?LinearGradient(
                  colors: [Colors.black,Colors.pink],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ):null
              ),
              child:Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    hold?Text(
                      'Try saying',
                      style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                      ),
                    ):SizedBox.shrink(),
                    hold?(vctext.text.isEmpty?GradientText(
                        text: 'Create an event',
                        gradient: LinearGradient(
                            colors: [Colors.pink,Colors.purple]
                        ),
                      style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                    ):GradientText(
                      text: vctext.text,
                      gradient: LinearGradient(
                          colors: [Colors.pink,Colors.purple]
                      ),
                      style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                    )):SizedBox.shrink(),
                    /*hold?Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black,Colors.pink],
                              begin:Alignment.topCenter,
                              end:Alignment.bottomCenter
                          )
                        ),
                      ),
                    ):SizedBox.shrink()*/
                  ]
              ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25+(_x*120)),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.white,width: 2)
                  )
              ),
              child: BottomAppBar(

                color: Colors.blueGrey, // Background color for BottomAppBar

                height: 95, // Height of the custom bottom navigation bar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildNavItem(Icons.checklist, 'Tasks', 0),
                    SizedBox(width: 2),
                    _buildNavItem(Icons.event, 'Events', 1),
                    SizedBox(width: 90),
                    _buildNavItem(Icons.stars_sharp, 'Classroom', 3),
                    _buildNavItem(Icons.settings, 'Settings', 4),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10+(_x*120),left: 158.3,
            child: GestureDetector(

              onLongPressStart: (details){
                setState(() {
                  hold=true;
                  _x=1;
              });},

              onLongPressEnd: (details){
                setState(() {
                  hold=false;
                  _x=0;
                });
              },

              onLongPressCancel: (){
                setState(() {
                  hold=false;
                  _x=0;
                });
              },

              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: hold?LinearGradient(
                      colors:[Colors.pink,Colors.purple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                  ):null,
                  shape: BoxShape.circle,

                ),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                    ),
                    child: hold?ShaderMask(
                      shaderCallback: (Rect bounds){
                        return LinearGradient(
                            colors: [Colors.pink,Colors.purple]
                        ).createShader(bounds);
                      },
                        child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 65,
                      ),
                    ):Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 65,
                    ),
                  ),
                ),
              ),
            ),
          )
       ],
      ),
    );
  }

  // Function to build each navigation item
  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Container(
              width: 50,
              height: 50,
              color: _currentIndex == index ? Colors.yellowAccent : Colors.black,

              child: Icon(
                icon,
                color: _currentIndex == index ? Colors.black87 : Colors.white,
              ),
            ),
          ),

          Text(
            label,
            style: TextStyle(
              color: _currentIndex == index ? Colors.white : Colors.white,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }



}


