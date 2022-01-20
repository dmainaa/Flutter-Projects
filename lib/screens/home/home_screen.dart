import 'dart:convert';


import 'package:amc/constants.dart';
import 'package:amc/models/ad.dart';
import 'package:amc/models/home.dart';
import 'package:amc/models/scripture_home.dart';
import 'package:amc/screens/article/article_screen.dart';
import 'package:amc/screens/uiutils/ad_screen.dart';
import 'package:amc/screens/uiutils/cache_image.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  int selected_article = 0;

  bool checkConnectivity = true;

  ScriptureHome scriptureHome;

  String errorText = 'Failed...Please check your Internet Connection';





  List<Home> homeArticles;
  NetworkService get networkService => GetIt.I<NetworkService>();
  AppUtils get appUtils => GetIt.I<AppUtils>();


  @override
  void initState() {
    super.initState();
    fetchHomeDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Builder(
        builder: (_){

          if(!checkConnectivity){
          return NoConnectionScreen(text: errorText, tryAgain: (){
            fetchHomeDetails();
          },);
               }
          if(isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Column(

              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selected_article = 0;
                      });
                      navigateToArticle(context);
                    },
                      child: CacheImage(
                        image_url: homeArticles[0].image_url,
                        height: size.height * 0.2,
                        width: size.width,

                  ),

                )),
                SizedBox(height: 5.0,),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selected_article = 1;
                          });
                          navigateToArticle(context);
                        },
                        child: CacheImage(
                          image_url: homeArticles[1].image_url,
                          height: size.height * 0.2,
                          width: size.width /2 - 5.0,

                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                        flex: 1,
                        child:GestureDetector(
                          onTap: (){
                            setState(() {
                              selected_article = 2;
                            });
                            navigateToArticle(context);
                          },
                          child:  CacheImage(
                            image_url: homeArticles[2].image_url,
                            height: size.height * 0.2,
                            width: size.width /2 - 5.0,

                          ),
                        )

                    )
                  ],
                ),
                Container(


                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: Column(

                      children: <Widget>[
                        Text(
                         scriptureHome.description,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 15.0,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(scriptureHome.source,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 15.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Divider(
                          thickness: 2,
                        ),

                      ],
                    ),
                  ),
                )
              ],
            );
          }
        }
        ,)
    );
  }
  void fetchHomeDetails() async{
    setState(() {
      isLoading = true;
    });

    final response = await networkService.makeSimpleGetRequest(url: HOME_DETAILS_URL, includeToken: true, context: context);
    debugPrint(response.errorMessage);
    if(response.error){
      debugPrint(response.errorMessage);
      if(response.errorMessage == 'Failed...Please check your internet connection'){
        setState(() {

          checkConnectivity = false;
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading = false;
          checkConnectivity = true;
          errorText = response.errorMessage;


        });
      }


    }else {
      debugPrint(response.data.toString());

      final jsonData = jsonDecode(response.data);

      scriptureHome = ScriptureHome.fromJson(jsonData['scripture']);

      var jsonarticles = jsonData['articles'] as List;

      print(jsonarticles.runtimeType);

      homeArticles = jsonarticles.map((i) => Home.fromJson(i)).toList();

      print(homeArticles.length);

      setState(() {
        checkConnectivity = true;
        isLoading = false;
      });
    }



}

void navigateToArticle(BuildContext context){
    Navigator.push(context, new MaterialPageRoute(builder: (context){
      return ArticleScreen(articleHome: homeArticles[selected_article],);
    }));
}
}
