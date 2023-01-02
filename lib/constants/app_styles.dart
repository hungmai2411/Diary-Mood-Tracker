import 'package:cs214/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FontFamily {
  static const monsterat = 'Montserrat';
}

class AppStyles {
  static TextStyle medium = TextStyle(
    fontFamily: FontFamily.monsterat,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryColor,
  );
  static TextStyle regular = TextStyle(
    fontFamily: FontFamily.monsterat,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryColor,
  );
  static TextStyle bold = TextStyle(
    fontFamily: FontFamily.monsterat,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryColor,
  );

  static TextStyle semibold = TextStyle(
    fontFamily: FontFamily.monsterat,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
  );
}
