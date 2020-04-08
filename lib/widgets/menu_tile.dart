import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuTile({Key key, this.label, this.icon, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, color: color, size: 72),
            SizedBox(height: 24),
            Text(label, style: textTheme.button),
          ],
        ),
      ),
    );
  }
}
