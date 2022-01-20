import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';

class DateText extends StatelessWidget{
  String text;


  DateText({this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultMinPadding, vertical: kDefaultMinPadding),
       child:   Text(
            this.text,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontStyle: FontStyle.italic


            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
      )
      ,
    );
  }


}