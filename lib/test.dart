import 'package:flutter/material.dart';
import 'package:flutter_advanced/app/app.dart';

class Test extends StatelessWidget {

  void updateAppState(){
    MyApp.instance.appState = 0;
  }

  void getAppState(){
    print(MyApp.instance.appState);
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
