import 'package:alimentracker/auth.dart';
import 'package:alimentracker/screens/login_screen.dart';
import 'package:alimentracker/screens/main_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges, builder: (context, snapshot){
      if (snapshot.hasData){
        return MainScreen();
      } else {
        return const LoginScreen();
      }
    });
  }
}
