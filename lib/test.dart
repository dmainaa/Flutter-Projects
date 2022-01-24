import 'package:flutter/material.dart';
import 'package:tutapp/app/app.dart';

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
