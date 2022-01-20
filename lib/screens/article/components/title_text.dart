import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';

class TitleText extends StatelessWidget{
  String text;


  TitleText({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultMinPadding, vertical: kDefaultMinPadding),
      child: Text(
        this.text,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: kPrimaryColor

        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}