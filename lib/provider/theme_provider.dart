import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  set darkTheme(bool value) {
    isDarkTheme = value;
    notifyListeners();
  }
}
