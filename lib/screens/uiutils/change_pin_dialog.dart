import 'package:amc/constants.dart';
import 'package:amc/screens/article/components/title_text.dart';
import 'package:amc/screens/uiutils/pin_form_widget.dart';
import 'package:amc/screens/uiutils/rounded_button.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChangePinDialog extends StatefulWidget{


  @override
  State createState() {
   return _ChangePinDialogState();
  }
}

class _ChangePinDialogState extends State<ChangePinDialog>{

  String current_pin;

  String new_pin;

  String re_new_pin;

  bool isLoading = false;

  NetworkService get networkService => GetIt.instance<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  @override
  Widget build(BuildContext context) {
    return isLoading? Center(
      child: CircularProgressIndicator(),
    ):

    Container(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          TitleText(text: 'Change Pin',),
        SizedBox(height: kDefaultMinPadding,),
        PinFormWidget(
          itemCount: 4,
          onSubmitted: (value){
            current_pin = value;
          },

          labelText: "Enter current pin",

        ),
            SizedBox(height: kDefaultMinPadding,),
        PinFormWidget(
          itemCount: 4,
          onSubmitted: (value){
            new_pin = value;
          },

          labelText: "Enter New Pin",

        ),
            SizedBox(height: kDefaultMinPadding,),

        PinFormWidget(
          itemCount: 4,
          onSubmitted: (value){
            re_new_pin = value;
          },

          labelText: "Retype new pin",

        ),
            SizedBox(height: kDefaultMinPadding,),
        RoundedButton(
          text: 'Submit',
          press: (){
            changePin();
          },
        )],
      )


      ),
    );
  }

  void changePin() async{
      setState(() {
        isLoading = true;
      });
          Map<String, dynamic> params = new Map();

          params['current_pin'] = current_pin;
          params['new_pin'] = new_pin;
          params['confirm_pin'] = re_new_pin;

          final response = await networkService.makeStringPostRequest(body: params, url: CHANGE_PIN_URL, includeToken:  true, context: context);

          debugPrint(response.data);

          if(response.error){
            setState(() {
              isLoading = false;
            });

            uiService.showToastMessage(message: response.errorMessage, context: context);
          }else{
            uiService.showToastMessage(message: 'Pin updated successfully');
            Navigator.of(context).pop(true);
          }




    //Call the change pin API
  }
}