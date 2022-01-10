import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/navigator_bloc.dart';
import 'package:school_notebook/services/navigator_service.dart';

import '../blocs/data_base_service_bloc.dart';
import '../types/d4_page.dart';

class FolderElement extends StatefulWidget {
  final int index;
  final FolderType folder;

  const FolderElement({Key? key, required this.index, required this.folder})
      : super(key: key);

  @override
  _FolderElementState createState() => _FolderElementState();
}

class _FolderElementState extends State<FolderElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool menuOpen = false;

  @override
  void initState() {
    super.initState();
    Duration _duration = const Duration(milliseconds: 200);
    _controller = AnimationController(
        duration: _duration, reverseDuration: _duration, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Provider.of<NavigatorBloc>(context, listen: false).folder =
            widget.folder.id;
        NavigatorService.goTo(context, "/notes");
      },
      child: MouseRegion(
        onEnter: (event) => _controller.forward(),
        onExit: (event) => _controller.reverse(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.grey.shade100,
              ),
            ),
            SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 5),
                      child: SizedBox(
                        height: (size.width * 0.097 / (size.width ~/ 400))
                            .toDouble(),
                        // width: ((size.height * 0.175)).toDouble(),
                        child: Center(
                          child: Text(
                            widget.folder.name,
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
            SizedBox(
              width: size.width,
              height: size.height,
              child: AnimatedBuilder(
                animation: _controller,
                child: CustomPaint(
                  painter: FolderPainter(widget.folder.color),
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    transform: Matrix4.rotationX(0)
                      ..multiply(Matrix4.rotationY(
                          _controller.value * 0.33333)) // 0.15
                      ..multiply(Matrix4.rotationZ(0)),
                    alignment: Alignment.bottomLeft,
                    child: child,
                  );
                },
              ),
            ),
            SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        splashRadius: 25,
                        onPressed: () {
                          setState(() {
                            menuOpen = !menuOpen;
                          });
                        },
                      ),
                    ),
                    if (menuOpen)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "edit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    if (menuOpen)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () {
                            // TODO confirmation
                            Provider.of<DataBaseServiceBloc>(context, listen: false)
                                .folderDao.delete(widget.folder);
                          },
                          child: const Text(
                            "remove",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class FolderPainter extends CustomPainter {
  final Color color;

  FolderPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paintFolder = Paint()
      ..color = color
      ..strokeWidth = 2;

    var pathFolder = Path();

    const double _borderRadius = 35;
    const double _slantOffset = 20;

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
