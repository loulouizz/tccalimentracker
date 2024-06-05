import 'package:alimentracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/food_model.dart';
import 'models/meal_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      home: FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para adicionar um novo alimento ao Firestore
  Future<void> addFood() async {
    try {
      // Cria um novo objeto FoodModel
      FoodModel food = FoodModel(
        name: 'Maçã',
        kcal: 52,
        protein: 0.3,
        carbohydrate: 14,
        fat: 0.2,
        fiber: 2.4,
        sodium: 1,
      );

      // Adiciona o alimento ao Firestore
      await _firestore.collection('foods').add(food.toJson());

      print('Food added to Firestore successfully!');
    } catch (e) {
      print('Error adding food to Firestore: $e');
    }
  }

  // Função para adicionar uma nova refeição ao Firestore
  Future<void> addMeal() async {
    try {
      // Cria uma lista de alimentos
      List<FoodModel> foods = [
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

      // Cria um novo objeto MealModel
      MealModel meal = MealModel(
        name: 'Almoço',
        time: DateTime.now(),
        foods: foods,
      );

      // Adiciona a refeição ao Firestore
      await _firestore.collection('meals').add(meal.toJson());

      print('Meal added to Firestore successfully!');
    } catch (e) {
      print('Error adding meal to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addFood,
              child: Text('Adicionar Alimento ao Firestore'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addMeal,
              child: Text('Adicionar Refeição ao Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
