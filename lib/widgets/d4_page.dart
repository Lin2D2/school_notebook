import 'package:flutter/material.dart';

import 'd4_page_content_layout.dart';

Color paperColor = Colors.grey.shade200;

class D4PagePortrait extends StatelessWidget {
  final String title;
  final String date;
  final Widget child;

  final double height;
  final double width = 188;
  final double scale = 4;

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
      padding: EdgeInsets.all(5 * scale),
      child: Center(
        child: Container(
          color: paperColor,
          height: visible ? height * scale : 40 * scale,
          width: width * scale,
          child: CustomPaint(
            painter: visible
                ? BackgroundPaint(height, width, scale)
                : BackgroundPaint(40, width, scale),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5 * scale),
                  child: SizedBox(
                    height: 15 * scale,
                    width: width * scale,
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
                                title,
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
                                date,
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
                Visibility(
                  visible: visible,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          5 * scale, 0 * scale, 1.5 * scale, 2 * scale),
                      child: D4PageContentLayout(
                        scale: scale,
                      ),
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
                      child: Text(
                        "...",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 8 * scale,
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
