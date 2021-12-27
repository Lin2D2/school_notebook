import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/navigator_bloc.dart';
import 'package:school_notebook/widgets/d4_page.dart';
import 'package:school_notebook/widgets/side_navigation_rail.dart';

import '../blocs/mouse_cursor_state_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../widgets/custom_action_button_column.dart';

class Notes extends StatelessWidget {
  Notes({Key? key}) : super(key: key);
  ScrollController controller = ScrollController();
  static const TextStyle textStyle =
      TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
      ],
      child: SafeArea(
        child: MouseRegion(
          cursor: Provider.of<MouseCursorState>(context, listen: true).cursorState, // TODO not directly but on Hover of specific Elements
          child: Scaffold(
            floatingActionButton: const CustomActionButtonColumn(),
            body: SideNavigationRail(
              child: Scrollbar(
                controller: controller,
                isAlwaysShown: true,
                // TODO combine scrolling for Viewer and ListView
                child: InteractiveViewer(
                  minScale: 0.9,
                  maxScale: 9,
                  // TODO only infinite in x Axis but not y
                  child: ListView(
                    // TODO listView.builder from database
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      D4PagePortrait(
                          title: "Test Blatt 1",
                          date: "25.12.21",
                          visible: false,
                          child: Text(
                            "1",
                            style: textStyle,
                          )),
                      D4PagePortrait(
                          title: "Test Blatt 2",
                          date: "25.12.21",
                          child: Text(
                            "2",
                            style: textStyle,
                          )),
                      D4PagePortrait(
                          title: "Test Blatt 3",
                          date: "25.12.21",
                          visible: false,
                          child: Text(
                            "3",
                            style: textStyle,
                          )),
                      D4PagePortrait(
                          title: "Test Blatt 4",
                          date: "25.12.21",
                          visible: false,
                          child: Text(
                            "4",
                            style: textStyle,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
