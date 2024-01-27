import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helper/firebase_options.dart';
import 'package:helper/screens/home_screen.dart';
import 'package:helper/screens/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Collector',
      theme: Provider.of<ThemeProvider>(context).getCurrentTheme(),
      home: const MyHomePage(),
    );
  }
}
