import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _foods = [];
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<Map<String, dynamic>> get foods => _foods;

  void addFood(Map<String, dynamic> food) {
    _foods.add(food);
    notifyListeners();
  }

  void removeFood(int index) {
    if (index >= 0 && index < _foods.length) {
      _foods.removeAt(index);
      notifyListeners();
    }
  }

  void removeFoodByName(String name) {
    _foods.removeWhere((food) => food['nome'] == name);
    notifyListeners();
  }

  Future<void> updateFood(Map<String, dynamic> updatedFood, String mealId) async {
    try {
      DocumentSnapshot mealSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('meals')
          .doc(mealId)
          .get();

      if (mealSnapshot.exists) {
        Map<String, dynamic> mealData = mealSnapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(mealData['foods'] ?? []);

        final foodIndex = foods.indexWhere((food) => food['nome'] == updatedFood['nome']);
        if (foodIndex != -1) {
          foods[foodIndex] = updatedFood;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('meals')
              .doc(mealId)
              .update({'foods': foods});

          print('Food updated successfully in Firestore.');
        } else {
          print('Food not found in the meal.');
        }
      }
    } catch (e) {
      print('Error updating food in Firestore: $e');
    }

    notifyListeners();
  }

  void clearFoods() {
    _foods.clear();
    notifyListeners();
  }
}
