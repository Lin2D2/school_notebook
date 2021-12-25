import 'package:flutter/material.dart';

import '../types/d4_page.dart';

class D4PageContentLayout extends StatelessWidget {
  final List<ContentElement> content = [
    ContentElement(0, 0, 5, 5),
    ContentElement(5, 5, 5, 5),
  ];

  D4PageContentLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List<Positioned>.generate(
        content.length,
        (index) => Positioned(
          left: content[index].left*25,
          top: content[index].top*25,
          width: content[index].width*25-2,
          height: content[index].height*25-2,
          child: Container(
            color: Colors.red,
            child: const Center(child: Text("Test")),
          ),
        ),
      ),
    );
  }
}
