import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  final Color kcalBarColor = Colors.red;
  final Color proteinBarColor = Colors.blue;
  final Color carbBarColor = Colors.brown;
  final Color fatBarColor = Colors.yellow;
  final Color avgColor = Colors.green;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups = [];
  late List<BarChartGroupData> showingBarGroups = [];
  late List<String> daysLabels = [];
  int touchedGroupIndex = -1;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final uid = _auth.currentUser?.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtém a data de hoje e calcula os últimos 7 dias
    DateTime today = DateTime.now();
    List<DateTime> last7Days = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));

    // Formata as datas para 'dd/MM/yyyy'
    List<String> formattedLast7Days = last7Days.map((date) => DateFormat('dd/MM/yyyy').format(date)).toList();

    // Consulta Firestore para buscar refeições dos últimos 7 dias
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .where('data', whereIn: formattedLast7Days)
        .get();

    // Mapeia os documentos de refeições em um mapa de data -> valores
    Map<String, Map<String, dynamic>> mealsMap = {
      for (var date in formattedLast7Days) date: {'calorias': 0.0, 'proteína': 0.0, 'carboidrato': 0.0, 'gordura': 0.0}
    };

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String date = data['data'];
      mealsMap[date] = {
        'calorias': data['calorias']?.toDouble() ?? 0.0,
        'proteína': data['proteína']?.toDouble() ?? 0.0,
        'carboidrato': data['carboidrato']?.toDouble() ?? 0.0,
        'gordura': data['gordura']?.toDouble() ?? 0.0,
      };
    }

    List<BarChartGroupData> barGroups = [];
    List<String> labels = [];

    // Cria o gráfico para cada um dos últimos 7 dias
    for (int i = 0; i < last7Days.length; i++) {
      String formattedDate = formattedLast7Days[i];
      double calorias = mealsMap[formattedDate]?['calorias'] ?? 0;
      double proteina = mealsMap[formattedDate]?['proteína'] ?? 0;
      double carboidrato = mealsMap[formattedDate]?['carboidrato'] ?? 0;
      double gordura = mealsMap[formattedDate]?['gordura'] ?? 0;

      barGroups.add(makeGroupData(i, calorias, proteina, carboidrato, gordura));
      labels.add(formattedDate);
    }

    setState(() {
      rawBarGroups = barGroups;
      showingBarGroups = rawBarGroups;
      daysLabels = labels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(
                  width: 38,
                ),
                const Text(
                  'Histórico de refeições',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 5000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.grey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String value = rod.toY.toStringAsFixed(0);
                        return BarTooltipItem(
                          '$value',
                          TextStyle(
                            color: rod.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                      });
                    },
                  ),

                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1000,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 2000) {
      text = '2k';
    } else if (value == 5000) {
      text = '5k';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < daysLabels.length) {
      String dateLabel = daysLabels[index].substring(0, 5);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(
          dateLabel,
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3, double y4) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: widget.kcalBarColor, width: width),
        BarChartRodData(toY: y2, color: widget.proteinBarColor, width: width),
        BarChartRodData(toY: y3, color: widget.carbBarColor, width: width),
        BarChartRodData(toY: y4, color: widget.fatBarColor, width: width),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: width, height: 10, color: Colors.white.withOpacity(0.4)),
        const SizedBox(width: space),
        Container(width: width, height: 28, color: Colors.white.withOpacity(0.8)),
        const SizedBox(width: space),
        Container(width: width, height: 10, color: Colors.white.withOpacity(0.4)),
      ],
    );
  }
}
