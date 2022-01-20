import 'package:amc/models/article_content.dart';
import 'package:amc/screens/article/components/description_text.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:flutter/cupertino.dart';

class ArticleContentCardItem extends  StatelessWidget{
  final ArticleContent articleContent;

  ArticleContentCardItem({this.articleContent});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TitleText(text: this.articleContent.title),
          ),
          DescriptionText(text: this.articleContent.paragraph,)

        ],
      ),
    );
  }
}