import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_notebook/blocs/data_base_service_bloc.dart';

import '../blocs/navigator_bloc.dart';
import '../blocs/notes_edit_state_bloc.dart';
import '../types/page_types.dart';
import '../widgets/custom_action_button_column.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_drawer_side_rail.dart';
import '../widgets/custom_page_layout.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
      ],
      child: SafeArea(
        child: CustomDrawerSideRail(
          child: Scaffold(
            appBar: CustomAppBar(
              title: Provider.of<DataBaseServiceBloc>(context, listen: true)
                  .folderDao
                  .getByID(Provider.of<NavigatorBloc>(context, listen: true)
                      .folderID!)
                  .then((value) => value.name),
            ),
            drawer: const CustomDrawer(),
            persistentFooterButtons: [
              Row(
                children: const [
                  ZoomWidget(),
                ],
              )
            ],
            floatingActionButton: const CustomActionButtonColumn(),
            body: const CustomPageLayout(),
          ),
        ),
      ),
    );
  }
}

class ZoomWidget extends StatelessWidget {
  const ZoomWidget({Key? key}) : super(key: key);
  static const double _size = 15;
  static const EdgeInsetsGeometry _padding = EdgeInsets.all(0);
  static const double stepSize = 0.125;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: Row(
        children: [
          IconButton(
            iconSize: _size,
            splashRadius: _size,
            padding: _padding,
            constraints: BoxConstraints.tight(const Size(_size, _size)),
            icon: const Icon(Icons.add),
            onPressed: () {
              NotesEditState editState =
                  Provider.of<NotesEditState>(context, listen: false);
              editState.viewPortZoom = editState.viewPortZoom + stepSize;
            },
          ),
          const Spacer(),
          IconButton(
            iconSize: _size,
            splashRadius: _size,
            padding: _padding,
            constraints: BoxConstraints.tight(const Size(_size, _size)),
            icon: const Icon(Icons.remove),
            onPressed: () {
              NotesEditState editState =
                  Provider.of<NotesEditState>(context, listen: false);
              editState.viewPortZoom = editState.viewPortZoom - stepSize;
            },
          ),
          const Spacer(),
          SizedBox(
            height: _size,
            width: _size * 2.5,
            child: Center(
              child: Text(
                (Provider.of<NotesEditState>(context, listen: true)
                                .viewPortZoom *
                            100)
                        .toInt()
                        .toString() +
                    "%",
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
