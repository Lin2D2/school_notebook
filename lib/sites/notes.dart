import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/notes_edit_state_bloc.dart';
import '../widgets/custom_action_button_column.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/notes_d4_page_layout.dart';

class Notes extends StatelessWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesEditState>(create:
            (_) => NotesEditState()),
      ],
      child:
      SafeArea(
        child: Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            persistentFooterButtons: const [],
            floatingActionButton: const CustomActionButtonColumn(),  // TODO move on wide screen to to overlab toolarea
            body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              CustomDrawer drawer = const CustomDrawer();
              NotesD4PageLayout notesD4Page = const NotesD4PageLayout();
              Widget notesFolderPage = const SizedBox();

              return Row(
                children: [
                  false ? drawer : const SizedBox(),
                  true ? notesD4Page : notesFolderPage,
                ],
              );
            },),
          ),
        ),
      );
  }
}
