import 'package:flutter/material.dart';

import '../types/d4_page.dart';
import 'custom_draggable.dart';

class D4PageContentLayout extends StatefulWidget {
  D4PageContentLayout({Key? key}) : super(key: key);

  @override
  State<D4PageContentLayout> createState() => _D4PageContentLayoutState();
}

class _D4PageContentLayoutState extends State<D4PageContentLayout> {
  List<ContentElement> content = [
    ContentElement(id: 1, left: 0, top: 0, width: 5, height: 5, contentId: 11),
    ContentElement(id: 2, left: 0, top: 0, width: 10, height: 10, contentId: 21),
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
