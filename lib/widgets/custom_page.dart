import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../types/page_types.dart';
import '../blocs/notes_edit_state_bloc.dart';
import 'custom_page_content_layout.dart';

Color paperColor = Colors.grey.shade200;

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
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              40 * scale, 2 * scale, 0 * scale, 0 * scale),
                          child: SizedBox(
                            height: 15 * scale,
                            width: 105 * scale,
                            child: Center(
                              child: Text(
                                widget.page.name,
                                style: TextStyle(
                                    // TODO other font
                                    color: Colors.black,
                                    fontSize: 10 * scale,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              10 * scale, 0 * scale, 0 * scale, 10 * scale),
                          child: SizedBox(
                            height: 5 * scale,
                            width: 30 * scale,
                            child: Center(
                              child: Text(
                                widget.page.date,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 4 * scale,
                                    letterSpacing: 1.5 * scale),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        5 * scale, 0 * scale, 1.5 * scale, 2 * scale),
                    child: const CustomPageContentLayout(),
                  ),
                ),
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
    paint.color = Colors.grey.shade400;

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

    paint.color = paperColor;

    // Heading space
    Path linePath = Path();
    linePath
        .addRect(Rect.fromLTRB(40 * scale, 5 * scale, 145 * scale, 20 * scale));
    canvas.drawPath(linePath, paint);

    // Date space
    linePath = Path();
    linePath.addRect(
        Rect.fromLTRB(155 * scale, 5 * scale, 185 * scale, 10 * scale));
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}