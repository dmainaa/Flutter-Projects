import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';

class DescriptionText extends StatelessWidget{
  String text;

  DescriptionText({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultMinPadding, vertical: kDefaultMinPadding),
      child: Text(
        this.text,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 15.0,
        ),

      ),

    );
  }


}