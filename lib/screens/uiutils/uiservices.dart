import 'package:amc/constants.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UIServices {

  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text("Loading..")),
      ],),
  );


  showLoaderDialog(BuildContext context) {
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAdialog(BuildContext context, AlertDialog dialog) {
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }




  showToastMessage({String message, BuildContext context}) {

    Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER, backgroundColor: kPrimaryColor, textColor: Colors.white);

  }

}