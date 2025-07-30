import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabary/domain/models/meal.dart';

class MealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userMealsCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('meals');
  }

  Future<void> saveMeal(Meal meal, String userId) async {
    final mealsRef = _userMealsCollection(userId);
    await mealsRef.add(meal.toMap());
  }

  Future<List<Meal>> getMeals(String userId) async {
    final snapshot =
        await _userMealsCollection(
          userId,
        ).orderBy('date', descending: true).get();

    return snapshot.docs
        .map((doc) => Meal.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deleteMeal(String userId, String mealId) async {
    final docRef = _userMealsCollection(userId).doc(mealId);
    await docRef.delete();
  }
}
