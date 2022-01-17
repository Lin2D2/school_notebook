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
  // TODO make resizable
  void dragStart(DragStartDetails details, BuildContext context) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    leftOffset =
        details.localPosition.dx - (widget.contentElement.left * (5 * scale));
    topOffset =
        details.localPosition.dy - (widget.contentElement.top * (5 * scale));
    if (notesEditState.isMove()) {
      leftTmp = widget.contentElement.left * (5 * scale);
      topTmp = widget.contentElement.top * (5 * scale);
      setState(() {
        move = true;
      });
    } else if (notesEditState.isResize()) {
      double margin = 0.5; // NOTE 1 is one box
      double dx =
          details.localPosition.dx - widget.contentElement.left * (5 * scale);
      double dy =
          details.localPosition.dy - widget.contentElement.top * (5 * scale);
      double width = widget.contentElement.width * (5 * scale);
      double height = widget.contentElement.height * (5 * scale);
      if (dx + (5 * scale) * margin > width) {
        if (dy + (5 * scale) * margin > height) {
          heightResize = true;
          widthResize = true;
        } else {
          widthResize = true;
        }
      } else if (dy + (5 * scale) * margin > height) {
        heightResize = true;
      }
    }
  }

  void dragUpdate(DragUpdateDetails details) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;
    if (notesEditState.isMove()) {
      setState(() {
        leftTmp = details.localPosition.dx - leftOffset;
        topTmp = details.localPosition.dy - topOffset;
      });
    } else if (notesEditState.isResize()) {
      setState(() {
        widthTmp =
            details.localPosition.dx - widget.contentElement.left * (5 * scale);
        heightTmp =
            details.localPosition.dy - widget.contentElement.top * (5 * scale);
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
        // TODO check bounds of other children
        if (move) {
          top = (topTmp / (5 * scale)).round();
          left = (leftTmp / (5 * scale)).round();
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
        // TODO check bounds of other children
        if (widthResize || heightResize) {
          height = (heightTmp / (5 * scale)).round();
          width = (widthTmp / (5 * scale)).round();
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementUpdateSize(widget.contentElement, height, width);
        }
      }
      setState(() {
        if (widthResize || heightResize) {
          widthCache = width!;
          heightCache = height!;
          widthResize = false;
          heightResize = false;
        }
      });
    }
  }

  // TODO reduce variables
  bool move = false;
  double leftOffset = 0;
  double topOffset = 0;
  double leftTmp = 0;
  double topTmp = 0;
  int leftCache = 0;
  int topCache = 0;
  bool widthResize = false;
  bool heightResize = false;
  double widthTmp = 0;
  double heightTmp = 0;
  int widthCache = 0;
  int heightCache = 0;

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
                ? leftTmp
                : leftCache != widget.contentElement.left
                    ? leftCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.left * (5 * scale) + (0.25 * scale),
            top: move
                ? topTmp
                : topCache != widget.contentElement.top
                    ? topCache * (5 * scale) + (0.25 * scale)
                    : widget.contentElement.top * (5 * scale) + (0.25 * scale),
            height: heightResize
                ? heightTmp
                : heightCache != widget.contentElement.height
                    ? heightCache * (5 * scale) - (0.5 * scale)
                    : widget.contentElement.height * (5 * scale) -
                        (0.5 * scale),
            width: widthResize
                ? widthTmp
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
