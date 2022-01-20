import 'package:amc/constants.dart';
import 'package:amc/models/scripture.dart';
import 'package:amc/screens/article/components/description_text.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:flutter/cupertino.dart';

class ScriptureCardItem extends StatelessWidget{
  final Scripture scripture;




  ScriptureCardItem({this.scripture});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,


        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleText(text: scripture.title,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultMinPadding, vertical: kDefaultMinPadding),
              child: Text(
                scripture.description,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 12.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,

              ),

            )
          ],
        ),

    );
  }
}