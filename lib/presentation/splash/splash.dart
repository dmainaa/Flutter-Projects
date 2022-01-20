import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced/presentation/resources/assets_manager.dart';
import 'package:flutter_advanced/presentation/resources/color_manager.dart';
import 'package:flutter_advanced/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  Timer _timer = null;
  List lkfaj;

  _startDelay(){
    _timer = Timer(Duration(seconds: 3), ()async{
      _goNext();
    });
  }

  _goNext(){
    Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
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
