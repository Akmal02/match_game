import 'package:match_game/models/grid_generator.dart';

class StageOptions {
  final int level;
  final int width;
  final int height;
  final GridGenerator generator;

  const StageOptions({this.level, this.width, this.height, this.generator});
}

class Stages {
  static final timed = [
    TimedStage(
      level: 1,
      width: 4,
      height: 4,
      memorizeTime: Duration(seconds: 4),
      playTime: Duration(seconds: 10),
      generator: GridGenerator.standard,
    ),
    TimedStage(
      level: 2,
      width: 4,
      height: 5,
      memorizeTime: Duration(seconds: 7),
      playTime: Duration(seconds: 25),
      generator: GridGenerator.standard,
      timeCompensator: Duration(milliseconds: 500),
    ),
    TimedStage(
      level: 3,
      width: 5,
      height: 5,
      memorizeTime: Duration(seconds: 9),
      playTime: Duration(seconds: 32),
      generator: GridGenerator.withTimeBonus,
      timeCompensator: Duration(milliseconds: 500),
      addedTimeBonus: Duration(seconds: 5),
    ),
    TimedStage(
      level: 4,
      width: 5,
      height: 6,
      memorizeTime: Duration(seconds: 12),
      playTime: Duration(seconds: 42),
      generator: GridGenerator.withTimeBonus,
      timeCompensator: Duration(milliseconds: 800),
      addedTimeBonus: Duration(seconds: 8),
    ),
  ];

  static final focus = [
    FocusStage(
      level: 1,
      width: 4,
      height: 4,
      startingLives: 4,
      generator: GridGenerator.standard,
      memorizeTime: Duration(seconds: 15),
    )
  ];

  static final relax = [
    RelaxStage(
      level: 1,
      width: 6,
      height: 8,
      generator: GridGenerator.standard,
    )
  ];
}

class TimedStage extends StageOptions {
  final Duration memorizeTime;
  final Duration playTime;
  final Duration timeCompensator;
  final Duration addedTimeBonus;

  const TimedStage({
    int level,
    int width,
    int height,
    GridGenerator generator,
    this.memorizeTime,
    this.playTime,
    this.addedTimeBonus = Duration.zero,
    this.timeCompensator = Duration.zero,
  }) : super(
          level: level,
          width: width,
          height: height,
          generator: generator,
        );
}

class FocusStage extends StageOptions {
  final Duration memorizeTime;
  final int startingLives;

  const FocusStage({
    int level,
    int width,
    int height,
    GridGenerator generator,
    this.memorizeTime,
    this.startingLives,
  }) : super(
          level: level,
          width: width,
          height: height,
          generator: generator,
        );
}

class RelaxStage extends StageOptions {
  const RelaxStage({
    int level,
    int width,
    int height,
    GridGenerator generator,
  }) : super(
          level: level,
          width: width,
          height: height,
          generator: generator,
        );
}
