import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

import 'blocs/data_base_service_bloc.dart';
import 'blocs/mouse_cursor_state_bloc.dart';
import 'blocs/navigator_bloc.dart';
import 'sites/dashboard.dart';
import 'sites/custom_page_view.dart';
import 'sites/folder_view.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const String _title = "School Notebook";

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigatorBloc()),
        ChangeNotifierProvider<MouseCursorState>(
            create: (_) => MouseCursorState()),
        ChangeNotifierProvider<DataBaseServiceBloc>(
            create: (_) => DataBaseServiceBloc()),
      ],
      child: MaterialApp(
        title: _title,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(background: Colors.grey.shade800),
          textTheme: const TextTheme()
              .apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          textTheme: const TextTheme()
              .apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
        initialRoute: "/dashboard",
        onGenerateRoute: (route) {
          switch (route.name) {
            case '/dashboard':
              return PageTransition(
                child: const Dashboard(),
                type: PageTransitionType.fade,
                settings: route,
              );
            case '/notes':
              return PageTransition(
                child: const CustomPageView(),
                type: PageTransitionType.fade,
                settings: route,
              );
            case '/folder':
              return PageTransition(
                child: const FolderView(),
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
