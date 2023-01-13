import 'package:cs214/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final child;
  double? height;
  EdgeInsets? margin;
  EdgeInsets? padding;
  Border? border;
  Color? color;

  Box({
    super.key,
    required this.child,
    this.height,
    this.margin,
    this.border,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.boxColor,
        borderRadius: BorderRadius.circular(10),
        border: border,
      ),
      child: child,
    );
  }
}
