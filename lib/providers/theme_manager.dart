import 'package:flutter/material.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.lightGreen[900],
    ),
    fontFamily: 'Lato',
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 15,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.red,
      primary: Colors.lightGreen[900],
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData(
    fontFamily: 'Lato-Bold',
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 15,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.pink,
      primary: Colors.lightGreen,
      brightness: Brightness.light,
    ),
  );

  ThemeData _themeData = ThemeData();
  ThemeData getTheme() => _themeData;

  bool getThemeBool() {
    if (_themeData == lightTheme) {
      return true;
    } else {
      return false;
    }
  }

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setMode(bool theme) async {
    if (theme) {
      _themeData = lightTheme;
      StorageManager.saveData('themeMode', 'light');
    } else {
      _themeData = darkTheme;
      StorageManager.saveData('themeMode', 'dark');
    }
    notifyListeners();
  }
}
