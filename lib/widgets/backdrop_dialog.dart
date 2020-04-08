import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackdropDialog extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.1);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  final String title;
  final List<Widget> children;

  BackdropDialog({@required this.title, @required this.children});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SafeArea(
      child: Center(
        child: Material(
          elevation: 2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 32, top: 24, right: 32, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: animation.value * 7, sigmaY: animation.value * 7),
        child: child,
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
