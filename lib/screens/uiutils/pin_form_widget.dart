import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:pin_view/pin_view.dart';

class PinFormWidget extends StatelessWidget{
  final int itemCount;
  final String labelText;
  final Function(String) onSubmitted;


  PinFormWidget({this.itemCount, this.labelText, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.labelText, style: appTitleTextStyle,),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: PinView(
            obscureText: true,
            count: this.itemCount,
            autoFocusFirstField: false,
            submit: onSubmitted,
          ),
        )
      ],
    );
  }
}