import 'package:flutter/material.dart';

class WeekDaysProvider with ChangeNotifier {
  final Map<String, bool> _selectedDays = {
    'Domingo': false,
    'Segunda': false,
    'Terça': false,
    'Quarta': false,
    'Quinta': false,
    'Sexta': false,
    'Sábado': false,
  };

  Map<String, bool> get selectedDays => _selectedDays;

  void toggleDay(String day) {
    _selectedDays[day] = !_selectedDays[day]!;
    notifyListeners();
  }

  List<String> get selectedDaysList =>
      _selectedDays.entries.where((e) => e.value).map((e) => e.key).toList();

  void clearSelection() {
    for (final key in _selectedDays.keys) {
      _selectedDays[key] = false;
    }
    notifyListeners();
  }
}
