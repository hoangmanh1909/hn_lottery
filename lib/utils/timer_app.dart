// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, avoid_print, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';

class TimerApp extends StatefulWidget {
  const TimerApp({super.key, required this.eventTime, this.textStyle});

  final DateTime eventTime;
  final TextStyle? textStyle;
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  DateTime? eventTime;
  Duration duration = Duration(seconds: 1);

  int timeDiff = 0;
  bool isActive = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    setState(() {
      eventTime = widget.eventTime;
      timeDiff = widget.eventTime.difference(DateTime.now()).inSeconds;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
  }

  void handleTick() {
    if (timeDiff > 0) {
      if (isActive) {
        setState(() {
          if (eventTime != DateTime.now()) {
            timeDiff = timeDiff - 1;
          } else {
            print('Times up!');
            //Do something
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    timer ??= Timer.periodic(duration, (Timer t) {
      handleTick();
    });

    int days = timeDiff ~/ (24 * 60 * 60) % 24;
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              days.toString().padLeft(2, '0'),
              style: widget.textStyle,
            ),
            Text(
              ":",
              style: widget.textStyle,
            ),
            Text(
              hours.toString().padLeft(2, '0'),
              style: widget.textStyle,
            ),
            Text(
              ":",
              style: widget.textStyle,
            ),
            Text(
              minutes.toString().padLeft(2, '0'),
              style: widget.textStyle,
            ),
            Text(
              ":",
              style: widget.textStyle,
            ),
            Text(
              seconds.toString().padLeft(2, '0'),
              style: widget.textStyle,
            )
          ],
        )
      ],
    );
  }
}

class LabelText extends StatelessWidget {
  const LabelText({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
