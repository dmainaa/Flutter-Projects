import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';

class ExtraMainText extends StatelessWidget{

  final String title, content;
  final bool shouldShowTitle;
  final Color textColor;

  ExtraMainText({this.title, this.content, this.shouldShowTitle = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(

      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
      children: <Widget>[
      shouldShowTitle? Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: textColor
        ),),
      ): Container(),
    Align(
      alignment: Alignment.centerLeft,
      child: Text(content, style: TextStyle(
        fontFamily: 'Raleway',
        color: textColor,
        fontSize: 12.0,),

      ),
    )
    ],
    ),
      ),
    );
  }


}