import 'package:amc/constants.dart';
import 'package:amc/screens/uiutils/text_field_container.dart';

import 'package:flutter/material.dart';




class RoundedInputField extends StatelessWidget{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;

  RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.textEditingController
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: kPrimaryColor ,
            ),
            hintText: hintText
        ),

      ),
    );
  }


}