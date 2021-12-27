import 'package:flutter/material.dart';

import '../types/d4_page.dart';

class D4PageContentLayout extends StatefulWidget {
  D4PageContentLayout({Key? key}) : super(key: key);

  @override
  State<D4PageContentLayout> createState() => _D4PageContentLayoutState();
}

class _D4PageContentLayoutState extends State<D4PageContentLayout> {
  List<ContentElement> content = [
    ContentElement(left: 0, top: 0, width: 5, height: 5),
    ContentElement(left: 0, top: 0, width: 10, height: 10),
  ];
  Widget child = Container(
    color: Colors.red,
    child: const Center(child: Text("Test")),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        content.length,
        (index) => CustomDraggable(
          child: child, // TODO Determint by content
          left: content[index].left * 25,
          top: content[index].top * 25,
          width: content[index].width * 25 - 2,
          height: content[index].height * 25 - 2,
        ),
      ),
    );
  }
}

class CustomDraggable extends StatefulWidget {
  final Widget child;
  // final Key contentID;  // TODO use instead for reference
  double left;
  double top;
  final double height;
  final double width;

  CustomDraggable({
    Key? key,
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
  void DragStart(details) {
    leftTmp = widget.left;
    topTmp = widget.top;
    setState(() {
      moving = true;
    });
  }

  void DragUpdate(details) {
    setState(() {
      leftTmp = details.localPosition.dx;
      topTmp = details.localPosition.dy;
    });
  }

  void DragEnd(details) {
    setState(() {
      moving = false;
      // TODO check for overlap
      widget.left = (leftTmp ~/ 25) * 25;
      widget.top = (topTmp ~/ 25) * 25;
    });
  }
  double left = 0;
  double top = 0;
  double height = 125;
  double width = 125;
  Widget child = const Center(child: Text("Test"));

  bool moving = false;
  double leftTmp = 0;
  double topTmp = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => DragStart(details),
      onPanUpdate: (details) => DragUpdate(details),
      onPanEnd: (details) => DragEnd(details),
      child: Stack(
        children: [
          if (moving)
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
            left: moving ? leftTmp : widget.left,
            top: moving ? topTmp : widget.top,
            height: widget.height,
            width: widget.width,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
