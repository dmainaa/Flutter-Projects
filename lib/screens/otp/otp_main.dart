import 'package:amc/constants.dart';
import 'package:amc/screens/login/login_screen.dart';
import 'package:amc/screens/otp/otp_screen.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pin_view/pin_view.dart';
import 'package:amc/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPMain extends StatefulWidget{
  final String phoneNumber;


  OTPMain({this.phoneNumber});

  @override
  State createState() {
    return _OTPMainState();
  }
}

class _OTPMainState extends State<OTPMain>{
  String entered_code;

  bool isLoading = true;

  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  AppUtils appUtils = GetIt.I<AppUtils>();


  @override
  void initState() {
    requestOTP();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Amc'),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor,
              kPrimaryColor.withOpacity(0.8)
            ],
            begin: Alignment.topRight
          )
        ),
        child: isLoading? Center(
          child: CircularProgressIndicator(),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('An SMS was sent to ${widget.phoneNumber}', style: TextStyle(
                  fontSize: MediaQuery.textScaleFactorOf(context) * 17,
          fontWeight: FontWeight.w400,
          color: Colors.white
          ,)
            )),
            SizedBox(height: kDefaultMinPadding),
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/icons/icon_read_message.png', color: Colors.white54,),
            ),

            Container(
              width: size.width * 4.5,
              child: Text (
                "Enter the code sent via sms",
                textAlign: TextAlign.center,
                style: TextStyle (
                    fontSize: MediaQuery.textScaleFactorOf(context) * 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                ),
              )),
            SizedBox(height: kDefaultMinPadding),
            PinView(
              count: 6,
              autoFocusFirstField: false,
              submit: (String pin){
                entered_code = pin;
                debugPrint("Entered pin" + pin);
              }, style: TextStyle(
              color: Colors.white
            ),
            ),
            SizedBox(height: kDefaultMinPadding),

            RoundedButton(
              text: "Submit",
              press: (){
                //call the verify pin api
                verifyOTP();
              },
              textColor: Colors.white,
            ),
            SizedBox(height: kDefaultMinPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("Didn't receive the code? ", style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: MediaQuery.textScaleFactorOf(context) * 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      ),
                    ),),

                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: (){
                        requestOTP(resend: true);
                      },
                      child: Text('Resend', style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: MediaQuery.textScaleFactorOf(context) * 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.green
                      ),
                      ),
                    ),
                  ),
                )
              ],
            ),


          ],
        ),
      ),
    );
  }

  void requestOTP({resend = false}) async{
    setState(() {
      isLoading = true;
    });
    String url = REQUEST_OTP_URL + widget.phoneNumber;

    debugPrint("otp url: " + url);
    final response = await networkService.makeSimpleGetRequest(url: url, includeToken: false, context: context);
    debugPrint(response.data);

    if(response.error){
      debugPrint("An error occurred");
      uiService.showToastMessage(message: response.errorMessage, context: context);

    }else{
      if(resend){
        uiService.showToastMessage(message: "Code was resent", context: context);
      }
      //verify the otp
    }
    setState(() {
      isLoading = false;
    });


  }

  void verifyOTP() async{
      uiService.showLoaderDialog(context);
      Map<String, dynamic> params = Map();

      params['phone'] = widget.phoneNumber;

      params['otp'] = entered_code;
      final response = await networkService.makeStringPostRequest(url: VERIFY_OTP_URL, body: params, includeToken: false, context: context);

      Navigator.of(context).pop(true);

      if(response.error){

        uiService.showToastMessage(message: response.errorMessage, context: context);

      }else{


        uiService.showToastMessage(message: "OTP has been verified successfully");

        //save verified to sharedpreferences

        saveVerification();

        appUtils.NavigateToPage(context: context, destination: LoginScreen());


      }


  }

  saveVerification() async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isVerified", true).then((bool success) => {
      debugPrint('Verification saved successfully')


    });

    prefs.setString("phoneNumber", widget.phoneNumber).then((value) => {
      debugPrint("PhoneNumber saved successfully")
    });
  }
}