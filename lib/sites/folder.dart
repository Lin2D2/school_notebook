import 'package:flutter/material.dart';

import '../widgets/custom_action_button_column.dart';
import '../widgets/folder_page_layout.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/drawer_side_rail.dart';

class Folder extends StatelessWidget {
  const Folder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      // MultiProvider(
      // providers: [
      //   ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
      // ],
      // child:
    const SafeArea(
        child: DrawerSideRail(
          child: Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            persistentFooterButtons: [],
            // floatingActionButton: CustomActionButtonColumn(),
            body: FolderPageLayout(),
          ),
        ),
      // ),
    );
  }
}
