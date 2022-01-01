import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
      ],
      child: const SafeArea(
        child: DrawerSideRail(
          child: Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            persistentFooterButtons: [],
            floatingActionButton: CustomActionButtonColumn(),
            body: NotesD4PageLayout(),
          ),
        ),
      ),
    );
  }
}
