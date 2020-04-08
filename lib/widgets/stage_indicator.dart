import 'package:flutter/material.dart';
import 'package:match_game/widgets/scoreboard.dart';

class StageIndicator extends StatelessWidget {
  final int stage;

  const StageIndicator({this.stage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Stage:   '),
        Text(
          stage.toString(),
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
