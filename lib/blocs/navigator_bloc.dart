import 'package:flutter/material.dart';


class NavigatorBloc extends ChangeNotifier {
  int _id = 1;  // because default open side is home
  int _index = 0;

  int get id => _id;
  int get index => _index;

  set id(int val) {
    _id = val;
    notifyListeners();
  }

  set index(int val) {
    _index = val;
    notifyListeners();
  }
}
