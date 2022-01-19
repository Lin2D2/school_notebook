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
          textTheme: const TextTheme( // TODO only works with scale 5, combine zoom and scale to zoom only
            bodyText1:
                TextStyle(color: Colors.black, fontSize: 16, height: 1.23),
            headline1: TextStyle(
              color: Colors.black,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 2
            ),
            headline2: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            headline3: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            headline5: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 6,
            ),
          ),
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
