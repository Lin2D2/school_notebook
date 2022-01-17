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
  void dragStart(details, BuildContext context) {
    if (Provider.of<NotesEditState>(context, listen: false).isMove()) {
      double scale =
          Provider.of<NotesEditState>(context, listen: false).viewPortScale;
      leftOffset =
          details.localPosition.dx - (widget.contentElement.left * (5 * scale));
      topOffset =
          details.localPosition.dy - (widget.contentElement.top * (5 * scale));
      leftTmp = widget.contentElement.left * (5 * scale);
      topTmp = widget.contentElement.top * (5 * scale);
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

  void dragEnd(details) async {
    if (Provider.of<NotesEditState>(context, listen: false).isMove()) {
      double scale =
          Provider.of<NotesEditState>(context, listen: false).viewPortScale;
      if (true) {
        // TODO check bounds of other children
        int top = (topTmp / (5 * scale)).round();
        int left = (leftTmp / (5 * scale)).round();
        await Provider.of<DataBaseServiceBloc>(context, listen: false)
            .elementUpdatePosition(widget.contentElement, top, left);
        // TODO still a bit of lag here
      }
      setState(() => moveResize = false);
    }
  }

  bool moveResize = false;
  double leftTmp = 0;
  double topTmp = 0;
  double leftOffset = 0;
  double topOffset = 0;

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
          if (moveResize)
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
            left: moveResize
                ? leftTmp
                : widget.contentElement.left * (5 * scale) + (0.25 * scale),
            top: moveResize
                ? topTmp
                : widget.contentElement.top * (5 * scale) + (0.25 * scale),
            height: widget.contentElement.height * (5 * scale) - (0.25 * scale),
            width: widget.contentElement.width * (5 * scale) - (0.25 * scale),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
