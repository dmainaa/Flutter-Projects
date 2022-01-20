import 'package:amc/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width * 0.5,
      decoration: BoxDecoration(

        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            kPrimaryColor.withOpacity(0.8)
          ]
        )
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          SizedBox(height:kDefaultPadding,),
          Align(
            alignment: Alignment.center,
            child: Text("Processing Payment. \n Please Wait...", textAlign: TextAlign.center, style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontSize: kDefaultTitleFont,
              fontWeight: FontWeight.bold
            ),),
          )
        ],
      ),
    );
  }
}