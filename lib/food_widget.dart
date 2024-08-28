import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class FoodWidget extends StatelessWidget {
  final FoodModel foodModel;

  const FoodWidget({
    Key? key,
    required this.foodModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final updatedFood = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodInfoScreen(foodModel: foodModel, isAdd: false,),
                ),
              );

              // Se o alimento foi editado e retornado, faz a atualização
              if (updatedFood != null && updatedFood is FoodModel) {
                Provider.of<MealProvider>(context, listen: false).updateFood({
                  'nome': updatedFood.name,
                  'quantidade': updatedFood.amount,
                  'kcal': updatedFood.kcal,
                  'proteína': updatedFood.protein,
                  'carboidrato': updatedFood.carbohydrate,
                  'gordura': updatedFood.fat,
                });
              }
            },
            icon: Icons.edit,
            backgroundColor: Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) {
              Provider.of<MealProvider>(context, listen: false).removeFoodByName(foodModel.name);
            },
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    foodModel.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${foodModel.kcal} kcal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Quantidade: ${foodModel.amount} g'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'P: ${foodModel.protein.toStringAsFixed(1)} g',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        'C: ${foodModel.carbohydrate.toStringAsFixed(1)} g',
                        style: TextStyle(color: Colors.brown[700]),
                      ),
                      Text(
                        'G: ${foodModel.fat.toStringAsFixed(1)} g',
                        style: TextStyle(color: Colors.yellow[800]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
