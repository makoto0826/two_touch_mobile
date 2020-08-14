import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback onPressed;

  CircleButton({
    this.text,
    this.color,
    this.width = 80,
    this.height = 80,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
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
          style: TextStyle(fontSize: 25),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
