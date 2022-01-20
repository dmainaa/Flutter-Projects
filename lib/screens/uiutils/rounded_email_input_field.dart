import 'package:amc/constants.dart';
import 'package:amc/screens/uiutils/text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedEmailInputField extends StatefulWidget

{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;
  final Function(bool) validator;


  RoundedEmailInputField({this.hintText, this.icon, this.onChanged, this.textEditingController, this.validator});

  @override
  State createState() {
    return RoundedEmailInputState();
  }


}


class RoundedEmailInputState extends State<RoundedEmailInputField>{

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(

        controller: widget.textEditingController,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(widget.icon, color: kPrimaryColor,),
            hintText: widget.hintText,
            errorText: validateEmail(widget.textEditingController.text)
        ),
        onChanged: (value){
          setState(() {

          });
        },
      ),
    );
  }

  String validateEmail(String value) {
    if(value.isNotEmpty){
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return (!regex.hasMatch(value)) ? 'Enter A Valid Email' : null;
    }else{
      return null;
    }

  }
}