import 'dart:convert';

import 'package:amc/constants.dart';
import 'package:amc/models/scripture.dart';
import 'package:amc/screens/scriptures/scripture_card_item.dart';
import 'package:amc/screens/scriptures/scripture_view_screen.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScriptureScreen extends StatefulWidget{


  @override
  State createState() {
    return _ScriptureScreenState();
  }
}

class _ScriptureScreenState extends State<ScriptureScreen>{
  bool isLoading = true;
  bool showError = false;
  String errorText = '';

  AppUtils get appUtils => GetIt.I<AppUtils>();

  NetworkService get networkService => GetIt.instance<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  List<Scripture> allScriptures;


  @override
  void initState() {
    super.initState();
    fetchScriptures();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (_){
          if(isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(showError){
            return NoConnectionScreen(text: errorText, tryAgain: (){},);
          }else{
            return ListView.separated(
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      appUtils.NavigateToPage(context: context, destination: ScriptureViewScreen(scripture: allScriptures[index],));
                    },
                    child: ScriptureCardItem(scripture: allScriptures[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index){
                  return Divider(color: Colors.black, thickness: 0.3, height: 1.5,);
                },
                itemCount: allScriptures.length);
          }
        },
      ),
    );
  }
  void fetchScriptures() async{
    setState(() {
      isLoading = true;
    });

    final response = await networkService.makeSimpleGetRequest(url: GET_ALL_SCRIPTURES_URL, includeToken: true, context: context);
    
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
      
      final scripturesList = jsonData['scriptures'] as List;
      
      allScriptures = scripturesList.map((e) => Scripture.fromJson(e)).toList();

      if(allScriptures.isEmpty){
        setState(() {
          isLoading = false;
          showError = true;
          errorText = 'There are no scriptures at the moment';

        });
      }else{
        setState(() {
          isLoading = false;
          showError = false;
        });
      }
    }
  }
}