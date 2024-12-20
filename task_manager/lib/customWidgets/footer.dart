import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:task_manager/screens/task_screens/task_screen.dart';
import 'package:task_manager/voice%20Connectivity/speech_to_text_service.dart';
import 'gradient_text.dart';

class MainFooter extends StatefulWidget {
  final Function()? onInput;
  final int index;
  const MainFooter({super.key , this.onInput , required this.index});

  @override
  State<MainFooter> createState() => _MainFooterState();
}

class _MainFooterState extends State<MainFooter> {
  int _currentIndex = 0;
  bool hold = false;
  int duration = 1;
  int _sizeFactor =0;
  final TextEditingController _micController =
  TextEditingController();
  final SpeechToTextService _sst = SpeechToTextService();


  final List<String> _pages = [
    '/',
      '/eventScreen',
    '/signUpScreen',
    '/settingsScreen'
  ];

  @override
  void initState() {
    super.initState();
    _sst.initSpeech();
    setState(() {
      _currentIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double navItemSize = screenWidth * 0.1; // Adjust this multiplier as needed
    double micSize = screenWidth * 0.2;
    return Stack(
      children: [
        Container(
          height: 120 + (_sizeFactor * 120),
          decoration: const BoxDecoration(
            color: Colors.transparent,
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
                    colors: [Colors.transparent, Colors.transparent],
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
                  _micController.text.isEmpty
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
          padding:EdgeInsets.only(top: 25+ (_sizeFactor * 120)),
          child: Container(
            decoration: const BoxDecoration(
                border:
                Border(top: BorderSide(color: Colors.white, width: 2))),
            child: Container(
              color: const Color(0xFF0A1329), // Background color for BottomAppBar

              height: 95, // Height of the custom bottom navigation bar
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: _buildNavItem(Icons.checklist, 'Tasks', 0,navItemSize)),
                    Expanded(child: _buildNavItem(Icons.event, 'Events', 1,navItemSize)),
                    const Spacer(), // Adds flexible space in between
                    Expanded(
                        child: _buildNavItem(Icons.stars_sharp, 'Classroom', 2,navItemSize)),
                    Expanded(child: _buildNavItem(Icons.settings, 'Settings', 3,navItemSize)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          // Mic widget, centered horizontally
          top: 10 + (_sizeFactor * 120),
          left: MediaQuery.of(context).size.width / 2 - (micSize / 2), // Center horizontally
          child: GestureDetector(
            onLongPressStart: (details) async {
              setState(() {
                hold = true;
                _sizeFactor = 1;
              });
              // Start listening
              await _sst.startListening((result) {
                if (result.recognizedWords.isNotEmpty) {
                  setState(() {
                    _micController.text = result.recognizedWords;
                  });
                }
              });
            },
            onLongPressEnd: (details) async {
              // Stop listening and reset state
              hold = false;
              _sizeFactor = 0;
              await _sst.stopListening(() {
                setState(() {
                  hold = false;
                  _sizeFactor = 0;
                  _micController.text = "";
                });
              });
              setState(() {
              });
            },
            onLongPressCancel: ()async {
              hold = false;
              _sizeFactor = 0;
              await _sst.stopListening(() {
                setState(() {
                  hold = false;
                  _sizeFactor = 0;
                  _micController.text = "";
                });// Uncomment to clear after stopping
              });
              setState(() {
              });
            },
            child: Container(
              width: micSize,
              height: micSize,
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
  Widget _buildNavItem(IconData icon, String label, int index , double size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(index != _currentIndex){
            Navigator.pushNamed(context, _pages[index]);
          }

        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Container(
              width: size,
              height: size,
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
              fontSize: 0.3 * size,
            ),
          )
        ],
      ),
    );
  }
}
