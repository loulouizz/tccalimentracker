import 'package:alimentracker/food_widget.dart';
import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_list_screen.dart';
import 'package:intl/intl.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _addFood(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodListScreen(),
      ),
    );
  }

  Future<void> _saveMeal(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final mealName = _mealNameController.text;
    final mealTime = _timeController.text;
    final mealDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    double totalKcal = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var food in mealProvider.foods) {
      totalKcal += food['kcal'];
      totalProtein += food['proteína'];
      totalCarbs += food['carboidrato'];
      totalFat += food['gordura'];
    }

    final mealData = {
      'nome': mealName,
      'data': mealDate,
      'horário': mealTime,
      'calorias': totalKcal,
      'proteína': totalProtein,
      'carboidrato': totalCarbs,
      'gordura': totalFat,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('meals')
          .add(mealData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refeição salva com sucesso!')),
      );

      _mealNameController.clear();
      _timeController.clear();
      mealProvider.clearFoods();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar refeição: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar refeição"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _mealNameController,
                  decoration: const InputDecoration(
                    labelText: "Nome da refeição",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O nome da refeição é obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: "Horário",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O horário é obrigatório";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _timeController.text = pickedTime.format(context);
                          });
                        }
                      },
                      icon: const Icon(Icons.timer_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: mealProvider.foods.length,
                    itemBuilder: (context, index) {
                      final food = mealProvider.foods[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: FoodWidget(
                          foodModel: FoodModel(
                            name: food['nome'],
                            amount: food['quantidade'],
                            kcal: food['kcal'],
                            protein: food['proteína'],
                            carbohydrate: food['carboidrato'],
                            fat: food['gordura'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () => _addFood(context),
              icon: const Icon(Icons.add),
              label: const Text("Adicionar Alimentos"),
            ),
            SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () => _saveMeal(context),
              icon: const Icon(Icons.done),
              label: const Text("Salvar refeição"),
            ),
          ],
        ),
      ),
    );
  }
}
