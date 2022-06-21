import 'package:flutter/material.dart';

class Missile extends StatelessWidget {
  final double missileX;
  final double missileHeight;

  Missile({required this.missileX, required this.missileHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 2,
        height: missileHeight,
        color: Colors.white38,
      ),
    );
  }
}
