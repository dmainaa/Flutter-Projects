import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccesPaymentDialog extends StatelessWidget{
  final Function cancelPressed;
  final Function downloadsPagePressed;


  SuccesPaymentDialog({this.cancelPressed, this.downloadsPagePressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width * 0.5,
      decoration: BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimaryColor,
                kPrimaryColor.withOpacity(0.8)
              ]
          )
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/icons/icon_approved.png',
            ),
          ),
          SizedBox(height:kDefaultPadding,),
          Align(
            alignment: Alignment.center,
            child: Text("Payment was successful.", textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: kDefaultTitleFont,
                fontWeight: FontWeight.bold
            ),),
          ),
          SizedBox(height: size.height * 0.03,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: cancelPressed,
                  child: Padding(
                    padding: EdgeInsets.only(left: kDefaultMinPadding),
                    child: Text(

                      'Cancel', style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.red,
                        fontSize: MediaQuery.textScaleFactorOf(context) * 17
                    ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: downloadsPagePressed,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                    padding: EdgeInsets.only(right: kDefaultMinPadding),
                      child: Text(
                        'GO TO DOWNLOADS', style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.green,
                          fontSize: MediaQuery.textScaleFactorOf(context) * 15
                      ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}