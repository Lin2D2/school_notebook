import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../types/page_types.dart';
import '../blocs/notes_edit_state_bloc.dart';

class CustomDraggable extends StatefulWidget {
  // TODO optimize, big performance hit
  final Widget child;
  final ContentElement contentElement;

  const CustomDraggable({
    Key? key,
    required this.child,
    required this.contentElement,
  }) : super(key: key);

  @override
  _CustomDraggableState createState() => _CustomDraggableState();
}

class _CustomDraggableState extends State<CustomDraggable> {
  void _dragStart(DragStartDetails details, BuildContext context) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    _xOffset =
        details.localPosition.dx - (widget.contentElement.left * (5 * scale));
    _yOffset =
        details.localPosition.dy - (widget.contentElement.top * (5 * scale));
    if (notesEditState.isMove()) {
      _xTmp = widget.contentElement.left * (5 * scale);
      _yTmp = widget.contentElement.top * (5 * scale);
      setState(() {
        _move = true;
      });
    } else if (notesEditState.isResize()) {
      _xTmp = widget.contentElement.width * (5 * scale);
      _yTmp = widget.contentElement.height * (5 * scale);
      double margin = 0.5; // NOTE 1 is one box
      double dx =
          details.localPosition.dx - widget.contentElement.left * (5 * scale);
      double dy =
          details.localPosition.dy - widget.contentElement.top * (5 * scale);
      double width = widget.contentElement.width * (5 * scale);
      double height = widget.contentElement.height * (5 * scale);
      if (dx + (5 * scale) * margin > width) {
        if (dy + (5 * scale) * margin > height) {
          _yResize = true;
          _xResize = true;
        } else {
          _xResize = true;
        }
      } else if (dy + (5 * scale) * margin > height) {
        _yResize = true;
      }
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    if (notesEditState.isMove()) {
      setState(() {
        _xTmp = details.localPosition.dx - _xOffset;
        _yTmp = details.localPosition.dy - _yOffset;
      });
    } else if (notesEditState.isResize()) {
      setState(() {
        if (_xResize) {
          _xTmp = details.localPosition.dx -
              widget.contentElement.left * (5 * scale);
        }
        if (_yResize) {
          _yTmp = details.localPosition.dy -
              widget.contentElement.top * (5 * scale);
        }
      });
    }
  }

  void _dragEnd(DragEndDetails details) async {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    if (notesEditState.isMove()) {
      int? top;
      int? left;
      if (true) {
        // TODO check bounds of other children and bound of parent
        if (_move) {
          top = (_yTmp / (5 * scale)).round();
          left = (_xTmp / (5 * scale)).round();
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementUpdatePosition(widget.contentElement, top, left);
        }
      }
      setState(() {
        if (_move) {
          _leftCache = left!;
          _topCache = top!;
          _move = false;
        }
      });
    } else if (notesEditState.isResize()) {
      int? height;
      int? width;
      if (true) {
        // TODO check bounds of other children and bound of parent
        if (_xResize || _yResize) {
          height = (_yTmp / (5 * scale)).round();
          width = (_xTmp / (5 * scale)).round();
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementUpdateSize(widget.contentElement, height, width);
        }
      }
      setState(() {
        if (_xResize || _yResize) {
          _widthCache = width!;
          _heightCache = height!;
          _xResize = false;
          _yResize = false;
        }
      });
    }
  }

  bool _move = false;
  bool _xResize = false;
  bool _yResize = false;
  late double _xOffset;
  late double _yOffset;
  late double _xTmp;
  late double _yTmp;
  late int _leftCache;
  late int _topCache;
  late int _widthCache;
  late int _heightCache;

  @override
  void initState() {
    super.initState();
    _leftCache = widget.contentElement.left;
    _topCache = widget.contentElement.top;
    _widthCache = widget.contentElement.width;
    _heightCache = widget.contentElement.height;
  }

  @override
  Widget build(BuildContext context) {
    double scale =
        Provider.of<NotesEditState>(context, listen: true).viewPortScale;
    return GestureDetector(
      onPanStart: (details) => _dragStart(details, context),
      onPanUpdate: (details) => _dragUpdate(details),
      onPanEnd: (details) => _dragEnd(details),
      child: Stack(
        children: [
          if (_move)
            Positioned(
              left: widget.contentElement.left * (5 * scale),
              top: widget.contentElement.top * (5 * scale),
              height: widget.contentElement.height * (5 * scale),
              width: widget.contentElement.width * (5 * scale),
              child: Opacity(
                opacity: 0.3,
                child: widget.child,
              ),
            ),
          Positioned(
            // TODO still bug here
            left: _move
                ? _xTmp
                : _leftCache != widget.contentElement.left
                    ? _leftCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.left * (5 * scale) + (0.25 * scale),
            top: _move
                ? _yTmp
                : _topCache != widget.contentElement.top
                    ? _topCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.top * (5 * scale) + (0.25 * scale),
            height: _yResize
                ? _yTmp
                : _heightCache != widget.contentElement.height
                    ? _heightCache * (5 * scale) - (0.5 * scale)
                    : widget.contentElement.height * (5 * scale) -
                        (0.5 * scale),
            width: _xResize
                ? _xTmp
                : _widthCache != widget.contentElement.width
                    ? _widthCache * (5 * scale) - (0.5 * scale)
                    : widget.contentElement.width * (5 * scale) - (0.5 * scale),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
