import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_folder_layout.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_drawer_side_rail.dart';

class FolderView extends StatelessWidget {
  const FolderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomDrawerSideRail(
        child: Scaffold(
          appBar: CustomAppBar(title: Future(() => "Folder")),
          drawer: const CustomDrawer(),
          persistentFooterButtons: [],
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () async {
              print("refresh");
            },
          ),
          body: const CustomFolderLayout(),
        ),
      ),
    );
  }
}
