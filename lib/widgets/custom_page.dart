import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../types/page_types.dart';
import '../blocs/notes_edit_state_bloc.dart';
import 'custom_focus_node.dart';
import 'custom_page_content_layout.dart';

class CustomPage extends StatefulWidget {
  final D4PageType page;

  const CustomPage(
    this.page, {
    Key? key,
  }) : super(key: key);

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final Color paperColor = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    double scale =
        Provider.of<NotesEditState>(context, listen: true).viewPortScale;
    return Padding(
      padding: EdgeInsets.all(5 * scale),
      child: Center(
        child: Container(
          color: paperColor,
          height: widget.page.height * scale,
          width: widget.page.width * scale,
          child: CustomPaint(
            painter:
                BackgroundPaint(widget.page.height, widget.page.width, scale),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5 * scale),
                  child: SizedBox(
                    height: 15 * scale,
                    width: widget.page.width * scale,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 35 * scale,
                          height: 15 * scale,
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              height: 15 * scale,
                              width: widget.page.name.length * 6.85 * scale,
                              // NOTE max length 20 or 18?
                              color: paperColor,
                              child: Center(
                                child: CustomFocusNode(
                                  id: widget.page.id,
                                  focusChild: EditableText(
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController(),
                                    // TODO save
                                    backgroundCursorColor: Colors.grey,
                                    cursorColor: Colors.black,
                                    focusNode: FocusNode(),
                                    style:
                                        Theme.of(context).textTheme.headline1!,
                                  ),
                                  child: Text(
                                    widget.page.name,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 38 * scale,
                          height: 15 * scale,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                5 * scale, 0, 8 * scale, 10 * scale),
                            child: Container(
                              height: 5 * scale,
                              width: 30 * scale,
                              color: paperColor,
                              child: Center(
                                child: CustomFocusNode(
                                  id: widget.page.id + 1,
                                  focusChild: EditableText(
                                    controller: TextEditingController(),
                                    // TODO save
                                    backgroundCursorColor: Colors.grey,
                                    cursorColor: Colors.black,
                                    focusNode: FocusNode(),
                                    style:
                                        Theme.of(context).textTheme.headline6!,
                                  ),
                                  child: Text(
                                    widget.page.date,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          5 * scale, 0 * scale, 3 * scale, 5 * scale),
                      child: Stack(
                        children: [
                          if (!Provider.of<NotesEditState>(context,
                                  listen: true)
                              .isNone())
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                  width: 2.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          CustomPageContentLayout(page: widget.page),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPaint extends CustomPainter {
  final double height;
  final double width;
  final double scale;

  BackgroundPaint(this.height, this.width, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.grey.shade300;

    for (int i = 1; i < height * scale; i++) {
      if (i % (5 * scale) == 0) {
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(0, i.toDouble() - 0.3 * scale,
            width * scale, i.toDouble() + 0.3 * scale));
        canvas.drawPath(linePath, paint);
      }
    }
    for (int i = 1; i < width * scale; i++) {
      if (i % (5 * scale) == 0) {
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(i.toDouble() - 0.3 * scale, 0,
            i.toDouble() + 0.3 * scale, height * scale));
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
