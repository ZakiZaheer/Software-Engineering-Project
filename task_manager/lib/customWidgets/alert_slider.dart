// alertslider.dart
import 'package:flutter/material.dart';

class CustomAlertSlider extends StatefulWidget {
  final Function(double) onValueChanged;
  final double initialValue;

  const CustomAlertSlider({super.key, required this.onValueChanged , this.initialValue =0});

  @override
  _CustomAlertSliderState createState() => _CustomAlertSliderState();
}

class _CustomAlertSliderState extends State<CustomAlertSlider> {
  late double _sliderValue;

  final List<double> sliderSteps = [-1, 0, 1];

  double _snapSlider(double value) {
    int divisions = sliderSteps.length - 1;
    int nearestDivision = ((value + 1) * divisions / 2).round();
    return sliderSteps[nearestDivision];
  }

  @override
  void initState() {
    _sliderValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
              fontFamily:
                  'Roboto', // Ensure this matches the font declared in pubspec.yaml
              fontWeight: FontWeight.w400, // Weight 300
              fontSize: 18,
              color: Colors.white),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text('Low',
                  style: TextStyle(
                      fontFamily:
                          'Roboto', // Ensure this matches the font declared in pubspec.yaml
                      fontWeight: FontWeight.w200, // Weight 300
                      fontSize: 18,
                      color: Colors.white)),
            ),
            SizedBox(
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 20.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.yellow, Colors.red],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    child: _buildDot(10.0, Colors.black, -1),
                  ),
                  Positioned(
                    right: 8,
                    child: _buildDot(10.0, Colors.black, 1),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 20.0),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: -1,
                      max: 1,
                      divisions: 2,
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      thumbColor: Colors.white,
                      onChanged: (newValue) {
                        double snappedValue = _snapSlider(newValue);
                        setState(() {
                          _sliderValue = snappedValue;
                        });
                      },
                      onChangeEnd: (newValue) {
                        double snappedValue = _snapSlider(newValue);
                        widget.onValueChanged(snappedValue);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('High',
                  style: TextStyle(
                      fontFamily:
                          'Roboto', // Ensure this matches the font declared in pubspec.yaml
                      fontWeight: FontWeight.w200, // Weight 300
                      fontSize: 18,
                      color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(double size, Color color, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sliderValue = value.toDouble();
        });
        widget.onValueChanged(_sliderValue);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  final double initialValue;
  final Function(double) onValueChanged;

  CustomSlider({required this.onValueChanged , this.initialValue = 0});

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _sliderValue;
  final List<double> sliderSteps = [-1, 0, 1];

  double _snapSlider(double value) {
    int divisions = sliderSteps.length - 1;
    int nearestDivision = ((value + 1) * divisions / 2).round();
    return sliderSteps[nearestDivision];
  }

  @override
  void initState() {
    _sliderValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // Adjust width as needed
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          Positioned(
            left: 8,
            child: _buildDot(10.0, Colors.black, -1),
          ),
          Positioned(
            right: 8,
            child: _buildDot(10.0, Colors.black, 1),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: _sliderValue,
              min: -1,
              max: 1,
              divisions: 2,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              thumbColor: Colors.white,
              onChanged: (newValue) {
                double snappedValue = _snapSlider(newValue);
                setState(() {
                  _sliderValue = snappedValue;
                });
              },
              onChangeEnd: (newValue) {
                double snappedValue = _snapSlider(newValue);
                widget.onValueChanged(snappedValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(double size, Color color, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sliderValue = value.toDouble();
        });
        widget.onValueChanged(_sliderValue);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
