import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:match_game/models/data_value.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/settings_pane.dart';
import 'package:match_game/screens/timed_stage.dart';
import 'package:match_game/widgets/backdrop_dialog.dart';
import 'package:match_game/widgets/match_grid.dart';
import 'package:match_game/widgets/message_ticker.dart';
import 'package:match_game/widgets/scoreboard.dart';
import 'package:match_game/widgets/stage_indicator.dart';

class GameScreen extends StatelessWidget {
  final Widget board;

  const GameScreen({@required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: board,
      ),
    );
  }
}

enum GameStatus { memorizing, playing, cleared, gameOver }

abstract class GameboardState extends State<StatefulWidget> with WidgetsBindingObserver {
  GameStatus _status;
  int _score, _combo, _tries, _matches;
  bool isPaused = false;

  GlobalKey<MessageTickerState> _messageTickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _score = _combo = _tries = _matches = 0;
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds: 500), () {
      status = GameStatus.memorizing;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused && !isPaused) {
      _onGamePaused();
    } else if (state == AppLifecycleState.resumed && !isPaused) {
      _onGamePaused();
    }
  }

  StageOptions get options;

  void onPrestart();

  void onStart();

  void onPause();

  void onResume();

  void onCleared();

  void onGameOver();

  void onNextLevel();

  Widget buildHeader(BuildContext context);

  void onMatchFound(MatchTile tile);

  void onMatchFailed();

  GameStatus get status => _status;

  set status(GameStatus status) {
    setState(() {
      _status = status;
    });

    switch (status) {
      case GameStatus.memorizing:
        print('Status: Memorizing');
        sendMessage(message: 'Memorize...');
        onPrestart();
        break;
      case GameStatus.playing:
        print('Status: Started');
        sendMessage(message: 'Start!', holdDuration: Duration(milliseconds: 1000));
        onStart();
        break;
      case GameStatus.cleared:
        print('Status: Cleared');
        sendMessage(message: 'Cleared!');
        onCleared();
        break;
      case GameStatus.gameOver:
        print('Status: Game over');
        onGameOver();
        break;
    }
  }

  void sendMessage({String message, Duration holdDuration}) {
    _messageTickerKey.currentState.set(message: message, holdDuration: holdDuration);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onGamePaused();
        return false;
      },
      child: AnimatedOpacity(
        opacity: status == null ? 0 : 1,
        duration: Duration(milliseconds: 500),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.pause,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black38),
                onPressed: () {
                  if (status == GameStatus.memorizing || status == GameStatus.playing) {
                    _onGamePaused();
                  }
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    MessageTicker(
                      key: _messageTickerKey,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: buildHeader(context),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MatchGrid(
                    width: options.width,
                    height: options.height,
                    revealAll: status == GameStatus.memorizing,
                    enableFlip: status == GameStatus.playing,
                    gridGenerator: options.generator,
                    onPick: _onPick,
                    onCleared: () => status = GameStatus.cleared,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StageIndicator(
                      stage: options.level,
                    ),
                    Scoreboard(
                      value: currentTotalScore + _score,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onGamePaused() async {
    if (status != GameStatus.playing && status != GameStatus.memorizing) return;
    isPaused = true;
    onPause();

    await Navigator.push(
      context,
      BackdropDialog(
        title: 'Game paused',
        children: [
          SettingsPane(),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: [
              OutlineButton.icon(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                icon: Icon(Icons.play_arrow),
                label: Text('Resume'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              OutlineButton.icon(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                icon: Icon(Icons.close, color: Colors.red),
                label: Text('Quit game', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, false);
                },
              ),
            ],
          ),
        ],
      ),
    );
    isPaused = false;
    onResume();
  }

  void _onPick(bool isMatchFound, MatchTile tile) {
    _tries++;
    if (isMatchFound) {
      if (Settings.vibrationOn) HapticFeedback.mediumImpact();
      _combo++;
      _matches++;
      setState(() {
        _score += 100 + (_combo - 1) * 15;
      });
      if (_combo >= 2)
        _messageTickerKey.currentState.set(message: 'Combo ×$_combo', holdDuration: Duration(milliseconds: 600));
      else
        _messageTickerKey.currentState.set(message: 'Great!', holdDuration: Duration(milliseconds: 600));
      onMatchFound(tile);
    } else {
      _combo = 0;
      onMatchFailed();
    }
  }

  void showStageClearedDialog() {
    var _textTheme = Theme.of(context).textTheme;

    Navigator.push(
      context,
      BackdropDialog(
        title: 'Stage cleared!',
        children: [
          Text(
            'Score for this stage:',
            style: _textTheme.body1,
          ),
          SizedBox(height: 4),
          Text(
            '$_score',
            style: _textTheme.headline,
          ),
          SizedBox(height: 16),
          Text(
            'Total score:',
            style: _textTheme.body1,
          ),
          SizedBox(height: 4),
          Text(
            '${currentTotalScore + _score}',
            style: _textTheme.headline.copyWith(color: Theme.of(context).accentColor),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$_tries',
                  style: _textTheme.title,
                ),
                TextSpan(
                  text: '  tries with ',
                  style: _textTheme.body1,
                ),
                TextSpan(
                  text: '${(_matches * 100 / _tries).toStringAsFixed(1)}%',
                  style: _textTheme.title,
                ),
                TextSpan(
                  text: '  accuracy.',
                  style: _textTheme.body1,
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          WillPopScope(
            onWillPop: () async => false, // Prevent back key dismissing
            child: OutlineButton.icon(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              icon: Icon(Icons.fast_forward),
              label: Text('Next level'),
              onPressed: () {
                currentTotalScore += _score;
                currentStage++;
                Navigator.pop(context);
                onNextLevel();
              },
            ),
          ),
        ],
      ),
    );
  }

  void showGameOverDialog() {
    var _textTheme = Theme.of(context).textTheme;

    Navigator.push(
      context,
      BackdropDialog(
        title: 'Game over',
        children: [
          Text(
            'Total score:',
            style: _textTheme.body1,
          ),
          SizedBox(height: 4),
          Text(
            '${currentTotalScore + _score}',
            style: _textTheme.headline.copyWith(color: Theme.of(context).accentColor),
          ),
          SizedBox(height: 16),
          WillPopScope(
            onWillPop: () async {
              Navigator.pop(context); // Pop another level of route to go back to previous screen
              return true;
            },
            child: Wrap(
              spacing: 16,
              children: [
                OutlineButton.icon(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  icon: Icon(Icons.refresh),
                  label: Text('Start over'),
                  onPressed: () {
                    Navigator.pop(context); // Dismiss dialog
                    Navigator.pop(context, true); // Go to previous screen with needsRestart = true
                  },
                ),
                OutlineButton.icon(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  icon: Icon(Icons.close, color: Colors.red),
                  label: Text('Quit game', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context); // Dismiss dialog
                    Navigator.pop(context, false); // Go to previous screen with needsRestart = false
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
