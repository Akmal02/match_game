import 'dart:math';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:match_game/screens/main_menu.dart';
import 'package:match_game/widgets/fade_in_out_page_route.dart';

import 'models/data_value.dart';

final Random random = Random();
final Stopwatch stopwatch = Stopwatch();

void runAsync(Function function) => Future.delayed(Duration(milliseconds: 50), function);

void main() async {
  await Settings.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        accentColor: Colors.amber[700],
        brightness: brightness,
        fontFamily: 'Rubik',
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeInOutPageRoute(),
          TargetPlatform.iOS: FadeInOutPageRoute(),
        }),
      ),
      themedWidgetBuilder: (context, theme) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: null,
        home: MainMenuScreen(),
      ),
    );
  }
}
