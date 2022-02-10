import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/widgets/custom_focus_node.dart';

import '../blocs/data_base_service_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../types/page_types.dart';

class CustomPageContentLayout extends StatefulWidget {
  final D4PageType page;

  const CustomPageContentLayout({Key? key, required this.page})
      : super(key: key);

  @override
  State<CustomPageContentLayout> createState() =>
      _CustomPageContentLayoutState();
}

class _CustomPageContentLayoutState extends State<CustomPageContentLayout> {
  late List<ContentElement> _contentElements;

  ContentElement? _contentHitDetection(
      {ContentElement? currentContent,
      double? top,
      double? left,
      double? height,
      double? width}) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;

    top ??= currentContent!.top * (5 * scale);
    left ??= currentContent!.left * (5 * scale);
    height ??= currentContent!.height * (5 * scale);
    width ??= currentContent!.width * (5 * scale);

    for (ContentElement contentElement in _contentElements) {
      if (currentContent != null) {
        if (contentElement.id == currentContent.id) {
          continue;
        }
      }
      if (contentElement.top * (5 * scale) < top &&
          contentElement.top * (5 * scale) +
                  contentElement.height * (5 * scale) >
              top) {
        if (contentElement.left * (5 * scale) < left &&
            contentElement.left * (5 * scale) +
                    contentElement.width * (5 * scale) >
                left) {
          return contentElement;
        }
      }
      if (contentElement.top * (5 * scale) < top + height &&
          contentElement.top * (5 * scale) +
                  contentElement.height * (5 * scale) >
              top + height) {
        if (contentElement.left * (5 * scale) < left + width &&
            contentElement.left * (5 * scale) +
                    contentElement.width * (5 * scale) >
                left + width) {
          return contentElement;
        }
      }
      // TODO check viewport bounds
    }
    return null;
  }

  void _reset() {
    setState(() {
      _top = null;
      _left = null;
      _height = null;
      _width = null;
      _currentContentElement = null;
      _placeholder = false;
    });
  }

  void _tapDown(details) {
    NotesEditState editState =
        Provider.of<NotesEditState>(context, listen: false);
    if (editState.isAdd()) {
      // TODO drag instead an then create ContentElement of Dragged box
      double scale = editState.viewPortScale;
      int top = details.localPosition.dy ~/ (5 * scale);
      int left = details.localPosition.dx ~/ (5 * scale);
      Provider.of<DataBaseServiceBloc>(context, listen: false)
          .elementInsert(widget.page.id, top, left);
    }
  }

  void _panStart(details) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;

    ContentElement? contentElement = _contentHitDetection(
        top: details.localPosition.dy,
        left: details.localPosition.dx,
        height: 0,
        width: 0);

    if (contentElement == null) {
      return;
    }

    setState(() {
      _leftOffset =
          details.localPosition.dx - (contentElement.left * (5 * scale));
      _topOffset =
          details.localPosition.dy - (contentElement.top * (5 * scale));
      _top = contentElement.top * (5 * scale);
      _left = contentElement.left * (5 * scale);
      _width = contentElement.width * (5 * scale);
      _height = contentElement.height * (5 * scale);
      _currentContentElement = contentElement;
    });
    if (notesEditState.isMove()) {
      setState(() {
        _placeholder = true;
      });
    } else if (notesEditState.isResize()) {
      // double margin = 0.5; // NOTE 1 is one box
      // double dx = details.localPosition.dx - contentElement.left * (5 * scale);
      // double dy = details.localPosition.dy - contentElement.top * (5 * scale);
      // double width = contentElement.width * (5 * scale);
      // double height = contentElement.height * (5 * scale);
      setState(() {
        // if (dx + (5 * scale) * margin > width) {
        //   if (dy + (5 * scale) * margin > height) {
        //     _placeholder = true;
        //     // _yResize = true;
        //     // _xResize = true;
        //   } else {
        //     _placeholder = true;
        //     // _xResize = true;
        //   }
        // } else if (dy + (5 * scale) * margin > height) {
        //   _placeholder = true;
        //   // _yResize = true;
        // }
        _placeholder = true;
      });
    }
  }

  void _panUpdate(details) {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;

    if (_currentContentElement == null) {
      return;
    }

    setState(() {
      if (notesEditState.isMove()) {
        _left = details.localPosition.dx - _leftOffset;
        _top = details.localPosition.dy - _topOffset;
      } else if (notesEditState.isResize()) {
        // if (_xResize) {
        //   _xTmp = details.localPosition.dx -
        //       widget.contentElement.left * (5 * scale);
        // }
        // if (_yResize) {
        //   _yTmp = details.localPosition.dy -
        //       widget.contentElement.top * (5 * scale);
        // }
        _width = details.localPosition.dx -
            _currentContentElement!.left * (5 * scale);
        _height = details.localPosition.dy -
            _currentContentElement!.top * (5 * scale);
      }
    });
  }

  void _panEnd(details) async {
    NotesEditState notesEditState =
        Provider.of<NotesEditState>(context, listen: false);
    double scale = notesEditState.viewPortScale;

    if (_currentContentElement == null) {
      _reset();
      return;
    }

    if (notesEditState.isMove()) {
      int top = (_top! / (5 * scale)).round();
      int left = (_left! / (5 * scale)).round();
      if (_contentHitDetection(
            currentContent: _currentContentElement,
            top: _top,
            left: _left,
          ) ==
          null) {
        Provider.of<DataBaseServiceBloc>(context, listen: false)
            .elementUpdatePosition(_currentContentElement!, top, left);
        _reset();
      } else {
        _reset();
      }
    } else if (notesEditState.isResize()) {
      int height = (_height! / (5 * scale)).round();
      int width = (_width! / (5 * scale)).round();
      if (_contentHitDetection(
            currentContent: _currentContentElement,
            height: _height,
            width: _width,
          ) ==
          null) {
        await Provider.of<DataBaseServiceBloc>(context, listen: false)
            .elementUpdateSize(_currentContentElement!, height, width);
        _reset();
      } else {
        _reset();
      }
    }
  }

  double? _topOffset;
  double? _leftOffset;
  double? _top;
  double? _left;
  double? _height;
  double? _width;
  bool _placeholder = false;
  ContentElement? _currentContentElement;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _tapDown(details),
      onPanStart: (details) => _panStart(details),
      onPanUpdate: (details) => _panUpdate(details),
      onPanEnd: (details) => _panEnd(details),
      child: FutureBuilder<List<ContentElement>>(
          future: Provider.of<DataBaseServiceBloc>(context, listen: true)
              .elementsDao
              .getByIDs(widget.page.contentIDs),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _contentElements = snapshot.data!; // TODO maybe change this
              double scale = Provider.of<NotesEditState>(context, listen: true)
                  .viewPortScale;
              return Stack(
                children: [
                  Stack(
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => Element(
                        id: snapshot.data![index].id,
                        left: snapshot.data![index].left * (5 * scale) +
                            (0.25 * scale),
                        top: snapshot.data![index].top * (5 * scale) +
                            (0.25 * scale),
                        height: snapshot.data![index].height * (5 * scale) -
                            (0.5 * scale),
                        width: snapshot.data![index].width * (5 * scale) -
                            (0.5 * scale),
                        contentType: snapshot.data![index].contentType,
                        contentIDs: snapshot.data![index].contentIDs,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _placeholder,
                    child: Element(
                      top: _top ?? 0,
                      left: _left ?? 0,
                      height: _height ?? 0,
                      width: _width ?? 0,
                    ),
                  ),
                ],
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

class Element extends StatefulWidget {
  final int? id;
  final double top;
  final double left;
  final double height;
  final double width;
  final ContentTypes? contentType;
  final List<int>? contentIDs;

  const Element(
      {Key? key,
      required this.top,
      required this.left,
      required this.height,
      required this.width,
      this.id,
      this.contentType,
      this.contentIDs})
      : super(key: key);

  // TODO handle contentElements of contentElements
  @override
  State<Element> createState() => _ElementState();
}

class _ElementState extends State<Element> {
  final TextEditingController _textEditingController = TextEditingController();
  String _contentText = "# Test\n blablabla\n";

  @override
  Widget build(BuildContext context) {
    _contentText = _textEditingController.text;
    print(_contentText);
    return Positioned(
      top: widget.top,
      left: widget.left,
      child: Stack(
        children: [
          if (widget.id == null ||
              !Provider.of<NotesEditState>(context, listen: true).isNone())
            Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade700,
                  width: 2.5,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          if (widget.id != null)
            SizedBox(
              height: widget.height,
              width: widget.width,
              child: FutureBuilder(
                future: Future(() => "Test"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    TextTheme theme = Theme.of(context).textTheme;
                    TextSpan spacer = const TextSpan(text: "  ");
                    TextSpan content = TextSpan(
                      // TODO generate content
                      style: theme.bodyText1,
                      children:
                          generateContentTextLayout(_contentText, context),
                    );
                    return CustomFocusNode(
                      id: widget.id!,
                      focusChild: EditableText(
                        controller: _textEditingController,
                        backgroundCursorColor: Colors.grey,
                        cursorColor: Colors.black,
                        focusNode: FocusNode(),
                        // NOTE max 32-bit int
                        maxLines: 0x7fffffff,
                        style: Theme.of(context).textTheme.bodyText1!,
                      ),
                      child: Provider.of<NotesEditState>(context, listen: true)
                              .isNone()
                          ? SelectableText.rich(content)
                          : RichText(text: content),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

List<InlineSpan> generateContentTextLayout(String input, BuildContext context) {
  TextTheme theme = Theme.of(context).textTheme;
  int indentionLevel = 0;
  List<InlineSpan> output = [];
  List<String> lines = input.split("\n");
  for (String line in lines) {
    if (line.startsWith("### ")) {
      indentionLevel = 2;
      output.addAll([
        TextSpan(text: (indentionLevel == 0 ? "" : "  " * indentionLevel)),
        TextSpan(
            text: line.replaceFirst("### ", "") + "\n", style: theme.headline4)
      ]);
    } else if (line.startsWith("## ")) {
      indentionLevel = 1;
      output.addAll([
        TextSpan(text: (indentionLevel == 0 ? "" : "  " * indentionLevel)),
        TextSpan(
            text: line.replaceFirst("## ", "") + "\n", style: theme.headline3)
      ]);
    } else if (line.startsWith("# ")) {
      indentionLevel = 0;
      output.addAll([
        TextSpan(text: (indentionLevel == 0 ? "" : "  " * indentionLevel)),
        TextSpan(
            text: line.replaceFirst("# ", "") + "\n", style: theme.headline2)
      ]);
    } else {
      output.addAll([
        TextSpan(text: ("  " * (indentionLevel + 1))),
        TextSpan(text: line + "\n")
      ]);
    }
  }
  return output;
}
