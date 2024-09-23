import 'package:alimentracker/auth.dart';
import 'package:alimentracker/food_widget.dart';
import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/screens/add_meal_screen.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
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
                    // Foods ListView
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
                return Center(
                    child: Text('Nenhuma refeição registrada para hoje.'));
              }

              final kcalSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['calorias'] as num?) ?? 0;
              }).reduce((value, element) => value + element);

              final proteinSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['proteína'] as num?) ?? 0;
              }).reduce((value, element) => value + element);

              final carbSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['carboidrato'] as num?) ?? 0;
              }).reduce((value, element) => value + element);

              final fatSum = snapshot.data!.docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['gordura'] as num?) ?? 0;
              }).reduce((value, element) => value + element);


              final meals = snapshot.data!.docs;

              return Column(
                children: [
                  Text("${kcalSum.toStringAsFixed(0)} / Kcal", style: GoogleFonts.lato(),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Proteína"),
                                  Text("$proteinSum/200g"),
                                ],
                              ),
                            ),
                            LinearPercentIndicator(
                              barRadius: Radius.circular(60),
                              lineHeight: 10,
                              progressColor: Theme.of(context).colorScheme.tertiaryContainer,
                              percent: proteinSum/200,
                            ),
                          ],
                        ),
                        SizedBox(height: 6,),

                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Carboidrato"),
                                  Text("$carbSum/200g"),
                                ],
                              ),
                            ),
                            LinearPercentIndicator(
                              barRadius: Radius.circular(60),
                              lineHeight: 10,
                              progressColor: Theme.of(context).colorScheme.tertiaryContainer,
                              percent: proteinSum/200,
                            ),
                          ],
                        ),
                        SizedBox(height: 6,),

                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Gordura"),
                                  Text("$fatSum/200g"),
                                ],
                              ),
                            ),
                            LinearPercentIndicator(
                              barRadius: Radius.circular(60),
                              lineHeight: 10,
                              progressColor: Theme.of(context).colorScheme.tertiaryContainer,
                              percent: proteinSum/200,
                            ),
                          ],
                        ),
                        SizedBox(height: 6,),

                        SizedBox(height: 20,),

                      ],
                    ),
                  ),


                  Expanded(
                    child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final mealDoc = meals[index];
                    
                        if (mealDoc == null || mealDoc.id.isEmpty) {
                          print("Meal document is null or has an empty ID.");
                          return ListTile(
                            title: Text("Erro ao carregar a refeição"),
                          );
                        }
                    
                        final mealData = mealDoc.data() as Map<String, dynamic>;
                    
                        print("Loaded meal with ID: ${mealDoc.id}");
                    
                        final mealName = mealData['nome'] ?? 'Nome não disponível';
                        final mealTime = mealData['horário'] ?? 'Horário não disponível';
                        final kcal = mealData['calorias'] ?? 0.0;
                    
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  print("Editing meal with ID: ${mealDoc.id}");
                                  _editMeal(context, mealDoc);
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  print("Deleting meal with ID: ${mealDoc.id}");
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
                            subtitle: Text(
                                'Horário: $mealTime\nCalorias: ${kcal.toStringAsFixed(2)} kcal'),
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

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Placeholder(),
      mainPage(),
      Placeholder(),
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

