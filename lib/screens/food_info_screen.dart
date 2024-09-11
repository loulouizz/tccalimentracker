import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodInfoScreen extends StatefulWidget {
  final FoodModel foodModel;
  final bool isAdd;
  final String? mealId;


  FoodInfoScreen({
    required this.foodModel,
    required this.isAdd,
    required this.mealId,
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
    double amount = double.tryParse(amountText) ?? 100.0;
    double factor = amount / 100;

    double base100kcal = (100 * widget.foodModel.kcal) /
        (widget.foodModel.amount ?? 100.0);
    double base100protein = (100 * widget.foodModel.protein) /
        (widget.foodModel.amount ?? 100.0);
    double base100carbo = (100 * widget.foodModel.carbohydrate) /
        (widget.foodModel.amount ?? 100.0);
    double base100fat = (100 * widget.foodModel.fat) /
        (widget.foodModel.amount ?? 100.0);

    setState(() {
      _kcalEC.text = (base100kcal * factor).toStringAsFixed(2);
      _proteinEC.text = (base100protein * factor).toStringAsFixed(2);
      _carbEC.text = (base100carbo * factor).toStringAsFixed(2);
      _fatEC.text = (base100fat * factor).toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.isAdd && widget.foodModel.amount == null) {
      widget.foodModel.amount =
      100.0;
    }

    _amountEC.text = widget.foodModel.amount?.toString() ?? "100";
    _updateNutritionalValues(_amountEC.text);

    dropDownValueMeasures = measuresList[0];
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
                    onChanged: (value) {
                      _updateNutritionalValues(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: dropDownValueMeasures,
                    items: measuresList.map<DropdownMenuItem<String>>((
                        String value) {
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
            Navigator.of(context).pop();
          } else {
            if (widget.mealId != null) {
              Provider.of<MealProvider>(context, listen: false).updateFood(
                  foodData, widget.mealId!);
            }
            Navigator.of(context).pop(updatedFoodModel);
          }
        },
        label: Text(widget.isAdd ? "Adicionar" : "Atualizar"),
      ),
    );
  }
}