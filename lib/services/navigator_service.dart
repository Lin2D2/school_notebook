import 'package:flutter/material.dart';

import '../types/navigator_item_type.dart';

class NavigatorService {
  static const List<NavigatorItemType> routes = [
    NavigatorItemType(
        icon: Icons.home,
        name: "Dashboard",
        route: "/dashboard"
    ),
    NavigatorItemType(
        icon: Icons.notes,
        name: "Notes",
        route: "/folder"
    ),
    NavigatorItemType(
        icon: Icons.calendar_today,
        name: "Calender",
        route: "/calender"
    ),
    NavigatorItemType(
        icon: Icons.check,
        name: "TODO",
        route: "/todo"
    ),
    NavigatorItemType(
        icon: Icons.settings,
        name: "Settings",
        route: "/settings"
    ),
  ];

  static void goTo(BuildContext context, String route) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.pushReplacementNamed(context, route);
    // context.read<IndexMainBloc>().id = id;
    // if (context.read<IndexMainBloc>().userFavorites.contains(id)) {
    //   context.read<IndexMainBloc>().index = context.read<IndexMainBloc>().userFavorites.indexOf(id);
    // }
  }
}
