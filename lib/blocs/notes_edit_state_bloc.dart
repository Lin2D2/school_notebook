import 'package:flutter/material.dart';


enum CustomDraggableEditState {
  none,
  move,
  resize,
}


class NotesEditState extends ChangeNotifier {
  CustomDraggableEditState _editState = CustomDraggableEditState.none;

  CustomDraggableEditState get editState => _editState;

  void none() {
    _editState = CustomDraggableEditState.none;
    notifyListeners();
  }

  bool isNone() {
    return _editState == CustomDraggableEditState.none;
  }

  void move() {
    _editState = CustomDraggableEditState.move;
    notifyListeners();
  }

  bool isMove() {
    return _editState == CustomDraggableEditState.move;
  }

  void resize() {
    _editState = CustomDraggableEditState.resize;
    notifyListeners();
  }

  bool isResize() {
    return _editState == CustomDraggableEditState.resize;
  }
}
