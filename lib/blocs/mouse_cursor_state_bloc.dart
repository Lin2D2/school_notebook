import 'package:flutter/material.dart';

enum MouseCursorStateEnum {
  basic, // SystemMouseCursors.basic
  grab,
  move,
  resizeDownRight,
  cell,
  text,
}

class MouseCursorState extends ChangeNotifier {
  MouseCursor _cursorState = SystemMouseCursors.basic;

  MouseCursor get cursorState => _cursorState;

  set cursorState(MouseCursor val) {
    _cursorState = val;
    notifyListeners();
  }
}
