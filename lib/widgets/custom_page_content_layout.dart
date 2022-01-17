import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../types/page_types.dart';
import 'custom_draggable.dart';

class CustomPageContentLayout extends StatefulWidget {
  final D4PageType page;

  const CustomPageContentLayout({Key? key, required this.page})
      : super(key: key);

  @override
  State<CustomPageContentLayout> createState() =>
      _CustomPageContentLayoutState();
}

class _CustomPageContentLayoutState extends State<CustomPageContentLayout> {
  Widget getChild(BuildContext context) {
    double scale =
        Provider.of<NotesEditState>(context, listen: true).viewPortScale;
    return Container(
      color: Colors.red,
      child: MarkdownBody(
        styleSheet: MarkdownStyleSheet.fromTheme(
          ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
                fontSizeFactor: 0.2 * scale),
          ),
        ),
        data: "# Test Data \n # H1 \n ## H2 \n ### H3 \n test, test",
        selectable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) async {
        NotesEditState editState =
            Provider.of<NotesEditState>(context, listen: false);
        if (editState.isAdd()) {
          double scale = editState.viewPortScale;
          int top = details.localPosition.dy ~/ (5 * scale);
          int left = details.localPosition.dx ~/ (5 * scale);
          await Provider.of<DataBaseServiceBloc>(context, listen: false)
              .elementInsert(widget.page.id, top, left);
        }
      },
      child: FutureBuilder<List<ContentElement>>(
          future: Provider.of<DataBaseServiceBloc>(context, listen: true)
              .elementsDao
              .getByIDs(widget.page.contentIds),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: List.generate(
                  snapshot.data!.length,
                  (index) => CustomDraggable(
                    child: getChild(context),
                    contentElement: snapshot.data![index],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
