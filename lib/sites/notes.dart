import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/mouse_cursor_state_bloc.dart';
import '../blocs/navigator_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../widgets/custom_action_button_column.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/d4_page.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);
  static const TextStyle textStyle =
  TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
        length: 4, initialIndex: 1, vsync: this);
    return
      // MultiProvider(
      // providers: [],
      // child:
      SafeArea(
        child: MouseRegion(
          cursor:
          Provider
              .of<MouseCursorState>(context, listen: true)
              .cursorState,
          // TODO not directly but on Hover of specific Elements
          child: Scaffold(
            appBar: const CustomAppBar(),
            drawer: CustomDrawer(),
            persistentFooterButtons: [],
            floatingActionButton: const CustomActionButtonColumn(),  // TODO move on wide screen to to overlab toolarea
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                Widget sideRail = CustomDrawer();
                Widget mainContent = Expanded(
                  child:
                  Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: false,
                    interactive: false,
                    // TODO combine scrolling for Viewer and ListView
                    child:
                    InteractiveViewer(
                      minScale: 0.9,
                      maxScale: 9,
                      scaleEnabled: false,
                      // TODO only infinite in x Axis but not y
                      child:
                      ListView(
                        // TODO listView.builder from database
                        primary: false,
                        // physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        children: [
                          D4PagePortrait(
                              title: "Test Blatt 1",
                              date: "25.12.21",
                              visible: false,
                              child: Text(
                                "1",
                                style: Notes.textStyle,
                              )),
                          SingleChildScrollView(
                            // physics: NeverScrollableScrollPhysics(),
                            child: D4PagePortrait(
                                title: "Test Blatt 2",
                                date: "25.12.21",
                                child: Text(
                                  "2",
                                  style: Notes.textStyle,
                                )),
                          ),
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
                );
                Widget navigation = SizedBox(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: TabPageSelector( // TODO indexing based on page in the middle of the screen
                      controller: tabController,
                    ),),
                );
                Widget toolArea = const SizedBox(
                  width: 300,
                );
                return Scaffold(
                  body: Row(
                    children: [
                      false ? sideRail : const SizedBox(), // TODO only show on wide screen
                      mainContent,
                      navigation,
                      false ? toolArea : const SizedBox(), // TODO only show on wide screen
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // ),
      );
  }
}
