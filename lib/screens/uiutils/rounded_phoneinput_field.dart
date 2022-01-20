import 'package:amc/constants.dart';
import 'package:amc/screens/uiutils/text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedPhoneInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;
  final bool shouldValidate;
  final Function(bool) validator;


  RoundedPhoneInputField(
      {this.hintText, this.icon, this.onChanged, this.textEditingController, this.shouldValidate = true, this.validator});

  @override
  State createState() {
    return _RoundedPhoneInputState();
  }
}



class _RoundedPhoneInputState extends State<RoundedPhoneInputField>{

  @override
  Widget build(BuildContext context) {
   return TextFieldContainer (
      child: TextFormField(
        controller: widget.textEditingController,
        onChanged: (value){
          setState(() {

          });
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              widget.icon,
              color: kPrimaryColor ,
            ),
            hintText: widget.hintText,
          errorText: validatePhone(widget.textEditingController.text)
        ),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

      ),
    );
  }

  String validatePhone(String value) {
    if(widget.shouldValidate){
      if(value.isEmpty){
        return null;
      }
      if ((value.length > 10)) {
        widget.validator(false);
        return "Enter a valid Phone Number";
      }else{
        widget.validator(true);

      }
    }else{
      return null;
    }

  }
}