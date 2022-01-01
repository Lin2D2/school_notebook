import 'package:flutter/material.dart';

import '../types/d4_page.dart';
import 'folder_element.dart';

class FolderPageLayout extends StatelessWidget {
  const FolderPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width ~/ 400,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 188 / 260,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              15, 15, (index + 1) % (width ~/ 400) == 0 ? 15 : 0, 0),
          child: FolderElement(
            index: index,
            folder: FolderType(
                id: 0,
                name: 'Test ' + (index+1).toString(),
                color: [Colors.red, Colors.green, Colors.purple, Colors.yellow, Colors.blue].toList()[index % 5],
                contentIds: [],
            ),
          ),
        );
      },
    );
  }
}
