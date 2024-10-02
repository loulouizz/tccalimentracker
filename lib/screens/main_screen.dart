import 'package:alimentracker/auth.dart';
import 'package:alimentracker/food_widget.dart';
import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/screens/add_meal_screen.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
import 'package:alimentracker/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String dayAndMonth = '';
  int _selectedIndex = 1;
  final User? user = Auth().currentUser;

  double dailyCalories = 0;
  double dailyProtein = 0;
  double dailyCarbs = 0;
  double dailyFat = 0;

  String _formatNumber(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    } else {
      return value?.toString() ?? '0.00';
    }
  }

  @override
  void initState() {
    super.initState();
    dayAndMonth = DateFormat('d/MM').format(DateTime.now());
    _loadUserNutritionalGoals();
  }

  Future<void> _loadUserNutritionalGoals() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          dailyCalories = userData['calories'] ?? 0;
          dailyProtein = userData['macronutrients']['Proteínas (g)'] ?? 0;
          dailyCarbs = userData['macronutrients']['Carboidratos (g)'] ?? 0;
          dailyFat = userData['macronutrients']['Gorduras (g)'] ?? 0;
        });
      }
    } catch (e) {
      print('Erro ao carregar metas nutricionais: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return Text(dayAndMonth);
  }

  Future<void> _editMeal(BuildContext context, DocumentSnapshot mealDoc) async {
    final mealData = mealDoc.data() as Map<String, dynamic>;
    final TextEditingController mealNameController =
    TextEditingController(text: mealData['nome']);
    final TextEditingController mealTimeController =
    TextEditingController(text: mealData['horário']);
    List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(mealData['foods'] ?? []);

    void _recalculateTotals() {
      double totalKcal = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;

      for (var food in foods) {
        totalKcal += food['kcal'];
        totalProtein += food['proteína'];
        totalCarbs += food['carboidrato'];
        totalFat += food['gordura'];
      }

      mealData['calorias'] = totalKcal;
      mealData['proteína'] = totalProtein;
      mealData['carboidrato'] = totalCarbs;
      mealData['gordura'] = totalFat;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Editar Refeição'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: mealNameController,
                      decoration: InputDecoration(labelText: 'Nome da Refeição'),
                    ),
                    TextField(
                      controller: mealTimeController,
                      decoration: InputDecoration(labelText: 'Horário'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: foods.isEmpty
                          ? Center(child: Text('Nenhum alimento adicionado.'))
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          final foodModel = FoodModel(
                            name: food['nome'] ?? 'Nome não disponível',
                            amount: food['quantidade'] ?? 0.0,
                            kcal: food['kcal'] ?? 0.0,
                            protein: food['proteína'] ?? 0.0,
                            carbohydrate: food['carboidrato'] ?? 0.0,
                            fat: food['gordura'] ?? 0.0,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FoodWidget(
                              mealId: mealDoc.id,
                              foodModel: foodModel,
                              onUpdate: (updatedFood) async {
                                final updatedFoodModel =
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodInfoScreen(
                                      foodModel: updatedFood,
                                      isAdd: false,
                                      mealId: mealDoc.id,
                                    ),
                                  ),
                                );
                                if (updatedFoodModel != null) {
                                  setState(() {
                                    foods[index] = {
                                      'nome': updatedFoodModel.name,
                                      'quantidade': updatedFoodModel.amount,
                                      'kcal': updatedFoodModel.kcal,
                                      'proteína': updatedFoodModel.protein,
                                      'carboidrato': updatedFoodModel.carbohydrate,
                                      'gordura': updatedFoodModel.fat,
                                    };
                                    _recalculateTotals();
                                  });
                                }
                              },
                              onDelete: () {
                                setState(() {
                                  foods.removeAt(index);
                                  _recalculateTotals();
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .collection('meals')
                            .doc(mealDoc.id)
                            .update({
                          'nome': mealNameController.text,
                          'horário': mealTimeController.text,
                          'foods': foods,
                          'calorias': mealData['calorias'],
                          'proteína': mealData['proteína'],
                          'carboidrato': mealData['carboidrato'],
                          'gordura': mealData['gordura'],
                        });

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Refeição atualizada com sucesso!')),
                        );
                      },
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

  }

  Future<void> _deleteMeal(BuildContext context, DocumentSnapshot mealDoc) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('meals')
          .doc(mealDoc.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refeição excluída com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir a refeição: $e')),
      );
    }
  }

  Widget mainPage() {
    final todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .collection('meals')
                .where('data', isEqualTo: todayDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar as refeições.'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    Text("0 / ${dailyCalories.toStringAsFixed(0)} Kcal", style: GoogleFonts.lato(fontSize: 48)),
                    _buildNutrientProgressBars(0, 0, 0),
                    Center(child: Text('Nenhuma refeição registrada para hoje.')),
                  ],
                );
              }

              final kcalSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['calorias'] as double?) ?? 0;
              })
                  .reduce((value, element) => value + element);

              final proteinSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['proteína'] as double?) ?? 0;
              })
                  .reduce((value, element) => value + element);

              final carbSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['carboidrato'] as double?) ?? 0;
              })
                  .reduce((value, element) => value + element);

              final fatSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['gordura'] as double?) ?? 0;
              })
                  .reduce((value, element) => value + element);

              return Column(
                children: [
                  Text("${kcalSum.toStringAsFixed(0)} / ${dailyCalories.toStringAsFixed(0)} Kcal",
                      style: GoogleFonts.lato(fontSize: 48)),
                  _buildNutrientProgressBars(proteinSum, carbSum, fatSum),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final mealDoc = snapshot.data!.docs[index];
                        final mealData = mealDoc.data() as Map<String, dynamic>;
                        final mealName = mealData['nome'] ?? 'Nome não disponível';
                        final mealTime = mealData['horário'] ?? 'Horário não disponível';
                        final kcal = mealData['calorias'] ?? 0.0;

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  _editMeal(context, mealDoc);
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  _deleteMeal(context, mealDoc);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            tileColor: Theme.of(context).colorScheme.primaryContainer,
                            title: Text(mealName),
                            subtitle: Text('Horário: $mealTime\nCalorias: ${kcal.toStringAsFixed(2)} kcal'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientProgressBars(double proteinSum, double carbSum, double fatSum) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProgressBar("Proteína", proteinSum, dailyProtein),
          SizedBox(height: 6),
          _buildProgressBar("Carboidrato", carbSum, dailyCarbs),
          SizedBox(height: 6),
          _buildProgressBar("Gordura", fatSum, dailyFat),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double currentAmount, double goalAmount) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text("${currentAmount.toStringAsFixed(2)} / ${goalAmount.toStringAsFixed(2)}g"),
            ],
          ),
        ),
        LinearPercentIndicator(
          barRadius: Radius.circular(60),
          lineHeight: 10,
          progressColor: Theme.of(context).colorScheme.primary,
          percent: (goalAmount > 0) ? (currentAmount / goalAmount).clamp(0.0, 1.0) : 0.0,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Placeholder(),
      mainPage(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _title(),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'goToAddMealScreenButton',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddMealScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: "Histórico",
            icon: Icon(Icons.calendar_month),
          ),
          BottomNavigationBarItem(
            label: "Início",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Perfil",
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

