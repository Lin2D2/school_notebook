import 'package:flutter/material.dart';

import 'd4_page_content_layout.dart';


Color paperColor = Colors.grey.shade200;


class D4PagePortrait extends StatelessWidget {
  final String title;
  final String date;
  final Widget child;

  final double height;
  final double width = 188;
  final int scale = 5; // TODO cant change

  bool visible; // TODO use bloc instead

  D4PagePortrait(
      {Key? key,
      required this.child,
      required this.title,
      required this.date,
      this.height = 260,
      this.visible = true}) // Note min Value 40
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          color: paperColor,
          height: visible ? height * scale : 40.0 * scale,
          width: width * scale,
          child: CustomPaint(
            painter: visible
                ? BackgroundPaint(height, width, scale)
                : BackgroundPaint(40.0, width, scale),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: SizedBox(
                    height: 75,
                    width: width * scale,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(202, 2, 0, 0),
                          child: SizedBox(
                            height: 73,
                            width: 523,
                            child: Center(
                              child: Text(
                                title,
                                style: const TextStyle(
                                    // TODO other font
                                    color: Colors.black,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(52, 2, 0, 50),
                          child: SizedBox(
                            height: 23,
                            width: 148,
                            child: Center(
                              child: Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    letterSpacing: 8.25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: visible,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(52, 27, 40, 50),
                      child: D4PageContentLayout(),
                    ),
                  ),
                ),
                Visibility(
                  visible: !visible,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        visible = !visible;
                      },
                      child: const Text(
                        "...",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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
  final int scale;

  BackgroundPaint(this.height, this.width, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO only works with scale 5
    final heightScaled = height * scale;
    final widthScaled = width * scale;
    final heightLine = heightScaled ~/ (height / scale / ((1 / scale) * scale));
    final widthLine = widthScaled ~/ (width / scale / ((1 / scale) * scale));

    final paint = Paint();
    paint.color = Colors.grey.shade400;

    for (int i = 1; i < heightScaled; i++) {
      if (i % heightLine == 0) {
        Path linePath = Path();
        linePath.addRect(
            Rect.fromLTRB(0, i.toDouble(), widthScaled, (i + 2).toDouble()));
        canvas.drawPath(linePath, paint);
      }
    }
    for (int i = 1; i < widthScaled; i++) {
      if (i % widthLine == 0) {
        Path linePath = Path();
        linePath.addRect(
            Rect.fromLTRB(i.toDouble(), 0, (i + 2).toDouble(), heightScaled));
        canvas.drawPath(linePath, paint);
      }
    }

    paint.color = paperColor;

    // Heading space
    Path linePath = Path();
    linePath.addRect(const Rect.fromLTRB(202, 27, 725, 100));
    canvas.drawPath(linePath, paint);

    // Date space
    linePath = Path();
    linePath.addRect(const Rect.fromLTRB(777, 27, 925, 50));
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
