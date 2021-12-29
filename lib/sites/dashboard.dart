import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body:
        // SideNavigationRail(
        //   child:
          const Center(
            child: Text("Dashboard"),
          ),
        // ),
      ),
    );
  }
}
