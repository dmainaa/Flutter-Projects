import 'dart:async';
import 'dart:convert';

import 'package:amc/constants.dart';
import 'package:amc/models/article.dart';
import 'package:amc/screens/allarticles/all_articles_card_item.dart';

import 'package:amc/screens/allarticles/m_article_view.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/payment_dialog.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AllArticlesScreen extends StatefulWidget{
  final String category;


  AllArticlesScreen({this.category});

  @override
  State createState() {
    return _AllArticlesScreenState();
  }
}

class _AllArticlesScreenState extends State<AllArticlesScreen>{

  bool isLoading = true;
  bool showError = true;

  String errorText = "";

  List<Article> allArticles;


  @override
  void initState() {
    fetchArticles();
  }

  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  AppUtils get appUtils => GetIt.I<AppUtils>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey
      ),

      child: SafeArea(
        child:  Builder(
          builder: (_){
            if(isLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(showError){
              return NoConnectionScreen(text: errorText, tryAgain: (){},);
            }else{
              return ListView.separated(itemBuilder: (context, index){
                return AllArticlesCardItem(article:  allArticles[index], onPressed: (article_id){
                    if(allArticles[index].access_type == 'free'){
                      //Go ahead and launch the article page
                      appUtils.NavigateToPage(context: context, destination: MArticleView(article: allArticles[index],));

                    }else{

                      requestPayment(article_id, index);

                    }
                },);
              },
                  separatorBuilder: (BuildContext context, int index){
                    return Divider(color: Colors.white, thickness: 0.1, height: 1.0,);
                  },
                  itemCount: allArticles.length);
            }
          },
        )

      ),
    );
  }

  void fetchArticles() async{

    setState(() {
      isLoading = true;

    });

    String url = GET_ALL_CATEGORY_ARTICLES_URL + widget.category;

    debugPrint(url);

    final response = await  networkService.makeSimpleGetRequest(url: url, includeToken: true, context: context);

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
      final jsonData = jsonDecode(response.data);

      final articlesjson = jsonData['articles'] as List;

      allArticles = articlesjson.map((e) => Article.fromJson(e)).toList();

      if(allArticles.isEmpty){
        setState(() {
          isLoading = false;
          showError  = true;
          errorText = 'There are no articles at the moment';
        });
      }else{
        setState(() {
          isLoading = false;
          showError  = false;
        });
      }


    }

  }

  void requestPayment(String media_id, int index) async{

    Map<String, dynamic> params = new Map();
    params['content_id'] = media_id;
    params['content_type'] = 'article';

    showPaymentDialog();


    final response = await networkService.makeStringPostRequest(body: params, url: REQUEST_PAY_URL, includeToken: true, context: context);

    debugPrint(response.data);
    if(response.error){
      debugPrint(response.errorMessage);
      if(response.errorMessage == 'Payment status is success'){
        Navigator.pop(context);
        appUtils.NavigateToPage(context: context, destination: MArticleView(article: allArticles[index],));
      }else{
        Navigator.of(context).pop(true);
        uiService.showToastMessage(message: response.errorMessage, context: context);
      }

    }else{
      debugPrint(response.data);
      final jsonData = jsonDecode(response.data);

      bool status = jsonData['status'];

      if(status){
        listenForPaymentCallback(media_id, index);
      }
    }
  }

  void listenForPaymentCallback(String media_id, int index) async{
    String url = PAYMENT_CALLBACK_URL + media_id;



    Timer(Duration(seconds: 3), () async{
      debugPrint("Time has lapsed");

      final response = await networkService.makeSimpleGetRequest(url: url, includeToken: true, context: context);
      debugPrint(response.data);
      if(!response.error){

        final jsonData = jsonDecode(response.data);
        String message = jsonData["message"];
        if(message == "status: success"){

          debugPrint('Request has been completed successfully');

          Navigator.pop(context);

          uiService.showToastMessage(context: context, message: 'Payment was successful');

          appUtils.NavigateToPage(context: context, destination: MArticleView(article: allArticles[index],));

        }else if(message == "status: pending"){

          listenForPaymentCallback(media_id, index);

          debugPrint('Request is still pending');

        }else{
          debugPrint('Request has failed');
        }


      }else{





      }
    });


  }

  void showPaymentDialog(){
    AlertDialog alertDialog = new AlertDialog(
      content: PaymentDialog(),
    );
    showDialog(context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: PaymentDialog(

            ),
          );
        },
        barrierDismissible: false
    );
  }


  }


