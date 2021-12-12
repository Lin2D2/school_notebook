import 'package:flutter/material.dart';
import 'package:school_notebook/types/text_icon_pair.dart';

class SideNavigationRail extends StatefulWidget {
  final Widget child;
  final List<IconTextPair> navigationItems = [
    IconTextPair(Icons.home, "Dashboard"),
    IconTextPair(Icons.notes, "Notes"),
    IconTextPair(Icons.calendar_today, "Calender"),
    IconTextPair(Icons.check, "TODO"),
    IconTextPair(Icons.settings, "Settings"),
  ];
  bool expand = true; // TODO with bloc
  final Color backgroundColor = Colors.grey.shade800;
  final double width = 75;
  final double widthExpand = 170;
  final double heightSpacer = 10;

  SideNavigationRail({Key? key, required this.child}) : super(key: key);

  @override
  _SideNavigationRailState createState() => _SideNavigationRailState();
}

class _SideNavigationRailState extends State<SideNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: widget.expand ? widget.widthExpand : widget.width,
          color: widget.backgroundColor,
          child: Column(
            children: [
              Container(
                height: widget.width,
                width: widget.expand ? widget.widthExpand : widget.width,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: widget.expand
                      ? Row(
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
                        )
                      : const CircleAvatar(
                          radius: 28,
                          child: Text("N"),
                        ),
                ),
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
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: widget.expand
                                  ? Row(
                                      children: [
                                        Icon(widget
                                            .navigationItems[index ~/ 2].icon),
                                        const SizedBox(
                                          width: 26,
                                        ),
                                        Text(widget
                                            .navigationItems[index ~/ 2].text),
                                        const Spacer(),
                                      ],
                                    )
                                  : Icon(
                                      widget.navigationItems[index ~/ 2].icon),
                            ),
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
        ),
        Expanded(child: widget.child)
      ],
    );
  }
}
