import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../blocs/navigator_bloc.dart';
import '../types/d4_page.dart';
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
          FolderType? folder =
              Provider.of<NavigatorBloc>(context, listen: true).folder;
          Widget mainContent = Expanded(
            child: FutureBuilder<List<D4PageType>>( // TODO optimize
              future: Provider.of<DataBaseServiceBloc>(context, listen: true)
                  .pageDao
                  .getByIDs(folder!.contentIds),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scrollbar(
                    controller: NotesD4PageLayout.scrollController,
                    isAlwaysShown: false,
                    interactive: false,
                    // TODO combine scrolling for Viewer and ListView
                    child: InteractiveViewer(
                      minScale: 0.9,
                      maxScale: 9,
                      scaleEnabled: true,
                      // TODO only infinite in x Axis but not y
                      child: ListView.builder(
                        // TODO listView.builder from database
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: NotesD4PageLayout.scrollController,
                        itemCount: ((snapshot.data?.length ?? 0) + 1),
                        itemBuilder: (BuildContext context, int index) {
                          if (index + 1 == ((snapshot.data?.length ?? 0) + 1)) {
                            double scale = 4; // TODO make global
                            return Padding(
                              padding: EdgeInsets.all(5 * scale),
                              child: Center(
                                child: Container(
                                  width: 188 * scale,
                                  height: 40 * scale,
                                  color: Colors.white,
                                  child: Center(
                                    child: IconButton(
                                      constraints:
                                          const BoxConstraints.expand(),
                                      icon: const Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.black,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        DateTime now = DateTime.now();
                                        String date = now.day.toString() +
                                            "." +
                                            now.month.toString() +
                                            "." +
                                            now.year.toString().substring(2);
                                        int id = Random()
                                            .nextInt(10000); // TODO better id
                                        D4PageType page = D4PageType(
                                          id: id,
                                          name: "Untitled",
                                          date: date,
                                          contentIds: [],
                                        );
                                        List<int> contentIds = [id];
                                        contentIds.addAll(folder.contentIds);
                                        FolderType newFolder = FolderType(
                                            id: folder.id,
                                            name: folder.name,
                                            color: folder.color,
                                            contentIds: contentIds);
                                        DataBaseServiceBloc database =
                                            Provider.of<DataBaseServiceBloc>(
                                                context,
                                                listen: false);
                                        database.pageInsert(page);
                                        database.folderUpdate(newFolder);
                                        Provider.of<NavigatorBloc>(context,
                                                listen: false)
                                            .folder = newFolder;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return D4PagePortrait(snapshot.data![index]);
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
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
