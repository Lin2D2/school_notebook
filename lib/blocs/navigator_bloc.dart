import 'package:flutter/material.dart';


class NavigatorBloc extends ChangeNotifier {
  int _id = 1;  // because default open side is home
  int _index = 0;
  bool _sideNavigationRailState = true;
  int? _folder;

  int get id => _id;
  int get index => _index;
  bool get sideNavigationRailState => _sideNavigationRailState;
  int? get folder => _folder;

  set id(int val) {
    _id = val;
    notifyListeners();
  }

  set index(int val) {
    _index = val;
    notifyListeners();
  }

  set sideNavigationRailState(bool val) {
    _sideNavigationRailState = val;
    notifyListeners();
  }

  set folder(int? val) {
    _folder = val;
    notifyListeners();
  }
}
