import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListScreen extends StatefulWidget {
  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Comidas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhuma comida encontrada.'));
          }

          final foodDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foodDocs.length,
            itemBuilder: (context, index) {
              final foodData = foodDocs[index].data() as Map<String, dynamic>;

              final nome = foodData['Nome'] ?? 'Nome não disponível';
              final calorias = _formatNumber(foodData['Calorias']);
              final proteinas = _formatNumber(foodData['Proteína']);
              final carboidratos = _formatNumber(foodData['Carboidratos']);
              final lipideos = _formatNumber(foodData['Lipídeos']);

              FoodModel foodModel = FoodModel(
                  name: nome,
                  kcal: double.parse(calorias),
                  protein: double.parse(proteinas),
                  carbohydrate: double.parse(carboidratos),
                  fat: double.parse(lipideos),
              );

              return ListTile(
                  title: Text(nome),
                  subtitle: Text(
                      'Calorias: $calorias\nProteínas: $proteinas g\nCarboidratos: $carboidratos g\nLipídeos: $lipideos g'),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            FoodInfoScreen(foodModel: foodModel, isAdd: true,)));
                  });
            },
          );
        },
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    } else {
      return value?.toString() ?? '0.00';
    }
  }
}
