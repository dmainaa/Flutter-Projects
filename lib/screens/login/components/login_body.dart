
import 'dart:convert';

import 'package:amc/models/api_response.dart';
import 'package:amc/models/user.dart';
import 'package:amc/screens/main/main_screen.dart';
import 'package:amc/screens/otp/otp_main.dart';

import 'package:amc/screens/uiutils/alreadyhaveanaccountcheck.dart';
import 'package:amc/screens/uiutils/login_background.dart';
import 'package:amc/screens/uiutils/pin_form_widget.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:amc/screens/uiutils/rounded_input_field.dart';
import 'package:amc/screens/uiutils/rounded_password_field.dart';
import 'package:amc/screens/signup/signup_screen.dart';
import 'package:amc/screens/uiutils/rounded_phoneinput_field.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBody extends StatefulWidget {

  @override
  State createState() {
    return _LoginBodyState();
  }
}

class _LoginBodyState extends State<LoginBody>{
  TextEditingController phoneEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AppUtils get appUtils => GetIt.I<AppUtils>();

  bool isvalidated = false;

  bool isVerified;

  String entered_pin;

  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Logging in..." )),
      ],),
  );


  @override
  void initState() {
    super.initState();
    requestPermissions();
    checkifloggedin();
  }

  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/amc_logo.PNG',
//              width: size.width * 0.8,
            ),
            SizedBox(height: 15),
            Text('LOGIN',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway',
                  fontSize: 30.0


              ),),
            RoundedPhoneInputField(
              textEditingController: phoneEditingController,
              icon: Icons.phone_android,
              hintText: 'Enter Phone Number',
              onChanged: (value){
                isvalidated = true;
              },

              validator: (value){
                isvalidated = value;
              },

              shouldValidate: true,
            ),

            PinFormWidget(

              itemCount: 4,
              onSubmitted: (value){
                entered_pin = value;
              },

              labelText: "Enter pin",

            ),

            RoundedButton(
              text: "Log In",
              press: (){

                loginUser();

//              appUtils.NavigateToPage(context: context, destination: OTPMain(phoneNumber: '0790090073',));
              },
            ),
            AlreadyHaveAnAccount(
              login: true,
              press: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context){
                    return SignupScreen();
                }));
              },
            )

          ],
        ),
      ),
    );
  }

  void loginUser() async{
    bool isconnected = await appUtils.checkInternetConnectivity();

    if(isconnected){
      uiService.showLoaderDialog(context);

      User user = User(phone: phoneEditingController.text, pin: entered_pin);

      final  response =  await networkService.makeStringPostRequest(body: user.toJson(), url: LOGIN_URL, context: context);

      Navigator.of(context).pop(true);
      if(response.error){

        debugPrint(response.errorMessage);

        if(response.errorMessage == 'User is not verified'){
          //launch the otp verification page
          uiService.showToastMessage(message: 'Your account has not been verified', context: context);

          appUtils.NavigateToPage(context: context, destination: OTPMain(phoneNumber: phoneEditingController.text,));
        }else
        if(response.errorMessage == 'use the phone you registered with'){
          uiService.showToastMessage(message: 'Your have not yet registered', context: context);
          appUtils.NavigateToPage(context: context, destination: SignupScreen());
        }


      }else{
        final jsonData = jsonDecode(response.data);
        String token = jsonData['Authorization'];
        debugPrint('Decoded Token ${token}');
        final SharedPreferences prefs = await _prefs;
        prefs.setString("token", token).then((bool success) => {
          debugPrint('Token inserted successfully')
        });

        prefs.setString("phoneNumber", phoneEditingController.text).then((bool success) => {
          debugPrint('PhoneNumber inserted successfully')
        });

        prefs.setBool('isloggedin', true).then((value) => debugPrint('Details updated successfully'));
        //show toast
        Navigator.push(context, new MaterialPageRoute(builder: (context){
          return MainScreen();
        }));

//      debugPrint(response.data);

      }
    }else{
      uiService.showToastMessage(message: "Failed...Please check your Internet connectivity", context: context);
    }

  }

  showLoaderDialog(BuildContext context){
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  checkifloggedin() async {
    final SharedPreferences prefs = await _prefs;
    bool isVerified = prefs.get('isVerified');
    bool isLoggedIn = prefs.get('isloggedin');

    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MainScreen();
          }
      ));
    }
  }


  requestPermissions() async{
      Map<Permission, PermissionStatus> statuses = await [

        Permission.storage,

      ].request();
      print(statuses[Permission.location]);

      if(await Permission.storage.isDenied){

        uiService.showToastMessage(message: 'The application needs the permissions', context: context);


      }
  }


}