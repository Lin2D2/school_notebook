import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/navigator_bloc.dart';
import 'package:school_notebook/widgets/custom_drawer.dart';
import 'package:school_notebook/widgets/d4_page.dart';
import 'package:school_notebook/widgets/side_navigation_rail.dart';

import '../blocs/mouse_cursor_state_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../widgets/custom_action_button_column.dart';
import '../widgets/custom_app_bar.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);
  static const TextStyle textStyle =
      TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        // providers: [],
        // child:
        SafeArea(
      child: MouseRegion(
        cursor:
            Provider.of<MouseCursorState>(context, listen: true).cursorState,
        // TODO not directly but on Hover of specific Elements
        child: Scaffold(
          appBar: const CustomAppBar(),
          drawer: CustomDrawer(),
          persistentFooterButtons: [
            TabPageSelector(
              controller:
                  TabController(length: 4, initialIndex: 1, vsync: this),
            ),
          ],
          floatingActionButton: const CustomActionButtonColumn(),
          body:
              // SideNavigationRail(
              //   child:
              Scrollbar(
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
                        style: Notes.textStyle,
                      )),
                  D4PagePortrait(
                      title: "Test Blatt 2",
                      date: "25.12.21",
                      child: Text(
                        "2",
                        style: Notes.textStyle,
                      )),
                  D4PagePortrait(
                      title: "Test Blatt 3",
                      date: "25.12.21",
                      visible: false,
                      child: Text(
                        "3",
                        style: Notes.textStyle,
                      )),
                  D4PagePortrait(
                      title: "Test Blatt 4",
                      date: "25.12.21",
                      visible: false,
                      child: Text(
                        "4",
                        style: Notes.textStyle,
                      )),
                ],
              ),
            ),
          ),
        ),
        // ),
      ),
      // ),
    );
  }
}
