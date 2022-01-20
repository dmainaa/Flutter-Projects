import 'package:amc/constants.dart';
import 'package:amc/models/article.dart';
import 'package:amc/screens/uiutils/cache_image.dart';
import 'package:amc/screens/uiutils/leave_comment_screen.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';

class MArticleView extends StatefulWidget{
  final Article article;


  MArticleView({this.article});

  @override
  State createState() {
    return _MArticleViewState();
  }
}

class _MArticleViewState extends State<MArticleView>{

  String htmlData = "";

  bool isLoading = true;
  bool showError = false;
  String errorText = '';



  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();


  @override
  void initState() {
    super.initState();
    fetchArticleContents();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Article'),),
      body: SingleChildScrollView(
        child: Builder(
          builder: (_){
            if(isLoading){
              return Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(child: CircularProgressIndicator(),),
              );
            }

            if(showError){
              return NoConnectionScreen(text: errorText, tryAgain: (){
                  fetchArticleContents();
              });
            }else{
              return Column(
                children: [
                  CacheImage(image_url: widget.article.image_url, width: size.width - 10.0, height: size.height * 0.2,),

                  Html(

                    data: htmlData,

                  ),
                  SizedBox(height: kDefaultMinPadding,),
                  Row(
                    children: [
                      LeaveCommentScreen(article_id: widget.article.id,)
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  fetchArticleContents() async{
    setState(() {

      isLoading = true;
    });
    final response = await networkService.getArticleDescription(url: widget.article.article_url, context: context);
    debugPrint(response.data);
    if(response.error){
      if(response.errorMessage == noInternetString){
        setState(() {
          isLoading = false;
          showError = true;
          errorText = noInternetString;
        });
      }else{

        setState(() {
          isLoading = false;
          showError = true;
          errorText = response.errorMessage;
        });

      }

    }else{
      setState(() {
        isLoading = false;
        showError = false;
        htmlData = response.data;
      });
    }
  }
}