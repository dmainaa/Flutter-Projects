import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';

class NoMediaWidget extends StatelessWidget{

 final  String messageText;


 NoMediaWidget({this.messageText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(messageText, style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: kDefaultTitleFont,
          color: kPrimaryColor
      ),),
    );
  }
}