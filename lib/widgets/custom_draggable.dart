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
  void dragStart(DragStartDetails details, BuildContext context) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    xOffset =
        details.localPosition.dx - (widget.contentElement.left * (5 * scale));
    yOffset =
        details.localPosition.dy - (widget.contentElement.top * (5 * scale));
    if (notesEditState.isMove()) {
      xTmp = widget.contentElement.left * (5 * scale);
      yTmp = widget.contentElement.top * (5 * scale);
      setState(() {
        move = true;
      });
    } else if (notesEditState.isResize()) {
      xTmp = widget.contentElement.width * (5 * scale);
      yTmp = widget.contentElement.height * (5 * scale);
      double margin = 0.5; // NOTE 1 is one box
      double dx =
          details.localPosition.dx - widget.contentElement.left * (5 * scale);
      double dy =
          details.localPosition.dy - widget.contentElement.top * (5 * scale);
      double width = widget.contentElement.width * (5 * scale);
      double height = widget.contentElement.height * (5 * scale);
      if (dx + (5 * scale) * margin > width) {
        if (dy + (5 * scale) * margin > height) {
          yResize = true;
          xResize = true;
        } else {
          xResize = true;
        }
      } else if (dy + (5 * scale) * margin > height) {
        yResize = true;
      }
    }
  }

  void dragUpdate(DragUpdateDetails details) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    if (notesEditState.isMove()) {
      setState(() {
        xTmp = details.localPosition.dx - xOffset;
        yTmp = details.localPosition.dy - yOffset;
      });
    } else if (notesEditState.isResize()) {
      setState(() {
        if (xResize) {
          xTmp = details.localPosition.dx -
              widget.contentElement.left * (5 * scale);
        }
        if (yResize) {
          yTmp = details.localPosition.dy -
              widget.contentElement.top * (5 * scale);
        }
      });
    }
  }

  void dragEnd(DragEndDetails details) async {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    if (notesEditState.isMove()) {
      int? top;
      int? left;
      if (true) {
        // TODO check bounds of other children and bound of parent
        if (move) {
          top = (yTmp / (5 * scale)).round();
          left = (xTmp / (5 * scale)).round();
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementUpdatePosition(widget.contentElement, top, left);
        }
      }
      setState(() {
        if (move) {
          leftCache = left!;
          topCache = top!;
          move = false;
        }
      });
    } else if (notesEditState.isResize()) {
      int? height;
      int? width;
      if (true) {
        // TODO check bounds of other children and bound of parent
        if (xResize || yResize) {
          height = (yTmp / (5 * scale)).round();
          width = (xTmp / (5 * scale)).round();
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementUpdateSize(widget.contentElement, height, width);
        }
      }
      setState(() {
        if (xResize || yResize) {
          widthCache = width!;
          heightCache = height!;
          xResize = false;
          yResize = false;
        }
      });
    }
  }

  bool move = false;
  bool xResize = false;
  bool yResize = false;
  late double xOffset;
  late double yOffset;
  late double xTmp;
  late double yTmp;
  late int leftCache;
  late int topCache;
  late int widthCache;
  late int heightCache;

  @override
  void initState() {
    super.initState();
    leftCache = widget.contentElement.left;
    topCache = widget.contentElement.top;
    widthCache = widget.contentElement.width;
    heightCache = widget.contentElement.height;
  }

  @override
  Widget build(BuildContext context) {
    double scale =
        Provider.of<NotesEditState>(context, listen: true).viewPortScale;
    return GestureDetector(
      onPanStart: (details) => dragStart(details, context),
      onPanUpdate: (details) => dragUpdate(details),
      onPanEnd: (details) => dragEnd(details),
      child: Stack(
        children: [
          if (move)
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
            left: move
                ? xTmp
                : leftCache != widget.contentElement.left
                    ? leftCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.left * (5 * scale) + (0.25 * scale),
            top: move
                ? yTmp
                : topCache != widget.contentElement.top
                    ? topCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.top * (5 * scale) + (0.25 * scale),
            height: yResize
                ? yTmp
                : heightCache != widget.contentElement.height
                    ? heightCache * (5 * scale) - (0.5 * scale)
                    : widget.contentElement.height * (5 * scale) -
                        (0.5 * scale),
            width: xResize
                ? xTmp
                : widthCache != widget.contentElement.width
                    ? widthCache * (5 * scale) - (0.5 * scale)
                    : widget.contentElement.width * (5 * scale) - (0.5 * scale),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
