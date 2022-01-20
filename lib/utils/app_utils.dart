import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AppUtils{

  Future<bool> checkInternetConnectivity() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Connected');
        return true;
      }else{
        return false;
      }
    } on SocketException catch (_) {

      print('not connected');
      return false;
    }
  }


  NavigateToPage({BuildContext context, Widget destination}){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context){
      return destination;
    }));
  }


}