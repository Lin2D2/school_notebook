import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/notes_edit_state_bloc.dart';

class CustomFocusNode extends StatefulWidget {
  final int id;
  final Widget focusChild;
  final Widget child;

  const CustomFocusNode(
      {Key? key,
      required this.id,
      required this.focusChild,
      required this.child})
      : super(key: key);

  @override
  State<CustomFocusNode> createState() => _CustomFocusNodeState();
}

class _CustomFocusNodeState extends State<CustomFocusNode> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // TODO do over the upper Gesture detector
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        Provider.of<NotesEditState>(context, listen: false)
          .activeFocusNode = widget.id;},
      child: Builder(
        builder: (context) {
          int? currentActive =
              Provider.of<NotesEditState>(context, listen: true)
                  .activeFocusNode;
          if (currentActive == widget.id) {
            return widget.focusChild;
          } else {
            return widget.child;
          }
        },
      ),
    );
  }
}
