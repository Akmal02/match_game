import 'package:flutter/material.dart';

class MessageTicker extends StatefulWidget {
  MessageTicker({Key key}) : super(key: key);

  @override
  MessageTickerState createState() => MessageTickerState();
}

class MessageTickerState extends State<MessageTicker> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _message;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void set({@required String message, Duration holdDuration}) async {
//    if (_controller.status != AnimationStatus.reverse) {
//      await _controller.animateBack(0, duration: Duration(milliseconds: 200));
//    }
    setState(() {
      this._message = message;
    });

    _controller.animateTo(1, duration: Duration(milliseconds: 200));
    if (holdDuration != null) {
      await Future.delayed(holdDuration);
      if (mounted && this._message == message) {
        _controller.animateBack(0, duration: Duration(milliseconds: 500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        _message ?? '',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
