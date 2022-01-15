import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/navigator_bloc.dart';
import 'custom_drawer.dart';

class CustomDrawerSideRail extends StatelessWidget {
  final Widget child;

  const CustomDrawerSideRail({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        CustomDrawer drawer = const CustomDrawer();

        return Row(
          children: [
            Provider.of<NavigatorBloc>(context, listen: true)
                        .sideNavigationRailState &&
                    MediaQuery.of(context).size.width > 1300
                ? drawer
                : const SizedBox(),
            Expanded(child: child)
          ],
        );
      },
    );
  }
}
