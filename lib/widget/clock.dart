import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Clock extends StatefulWidget {
  final timeFontSize;

  final dateFontSize;

  Clock({
    this.timeFontSize = 100.0,
    this.dateFontSize = 25.0,
  });

  @override
  State<StatefulWidget> createState() => ClockState();
}

class ClockState extends State<Clock> {
  String _time = '';
  String _date = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _setTime());
    _setTime();
  }

  void _setTime() {
    var now = DateTime.now();
    var timeFormatter = DateFormat('HH:mm:ss');
    var dateFormatter = DateFormat('yyyy年MM月dd日(E)', "ja_JP");
    var formattedTime = timeFormatter.format(now);
    var formattedDate = dateFormatter.format(now);

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _time,
          style: TextStyle(
            fontSize: widget.timeFontSize,
          ),
        ),
        Text(
          _date,
          style: TextStyle(
            fontSize: widget.dateFontSize,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
