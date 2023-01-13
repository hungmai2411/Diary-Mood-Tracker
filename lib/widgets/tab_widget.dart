import 'package:cs214/constants/app_styles.dart';
import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  final String name;
  final Color color;
  final IconData iconData;
  final Function() onPressed;
  const TabWidget({
    super.key,
    required this.name,
    required this.color,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 16,
            color: color,
          ),
          Text(
            name,
            style: AppStyles.regular.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
