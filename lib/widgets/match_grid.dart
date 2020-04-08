import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:match_game/models/grid_generator.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/widgets/match_tile_view.dart';

class MatchGrid extends StatefulWidget {
  final int width;
  final int height;
  final bool revealAll;
  final bool enableFlip;
  final VoidCallback onCleared;
  final Function(bool, MatchTile) onPick;
  final GridGenerator gridGenerator;

  const MatchGrid({
    @required this.width,
    @required this.height,
    this.revealAll = false,
    this.enableFlip = true,
    this.onCleared,
    this.onPick,
    this.gridGenerator,
  });

  @override
  _MatchGridState createState() => _MatchGridState();
}

class _MatchGridState extends State<MatchGrid> {
  List<MatchTile> grid;
  List<bool> isCleared;
  int firstPick, secondPick;
  int matchesFound = 0;
  int _size;

  @override
  void initState() {
    super.initState();
    _size = widget.width * widget.height;
    grid = widget.gridGenerator.generate(_size);
    isCleared = List.filled(_size, false, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enableFlip,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.width,
        ),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _size,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTapDown: (_) => _onTileTap(index),
            child: Padding(
              padding: widget.width >= 6 ? EdgeInsets.all(4.0) : EdgeInsets.all(6.0),
              child: MatchTileView(
                content: grid[index],
                flipped: widget.revealAll || index == firstPick || index == secondPick,
                hidden: isCleared[index],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTileTap(int index) {
    if (grid[index] == null || isCleared[index]) {
      return;
    }

    if (firstPick == null) {
      setState(() {
        return firstPick = index;
      });
    } else if (secondPick == null && index != firstPick) {
      setState(() {
        return secondPick = index;
      });

      var firstTile = grid[firstPick];
      var secondTile = grid[secondPick];

      if (firstTile == secondTile) {
        Future.delayed(Duration(milliseconds: 250), () {
          isCleared[firstPick] = isCleared[secondPick] = true;
          matchesFound++;
          widget.onPick(true, firstTile);
          setState(() {
            return firstPick = secondPick = null;
          });
          if (matchesFound >= _size ~/ 2) {
            widget.onCleared();
          }
        });
      } else {
        Future.delayed(Duration(milliseconds: 400), () {
          widget.onPick(false, null);
          setState(() {
            firstPick = secondPick = null;
          });
        });
      }
    }
  }
}
