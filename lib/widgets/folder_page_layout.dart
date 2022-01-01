import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderPageLayout extends StatelessWidget {
  const FolderPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
      // shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width ~/ 400,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 188 / 260,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        Size size = MediaQuery.of(context).size;
        return Padding(
          padding: EdgeInsets.fromLTRB(
              15, 15, (index + 1) % (width ~/ 400) == 0 ? 15 : 0, 0),
          child: CustomPaint(
            // size: Size(400,400),
            painter: FolderPainter(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 5),
                    child: SizedBox(
                      height: (size.width * 0.097 / (width ~/ 400)).toDouble(),
                      // width: ((size.height * 0.175)).toDouble(),
                      child: Center(
                        child: Text(
                          "Test Side " + index.toString(),
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FolderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paintFolder = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2;
    var paintPaper = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 2;

    var pathFolder = Path();
    var pathPaper = Path();

    const double _borderRadius = 35;
    const double _slantOffset = 20;
    const double _paperOffset = 10;

    // NOTE paper
    pathPaper.moveTo(size.width - (_borderRadius * 2.5), _paperOffset);
    pathPaper.lineTo(size.width - _paperOffset, _paperOffset);

    pathPaper.lineTo(
        size.width - _paperOffset, size.height * 0.3333 + _slantOffset);
    pathPaper.lineTo(size.width - (_borderRadius * 2.5),
        size.height * 0.3333 - _slantOffset);

    pathPaper.close();

    canvas.drawPath(pathPaper, paintPaper);

    // NOTE folder
    pathFolder.moveTo(_borderRadius, size.height);
    canvas.drawCircle(Offset(_borderRadius, size.height - _borderRadius),
        _borderRadius, paintFolder);
    pathFolder.lineTo(0, size.height - _borderRadius);

    pathFolder.lineTo(0, _borderRadius);
    canvas.drawCircle(
        const Offset(_borderRadius, _borderRadius), _borderRadius, paintFolder);
    pathFolder.lineTo(_borderRadius, 0);

    pathFolder.lineTo(size.width * 0.9 - _borderRadius, 0);
    canvas.drawCircle(Offset(size.width * 0.9 - _borderRadius, _borderRadius),
        _borderRadius, paintFolder);
    pathFolder.lineTo(size.width * 0.9, _borderRadius);

    pathFolder.lineTo(size.width * 0.9, size.height * 0.33333 - _slantOffset);
    pathFolder.lineTo(size.width, size.height * 0.33333 + _slantOffset);

    pathFolder.lineTo(size.width, size.height - _borderRadius);
    canvas.drawCircle(
        Offset(size.width - _borderRadius, size.height - _borderRadius),
        _borderRadius,
        paintFolder);
    pathFolder.lineTo(size.width - _borderRadius, size.height);

    pathFolder.close();

    canvas.drawPath(pathFolder, paintFolder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
