import 'package:amc/constants.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget{
  final Function tryAgain;
  final String text;


  NoConnectionScreen({this.tryAgain, this.text = 'Failed...Please Check Your Internet Connection'});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(text, style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20.0,
                color: Colors.red
            ),),
          ),
          SizedBox(height: kDefaultPadding,),
          RoundedButton(
            text: 'Try Again',
            press: tryAgain,
          )
        ],
      ),
    );
  }
}