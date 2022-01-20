import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtraTop extends StatelessWidget{
  final String title, description;


  ExtraTop({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: <Widget>[
            Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 12.0,
                fontWeight: FontWeight.bold
            ),
        )),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(description, style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 12.0,),



                )
              ,
            )
          ],
        )
    );

  }
}