import 'package:flutter/material.dart';
import 'package:tutapp/app/app.dart';
import 'package:tutapp/app/di.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}

