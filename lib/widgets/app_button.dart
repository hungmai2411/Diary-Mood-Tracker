import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String textButton;
  final TextStyle? style;
  final Function() onTap;

  const AppButton({
    super.key,
    required this.textButton,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.selectedColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          textButton,
          style: style ??
              AppStyles.regular.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
