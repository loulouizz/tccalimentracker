import 'package:alimentracker/firebase_options.dart';
import 'package:alimentracker/providers/meal_provider.dart';
import 'package:alimentracker/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'src/shared/themes/colors_schemes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MealProvider()),
    ],
    child: MyApp(),
  ));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test',
      themeMode: ThemeMode.system,
      theme: ThemeData(
          useMaterial3: true, colorScheme: MaterialTheme.lightScheme()),
      darkTheme: ThemeData(
          useMaterial3: true, colorScheme: MaterialTheme.darkScheme()),
      home: WidgetTree(),
    );
  }
}
