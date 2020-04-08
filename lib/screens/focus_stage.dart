import 'package:flutter/material.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/game_board.dart';
import 'package:match_game/widgets/life_bar.dart';
import 'package:match_game/widgets/timer_bar.dart';

class FocusStageGameboard extends StatefulWidget {
  final FocusStage options;

  FocusStageGameboard({this.options});

  @override
  _FocusStageGameboardState createState() => _FocusStageGameboardState(options);
}

class _FocusStageGameboardState extends GameboardState {
  GlobalKey<TimerBarState> _timerKey = GlobalKey();

  FocusStage _options;
  int currentLives = 0;

  _FocusStageGameboardState(this._options);

  @override
  StageOptions get options => _options;

  @override
  void onPrestart() {
    currentLives = _options.startingLives;
    _timerKey.currentState.start(
      duration: _options.memorizeTime,
      onTime: () => status = GameStatus.playing,
    );
  }

  @override
  Widget buildHeader(BuildContext context) {
    return status == null || status == GameStatus.memorizing
        ? TimerBar(
            key: _timerKey,
            color: Colors.blueGrey,
          )
        : LifeBar(
            color: Colors.deepOrange,
            current: currentLives,
            max: _options.startingLives,
          );
  }

  @override
  void onMatchFailed() {
    setState(() {
      currentLives--;
    });
    if (currentLives <= 0) {
      status = GameStatus.gameOver;
    }
  }

  @override
  void onMatchFound(MatchTile tile) {}

  @override
  void onStart() {}

  @override
  void onPause() {
    _timerKey?.currentState?.stop();
  }

  @override
  void onResume() {
    _timerKey?.currentState?.resume();
  }

  @override
  void onCleared() async {
    await Future.delayed(Duration(milliseconds: 600));
    showStageClearedDialog();
  }

  @override
  void onGameOver() async {
    sendMessage(message: 'Out of lives!');
    await Future.delayed(Duration(milliseconds: 600));
    showGameOverDialog();
  }

  @override
  void onNextLevel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          board: FocusStageGameboard(
            options: Stages.focus[0],
          ),
        ),
      ),
    );
  }
}
