import 'package:amc/constants.dart';
import 'package:amc/screens/login/login_screen.dart';
import 'package:amc/screens/splash/splash_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupServices();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });

}

void setupServices(){

  GetIt.instance.registerLazySingleton(() => NetworkService());
  GetIt.instance.registerLazySingleton(() => UIServices());
  GetIt.instance.registerLazySingleton(() => AppUtils());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: kPrimaryColor,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen()
    );
  }
}

