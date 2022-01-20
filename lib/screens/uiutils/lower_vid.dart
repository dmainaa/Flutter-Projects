import 'package:amc/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LowerVid extends StatelessWidget{
  final Function addPress;
  final Function forwardPress;
  final String mediaTitle;


  LowerVid({Key key, this.addPress, this.forwardPress, this.mediaTitle}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width:  size.width,
      height:  size.height*0.1,

      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: kDefaultPadding),
              child: Text(mediaTitle, style: appTitleTextStyle,),
            ),
          ),
//        Expanded(
//          flex: 1,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              IconButton(icon: Icon(Icons.playlist_add,)),
//              SizedBox(width: 10.0,),
//              IconButton(icon: Icon(Icons.share,)),
//            ],
//          ),
//        )
        ],
      ),
    );

  }
}