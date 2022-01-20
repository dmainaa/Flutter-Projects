import 'dart:convert';

import 'package:amc/constants.dart';
import 'package:amc/models/user_profile.dart';
import 'package:amc/screens/uiutils/change_pin_dialog.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:amc/screens/uiutils/rounded_input_field.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatefulWidget{


  @override
  State createState() {
    return _ProfileScreenState();
  }
}


class _ProfileScreenState extends State<ProfileScreen>{


  TextEditingController usernameEditingContoller = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();

  NetworkService get networkService => GetIt.instance<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  bool isLoading = true;

  bool showError = false;

  String errorText = '';


  @override
  void initState() {
    super.initState();
    usernameEditingContoller.text = 'John Doe';
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),

            ),
            SizedBox(width: 10.0,),
            Text('My Profile', style: TextStyle(
              fontFamily: 'Raleway',
              color: Colors.white,
            ),)
          ],
        ), ),
        body: Builder(
          builder: (_){
            if(isLoading){
              return Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if(showError){
              return NoConnectionScreen(text: errorText, tryAgain: (){},);
            }else{
              return Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Center(
                          child: Image.asset('assets/images/profile.png'),

                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text('Edit Profile', style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: kDefaultTitleFont
                      ),),
                      RoundedInputField(
                        textEditingController: usernameEditingContoller,
                        onChanged: (value){

                        },
                        icon: Icons.person,


                      ),

                      RoundedButton(
                        text: 'Change Pin',
                        press: (){
                          showSignUpScreen();
                        },
                      ),
                      RoundedButton(
                        text: 'Save Changes',
                        press: (){},
                      )


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

  void fetchUserDetails() async{

    setState(() {
      isLoading = true;
    });

    final response = await networkService.makeSimpleGetRequest(url: USER_PROFILE_URL, includeToken: true, context: context);


    if(response.error){

      if(response.errorMessage == noInternetString){
        setState(() {
          isLoading = false;
          showError = true;
          errorText = noInternetString;

        });
      }else{
        isLoading = false;
        showError = true;
        errorText = response.errorMessage;
      }
    }else{

      final jsonData = jsonDecode(response.data);

      UserProfile userProfile = UserProfile.fromJson(jsonData['user']);

      usernameEditingContoller.text = userProfile.username;
      
      setState(() {
          isLoading = false;
          showError = false;
      });
    }
  }

  void showSignUpScreen(){

    showDialog(
        context: context,
        builder: (BuildContext context){
          return ChangePinDialog();
        },
        barrierDismissible: true);
  }
}