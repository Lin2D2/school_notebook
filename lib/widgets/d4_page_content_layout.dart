import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../types/d4_page.dart';
import 'custom_draggable.dart';

class D4PageContentLayout extends StatefulWidget {
  final double scale;
  const D4PageContentLayout({Key? key, required this.scale}) : super(key: key);

  @override
  State<D4PageContentLayout> createState() => _D4PageContentLayoutState();
}

class _D4PageContentLayoutState extends State<D4PageContentLayout> {
  List<ContentElement> content = [
    ContentElement(id: 1, left: 0, top: 0, width: 5, height: 10, contentId: 11),
    ContentElement(id: 2, left: 5, top: 0, width: 5, height: 10, contentId: 21),
  ];

  Widget getChild(BuildContext context) {
    return Container(
      color: Colors.red,
      child: MarkdownBody(
        styleSheet: MarkdownStyleSheet.fromTheme(
          ThemeData(
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, displayColor: Colors.black, fontSizeFactor: 0.2*widget.scale),
          ),
        ),
        data: "# Test Data \n # H1 \n ## H2 \n ### H3 \n test, test",
        selectable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        content.length,
        (index) => CustomDraggable(
          child: getChild(context),
          // TODO Determint by content
          left: content[index].left * (5*widget.scale) + 0.25*widget.scale,
          top: content[index].top * (5*widget.scale) + 0.25*widget.scale,
          width: content[index].width * (5*widget.scale) - 0.5*widget.scale,
          height: content[index].height * (5*widget.scale) - 0.5*widget.scale,
          scale: widget.scale,
        ),
      ),
    );
  }
}
