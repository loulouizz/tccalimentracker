import 'package:alimentracker/auth.dart';
import 'package:alimentracker/screens/add_meal_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String dayAndMonth = '';
  int _selectedIndex = 1;
  final User? user = Auth().currentUser;

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
                return Center(child: Text('Nenhuma refeição registrada para hoje.'));
              }

              final meals = snapshot.data!.docs;

              return ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final mealData = meals[index].data() as Map<String, dynamic>;

                  final mealName = mealData['nome'] ?? 'Nome não disponível';
                  final mealTime = mealData['horário'] ?? 'Horário não disponível';
                  final kcal = mealData['calorias'] ?? 0.0;

                  return ListTile(
                    title: Text(mealName),
                    subtitle: Text('Horário: $mealTime\nCalorias: ${kcal.toStringAsFixed(2)} kcal'),
                  );
                },
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
