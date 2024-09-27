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
  final TextEditingController _ageEC = TextEditingController();

  String? _selectedGender;
  String? _selectedGoal;
  String? _selectedActivityLevel;

  double calculateTMB(double weight, double height, int age, String gender) {
    if (gender == "Masculino") {
      return 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
    } else {
      return 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
    }
  }

  double adjustTMBForActivity(double tmb, String activityLevel) {
    switch (activityLevel) {
      case "Sedentário (Pouca ou nenhuma atividade física)":
        return tmb * 1.2;
      case "Levemente ativo (Exercício leve 1-3 dias/semana)":
        return tmb * 1.375;
      case "Moderadamente ativo (Exercício moderado 3-5 dias/semana)":
        return tmb * 1.55;
      case "Muito ativo (Exercício intenso 6-7 dias/semana)":
        return tmb * 1.725;
      case "Extremamente ativo (Atividade física intensa diária)":
        return tmb * 1.9;
      default:
        return tmb;
    }
  }


  double calculateAdjustedCalories(double tmb, String goal) {
    switch (goal) {
      case "Ganhar massa":
        return tmb * 1.15;
      case "Perder peso":
        return tmb * 0.85;
      case "Manter peso":
      default:
        return tmb;
    }
  }

  Map<String, double> calculateMacronutrients(double calories, String goal) {
    double proteinPercentage;
    double carbsPercentage;
    double fatPercentage;

    switch (goal) {
      case "Ganhar massa":
        proteinPercentage = 0.30;
        carbsPercentage = 0.50;
        fatPercentage = 0.20;
        break;
      case "Perder peso":
        proteinPercentage = 0.35;
        carbsPercentage = 0.40;
        fatPercentage = 0.25;
        break;
      case "Manter peso":
      default:
        proteinPercentage = 0.25;
        carbsPercentage = 0.50;
        fatPercentage = 0.25;
        break;
    }

    double proteinCalories = calories * proteinPercentage;
    double carbsCalories = calories * carbsPercentage;
    double fatCalories = calories * fatPercentage;

    double proteinGrams = proteinCalories / 4;
    double carbsGrams = carbsCalories / 4;
    double fatGrams = fatCalories / 9;

    return {
      'Proteínas (g)': proteinGrams,
      'Carboidratos (g)': carbsGrams,
      'Gorduras (g)': fatGrams,
    };
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      double height = double.parse(_heightEC.text);
      double weight = double.parse(_weightEC.text);
      int age = int.parse(_ageEC.text);

      double tmb = calculateTMB(weight, height, age, _selectedGender!);
      tmb = adjustTMBForActivity(tmb, _selectedActivityLevel!);

      double adjustedCalories = calculateAdjustedCalories(tmb, _selectedGoal!);

      Map<String, double> macronutrients = calculateMacronutrients(adjustedCalories, _selectedGoal!);

      await Auth().createUserWithEmailAndPassword(
        email: _emailEC.text,
        password: _passwordEC.text,
        height: height,
        weight: weight,
        gender: _selectedGender!,
        goal: _selectedGoal!,
        tmb: tmb,
        calories: adjustedCalories,
        macronutrients: macronutrients,
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
                _buildTextField(controller: _ageEC, hintText: "Idade"),
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
                  items: [
                  "Sedentário (Pouca ou nenhuma atividade física)",
                  "Levemente ativo (Exercício leve 1-3 dias/semana)",
                  "Moderadamente ativo (Exercício moderado 3-5 dias/semana)",
                  "Muito ativo (Exercício intenso 6-7 dias/semana)",
                  "Extremamente ativo (Atividade física intensa diária)"
                  ],
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
