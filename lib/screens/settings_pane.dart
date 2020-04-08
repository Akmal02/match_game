import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:match_game/models/data_value.dart';

class SettingsPane extends StatefulWidget {
  @override
  _SettingsPaneState createState() => _SettingsPaneState();
}

class _SettingsPaneState extends State<SettingsPane> {
  @override
  Widget build(BuildContext context) {
    var nightModeOn = DynamicTheme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        ListTile(
          title: Text('Theme'),
          trailing: ToggleButtons(
            isSelected: [
              !nightModeOn,
              nightModeOn,
            ],
            children: [
              Icon(Icons.brightness_7),
              Icon(Icons.brightness_3),
            ],
            onPressed: (index) {
              setState(() {
                DynamicTheme.of(context).setBrightness(index == 0 ? Brightness.light : Brightness.dark);
              });
            },
          ),
        ),
        ListTile(
          title: Text('Sound'),
          leading: Icon(Icons.audiotrack),
          trailing: Switch(
            value: Settings.soundOn,
            onChanged: (value) {
              setState(() {
                Settings.soundOn = value;
                Settings.save();
              });
            },
          ),
        ),
        ListTile(
          title: Text('Vibration'),
          leading: Icon(Icons.vibration),
          trailing: Switch(
            value: Settings.vibrationOn,
            onChanged: (value) {
              setState(() {
                Settings.vibrationOn = value;
                Settings.save();
              });
            },
          ),
        ),
      ],
    );
  }
}
