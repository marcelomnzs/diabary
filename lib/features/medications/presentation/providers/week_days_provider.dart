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

  List<String> get selectedDaysList =>
      _selectedDays.entries.where((e) => e.value).map((e) => e.key).toList();

  List<int> get selectedDaysListInts {
    final Map<String, int> mapDiaToInt = {
      'Segunda': 1,
      'Terça': 2,
      'Quarta': 3,
      'Quinta': 4,
      'Sexta': 5,
      'Sábado': 6,
      'Domingo': 7,
    };

    return _selectedDays.entries
        .where((e) => e.value)
        .map((e) => mapDiaToInt[e.key]!)
        .toList();
  }

  void toggleDay(String day) {
    _selectedDays[day] = !_selectedDays[day]!;
    notifyListeners();
  }

  void setSelectedDays(List<int> diasSemana) {
    // limpa tudo
    for (final k in _selectedDays.keys) {
      _selectedDays[k] = false;
    }

    final Map<int, String> mapIntToDia = {
      1: 'Segunda',
      2: 'Terça',
      3: 'Quarta',
      4: 'Quinta',
      5: 'Sexta',
      6: 'Sábado',
      7: 'Domingo',
    };

    for (final dia in diasSemana) {
      final nomeDia = mapIntToDia[dia];
      if (nomeDia != null) _selectedDays[nomeDia] = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    for (final key in _selectedDays.keys) {
      _selectedDays[key] = false;
    }
    notifyListeners();
  }
}
