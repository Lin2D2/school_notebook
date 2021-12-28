import 'package:flutter/material.dart';

import '../types/text_icon_pair.dart';

class CustomDrawer extends StatefulWidget {
  final List<IconTextPair> navigationItems = [
    IconTextPair(Icons.home, "Dashboard"),
    IconTextPair(Icons.notes, "Notes"),
    IconTextPair(Icons.calendar_today, "Calender"),
    IconTextPair(Icons.check, "TODO"),
    IconTextPair(Icons.settings, "Settings"),
  ];
  final Color backgroundColor = Colors.grey.shade800;
  final double width = 80;
  final double widthExpand = 200;
  final double heightSpacer = 10;

  CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widthExpand,
      color: widget.backgroundColor,
      child: Column(
        children: [
          Container(
            height: widget.width,
            width: widget.widthExpand,
            color: Colors.blue,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Text("N"),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Logout"),
                    ),
                    Spacer(),
                  ],
                )),
          ),
          SizedBox(
            height: widget.heightSpacer,
          ),
          Material(
            color: widget.backgroundColor,
            elevation: 20,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  (widget.width + widget.heightSpacer),
              child: ListView.builder(
                itemCount: widget.navigationItems.length +
                    widget.navigationItems.length -
                    1,
                itemBuilder: (BuildContext ctx, int index) {
                  if (index.isEven) {
                    return SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Icon(widget.navigationItems[index ~/ 2].icon),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(widget.navigationItems[index ~/ 2].text),
                                const Spacer(),
                              ],
                            )),
                      ),
                    );
                  } else {
                    return const Divider(
                      thickness: 3,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
