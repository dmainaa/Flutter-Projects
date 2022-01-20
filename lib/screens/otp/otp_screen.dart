import 'package:amc/constants.dart';
import 'package:amc/screens/otp/keyboard_number.dart';
import 'package:amc/screens/otp/pin_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget{



  @override
  State createState() {
    return _OTPScreenState();
  }
}

class _OTPScreenState extends State<OTPScreen>{
  List<String> currentpin  = ["","","",""];

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent)
  );
  int pinIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildExitButton() ,
          Expanded(
            child: Container(
              alignment: Alignment(0, 0.5),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSecurityText(),
                  SizedBox(height: 40.0,),
                  buildPinRow(),
                  buildNumberPad()

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildExitButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: (){},
            minWidth: 50.0,
            height: 50.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Icon(Icons.clear, color: Colors.white,),
          ),

        ),

      ],
    );
  }
  buildPinRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PINNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: pinOneController
        ),
        PINNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: pinTwoController
        ),
        PINNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: pinThreeController
        ),
        PINNumber(
            outlineInputBorder: outlineInputBorder,
            textEditingController: pinThreeController
        ),
      ],
    );
  }

  buildSecurityText() {

    return Text("Security PIN", style: TextStyle(
        fontFamily: 'Raleway',
        color: Colors.white,
        fontSize: 21.0,
        fontWeight:  FontWeight.bold
    ),);
  }

  buildNumberPad(){
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 1,
                    onPressed: (){
                      pinIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: (){
                      pinIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: (){
                      pinIndexSetup("3");
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 4,
                    onPressed: (){
                      pinIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: (){
                      pinIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: (){
                      pinIndexSetup("6");
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 7,
                    onPressed: (){
                      pinIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: (){
                      pinIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: (){
                      pinIndexSetup("9");
                    },
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(

                      ),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: (){},
                  ),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      onPressed: (){
                        clearPin();
                      },
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),

                      ),
                      child: Image.asset('assets/icons/delete.png', color: Colors.white,),
                      
                    ),
                  )
                ],
              )


            ],
          ),
        ),
      ),
    );
  }
  pinIndexSetup(String text){

    if(pinIndex == 0){
      pinIndex = 1;
    }else if(pinIndex < 4){
      pinIndex ++;

    }

    setPin(pinIndex, text);

    currentpin[pinIndex - 1] = text;

    String strPin = "";

    currentpin.forEach((e) =>{
    strPin += e
    });

    if(pinIndex == 4){
      print(strPin);
    }
  }

  setPin(int n, String text){
    switch( n ){
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  clearPin(){
    if(pinIndex == 0){
      pinIndex = 0;
    }else if(pinIndex == 4){
      setPin(pinIndex, "");
      currentpin[pinIndex -1] = "";
      pinIndex--;
    }else{
      setPin(pinIndex, "");
      currentpin[pinIndex -1] = "";
      pinIndex--;
    }
  }

}



