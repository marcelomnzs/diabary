import 'package:diabary/domain/models/food_item.dart';

class Meal {
  final String? id;
  final List<FoodItem> items;
  final String category;
  final int totalCalories;
  final DateTime date;
  final String? photoBase64;

  Meal({
    this.id,
    required this.items,
    required this.category,
    required this.date,
    this.photoBase64,
  }) : totalCalories = _calculateTotalCalories(items);

  static int _calculateTotalCalories(List<FoodItem> items) {
    return items.fold(0, (sum, item) {
      final kcal =
          int.tryParse(item.calories.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return sum + kcal;
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'category': category,
      'totalCalories': totalCalories,
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'photoBase64': photoBase64,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map, String id) {
    return Meal(
      id: id,
      items: (map['items'] as List).map((e) => FoodItem.fromMap(e)).toList(),
      category: map['category'] ?? '',
      date: DateTime.parse(map['date']).toLocal(),
      photoBase64: map['photoBase64'],
    );
  }
}
