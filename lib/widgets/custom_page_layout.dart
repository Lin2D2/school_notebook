import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/notes_edit_state_bloc.dart';
import '../blocs/data_base_service_bloc.dart';
import '../blocs/navigator_bloc.dart';
import '../types/page_types.dart';
import '../blocs/mouse_cursor_state_bloc.dart';
import '../widgets/custom_page.dart';

class CustomPageLayout extends StatefulWidget {
  const CustomPageLayout({Key? key}) : super(key: key);
  static const TextStyle textStyle =
      TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold);
  static final ScrollController scrollController = ScrollController();

  @override
  State<CustomPageLayout> createState() => _CustomPageLayoutState();
}

class _CustomPageLayoutState extends State<CustomPageLayout>
    with TickerProviderStateMixin {
  int pageIndex = 0;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 1, initialIndex: pageIndex, vsync: this);
    CustomPageLayout.scrollController.addListener(() {
      double pixels = CustomPageLayout.scrollController.position.pixels;
      int newPageIndex = (pixels / 4 != 0 ? pixels / 4 : 1) ~/ (260 + 10);
      if (newPageIndex != tabController?.index && mounted) {
        setState(() {
          pageIndex = newPageIndex;
          tabController?.animateTo(newPageIndex);
        });
      }
      // page spacing with standard height of 260 ca 270 * scale
      // page (height + 10) * scale * index => pixels
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: Provider.of<MouseCursorState>(context, listen: true).cursorState,
      // TODO not directly but on Hover of specific Elements
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          FolderType? folder =
              Provider.of<NavigatorBloc>(context, listen: true).folder;
          Widget mainContent = Expanded(
            child: FutureBuilder<List<D4PageType>>(
              // TODO optimize
              future: Provider.of<DataBaseServiceBloc>(context, listen: true)
                  .pageDao
                  .getByIDs(folder!.contentIds),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scrollbar(
                    controller: CustomPageLayout.scrollController,
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
                        controller: CustomPageLayout.scrollController,
                        itemCount: ((snapshot.data?.length ?? 0) + 1),
                        itemBuilder: (BuildContext context, int index) {
                          if (index + 1 == ((snapshot.data?.length ?? 0) + 1)) {
                            double scale = Provider.of<NotesEditState>(context,
                                    listen: true)
                                .viewPortScale;
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
                            return CustomPage(snapshot.data![index]);
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
              child: FutureBuilder<List<D4PageType>>(
                // TODO optimize
                future: Provider.of<DataBaseServiceBloc>(context, listen: true)
                    .pageDao
                    .getByIDs(folder.contentIds),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    tabController = TabController(
                        length: ((snapshot.data?.length ?? 0) + 1),
                        initialIndex: pageIndex,
                        vsync: this);
                    return TabPageSelector(
                      controller: tabController,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
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