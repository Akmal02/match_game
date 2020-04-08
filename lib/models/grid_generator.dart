import 'package:match_game/models/match_tile.dart';

class GridGenerator {
  final List<MatchTile> Function(int size) builder;

  const GridGenerator({this.builder});

  List<MatchTile> generate(int size) {
    var list = builder(size);
    assert(list.length == size);
    return list;
  }

  static final standard = GridGenerator(
    builder: (size) {
      var tilePairs = MatchTile.presets
        ..shuffle()
        ..take(size ~/ 2);
      return List.generate(size, (index) => tilePairs[index ~/ 2], growable: false)..shuffle();
    },
  );

  static final withTimeBonus = GridGenerator(
    builder: (size) {
      var tilePairs = MatchTile.presets
        ..shuffle()
        ..take(size ~/ 2);
      return List.generate(size, (index) => index >= size - 2 ? MatchTile.timeBonus : tilePairs[index ~/ 2],
          growable: false)
        ..shuffle();
    },
  );
}
