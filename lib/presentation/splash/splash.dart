import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutapp/app/app_prefs.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/color_manager.dart';
import 'package:tutapp/app/di.dart';
import 'package:tutapp/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  late Timer _timer;
  late List lkfaj;
  AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay(){
    _timer = Timer(Duration(seconds: 3), ()async{
      _goNext();
    });
  }

  _goNext() async{
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
        if(isUserLoggedIn){
        Navigator.pushReplacementNamed(context, Routes.mainRoute)
        }else{
        _appPreferences.isOnBoardingScreenViewed().then((isOnBoardingScreenViewed) => {
          if(isOnBoardingScreenViewed){
            Navigator.pushReplacementNamed(context, Routes.loginRoute)
          }else{
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute)
          }
        })
        }
    });

  }


  @override
  void initState() {

    _startDelay();
    super.initState();
  }


  @override
  void dispose() {

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary ,
      body: Center(child: Image(image: AssetImage(AssetsManager.splashLogo),))
      ,
    );
  }
}
