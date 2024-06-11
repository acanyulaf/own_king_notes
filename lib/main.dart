import 'package:flutter/material.dart';
import 'package:own_king_notes/king.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:own_king_notes/provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ParameterProvider(),
      child: const KingApp(),
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class KingApp extends StatelessWidget {
  const KingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King of los pollos hermanos',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const KingHomePage(),
    );
  }
}
