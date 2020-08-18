import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double fontSize;
  final VoidCallback onPressed;

  CircleButton({
    this.text,
    this.color,
    this.size = 80,
    this.fontSize = 25,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: RaisedButton(
        color: Colors.white,
        highlightElevation: 16.0,
        highlightColor: color,
        shape: CircleBorder(
          side: BorderSide(
            color: color,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
