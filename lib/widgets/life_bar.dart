import 'package:flutter/material.dart';

class LifeBar extends StatelessWidget {
  final Color color;
  final int current;
  final int max;

  const LifeBar({Key key, this.color, this.current, this.max}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < max; i++) ...[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: i < current ? color : color.withOpacity(0.15),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              height: 8,
            ),
          ),
          if (i < max - 1) ...[
            SizedBox(width: 8),
          ],
        ],
      ],
    );
  }
}
