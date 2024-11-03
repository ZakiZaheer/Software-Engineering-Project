import 'package:flutter/material.dart';


class GradientText extends StatelessWidget{
  final String text;
  final Gradient gradient;
  final TextStyle style;

  const GradientText({
    Key?key,
    required this.text,
    required this.gradient,
    this.style=const TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback:(bounds)=>gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height)
        ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }

}