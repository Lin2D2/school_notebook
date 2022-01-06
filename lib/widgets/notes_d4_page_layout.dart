import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/mouse_cursor_state_bloc.dart';
import '../widgets/d4_page.dart';

class NotesD4PageLayout extends StatefulWidget {
  const NotesD4PageLayout({Key? key}) : super(key: key);
  static const TextStyle textStyle =
      TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold);
  static final ScrollController scrollController = ScrollController();

  @override
  State<NotesD4PageLayout> createState() => _NotesD4PageLayoutState();
}

class _NotesD4PageLayoutState extends State<NotesD4PageLayout>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: 4, initialIndex: 1, vsync: this);
    return MouseRegion(
      cursor: Provider.of<MouseCursorState>(context, listen: true).cursorState,
      // TODO not directly but on Hover of specific Elements
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Widget mainContent = Expanded(
            child: Scrollbar(
              controller: NotesD4PageLayout.scrollController,
              isAlwaysShown: false,
              interactive: false,
              // TODO combine scrolling for Viewer and ListView
              child: InteractiveViewer(
                minScale: 0.9,
                maxScale: 9,
                scaleEnabled: true,
                // TODO only infinite in x Axis but not y
                child: ListView(
                  // TODO listView.builder from database
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: NotesD4PageLayout.scrollController,
                  children: [
                    D4PagePortrait(
                      title: "Test Blatt 1",
                      date: "25.12.21",
                      visible: true,
                      child: const Text(
                        "1",
                        style: NotesD4PageLayout.textStyle,
                      ),
                    ),
                    D4PagePortrait(
                        title: "Test Blatt 2",
                        date: "25.12.21",
                        visible: false,
                        child: const Text(
                          "2",
                          style: NotesD4PageLayout.textStyle,
                        ),
                      ),
                    D4PagePortrait(
                      title: "Test Blatt 3",
                      date: "25.12.21",
                      visible: false,
                      child: const Text(
                        "3",
                        style: NotesD4PageLayout.textStyle,
                      ),
                    ),
                    D4PagePortrait(
                      title: "Test Blatt 4",
                      date: "25.12.21",
                      visible: false,
                      child: const Text(
                        "4",
                        style: NotesD4PageLayout.textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          Widget navigation = SizedBox(
            child: RotatedBox(
              quarterTurns: 1,
              child: TabPageSelector(
                // TODO indexing based on page in the middle of the screen
                controller: tabController,
              ),
            ),
          );
          Widget toolArea = const SizedBox(
            width: 300,
          );
          return Scaffold(
            body: Row(
              children: [
                mainContent,
                navigation,
                false ? toolArea : const SizedBox(),
                // TODO only show on wide screen
              ],
            ),
          );
        },
      ),
    );
  }
}
