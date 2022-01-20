import 'dart:convert';

import 'package:amc/constants.dart';
import 'package:amc/models/article.dart';
import 'package:amc/models/article_content.dart';
import 'package:amc/screens/allarticles/article_content_card_item.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:amc/screens/uiutils/cache_image.dart';
import 'package:amc/screens/uiutils/leave_comment_screen.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ArticleView extends StatefulWidget{
  String article_id;


  ArticleView({this.article_id});

  @override
  State createState() {
    return _ArticleViewState();
  }
}

class _ArticleViewState extends State<ArticleView>{

  List<ArticleContent> articleContents;

  Article article;

  bool isLoading = true;
  bool showError = false;
  bool noInternet = false;
  String errorText = '';

  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();
  AppUtils get appUtils => GetIt.I<AppUtils>();


  @override
  void initState() {
    fetchArticleContent();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
      ),
      body: Container(
        child: Builder(
          builder: (_){
            if(isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            if(showError){
              return NoConnectionScreen(text: errorText, tryAgain: (){},);
            }else{

               return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TitleText(text: article.title,),

                    SizedBox(height: 5.0,),

                    CacheImage(
                      image_url: article.image_url,
                      height: size.height *0.3,
                    ),

                    SizedBox(height: 5.0),
                    Flexible(
                      flex: 1,
                      child: ListView.builder(

                        itemCount: articleContents.length,
                        itemBuilder: (context, index){

                          if(index == articleContents.length - 1){
                            return LeaveCommentScreen(article_id: article.id,);
                          }else{
                            return ArticleContentCardItem(articleContent: articleContents[index],);
                          }

                        },
                      ),
                    ),
//                    Flexible(
//                      flex: 1,
//                      child: ListView.builder(
//
//                        itemCount: articleContents.length,
//                        itemBuilder: (context, index){
//
//                          if(index == articleContents.length - 1){
//                            return LeaveCommentScreen(article_id: article.id,);
//                          }else{
//                            return ArticleContentCardItem(articleContent: articleContents[index],);
//                          }
//
//                        },
//                      ),
//                    ),

//                  LeaveCommentScreen(article_id: article.id,)
                  ],

                );

            }
          },
        )
      ),
    );
  }

  void fetchArticleContent() async{
    setState(() {

      isLoading = true;
    });

  String url = GET_ARTICLE_URL + widget.article_id;

  debugPrint(url);

  final response = await networkService.makeSimpleGetRequest(url: url,  includeToken: true, context: context);

  if(response.error){
    if(response.errorMessage == noInternetString){
      setState(() {
        isLoading = false;
        noInternet = true;
        errorText = noInternetString;
      });
    }else{
      setState(() {
        isLoading = false;
        noInternet = true;
        errorText = response.errorMessage;
      });
    }
  }else{
    final jsonData = jsonDecode(response.data);

    final jsonArticle = jsonData['article'];

    article = Article.fromJson(jsonArticle);

    String rawDescription = jsonEncode(jsonArticle);

    final jsonDescription = jsonDecode(rawDescription);

    final jsonDescriptionList = jsonDescription['description'] as List;

    articleContents = jsonDescriptionList.map((e) => ArticleContent.fromJson(e)).toList();

    debugPrint('Fetched ' + articleContents.length.toString());
    if(articleContents.isEmpty){
      setState(() {
        isLoading = false;
        noInternet = false;
        errorText = 'There is no description at the moment';
      });
    }else{
      //Add one more item to cater for comments

      articleContents.add(new ArticleContent());
      setState(() {
        isLoading = false;
        noInternet = false;

      });
    }
  }
  }
}