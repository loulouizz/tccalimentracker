import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreenPart2 extends StatefulWidget {
  final String email;
  final String password;
  SignUpScreenPart2({required this.email, required this.password, super.key});

  @override
  State<SignUpScreenPart2> createState() => _SignUpScreenPart2State();
}

class _SignUpScreenPart2State extends State<SignUpScreenPart2> {
  final GlobalKey _formKey = GlobalKey();

  TextEditingController heightEC = TextEditingController();
  TextEditingController weightEC = TextEditingController();
  TextEditingController genderEC = TextEditingController();
  TextEditingController goalEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informações pessoais"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 100,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface,),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: heightEC,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Altura (cm)",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface,),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: weightEC,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Peso (kg)",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface,),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: genderEC,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Gênero",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface,),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: goalEC,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Objetivo",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
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
    );
  }
}
