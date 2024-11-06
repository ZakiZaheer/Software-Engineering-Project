import 'package:flutter/material.dart';
import 'customWidgets/alert_slider.dart';

Widget buildAlarmTile() {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF0A1A2A),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1.0),
    ),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Alarm',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Color(0xFFFFFFFF),
            )),
        CustomSlider(
          onValueChanged: (value) {
            print("Slider value changed to: $value");
          },
        ),
        Text('Voice',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Color(0xFFFFFFFF),
            )),
      ],
    ),
  );
}
