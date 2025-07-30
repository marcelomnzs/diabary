import 'dart:convert';
import 'dart:io';

import 'package:diabary/domain/models/food_item.dart';
import 'package:diabary/domain/repositories/meal_repository.dart';
import 'package:flutter/material.dart';

class MealProvider extends ChangeNotifier {
  String? _userId;
  int _selectedIndex = 0;
  final List<FoodItem> _mealItems = [];
  bool _isLoading = false;
  String? _error;
  String? _mealPhotoBase64;
  final MealRepository _repository = MealRepository();

  int get selectedIndex => _selectedIndex;
  List<FoodItem> get mealItems => _mealItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get mealPhotoBase64 => _mealPhotoBase64;

  void setUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void setMealPhoyo(File photo) async {
    final bytes = await photo.readAsBytes();
    _mealPhotoBase64 = base64Encode(bytes);
    notifyListeners();
  }

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void addFoodItem(item) {
    _mealItems.add(item);
    notifyListeners();
  }

  void removeFoodItem(item) {
    _mealItems.remove(item);
    notifyListeners();
  }

  Future<void> saveMeal(meal) async {
    if (_userId == null) {
      return;
    }

    try {
      _setLoading(true);
      await _repository.saveMeal(meal, _userId!);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearMeal() {
    _mealItems.clear();
    notifyListeners();
  }

  String get selectedMealLabel {
    switch (_selectedIndex) {
      case 0:
        return 'Café da manhã';
      case 1:
        return 'Almoço';
      case 2:
        return 'Jantar';
      default:
        return '';
    }
  }
}
