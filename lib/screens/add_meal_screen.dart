import 'package:alimentracker/food_widget.dart';
import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_list_screen.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  Future<void> _addFood(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodListScreen(),
      ),
    );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
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
                        decoration: const InputDecoration(
                          labelText: "Horário",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.timer_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Expanding ListView.builder
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
              SizedBox(height: 10,),
              FloatingActionButton.extended(
                onPressed: (){},
                icon: const Icon(Icons.done),
                label: const Text("Salvar refeição"),
              ),
            ],
          ),
      )
    );
  }
}
