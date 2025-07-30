import 'dart:convert';
import 'package:diabary/domain/models/food_item.dart';
import 'package:diabary/domain/models/meal.dart';
import 'package:diabary/domain/repositories/meal_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MealProvider extends ChangeNotifier {
  String? _userId;
  int _selectedIndex = 0;
  final List<FoodItem> _mealItems = [];
  List<Meal> _userMeals = [];
  bool _isLoading = false;
  String? _error;
  String? _mealPhotoBase64;
  final MealRepository _repository = MealRepository();

  int get selectedIndex => _selectedIndex;
  List<FoodItem> get mealItems => _mealItems;
  List<Meal> get userMeals => _userMeals;
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

  void setMealPhoto(XFile? photo) async {
    if (photo == null) {
      return;
    }

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

  Future<void> fetchUserMeals() async {
    if (_userId == null) {
      return;
    }

    try {
      _setLoading(true);
      _userMeals = await _repository.getMeals(_userId!);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  List<Meal> getMealsForLast30Days() {
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    return _userMeals.where((meal) {
      return meal.date.isAfter(last30Days) && meal.date.isBefore(now);
    }).toList();
  }

  Map<DateTime, int> getDailyCaloriesForChart() {
    final meals = getMealsForLast30Days();

    final Map<DateTime, int> caloriesPerDay = {};

    for (var meal in meals) {
      // Usa apenas a data (sem hora)
      final dateOnly = DateTime(meal.date.year, meal.date.month, meal.date.day);

      caloriesPerDay.update(
        dateOnly,
        (value) => value + meal.totalCalories,
        ifAbsent: () => meal.totalCalories,
      );
    }

    return caloriesPerDay;
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
