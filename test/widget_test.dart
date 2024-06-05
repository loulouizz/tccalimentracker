import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/models/meal_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoodModel Tests', () {
    test('Create food instance', () {
      final food = FoodModel(
        name: 'Maçã',
        kcal: 52,
        protein: 0.3,
        carbohydrate: 14,
        fat: 0.2,
        fiber: 2.4,
        sodium: 1,
      );

      expect(food.name, 'Maçã');
      expect(food.kcal, 52);
      expect(food.protein, 0.3);
      expect(food.carbohydrate, 14);
      expect(food.fat, 0.2);
      expect(food.fiber, 2.4);
      expect(food.sodium, 1);
    });
  });

  group('MealModel Tests', () {
    test('Create meal instance', () {
      final foods = [
        FoodModel(
          name: 'Arroz',
          kcal: 130,
          protein: 2.7,
          carbohydrate: 28.2,
          fat: 0.3,
          fiber: 0.6,
          sodium: 1,
        ),
        FoodModel(
          name: 'Feijão',
          kcal: 100,
          protein: 5.4,
          carbohydrate: 17.6,
          fat: 0.8,
          fiber: 6.2,
          sodium: 1,
        ),
      ];

      final meal = MealModel(
        name: 'Almoço',
        time: DateTime.now(),
        foods: foods,
      );

      expect(meal.name, 'Almoço');
      expect(meal.time, isA<DateTime>());
      expect(meal.foods.length, 2);
      expect(meal.foods[0].name, 'Arroz');
      expect(meal.foods[1].name, 'Feijão');
    });
  });
}
