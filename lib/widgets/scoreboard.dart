import 'package:flutter/material.dart';

class Scoreboard extends StatelessWidget {
  final int value;

  const Scoreboard({this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Score:   '),
        AnimatedTickingNumberText(
          value,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}

class AnimatedTickingNumberText extends StatefulWidget {
  final int value;
  final TextStyle style;

  const AnimatedTickingNumberText(this.value, {this.style});

  @override
  _AnimatedTickingNumberTextState createState() => _AnimatedTickingNumberTextState();
}

class _AnimatedTickingNumberTextState extends State<AnimatedTickingNumberText> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _startAnimation(from: widget.value, to: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedTickingNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _startAnimation(from: oldWidget.value, to: widget.value);
  }

  void _startAnimation({@required int from, @required int to}) {
    _animation = IntTween(begin: from, end: to).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ));
    _animation.addListener(() => setState(() {}));
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_animation.value.toString(), style: widget.style);
  }
}
