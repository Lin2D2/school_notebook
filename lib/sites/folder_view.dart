import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
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
          persistentFooterButtons: const [],
          floatingActionButton: FloatingActionButton(
            // TODO only here for debugging
            child: const Icon(Icons.delete),
            onPressed: () async {
              if (kDebugMode) {
                print("deleted: ");
                print(await Provider.of<DataBaseServiceBloc>(context,
                        listen: false)
                    .purgeDatabase()); // TODO only here for debugging
              }
            },
          ),
          body: const CustomFolderLayout(),
        ),
      ),
    );
  }
}
