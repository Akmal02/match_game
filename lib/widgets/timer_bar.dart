import 'package:flutter/material.dart';

class TimerBar extends StatefulWidget {
  final Color color;

  const TimerBar({Key key, this.color = Colors.black}) : super(key: key);

  @override
  TimerBarState createState() => TimerBarState();
}

class TimerBarState extends State<TimerBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _isMoving = false;
  VoidCallback onTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (onTime != null) onTime();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start({@required Duration duration, @required VoidCallback onTime}) {
    this.onTime = onTime;
    _controller.duration = duration;
    _controller.forward();
    _isMoving = true;
  }

  void resume() {
    _controller.forward();
    _isMoving = true;
  }

  void stop() {
    _controller.stop();
    _isMoving = false;
  }

  void add(Duration duration) {
    var timeFraction = duration.inMicroseconds / _controller.duration.inMicroseconds;
    if (_controller.status != AnimationStatus.completed) _controller.forward(from: _controller.value - timeFraction);
  }

  void reset() {
    _controller.reset();
    _isMoving = false;
  }

  bool get isMoving => _isMoving;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => LinearProgressIndicator(
            value: 1.0 - _controller.value,
            backgroundColor: widget.color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(widget.color),
          ),
        ),
      ),
    );
  }
}
