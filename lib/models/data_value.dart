import 'package:shared_preferences/shared_preferences.dart';

int currentTotalScore = 0;
int currentStage = 0;

class Settings {
  static bool soundOn;
  static bool vibrationOn;

  static SharedPreferences prefs;

  static Future<void> load() async {
    prefs ??= await SharedPreferences.getInstance();
    soundOn = prefs.getBool('soundOn') ?? true;
    vibrationOn = prefs.getBool('vibrationOn') ?? true;
  }

  static Future<void> save() async {
    prefs ??= await SharedPreferences.getInstance();
    prefs.setBool('soundOn', soundOn ?? true);
    prefs.setBool('vibrationOn', vibrationOn ?? true);
  }
}
