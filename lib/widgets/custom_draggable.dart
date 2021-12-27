import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/notes_edit_state_bloc.dart';

class CustomDraggable extends StatefulWidget {
  // TODO optimize, big performance hit

  final Widget child;

  // final Key contentID;  // TODO use instead for reference
  double left;
  double top;
  final double height;
  final double width;

  CustomDraggable({
    Key? key,
    // TODO all of this from database!
    required this.child,
    required this.height,
    required this.width,
    required this.left,
    required this.top,
    // required this.contentID,
  }) : super(key: key);

  @override
  _CustomDraggableState createState() => _CustomDraggableState();
}

class _CustomDraggableState extends State<CustomDraggable> {
  // TODO make resizable
  void dragStart(details, BuildContext context) {
    if (Provider.of<NotesEditState>(context, listen: false).isMove()) {
      leftOffset = details.localPosition.dx - widget.left;
      topOffset = details.localPosition.dy - widget.top;
      leftTmp = widget.left;
      topTmp = widget.top;
      setState(() {
        moveResize = true;
      });
    }
  }

  void dragUpdate(details) {
    if (Provider.of<NotesEditState>(context, listen: false).isMove()) {
      setState(() {
        leftTmp = details.localPosition.dx - leftOffset;
        topTmp = details.localPosition.dy - topOffset;
      });
    }
  }

  void dragEnd(details) {
    if (Provider.of<NotesEditState>(context, listen: false).isMove()) {
      setState(() {
        moveResize = false;
        // TODO check bounds of other children
        if (true) {
          widget.left = (leftTmp ~/ 25) * 25;
          widget.top = (topTmp ~/ 25) * 25;
        }
      });
    }
  }

  double left = 0;
  double top = 0;
  double height = 125;
  double width = 125;
  Widget child = const Center(child: Text("Test"));

  bool moveResize = false;
  double leftTmp = 0;
  double topTmp = 0;
  double leftOffset = 0;
  double topOffset = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => dragStart(details, context),
      onPanUpdate: (details) => dragUpdate(details),
      onPanEnd: (details) => dragEnd(details),
      child: Stack(
        children: [
          if (moveResize)
            Positioned(
              left: widget.left,
              top: widget.top,
              height: widget.height,
              width: widget.width,
              child: Opacity(
                opacity: 0.3,
                child: widget.child,
              ),
            ),
          Positioned(
            left: moveResize ? leftTmp : widget.left,
            top: moveResize ? topTmp : widget.top,
            height: widget.height,
            width: widget.width,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
