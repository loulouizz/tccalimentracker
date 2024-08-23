import 'package:alimentracker/auth.dart';
import 'package:alimentracker/screens/food_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dayAndMonth;

  int _selectedIndex = 1;

  @override
  void initState() {
    dayAndMonth = DateFormat('d/0M').format(DateTime.now());
    super.initState();
  }

  final User? user = Auth().currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return Text("${dayAndMonth}");
  }

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign out'));
  }

  Widget _historyPage() {
    return Placeholder();
  }

  Widget mainPage() {
    return Column(
      children: [
        Text("300 kcal"),
      ],
    );
  }

  Widget _profilePage() {
    return Placeholder();
  }

  List<Widget> _widgetOptions = <Widget>[
    Text("Tela de histórico"),

    Column(
      children: [
        Text("300 kcal"),
      ],
    ),

    Text("Tela de perfil"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _title(),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout),),]
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FoodListScreen()));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              label: "Histórico",
              icon: Icon(
                Icons.calendar_month,
              )),
          BottomNavigationBarItem(
              label: "Início",
              icon: Icon(
                Icons.home,
              )),
          BottomNavigationBarItem(label: "Perfil", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
