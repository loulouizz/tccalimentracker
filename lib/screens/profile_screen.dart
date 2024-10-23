import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _tmbController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _emailController.text = userData['email'] ?? '';
          _genderController.text = userData['gender'] ?? '';
          _goalController.text = userData['goal'] ?? '';
          _heightController.text = userData['height']?.toString() ?? '';
          _weightController.text = userData['weight']?.toString() ?? '';
          _caloriesController.text = userData['calories']?.toString() ?? '';
          _carbsController.text = userData['macronutrients']['Carboidratos (g)']?.toString() ?? '';
          _fatController.text = userData['macronutrients']['Gorduras (g)']?.toString() ?? '';
          _proteinController.text = userData['macronutrients']['Proteínas (g)']?.toString() ?? '';
          _tmbController.text = userData['tmb']?.toString() ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
        'email': _emailController.text,
        'gender': _genderController.text,
        'goal': _goalController.text,
        'height': int.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'calories': double.parse(_caloriesController.text),
        'macronutrients': {
          'Carboidratos (g)': double.parse(_carbsController.text),
          'Gorduras (g)': double.parse(_fatController.text),
          'Proteínas (g)': double.parse(_proteinController.text),
        },
        'tmb': double.parse(_tmbController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados atualizados com sucesso!')),
      );
    } catch (e) {
      print('Erro ao salvar dados: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar os dados.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Perfil')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Objetivo'),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Altura (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: 'Calorias diárias'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _carbsController,
              decoration: InputDecoration(labelText: 'Carboidratos (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fatController,
              decoration: InputDecoration(labelText: 'Gorduras (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _proteinController,
              decoration: InputDecoration(labelText: 'Proteínas (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tmbController,
              decoration: InputDecoration(labelText: 'Taxa Metabólica Basal (TMB)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
