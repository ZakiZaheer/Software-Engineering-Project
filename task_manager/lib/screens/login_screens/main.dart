import 'package:flutter/material.dart';

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

  // List of widgets for each tab
  final List<Widget> _pages = [
    const Center(child: Text('Tasks',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Events',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Mic',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Classroom',style: TextStyle(fontSize: 100))),
    const Center(child: Text('Settings',style: TextStyle(fontSize: 100))),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskbridge'),
      ),
      body: _pages[_currentIndex], // Show the current page

      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          onPressed: ()=>debugPrint("MIC") ,
          child: Icon(Icons.mic,size: 90,),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children:[

          BottomAppBar(
          color: Colors.blueGrey, // Background color for BottomAppBar
           // Shape of BottomAppBar
           // Margin around the floating action button
          height: 95, // Height of the custom bottom navigation bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNavItem(Icons.checklist, 'Tasks', 0),
              _buildNavItem(Icons.event, 'Events', 1),
              Container(width: 90),
              _buildNavItem(Icons.stars_sharp, 'Classroom', 3),
              _buildNavItem(Icons.settings, 'Settings', 4),
            ],
          ),
        ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
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
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
