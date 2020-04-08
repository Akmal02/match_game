import 'dart:async';

import 'package:flutter/material.dart';
import 'package:match_game/main.dart';

class Chronograph extends StatefulWidget {
  final Stopwatch stopwatch;

  Chronograph({@required this.stopwatch});

  @override
  _ChronographState createState() => _ChronographState(stopwatch);
}

class _ChronographState extends State<Chronograph> {
  Timer timer;
  final Stopwatch stopwatch;

  _ChronographState(this.stopwatch) {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (widget.stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int seconds = (stopwatch.elapsedMicroseconds / 1000000).truncate();
    int minutes = (seconds / 60).truncate();

    var _textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: minutes.toString(),
            style: _textTheme.title,
          ),
          TextSpan(
            text: ' min  ',
            style: _textTheme.subhead,
          ),
          TextSpan(
            text: (seconds % 60).toString().padLeft(2, '0'),
            style: _textTheme.title,
          ),
          TextSpan(
            text: ' sec',
            style: _textTheme.subhead,
          ),
        ],
      ),
    );
  }
}
