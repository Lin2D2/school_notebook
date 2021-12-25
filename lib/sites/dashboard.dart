import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/navigator_bloc.dart';
import 'package:school_notebook/widgets/side_navigation_rail.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SideNavigationRail(
          child: const Center(
            child: Text("Dashboard"),
          ),
        ),
      ),
    );
  }
}
