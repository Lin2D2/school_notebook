import 'package:flutter/material.dart';

import '../services/navigator_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static final Color backgroundColor = Colors.grey.shade800;
  static const double width = 80;
  static const double widthExpand = 200;
  static const double heightSpacer = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthExpand,
      color: backgroundColor,
      child: Column(
        children: [
          Container(
            height: width,
            width: widthExpand,
            color: Colors.blue,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Text("N"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Logout"),
                    ),
                    const Spacer(),
                  ],
                )),
          ),
          const SizedBox(
            height: heightSpacer,
          ),
          Material(
            color: backgroundColor,
            elevation: 20,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  (width + heightSpacer),
              child: ListView.builder(
                itemCount: NavigatorService.routes.length +
                    NavigatorService.routes.length -
                    1,
                itemBuilder: (BuildContext ctx, int index) {
                  if (index.isEven) {
                    return SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          NavigatorService.goTo(
                              context,
                              NavigatorService
                                  .routes[index ~/ 2]
                                  .route
                          );
                        },
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Icon(NavigatorService.routes[index ~/ 2].icon),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(NavigatorService.routes[index ~/ 2].name),
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
