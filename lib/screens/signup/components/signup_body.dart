
import 'dart:convert';

import 'package:amc/constants.dart';
import 'package:amc/models/church.dart';
import 'package:amc/models/user_insert.dart';
import 'package:amc/screens/login/login_screen.dart';
import 'package:amc/screens/otp/otp_main.dart';
import 'package:amc/screens/uiutils/alreadyhaveanaccountcheck.dart';
import 'package:amc/screens/uiutils/login_background.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/pin_form_widget.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:amc/screens/uiutils/rounded_input_field.dart';
import 'package:amc/screens/uiutils/rounded_phoneinput_field.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignupBody extends StatefulWidget{


  @override
  State createState() {
    return _SignupBodyState();
  }
}

class _SignupBodyState extends State<SignupBody>{
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  TextEditingController repasswordEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();

  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  bool isvalidated = false;

  bool isLoading = false;

  bool isConnected = true;

  List<String> churches = [];
  List<Church> allChurches;
  String selected_church = "";
  String entered_pin;
  String reentered_pin;
  String errorText = '';


  @override
  void initState() {

    super.initState();
    getAllChurches();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Background(
        child: Builder(
          builder: (_){
            if(isLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(!isConnected){
              return (NoConnectionScreen(text: errorText, tryAgain: (){
                getAllChurches();
              },));
            }else{
             return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: 15),
                  Text('Sign Up',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 30.0


                    ),),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(kDefaultMinPadding),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select Church", style: appTitleTextStyle,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton(
                          items: churches.map((String dropdownItem) {
                            return DropdownMenuItem<String>(
                              value: dropdownItem,
                              child: Text(dropdownItem),

                            );
                          }
                          ).toList(),
                          style: TextStyle(
                              fontFamily: 'Raleway',

                              fontSize: MediaQuery.textScaleFactorOf(context) * 15,
                              color: kPrimaryColor
                          ),
                          onChanged: (String selectedItem){
                            setState(() {
                              selected_church = selectedItem;

                            });

                          },

                          value: selected_church,
                        ),
                      ),
                    ],
                  ),
                  RoundedInputField(
                    textEditingController: usernameEditingController,
                    icon: Icons.person,
                    hintText: 'Enter Username',
                    onChanged: (value){

                    },
                  ),

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

                    labelText: "Choose pin",

                  ),
                  PinFormWidget(
                    itemCount: 4,
                    onSubmitted: (value){
                      reentered_pin = value;
                    },

                    labelText: "Re-enter pin",

                  ),

                  RoundedButton(
                    text: "Sign Up",
                    press: (){

                      if(isvalidated){
                        if(validatePin()){
                          signUp();
                        }else{
                          uiService.showToastMessage(message: "Failed. Pin don't match", context: context);
                        }

                      }
                    },
                  ),
                  AlreadyHaveAnAccount(
                    login: false,
                    press: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context){
                        return LoginScreen();
                      }));
                    },
                  )

                ],
              );
            }
          },
        ),
      ),
    );
  }

  void signUp() async{

    if(entered_pin == reentered_pin){
      uiService.showLoaderDialog(context);
      UserInsert userInsert = UserInsert(username: usernameEditingController.text, pin: entered_pin, phoneNumber: phoneEditingController.text, churchName: selected_church);

      final response = await networkService.makeStringPostRequest(body: userInsert.toJson(), url: SIGNUP_URL, context: context);

      if(response.error){
        Navigator.of(context).pop(true);
        uiService.showToastMessage(message: response.errorMessage, context: context);
        debugPrint(response.data);

      }else{

        uiService.showToastMessage(message: 'Success', context: context);
        debugPrint(response.data);
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return OTPMain(phoneNumber: phoneEditingController.text,);
        }));
      }
    }else{
      uiService.showToastMessage(message: 'pin do not match', context: context);
    }


  }

  void requestOTP() async{

    setState(() {
      isLoading = true;
    });

    final response = await networkService.makeSimpleGetRequest(url: REQUEST_OTP_URL + phoneEditingController.text, includeToken: false, context: context);

    setState(() {
      isLoading = false;
    });
    if(response.error){

      uiService.showToastMessage(message: response.errorMessage);

    }else{
      //verify the otp
    }

  }

  bool validatePin(){
    return entered_pin == reentered_pin;
  }

  void getAllChurches() async{
    setState(() {
      isLoading = true;
    });

    final response = await networkService.makeSimpleGetRequest(url: GET_ALL_CHURCHES_URL, includeToken: false, context: context);

    debugPrint(response.data);

    if(response.error){
      if(response.errorMessage == "Failed...Please check your Internet connection"){
        setState(() {
          isLoading = false;
          isConnected = false;
        });
      }else{
        setState(() {
          isLoading = false;
          isConnected = false;
          errorText  = response.errorMessage;
        });
      }
    }else{
      final jsonData = jsonDecode(response.data);

      final jsonChurches = jsonData['churches'] as List;

      allChurches = jsonChurches.map((e){
       return Church.fromJson(e);
      }).toList();
      debugPrint(allChurches.length.toString());
      debugPrint(allChurches[0].id);
      for(int i= 0; i<allChurches.length; i++){

        debugPrint(i.toString());
        churches.add(allChurches[i].name);

      }

      setState(() {
        selected_church = allChurches[0].name;
        isLoading = false;
        isConnected = true;
      });
    }
  }



}