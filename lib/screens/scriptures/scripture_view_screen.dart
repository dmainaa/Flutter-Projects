import 'package:amc/constants.dart';
import 'package:amc/models/scripture.dart';
import 'package:amc/screens/article/components/date_text.dart';
import 'package:amc/screens/article/components/description_text.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScriptureViewScreen extends StatelessWidget{
  final Scripture scripture;


  ScriptureViewScreen({@ required this.scripture});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Scripture'),),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TitleText(text: scripture.title,),

              SizedBox(height: kDefaultMinPadding,),




              DateText(text: scripture.source,),

              SizedBox(height: 5.0,),

              DescriptionText(text: scripture.description,)


            ]
        ),
      );
  }
}