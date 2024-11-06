import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, List<Map<String, dynamic>>>> fetchMeals() async {
    Map<String, List<Map<String, dynamic>>> mealsByDate = {};

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('meals')
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String date = data['data'];

        if (!mealsByDate.containsKey(date)) {
          mealsByDate[date] = [];
        }
        mealsByDate[date]!.add(data);
      }
    } catch (e) {
      print('Erro ao buscar refeições: $e');
    }

    return mealsByDate;
  }

  Widget _buildDayBarChart(List<Map<String, dynamic>> meals) {
    double totalCalories = 0.0;
    double totalCarbs = 0.0;
    double totalProteins = 0.0;

    for (var meal in meals) {
      totalCalories += meal['calorias'] ?? 0.0;
      totalCarbs += meal['carboidrato'] ?? 0.0;
      totalProteins += meal['proteína'] ?? 0.0;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: totalCarbs,
                    color: Colors.blue,
                    width: 5,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: totalProteins,
                    color: Colors.green,
                    width: 5,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: totalCalories / 100,
                    color: Colors.orange,
                    width: 5,
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              show: false,
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Refeições')),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma refeição encontrada.'));
          }

          final mealsByDate = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: mealsByDate.keys.length,
            itemBuilder: (context, index) {
              String date = mealsByDate.keys.elementAt(index);
              List<Map<String, dynamic>> meals = mealsByDate[date]!;

              return Column(
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: _buildDayBarChart(meals)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
