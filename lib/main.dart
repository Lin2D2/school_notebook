import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:io' show Platform;
import 'package:page_transition/page_transition.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite/sqflite.dart';

import 'blocs/mouse_cursor_state_bloc.dart';
import 'blocs/navigator_bloc.dart';
import 'blocs/notes_edit_state_bloc.dart';
import 'sites/dashboard.dart';
import 'sites/notes.dart';



void main() {
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  //   // Change the default factory
  //   databaseFactory = databaseFactoryFfi;
  // }

  runApp(App());
}


class App extends StatelessWidget {
  static const String _title = "School Notebook";
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigatorBloc()),
          ChangeNotifierProvider<MouseCursorState>(create: (_) => MouseCursorState()),
          ChangeNotifierProvider<NotesEditState>(create: (_) => NotesEditState()),
        ],
        child: MaterialApp(
          title: _title,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(background: Colors.grey.shade800),
          ),
          initialRoute: "/dashboard",
          onGenerateRoute: (route) {
            switch (route.name) {
              case '/dashboard':
                return PageTransition(
                  child: Dashboard(),
                  type: PageTransitionType.fade,
                  settings: route,
                );
              case '/notes':
                return PageTransition(
                  child: Notes(),
                  type: PageTransitionType.fade,
                  settings: route,
                );
              default:
                return PageTransition(
                  child: const SafeArea(child: Scaffold(body: Text("Not Found"))),
                  type: PageTransitionType.fade,
                  settings: route,
                );
            }
          },
          debugShowCheckedModeBanner: false,
        ),
    );
  }
  
}
