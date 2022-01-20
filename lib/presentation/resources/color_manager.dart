import 'package:flutter/material.dart';

class ColorManager{
  static Color primary = Color(0xFFED9728);
  static Color darkGrey = Color(0xFF525252);
  static Color grey  = Color(0xFF737477);
  static Color white  =Color(0xFFFFFFFF);
  static Color lightgrey = Color(0xFF9E9E9E);
  static Color primaryOpacity70 = Color(0xffED9728);

  static Color darkprimary = Color(0xFFd17d11);
  static Color grey1 = Color(0xFF707070);
  static Color grey2  = Color(0xFF737477);

  static Color error = Color(0xFFe61f34);

}

extension HexColor on Color{
  static Color fromHex(String hexColorString){
    hexColorString = hexColorString.replaceAll("#", "");
    if(hexColorString.length == 6){
      hexColorString = "FF" + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}