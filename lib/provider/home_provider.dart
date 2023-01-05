import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int homeBottomindex = 0;

  void changeHomeBottomIndex(int value) {
    homeBottomindex = value;
    notifyListeners();
  }
}
