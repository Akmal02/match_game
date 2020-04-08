import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:match_game/main.dart';
import 'package:match_game/models/match_tile.dart';
import 'package:match_game/widgets/match_tile_cover.dart';

class MatchTileView extends StatefulWidget {
  final MatchTile content;
  final bool flipped;
  final bool hidden;

  MatchTileView({@required this.content, this.flipped = false, this.hidden = false});

  @override
  _MatchTileViewState createState() => _MatchTileViewState();
}

class _MatchTileViewState extends State<MatchTileView> with TickerProviderStateMixin {
  AnimationController _flipAnimation;
  AnimationController _hideAnimation;

  @override
  void initState() {
    super.initState();
    _flipAnimation = AnimationController(vsync: this);
    _hideAnimation = AnimationController(vsync: this);
    _animateFlipping();
  }

  @override
  void dispose() {
    _flipAnimation.dispose();
    _hideAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MatchTileView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate only when the flipped property changes
    if (widget.hidden != oldWidget.hidden) {
      _animateHiding();
    }
    if (widget.flipped != oldWidget.flipped && !widget.hidden) {
      _animateFlipping();
    }
  }

  void _animateFlipping() {
    if (widget.flipped) {
      _flipAnimation.animateTo(1, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCirc);
    } else {
      Future.delayed(Duration(milliseconds: random.nextInt(150)), () {
        _flipAnimation.animateBack(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOutCirc);
      });
    }
  }

  void _animateHiding() {
    if (widget.hidden) {
      _hideAnimation.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      _hideAnimation.animateBack(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hideAnimation,
      builder: (context, child) => Transform(
        transform: Matrix4.identity()
          ..rotateZ(_hideAnimation.value * math.pi * 1.5)
          ..scale(1 - _hideAnimation.value),
        alignment: Alignment.center,
        child: child,
      ),
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) => Transform(
          // Scale only on x axis from (1 to 0 and back to 1).
          transform: Matrix4.diagonal3Values((_flipAnimation.value * 2 - 1).abs(), 1, 1),
          alignment: Alignment.center,
          // In the midpoint of the animation, change the content to simulate a flip.
          child: _flipAnimation.value > 0.5 ? widget.content : const MatchTileCover(),
        ),
      ),
    );
  }
}
