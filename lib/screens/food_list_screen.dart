import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodListScreen extends StatelessWidget {
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
              final proteinas = _formatNumber(foodData['Proteínas']);
              final carboidratos = _formatNumber(foodData['Carboidratos']);
              final lipideos = _formatNumber(foodData['Lipídeos']);

              return ListTile(
                title: Text(nome),
                subtitle: Text(
                    'Calorias: $calorias\nProteínas: $proteinas g\nCarboidratos: $carboidratos g\nLipídeos: $lipideos g'),
                isThreeLine: true,
              );
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
