import 'dart:async';

import 'package:amc/constants.dart';
import 'package:amc/screens/login/login_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget{


  @override
  State createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>{





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      kPrimaryColor,
                      kPrimaryColor.withOpacity(0.8)
                    ]
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/amc_logo.PNG', fit: BoxFit.fitWidth,)
            ],
            
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: kDefaultPadding),
              child: CircularProgressIndicator(backgroundColor: Colors.white,),
              ),

            ],
          )

        ],

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return LoginScreen();
          }
        ));
    });
  }
}