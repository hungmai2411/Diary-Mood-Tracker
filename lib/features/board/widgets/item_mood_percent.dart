import 'package:flutter/material.dart';

class ItemMoodPercent extends StatelessWidget {
  final int flex;
  final Color color;
  final BorderRadiusGeometry? radius;
  const ItemMoodPercent({
    super.key,
    required this.flex,
    required this.color,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
        ),
      ),
    );
  }
}
