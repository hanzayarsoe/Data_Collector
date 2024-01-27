import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.grey),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black, fontSize: 16),
          labelLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleSmall:
              TextStyle(color: Color.fromARGB(139, 0, 0, 0), fontSize: 16)));

  final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo,
        accentColor: Colors.deepOrange,
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        color: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[800],
      textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color.fromARGB(192, 33, 149, 243)),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.black, fontSize: 16),
          labelLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleSmall:
              TextStyle(color: Color.fromARGB(139, 0, 0, 0), fontSize: 16)));

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData getCurrentTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }
}
