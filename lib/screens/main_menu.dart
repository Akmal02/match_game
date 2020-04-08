import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:match_game/models/data_value.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/focus_stage.dart';
import 'package:match_game/screens/game_board.dart';
import 'package:match_game/screens/relax_stage.dart';
import 'package:match_game/screens/settings_pane.dart';
import 'package:match_game/screens/timed_stage.dart';
import 'package:match_game/widgets/backdrop_dialog.dart';
import 'package:match_game/widgets/life_bar.dart';
import 'package:match_game/widgets/timer_bar.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: _startTimed,
              child: Text('Start timed stage'),
            ),
            RaisedButton(
              onPressed: _startFocus,
              child: Text('Start focus stage'),
            ),
            RaisedButton(
              onPressed: _startRelax,
              child: Text('Start relax stage'),
            ),
            RaisedButton(
              onPressed: _options,
              child: Text('Options'),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimed() async {
    bool needsRestart;
    do {
      currentStage = 0;
      currentTotalScore = 0;
      needsRestart = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(
                  board: TimedStageGameboard(
                    options: Stages.timed[0],
                  ),
                ),
              )) ??
          false;
    } while (needsRestart);
  }

  void _startFocus() async {
    bool needsRestart;
    do {
      currentStage = 0;
      currentTotalScore = 0;
      needsRestart = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(
                  board: FocusStageGameboard(
                    options: Stages.focus[0],
                  ),
                ),
              )) ??
          false;
    } while (needsRestart);
  }

  void _startRelax() async {
    bool needsRestart;
    do {
      currentStage = 0;
      currentTotalScore = 0;
      needsRestart = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(
                  board: RelaxStageGameboard(
                    options: Stages.relax[0],
                  ),
                ),
              )) ??
          false;
    } while (needsRestart);
  }

  void _options() {
    var _textTheme = Theme.of(context).textTheme;

    Navigator.push(
      context,
      BackdropDialog(
        title: 'Options',
        children: [
          SettingsPane(),
          SizedBox(height: 16),
          OutlineButton.icon(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            icon: Icon(Icons.check),
            label: Text('Done'),
            onPressed: () {
              Navigator.pop(context); // Dismiss dialog
            },
          ),
        ],
      ),
    );
  }
}
