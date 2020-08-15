import 'package:flutter/material.dart';
import 'circle_button.dart';

typedef void NumberPressed(String number);

class NumberButtons extends StatelessWidget {
  final NumberPressed onNumberPressed;

  final VoidCallback onDeletePressed;

  final VoidCallback onOkPressed;

  NumberButtons({this.onNumberPressed, this.onDeletePressed, this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNumber(context, text: '1'),
            _buildNumber(context, text: '2'),
            _buildNumber(context, text: '3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNumber(context, text: '4'),
            _buildNumber(context, text: '5'),
            _buildNumber(context, text: '6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNumber(context, text: '7'),
            _buildNumber(context, text: '8'),
            _buildNumber(context, text: '9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItem(context, text: '×', onPressed: onDeletePressed),
            _buildNumber(context, text: '0'),
            _buildItem(context, text: 'OK', onPressed: onOkPressed),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context, {
    String text,
    VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: CircleButton(
        text: text,
        color: Colors.blue,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildNumber(
    BuildContext context, {
    String text,
  }) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: CircleButton(
        text: text,
        color: Colors.blue,
        onPressed: () => onNumberPressed(text),
      ),
    );
  }
}
