import 'package:amc/constants.dart';
import 'package:flutter/material.dart';


class AlreadyHaveAnAccount extends StatelessWidget{
  final bool login;
  final Function press;

  AlreadyHaveAnAccount({Key key, this.login = false, this.press}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login? "Don't have an account? " : "Already have an account "
          , style: TextStyle(
          color: kPrimaryColor,

        ),),
        GestureDetector(
          onTap: press,
          child: Text(
            login? 'Sign up' : 'Sign In',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,

            ),
          ),
        )
      ],
    );
  }
}