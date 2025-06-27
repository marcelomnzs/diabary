import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;

  void setFocusedDay(DateTime newFocusedDay) {
    if (_focusedDay != newFocusedDay) {
      _focusedDay = newFocusedDay;
      notifyListeners();
    }
  }

  void setSelectedDay(DateTime newSelectedDay) {
    if (_selectedDay != newSelectedDay) {
      _selectedDay = newSelectedDay;
      notifyListeners();
    }
  }
}
