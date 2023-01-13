import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  void setDay(DateTime day) {
    _selectedDay = day;
    _focusedDay = day;
    notifyListeners();
  }
}
