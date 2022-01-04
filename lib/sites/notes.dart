import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/data_base_service_bloc.dart';
import '../blocs/navigator_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../widgets/custom_action_button_column.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/drawer_side_rail.dart';
import '../widgets/notes_d4_page_layout.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> folder = Provider.of<DataBaseServiceBloc>(context, listen: true)
        .folderDao.getNameByID(Provider.of<NavigatorBloc>(context, listen: true)
        .folder ?? 0);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
      ],
      child: SafeArea(
        child: DrawerSideRail(
          child: Scaffold(
            appBar: CustomAppBar(title: folder),
            drawer: const CustomDrawer(),
            persistentFooterButtons: [],
            floatingActionButton: const CustomActionButtonColumn(),
            body: const NotesD4PageLayout(),
          ),
        ),
      ),
    );
  }
}
