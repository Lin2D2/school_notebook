import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../types/d4_page.dart';
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
        SafeArea(
      child: DrawerSideRail(
        child: Scaffold(
          appBar: const CustomAppBar(),
          drawer: const CustomDrawer(),
          persistentFooterButtons: [],
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () async {
              print("refresh");
              // Provider.of<DataBaseServiceBloc>(context, listen: false)
              //     .folderDao
              //     .insert(FolderType(
              //         contentIds: [5, 2],
              //         name: 'Green Test',
              //         color: Colors.green,
              //         id: 1));
            },
          ),
          body: const FolderPageLayout(),
        ),
      ),
      // ),
    );
  }
}
