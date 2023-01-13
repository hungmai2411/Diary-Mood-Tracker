import 'package:cs214/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final Widget child;

  const AppDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.boxColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}
