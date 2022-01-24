import 'package:flutter/material.dart';
import 'file:///C:/Users/Denis%20Maina/AndroidStudioProjects/Advanced%20Flutter/flutter_advanced/lib/presentation/resources/theme_manager.dart';
import 'package:tutapp/presentation/resources/routes_manager.dart';

class MyApp extends StatefulWidget {
  MyApp._internal();//Private named constructor

  int appState = 0;

  static final MyApp instance = MyApp._internal();//single instance -> Singleton

  factory MyApp() => instance;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
