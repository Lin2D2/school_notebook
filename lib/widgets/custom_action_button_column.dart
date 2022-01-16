import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/snack_bar_service.dart';
import '../blocs/mouse_cursor_state_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';

class CustomActionButtonColumn extends StatefulWidget {
  const CustomActionButtonColumn({Key? key}) : super(key: key);

  @override
  _CustomActionButtonColumnState createState() =>
      _CustomActionButtonColumnState();
}

class _CustomActionButtonColumnState extends State<CustomActionButtonColumn> {
  bool expanded = false;

  void menuButtonPressed() {
    setState(() {
      expanded = !expanded;
    });
  }

  void addButtonPressed() {
    MouseCursor cursorState =
        Provider.of<MouseCursorState>(context, listen: false).cursorState;
    if (cursorState == SystemMouseCursors.cell) {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.basic;
      Provider.of<NotesEditState>(context, listen: false).none();
      SnackBarService.createSimpleSnackBar(
          context: context,
          content: "Add Mode off",
          color: Colors.orange.shade400
      );
    } else {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.cell;
      Provider.of<NotesEditState>(context, listen: false).add();
      SnackBarService.createSimpleSnackBar(
          context: context,
          content: "Add Mode On",
          color: Colors.orange.shade400
      );
    }
  }

  void moveButtonPressed() {
    MouseCursor cursorState =
        Provider.of<MouseCursorState>(context, listen: false).cursorState;
    if (cursorState == SystemMouseCursors.grab) {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.basic;
      Provider.of<NotesEditState>(context, listen: false).none();
      SnackBarService.createSimpleSnackBar(
          context: context,
          content: "Edit Mode Off",
          color: Colors.orange.shade400
      );
    } else {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.grab;
      Provider.of<NotesEditState>(context, listen: false).move();
      SnackBarService.createSimpleSnackBar(
          context: context,
          content: "Edit Mode On",
          color: Colors.orange.shade400
      );
    }
  }

  void resizeButtonPressed() {
    MouseCursor cursorState =
        Provider.of<MouseCursorState>(context, listen: false).cursorState;
    if (cursorState == SystemMouseCursors.resizeDownRight) {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.basic;
      Provider.of<NotesEditState>(context, listen: false).none();
    } else {
      Provider.of<MouseCursorState>(context, listen: false).cursorState =
          SystemMouseCursors.resizeDownRight;
      Provider.of<NotesEditState>(context, listen: false).resize();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return FloatingActionButton(
        onPressed: () => menuButtonPressed(),
        child: const Icon(Icons.menu),
      );
    } else {
      // NOTE maybe use Stack instead an Animate it...
      return Column(
        verticalDirection: VerticalDirection.up,
        children: [
          FloatingActionButton(
            onPressed: () => menuButtonPressed(),
            child: const Icon(Icons.menu),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => addButtonPressed(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.delete),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => moveButtonPressed(),
            child: const Icon(Icons.auto_awesome_mosaic),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => resizeButtonPressed(),
            child: const Icon(Icons.aspect_ratio),
          ),
          // const SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: () {},
          //   child: const Icon(Icons.article),
          // ),
          // const SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: () {},
          //   child: const Icon(Icons.brush),
          // ),
          // const SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: () {},
          //   child: const Icon(Icons.add_photo_alternate),
          // ),
        ],
      );
    }
  }
}