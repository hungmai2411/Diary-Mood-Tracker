import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color(0xff197FC0);
  static Color backgroundColor = const Color(0xFFEBF4FB);
  static Color todayColor = const Color(0xFF5EC0FE);
  static Color selectedColor = const Color(0xFF2699E2);
  static Color trackSelectedColor = const Color(0xFFA7DDFF);
  static Color trackUnSelectedColor = const Color(0xFFCFE1EB);
  static Color thumUnSelectedColor = const Color(0xFFA5C0D1);
  static Color appbarColor = const Color(0xFFDBEDF9);

  static Color textPrimaryColor = const Color(0xFF1D1E2C);
  static Color textSecondaryColor = const Color(0xFF4E687A);
  static Color deleteColor = const Color(0xFFFF5252);
  static Color orange = const Color(0xFFFE9F10);
  static Color unNote = const Color(0xFFCFE1EB);
  static Color textSecondColor = const Color(0xFFB2B2B2);

  static Color mood1 = const Color(0xFFEEDB87);
  static Color mood2 = const Color(0xFFB8D68A);
  static Color mood3 = const Color(0xFF60AE72);
  static Color mood4 = const Color(0xFF3B7751);
  static Color mood5 = const Color(0xFF6B7672);

  static Color moodBarEmptyPrimary = const Color(0xFFEEEEEE);
  static Color moodBarEmptySecondary = const Color(0xFFB6B6B5);
  static Color backgroundShareScreen = const Color(0xFF707070);
  static Color boxColor = Colors.white;
  static Color bottomBarColor = Colors.white;
  static Color chartColor = Colors.white;
  static Color calendarColor = Colors.white;
  static Color calendarHeaderColor = const Color(0xFF2699E2);

  static void changeTheme(String background) {
    switch (background) {
      // Black Theme.
      case 'Dark mode':
        backgroundColor = const Color(0xFF20232A);
        boxColor = const Color(0xFF2B2F3A);
        textPrimaryColor = const Color(0xFFE2E2E2);
        bottomBarColor = const Color(0xFF2B2F3A);
        chartColor = const Color(0xFF2E2E2E);
        appbarColor = const Color(0xFF2B2F3A);
        calendarColor = const Color(0xFF414141);
        calendarHeaderColor = const Color(0xFF2B2F3A);
        break;

      // White Theme.
      case 'Light mode':
        backgroundColor = const Color(0xFFEBF4FB);
        boxColor = Colors.white;
        textPrimaryColor = const Color(0xFF1D1E2C);
        bottomBarColor = Colors.white;
        chartColor = Colors.white;
        appbarColor = const Color(0xFFDBEDF9);
        calendarHeaderColor = const Color(0xFF2699E2);
        calendarColor = Colors.white;
        break;
    }
  }
}
