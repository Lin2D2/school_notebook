import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

import 'blocs/navigator_bloc.dart';
import 'services/storage_service.dart';
import 'sites/dashboard.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StorageService storageServiceInstance = StorageService();
  storageServiceInstance.initStorage();
  runApp(App());
}


class App extends StatelessWidget {
  static const String _title = "School Notebook";
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigatorBloc()),
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
