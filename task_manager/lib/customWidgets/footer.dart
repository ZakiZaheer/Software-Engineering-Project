import 'package:flutter/material.dart';
import 'package:task_manager/screens/task_screens/task_screen.dart';

class MainFooter extends StatefulWidget {
  const MainFooter({super.key});

  @override
  State<MainFooter> createState() => _MainFooterState();
}

class _MainFooterState extends State<MainFooter> {
  int _currentIndex = 0;
  bool hold = false;
  int duration = 1;
  int _x =0;
  final TextEditingController _micController =
  TextEditingController(text: "Create A Task For Meeting Tomorrow");
  late final Gradient gradient;

  final List<Widget> _pages = [
    const TaskScreen(),
    const Center(child: Text('Events', style: TextStyle(fontSize: 100))),
    const Center(child: Text('Mic', style: TextStyle(fontSize: 100))),
    Scaffold(),
    const Center(child: Text('Settings', style: TextStyle(fontSize: 100))),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120+ (_x * 120),
          decoration: const BoxDecoration(
            color: Color(0xFF091F40),
          ),
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
                gradient: hold ? const LinearGradient(
                    colors: [Colors.black, Colors.pink],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
                    :
                const LinearGradient(
                    colors: [Color(0xFF091F40), Color(0xFF091F40)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (hold && _micController.text.isEmpty)
                      ? const Text(
                    'Try saying',
                    style:
                    TextStyle(fontSize: 20, color: Colors.white),
                  )
                      : const SizedBox.shrink(),
                  hold
                      ?
                  _micController.text.isNotEmpty
                      ?
                  const GradientText(
                    text: 'Create an event',
                    gradient: LinearGradient(
                        colors: [Colors.pink, Colors.purple]),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                      :
                  GradientText(
                    text: _micController.text,
                    gradient: const LinearGradient(
                        colors: [Colors.pink, Colors.purple]),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                      :
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding:EdgeInsets.only(top: 25+ (_x * 120)),
          child: Container(
            decoration: const BoxDecoration(
                border:
                Border(top: BorderSide(color: Colors.white, width: 2))),
            child: Container(
              color: Colors.blueGrey, // Background color for BottomAppBar

              height: 95, // Height of the custom bottom navigation bar
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: _buildNavItem(Icons.checklist, 'Tasks', 0)),
                  Expanded(child: _buildNavItem(Icons.event, 'Events', 1)),
                  const Spacer(), // Adds flexible space in between
                  Expanded(
                      child: _buildNavItem(Icons.stars_sharp, 'Classroom', 3)),
                  Expanded(child: _buildNavItem(Icons.settings, 'Settings', 4)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          // Mic widget, centered horizontally
          top: 10 + (_x * 120),
          left: MediaQuery.of(context).size.width / 2 -
              45, // Center horizontally
          child: GestureDetector(
            onLongPressStart: (details) {
              setState(() {
                hold = true;
                _x = 1;
              });
            },
            onLongPressEnd: (details) {
              setState(() {
                hold = false;
                _x = 0;
              });
            },
            onLongPressCancel: () {
              setState(() {
                hold = false;
                _x = 0;
              });
            },
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: hold
                    ? const LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)
                    : null,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: hold
                      ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                          colors: [Colors.pink, Colors.purple])
                          .createShader(bounds);
                    },
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 65,
                    ),
                  )
                      : const Icon(
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
    );
  }
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
              color:
              _currentIndex == index ? Colors.yellowAccent : Colors.black,
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
