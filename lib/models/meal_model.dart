import 'package:alimentracker/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealModel {
  String name;
  DateTime time;
  List<FoodModel> foods;

  MealModel({
    required this.name,
    required this.time,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': Timestamp.fromDate(time),
      'foods': foods.map((food) => food.toJson()).toList(),
    };
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      name: json['name'],
      time: (json['time'] as Timestamp).toDate(),
      foods: (json['foods'] as List<dynamic>)
          .map((foodJson) => FoodModel.fromJson(foodJson))
          .toList(),
    );
  }
}