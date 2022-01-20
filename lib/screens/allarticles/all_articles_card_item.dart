import 'package:amc/constants.dart';
import 'package:amc/models/article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllArticlesCardItem extends StatelessWidget{
  final Article article;
  final Function(String) onPressed;


  AllArticlesCardItem({this.article, this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: GestureDetector(
        onTap: (){
          onPressed(article.id);
        },
        child: Padding(
          padding: EdgeInsets.all(kDefaultMinPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(article.image_url, width: size.width,
                  height: size.height * 0.2,
                  fit: BoxFit.fill),
              SizedBox(height: 1,),
              Text(article.title, style: appTitleTextStyle, overflow: TextOverflow.ellipsis,),
              Align(
                alignment: Alignment.centerRight,
                child: article.access_type == 'free'?
                Text('Free', style: TextStyle(
                  color: Colors.green,
                  fontSize: kDefaultTitleFont,

                ),):
                Text('Paid @${article.cost}', style: TextStyle(
                  color: Colors.red,
                  fontSize: kDefaultTitleFont,

                ),)
              )

            ],
          ),
        ),
      ),
    );
  }
}