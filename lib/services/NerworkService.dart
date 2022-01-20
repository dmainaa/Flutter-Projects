import 'dart:async';
import 'dart:convert';

import 'package:amc/models/api_response.dart';

import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService{

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AppUtils appUtils = AppUtils();




  var  headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',

  };

  Future<String> getToken() async{
    final SharedPreferences prefs = await _prefs;
    String token = prefs.get('token');
    return token;
  }


  Future<APIResponse<String>>  makeStringPostRequest({Map<String, dynamic> body, String url, bool includeToken = false, BuildContext context}) async{
    bool isconnected  = await appUtils.checkInternetConnectivity();

    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();
      }



      return http.post(url , headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+ the_token
      }, body: json.encode(body)).then((data){


        debugPrint('Response Code: ${data.statusCode}');

        final jsonData = jsonDecode(data.body);

//      debugPrint(jsonData.toString());

        if(data.statusCode == 200){
          if(jsonData['status'] == false){
            String message = jsonData['message'];
            return APIResponse<String>(error: true, errorMessage: message);
          }else{
            return APIResponse<String>(data: data.body);
          }


        }else{

          return APIResponse<String>(error: true, errorMessage: 'An error occured');

        }
      }).catchError((error){
        debugPrint(error.toString());
        debugPrint('Something wrong happened');
        return APIResponse<String>(error: true, errorMessage: 'An error occured');
      });
    }else{
      return APIResponse<String>(error: true, errorMessage: 'Failed...Please check your internet connection');
    }
  }

  Future<APIResponse<String>> makeSimpleGetRequest({String url, bool includeToken = false, BuildContext context}) async{
    bool isconnected = await appUtils.checkInternetConnectivity();
    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();
      }

      return http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+ the_token
      }).then((data) {
        debugPrint('Server Response ${data.body}');
        debugPrint('Response Code: ${data.statusCode}');

        final jsonData = jsonDecode(data.body);

        if(data.statusCode == 200){

          if(jsonData['status'] == false){
            String message = jsonData['message'];
            return APIResponse<String>(error: true, errorMessage: message);
          }else{
            return APIResponse<String>(data: data.body);
          }

        }else{

          return APIResponse<String>(error: true, errorMessage: 'An error occured');

        }
      }).catchError((error){

      });
    }else{
      return APIResponse<String>(error: true, errorMessage: 'Failed...Please check your internet connection');
    }
  }

  Future<APIResponse<String>> getMediaRequest({String url, bool includeToken = false}) async{
    bool isconnected = await appUtils.checkInternetConnectivity();

    if(isconnected){
      String the_token = '';
      if(includeToken){
        the_token = await getToken();
      }

      String decoded_url = url;

      debugPrint(decoded_url);

      return http.get(decoded_url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+ the_token
      }).then((data) {
        debugPrint('Server Response ${data.body}');
        debugPrint('Response Code: ${data.statusCode}');

        final jsonData = jsonDecode(data.body);

        if(data.statusCode == 200){

          if(jsonData['status'] == false){
            String message = jsonData['message'];
            return APIResponse<String>(error: true, errorMessage: message);
          }else{
            return APIResponse<String>(data: data.body);
          }

        }else{

          return APIResponse<String>(error: true, errorMessage: 'An error occurred');

        }
      }).catchError((error){

      });
    }else{
      return APIResponse<String>(error: true, errorMessage: 'Failed...Please check your internet connection');
    }


  }

  Future<bool> checkConnectivity() async{
    bool isconnected = await appUtils.checkInternetConnectivity();
    return isconnected;
  }


  Future<APIResponse<String>> getArticleDescription({String url, BuildContext context}) async{
    bool isconnected = await appUtils.checkInternetConnectivity();

    if(isconnected){



      debugPrint(url);

      return http.read(url,
      ).then((data) {

        return APIResponse<String>(error: false, data: data);
      }).catchError((error){
        return APIResponse<String>(error: true, errorMessage: error.toString());
      });
    }else{
      return APIResponse<String>(error: true, errorMessage: 'Failed...Please check your internet connection');
    }


  }
}


