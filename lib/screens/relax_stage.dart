import 'package:flutter/material.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/game_board.dart';
import 'package:match_game/widgets/chronograph.dart';

class RelaxStageGameboard extends StatefulWidget {
  final RelaxStage options;

  RelaxStageGameboard({this.options});

  @override
  _RelaxStageGameboardState createState() => _RelaxStageGameboardState(options);
}

class _RelaxStageGameboardState extends GameboardState {
  RelaxStage _options;
  final Stopwatch stopwatch = Stopwatch();

  _RelaxStageGameboardState(this._options);

  @override
  StageOptions get options => _options;

  @override
  void onPrestart() {
    status = GameStatus.playing;
  }

  @override
  Widget buildHeader(BuildContext context) {
    return Chronograph(
      stopwatch: stopwatch,
    );
  }

  @override
  void onMatchFailed() {}

  @override
  void onMatchFound(MatchTile tile) {}

  @override
  void onStart() {
    stopwatch.start();
  }

  @override
  void onPause() {
    stopwatch.stop();
  }

  @override
  void onResume() {
    stopwatch.start();
  }

  @override
  void onCleared() async {
    await Future.delayed(Duration(milliseconds: 600));
    showStageClearedDialog();
  }

  @override
  void onGameOver() async {}

  @override
  void onNextLevel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          board: RelaxStageGameboard(
            options: Stages.relax[0],
          ),
        ),
      ),
    );
  }
}
