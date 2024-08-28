import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListScreen extends StatefulWidget {
  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Comidas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar comida',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                final foodDocs = snapshot.data!.docs.where((doc) {
                  final foodData = doc.data() as Map<String, dynamic>;
                  final nome = (foodData['Nome'] ?? '').toString().toLowerCase();
                  return nome.contains(_searchQuery);
                }).toList();

                if (foodDocs.isEmpty) {
                  return Center(child: Text('Nenhuma comida corresponde à pesquisa.'));
                }

                return ListView.builder(
                  itemCount: foodDocs.length,
                  itemBuilder: (context, index) {
                    final foodData = foodDocs[index].data() as Map<String, dynamic>;

                    final nome = foodData['Nome'] ?? 'Nome não disponível';
                    final calorias = _safeParseDouble(foodData['Calorias']);
                    final proteinas = _safeParseDouble(foodData['Proteína']);
                    final carboidratos = _safeParseDouble(foodData['Carboidratos']);
                    final lipideos = _safeParseDouble(foodData['Lipídeos']);

                    FoodModel foodModel = FoodModel(
                      name: nome,
                      kcal: calorias,
                      protein: proteinas,
                      carbohydrate: carboidratos,
                      fat: lipideos,
                    );

                    return ListTile(
                      title: Text(nome),
                      subtitle: Text(
                        'Calorias: ${calorias.toStringAsFixed(2)}\n'
                            'Proteínas: ${proteinas.toStringAsFixed(2)} g\n'
                            'Carboidratos: ${carboidratos.toStringAsFixed(2)} g\n'
                            'Lipídeos: ${lipideos.toStringAsFixed(2)} g',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FoodInfoScreen(
                              foodModel: foodModel,
                              isAdd: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _safeParseDouble(dynamic value) {
    try {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return 0.0;
    }
  }
}
