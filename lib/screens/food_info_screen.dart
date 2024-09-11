import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodInfoScreen extends StatefulWidget {
  final FoodModel foodModel;
  final bool isAdd;
  final String? mealId;

  // Ensure mealId is correctly assigned when FoodInfoScreen is instantiated
  FoodInfoScreen({
    required this.foodModel,
    required this.isAdd,
    required this.mealId, // Ensure mealId is marked as required if it must not be null
    super.key,
  });

  @override
  State<FoodInfoScreen> createState() => _FoodInfoScreenState();
}

class _FoodInfoScreenState extends State<FoodInfoScreen> {
  TextEditingController _amountEC = TextEditingController();
  TextEditingController _kcalEC = TextEditingController();
  TextEditingController _proteinEC = TextEditingController();
  TextEditingController _carbEC = TextEditingController();
  TextEditingController _fatEC = TextEditingController();

  late String dropDownValueMeasures;

  List<String> measuresList = ["gramas (g)", ""];

  void _updateNutritionalValues(String amountText) {
    final amount = double.tryParse(amountText) ?? 100.0;
    final factor = amount / 100;

    setState(() {
      _kcalEC.text = (widget.foodModel.kcal * factor).toStringAsFixed(2);
      _proteinEC.text = (widget.foodModel.protein * factor).toStringAsFixed(2);
      _carbEC.text = (widget.foodModel.carbohydrate * factor).toStringAsFixed(2);
      _fatEC.text = (widget.foodModel.fat * factor).toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    _amountEC.text = widget.foodModel.amount?.toString() ?? "100";
    _kcalEC.text = widget.foodModel.kcal.toString();
    _proteinEC.text = widget.foodModel.protein.toString();
    _carbEC.text = widget.foodModel.carbohydrate.toString();
    _fatEC.text = widget.foodModel.fat.toString();

    dropDownValueMeasures = measuresList[0];
    print("Received mealId in FoodInfoScreen: ${widget.mealId}");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do alimento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.foodModel.name,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(labelText: "Quantidade"),
                    onChanged: _updateNutritionalValues,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: dropDownValueMeasures,
                    items: measuresList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropDownValueMeasures = value!;
                      });
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    controller: _kcalEC,
                    decoration: InputDecoration(labelText: "Kcal"),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    controller: _proteinEC,
                    decoration: InputDecoration(labelText: "Prot"),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    controller: _carbEC,
                    decoration: InputDecoration(labelText: "Carb"),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    readOnly: true,
                    controller: _fatEC,
                    decoration: InputDecoration(labelText: "Gord"),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(widget.isAdd ? Icons.add : Icons.refresh),
        onPressed: () {
          final foodData = {
            'nome': widget.foodModel.name,
            'quantidade': double.tryParse(_amountEC.text) ?? 100.0,
            'kcal': double.tryParse(_kcalEC.text) ?? 0.0,
            'proteína': double.tryParse(_proteinEC.text) ?? 0.0,
            'carboidrato': double.tryParse(_carbEC.text) ?? 0.0,
            'gordura': double.tryParse(_fatEC.text) ?? 0.0,
          };

          final updatedFoodModel = FoodModel(
            name: foodData['nome'].toString(),
            amount: double.parse(foodData['quantidade'].toString()),
            kcal: double.parse(foodData['kcal'].toString()),
            protein: double.parse(foodData['proteína'].toString()),
            carbohydrate: double.parse(foodData['carboidrato'].toString()),
            fat: double.parse(foodData['gordura'].toString()),
          );

          if (widget.isAdd) {
            Provider.of<MealProvider>(context, listen: false).addFood(foodData);
            Navigator.of(context).pop(updatedFoodModel);
          } else {
            if (widget.mealId != null) {
              Provider.of<MealProvider>(context, listen: false).updateFood(foodData, widget.mealId!);
            }
            Navigator.of(context).pop(updatedFoodModel);
          }
        },
        label: Text(widget.isAdd ? "Adicionar" : "Atualizar"),
      ),

    );
  }
}

