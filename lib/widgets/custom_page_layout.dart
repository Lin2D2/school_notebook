import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/notes_edit_state_bloc.dart';
import '../blocs/data_base_service_bloc.dart';
import '../blocs/navigator_bloc.dart';
import '../types/page_types.dart';
import '../blocs/mouse_cursor_state_bloc.dart';
import '../widgets/custom_page.dart';
import 'custom_page_indicator.dart';

class CustomPageLayout extends StatelessWidget {
  const CustomPageLayout({Key? key}) : super(key: key);
  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: Provider.of<MouseCursorState>(context, listen: true).cursorState,
      // TODO not directly but on Hover of specific Elements
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Future<FolderType> folder = Provider.of<DataBaseServiceBloc>(context,
                  listen: true)
              .folderDao
              .getByID(
                  Provider.of<NavigatorBloc>(context, listen: true).folderID!);
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<D4PageType>>(
                    // TODO optimize
                    future:
                        Provider.of<DataBaseServiceBloc>(context, listen: true)
                            .pageDao
                            .getByFutureIDs(
                              folder.then((value) => value.contentIds),
                            ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Scrollbar(
                          controller: CustomPageLayout._scrollController,
                          isAlwaysShown: false,
                          interactive: false,
                          // TODO combine scrolling for Viewer and ListView
                          child: InteractiveViewer(
                            scaleEnabled: false,
                            panEnabled: false,
                            transformationController:
                                Provider.of<NotesEditState>(context,
                                        listen: true)
                                    .interactiveViewerController,
                            onInteractionUpdate: (details) {
                              Provider.of<NotesEditState>(context, listen: false)
                                  .translateView(details.focalPointDelta);
                            },
                            child: ListView.builder(
                              controller: CustomPageLayout._scrollController,
                              itemCount: ((snapshot.data?.length ?? 0) + 1),
                              itemBuilder: (BuildContext context, int index) {
                                if (index + 1 ==
                                    ((snapshot.data?.length ?? 0) + 1)) {
                                  return AddPagePage(folder: folder);
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
                ),
                CustomPageIndicator(
                    scrollController: CustomPageLayout._scrollController,
                    folder: folder),
                constraints.maxWidth > 1300
                    ? const SizedBox(
                        width: 300,
                      )
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddPagePage extends StatelessWidget {
  final Future<FolderType> folder;

  const AddPagePage({Key? key, required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scale =
        Provider.of<NotesEditState>(context, listen: true).viewPortScale;
    return Padding(
      padding: EdgeInsets.all(5 * scale),
      child: Center(
        child: Container(
          width: 188 * scale,
          height: 40 * scale,
          color: Colors.white,
          child: Center(
            child: IconButton(
              constraints: const BoxConstraints.expand(),
              icon: const Icon(
                Icons.add_circle_outlined,
                color: Colors.black,
                size: 50,
              ),
              onPressed: () =>
                  Provider.of<DataBaseServiceBloc>(context, listen: false)
                      .pageInsert(folder),
            ),
          ),
        ),
      ),
    );
  }
}
