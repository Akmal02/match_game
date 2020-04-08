import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:match_game/models/data_value.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/game_board.dart';
import 'package:match_game/widgets/timer_bar.dart';

class TimedStageGameboard extends StatefulWidget {
  final TimedStage options;

  TimedStageGameboard({this.options});

  @override
  GameboardState createState() => _TimedStageGameboardState(options);
}

class _TimedStageGameboardState extends GameboardState {
  GlobalKey<TimerBarState> _timerKey = GlobalKey();

  TimedStage _options;

  _TimedStageGameboardState(this._options);

  @override
  Widget buildHeader(BuildContext context) {
    return TimerBar(
      key: _timerKey,
      color: Colors.blueGrey,
    );
  }

  @override
  StageOptions get options => _options;

  @override
  void onPrestart() {
    _timerKey.currentState.start(
      duration: _options.memorizeTime,
      onTime: () => status = GameStatus.playing,
    );
  }

  @override
  void onStart() {
    var timer = _timerKey.currentState;
    timer.reset();
    timer.start(
      duration: _options.playTime,
      onTime: () => status = GameStatus.gameOver,
    );
  }

  @override
  void onCleared() async {
    _timerKey.currentState.stop();
    await Future.delayed(Duration(milliseconds: 600));
    showStageClearedDialog();
  }

  @override
  void onGameOver() async {
    sendMessage(message: 'Time out!');
    await Future.delayed(Duration(milliseconds: 600));
    showGameOverDialog();
  }

  @override
  void onPause() {
    _timerKey?.currentState?.stop();
  }

  @override
  void onResume() {
    _timerKey?.currentState?.resume();
  }

  @override
  void onMatchFailed() {}

  @override
  void onMatchFound(MatchTile tile) {
    _timerKey.currentState.add(_options.timeCompensator);
    if (tile == MatchTile.timeBonus) {
      _timerKey.currentState.add(_options.addedTimeBonus);
      sendMessage(message: 'Time bonus!', holdDuration: Duration(seconds: 1));
    }
  }

  @override
  void onNextLevel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          board: TimedStageGameboard(
            options: Stages.timed[currentStage],
          ),
        ),
      ),
    );
  }
}
