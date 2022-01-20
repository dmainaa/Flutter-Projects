import 'package:amc/constants.dart';

import 'package:amc/screens/uiutils/text_field_container.dart';
import 'package:flutter/material.dart';



class RoundedPasswordField extends StatefulWidget{
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController controller;
  final Function(bool) validator;
  final bool shouldvalidate;


  RoundedPasswordField({Key key, this.onChanged, this.hintText, this.controller, this.validator, this.shouldvalidate = true}): super(key: key);

  @override
  State createState() {
    return RoundedPasswordState();
  }


}

class RoundedPasswordState extends State<RoundedPasswordField>{
  bool visibility = true;
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';


  @override
  Widget build(BuildContext context) {
    return  TextFieldContainer(
      child: TextField(
        controller: widget.controller,
        obscureText: visibility,
        onChanged: (value){
          setState(() {

          });
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(Icons.lock, color: kPrimaryColor,),
          suffixIcon: IconButton(
            icon:  Icon(visibility? Icons.visibility: Icons.visibility_off, color: kPrimaryColor,),
            onPressed: (){
              if(visibility){
                setState(() {
                  visibility = false;
                });
              }else{
                setState(() {
                  visibility = true;
                });
              }

            },
          ),
          border:  InputBorder.none,
          errorText: validatePassword(widget.controller.text)

        ),

      ),
    );
  }

  String validatePassword(String value) {
    if(widget.shouldvalidate){
      if(value.isEmpty){
        return null;
      }
      if (!(value.length > 5)) {
        widget.validator(false);
        return "Password should contains more then 5 character";
      }else{
        if(validateStructure(value)){
          widget.validator(true);
          return null;
        }else{
          return "must have one uppercase, lowercase and special character";
        }

      }
    }else{
      return null;
    }

  }

  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}