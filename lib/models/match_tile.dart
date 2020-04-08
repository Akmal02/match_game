import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  static final List<MatchTile> presets = [
    MatchTile(icon: Icons.favorite, color: Colors.red, background: Colors.pink[100]),
    MatchTile(icon: Icons.extension, color: Colors.purple[100], background: Colors.purple),
    MatchTile(icon: Icons.pets, color: Colors.lightGreen[100], background: Colors.green),
    MatchTile(icon: Icons.local_airport, color: Colors.lightBlue[500], background: Colors.lightBlue[50]),
    MatchTile(icon: Icons.monetization_on, color: Colors.deepOrange, background: Colors.yellow[400]),
    MatchTile(icon: Icons.cloud, color: Colors.white, background: Colors.lightBlue[200]),
    MatchTile(icon: Icons.directions_run, color: Colors.green[700], background: Colors.white),
    MatchTile(icon: Icons.audiotrack, color: Colors.orange[100], background: Colors.orange[600]),
    MatchTile(icon: Icons.thumb_up, color: Colors.blue[50], background: Colors.blue[600]),
    MatchTile(icon: Icons.local_pizza, color: Colors.yellow, background: Colors.lime[800]),
    MatchTile(icon: Icons.security, color: Colors.white, background: Colors.deepOrange),
    MatchTile(icon: Icons.ac_unit, color: Colors.white, background: Colors.blue[800]),
    MatchTile(icon: Icons.sentiment_satisfied, color: Colors.yellow[800], background: Colors.white),
    MatchTile(icon: Icons.local_florist, color: Colors.green, background: Colors.grey[200]),
    MatchTile(icon: Icons.vpn_key, color: Colors.deepOrange, background: Colors.grey[200]),
    MatchTile(icon: Icons.casino, color: Colors.white, background: Colors.blueGrey),
    MatchTile(icon: Icons.cake, color: Colors.white, background: Colors.pink[400]),
    MatchTile(icon: Icons.restaurant, color: Colors.white, background: Colors.lime[600]),
    MatchTile(icon: Icons.directions_bike, color: Colors.white, background: Colors.cyan),
    MatchTile(icon: Icons.iso, color: Colors.grey[700], background: Colors.grey[300]),
    MatchTile(icon: Icons.toys, color: Colors.yellow[300], background: Colors.lightBlue[600]),
    MatchTile(icon: Icons.stars, color: Colors.white, background: Colors.purpleAccent),
    MatchTile(icon: Icons.chat, color: Colors.pink[100], background: Colors.indigo),
    MatchTile(icon: Icons.attach_file, color: Colors.black54, background: Colors.grey[300]),
  ];

  static const timeBonus = TimeBonusTile();

  final IconData icon;
  final Color color;
  final Color background;

  const MatchTile({this.icon, this.color = Colors.white, this.background = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      elevation: 2,
      child: Icon(icon, color: color),
    );
  }
}

class TimeBonusTile extends MatchTile {
  const TimeBonusTile() : super(icon: Icons.timer, color: Colors.white, background: const Color(0xff424242));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      elevation: 2,
      child: Icon(icon, color: color),
    );
  }
}
