import 'package:flutter/material.dart';
import 'package:match_game/models/data_value.dart';
import 'package:match_game/models/stage_option.dart';
import 'package:match_game/screens/focus_stage.dart';
import 'package:match_game/screens/game_board.dart';
import 'package:match_game/screens/relax_stage.dart';
import 'package:match_game/screens/settings_pane.dart';
import 'package:match_game/screens/timed_stage.dart';
import 'package:match_game/widgets/backdrop_dialog.dart';
import 'package:match_game/widgets/menu_tile.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Match game', style: textTheme.headline5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuTile(
                  label: 'Timed',
                  icon: Icons.timer,
                  color: Colors.blue,
                  onTap: _startTimed,
                ),
                MenuTile(
                  label: 'Focus',
                  icon: Icons.opacity,
                  color: Colors.red,
                  onTap: _startFocus,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuTile(
                  label: 'Relax',
                  icon: Icons.accessibility,
                  color: Colors.lightGreen,
                  onTap: _startRelax,
                ),
                MenuTile(
                  label: 'Options',
                  icon: Icons.settings,
                  color: Colors.blueGrey,
                  onTap: _options,
                ),
              ],
            ),
            Center(child: Text('© 2020', style: textTheme.caption)),
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
