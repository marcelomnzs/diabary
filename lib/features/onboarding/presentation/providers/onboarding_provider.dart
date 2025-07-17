import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _step = 0;
  DateTime? birthDate;
  String? gender;
  double? weight;
  String? diabetesType;
  String? diabetesDuration;
  bool usesMedication = false;
  List<Map<String, dynamic>> medications = [];
  String? otherConditions;

  // Getters
  int get step => _step;

  void nextStep() {
    if (_step < 5) {
      _step++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_step > 1) {
      _step--;
      notifyListeners();
    }
  }

  void reset() {
    _step = 0;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    birthDate = date;
    notifyListeners();
  }

  void setGender(String gen) {
    gender = gen;
    notifyListeners();
  }

  void setWeight(double w) {
    weight = w;
    notifyListeners();
  }

  void setPersonalInfo(DateTime birth, String gen, double w) {
    birthDate = birth;
    gender = gen;
    weight = w;
    notifyListeners();
  }

  void setDiabetesInfo(String type, String duration) {
    diabetesType = type;
    diabetesDuration = duration;
    notifyListeners();
  }

  void addMedication(Map<String, dynamic> med) {
    medications.add(med);
    usesMedication = true;
    notifyListeners();
  }

  void setOtherConditions(String cond) {
    otherConditions = cond;
    notifyListeners();
  }

  void clear() {
    birthDate = null;
    gender = null;
    weight = null;
    diabetesType = null;
    diabetesDuration = null;
    usesMedication = false;
    medications.clear();
    otherConditions = null;
    notifyListeners();
  }
}
