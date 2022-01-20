import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  final Widget child;

  Background({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/maintop.png',
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/main_bottom.png',
              width: size.width * 0.2,
            ),
          ),
          child
        ],
      ),
    );
  }
}
