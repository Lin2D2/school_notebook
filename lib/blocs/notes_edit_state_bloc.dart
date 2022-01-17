import 'package:flutter/material.dart';

enum CustomDraggableEditState {
  none,
  move,
  resize,
  add,
}

class NotesEditState extends ChangeNotifier {
  CustomDraggableEditState _editState = CustomDraggableEditState.none;
  double _viewPortScale = 4;
  double _viewPortZoom = 1;
  final TransformationController _interactiveViewerController =
      TransformationController();
  Matrix4? _interactiveViewerMatrix;

  CustomDraggableEditState get editState => _editState;

  double get viewPortScale => _viewPortScale;

  double get viewPortZoom => _viewPortZoom;

  TransformationController get interactiveViewerController =>
      _interactiveViewerController;

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

  void add() {
    _editState = CustomDraggableEditState.add;
    notifyListeners();
  }

  bool isAdd() {
    return _editState == CustomDraggableEditState.add;
  }

  set viewPortScale(double value) {
    _viewPortScale = value;
    notifyListeners();
  }

  set viewPortZoom(double value) {
    _interactiveViewerMatrix ??= _interactiveViewerController.value;
    Matrix4 currentMatrix = _interactiveViewerController.value;
    var translation = currentMatrix.getTranslation();
    _interactiveViewerController
        .value = (_interactiveViewerMatrix?.clone()?..scale(value))!
      ..setTranslation(
          translation); // TODO zoom center not top left
    _viewPortZoom = value;
    notifyListeners();
  }
}
