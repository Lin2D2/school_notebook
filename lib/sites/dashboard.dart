import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Future(() => "Dashboard"),),
        drawer: const CustomDrawer(),
        body: const Center(
          child: Text("Dashboard"),
        ),
      ),
    );
  }
}
