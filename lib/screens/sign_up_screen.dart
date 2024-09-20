import 'package:alimentracker/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? errorMessage = '';

  final TextEditingController _emailEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();
  final TextEditingController _heightEC = TextEditingController();
  final TextEditingController _weightEC = TextEditingController();

  String? _selectedGender;
  String? _selectedGoal;
  String? _selectedActivityLevel;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailEC.text,
        password: _passwordEC.text,
        height: double.parse(_heightEC.text),
        weight: double.parse(_weightEC.text),
        gender: _selectedGender!,
        goal: _selectedGoal!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso")));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Column(
      children: [
        Text(errorMessage == '' ? '' : 'Hmm? $errorMessage'),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      {required String hintText,
        required T? value,
        required List<T> items,
        required ValueChanged<T?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonFormField<T>(
            value: value,
            hint: Text(hintText),
            decoration: const InputDecoration(border: InputBorder.none),
            items: items
                .map((T item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add,
                  size: 200,
                  color: Colors.greenAccent[700],
                ),
                const SizedBox(height: 10),
                _buildTextField(controller: _emailEC, hintText: "Email"),
                const SizedBox(height: 10),
                _buildTextField(
                    controller: _passwordEC, hintText: "Senha", obscureText: true),
                const SizedBox(height: 10),
                _buildTextField(controller: _heightEC, hintText: "Altura (cm)"),
                const SizedBox(height: 10),
                _buildTextField(controller: _weightEC, hintText: "Peso (kg)"),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  hintText: "Gênero",
                  value: _selectedGender,
                  items: ["Masculino", "Feminino"],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  hintText: "Objetivo",
                  value: _selectedGoal,
                  items: ["Ganhar massa", "Manter peso", "Perder peso"],
                  onChanged: (value) {
                    setState(() {
                      _selectedGoal = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  hintText: "Nível de atividade física",
                  value: _selectedActivityLevel,
                  items: ["Sedentário (menos de 10min/semana)", "Irregularmente ativo", "Ativo(150min/semana)", "Muito ativo(300min/semana)"],
                  onChanged: (value) {
                    setState(() {
                      _selectedActivityLevel = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _errorMessage(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: createUserWithEmailAndPassword,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                "Finalizar cadastro",
                                style: GoogleFonts.roboto(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                          Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
