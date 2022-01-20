import 'package:amc/models/home.dart';
import 'package:amc/screens/article/components/date_text.dart';
import 'package:amc/screens/article/components/description_text.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:amc/screens/uiutils/cache_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget{
  final Home articleHome;


  ArticleScreen({this.articleHome});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TitleText(text: articleHome.title,),

            SizedBox(height: 5.0,),

            CacheImage(
              image_url: articleHome.image_url,
              height: size.height *0.3,
            ),

            SizedBox(height: 5.0,),

            DateText(text: articleHome.added_on,),

            SizedBox(height: 5.0,),

            DescriptionText(text: articleHome.description,)


          ],
        ),
      ),
    );
  }
}