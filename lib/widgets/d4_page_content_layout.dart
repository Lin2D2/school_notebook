import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../types/d4_page.dart';
import 'custom_draggable.dart';

class D4PageContentLayout extends StatefulWidget {
  const D4PageContentLayout({Key? key}) : super(key: key);

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
                .apply(bodyColor: Colors.black, displayColor: Colors.black),
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
          left: content[index].left * 25,
          top: content[index].top * 25,
          width: content[index].width * 25 - 2,
          height: content[index].height * 25 - 2,
        ),
      ),
    );
  }
}
