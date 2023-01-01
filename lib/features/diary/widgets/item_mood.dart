import 'package:flutter/material.dart';

class ItemMood extends StatelessWidget {
  final String mood;
  final String moodName;
  final bool isPicked;
  final Function(String) callback;

  const ItemMood({
    super.key,
    required this.mood,
    required this.isPicked,
    required this.callback,
    required this.moodName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(moodName),
      child: Opacity(
        opacity: isPicked ? 1 : 0.3,
        child: Image.asset(
          mood,
          width: 70,
          height: 70,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
