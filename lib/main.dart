import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helper/firebase_options.dart';
import 'package:helper/screens/home_screen.dart';
import 'package:helper/screens/login_screen.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Collector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
