import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback onPressed;

  RectButton({
    this.text,
    this.color,
    this.width = double.infinity,
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
        padding: EdgeInsets.all(16),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          borderSide: this.onPressed != null ? BorderSide(color: color) : BorderSide(),
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
