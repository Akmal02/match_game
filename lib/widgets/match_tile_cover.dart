import 'package:flutter/material.dart';

class MatchTileCover extends StatelessWidget {
  const MatchTileCover();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: CustomPaint(
        painter: Theme.of(context).brightness == Brightness.dark
            ? _MatchTileCoverDarkPainter()
            : _MatchTileCoverLightPainter(),
      ),
    );
  }
}

class _MatchTileCoverLightPainter extends CustomPainter {
  const _MatchTileCoverLightPainter();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey[350];

    // Rect from (0,0) to (width,height)
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = Colors.grey[400];

    var upperTriangle = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(upperTriangle, paint);

    var lowerTriangle = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(lowerTriangle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _MatchTileCoverDarkPainter extends CustomPainter {
  const _MatchTileCoverDarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey[600];

    // Rect from (0,0) to (width,height)
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = Colors.grey[700];

    var upperTriangle = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(upperTriangle, paint);

    var lowerTriangle = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();

    canvas.drawPath(lowerTriangle, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
