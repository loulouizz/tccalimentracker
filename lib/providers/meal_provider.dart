import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _foods = [];

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

  void updateFood(Map<String, dynamic> updatedFood) {
    final index = _foods.indexWhere((food) => food['nome'] == updatedFood['nome']);
    if (index != -1) {
      _foods[index] = updatedFood;
      notifyListeners();
    }
  }
}
