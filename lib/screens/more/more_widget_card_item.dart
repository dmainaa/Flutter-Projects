import 'package:amc/constants.dart';
import 'package:amc/models/moreitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MoreWidgetCard extends StatelessWidget{

  final MoreItem moreItem;


  MoreWidgetCard({Key key, this.moreItem}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
      ),
      child: Padding(
        padding: EdgeInsets.only( left:  kDefaultPadding ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: size.width * 0.01,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
//                    color: Colors.blue.withOpacity(0.7),
//                    boxShadow: [
//                      new BoxShadow(
//                          color: Colors.black,
//                          blurRadius: 10.0
//                      )
                    //]

                ),
                child: Image.asset(moreItem.asset_link, fit: BoxFit.fitWidth,),),
              
//              child:  SvgPicture.asset("assets/icons/Motivational Matter.svg"),
              ),

            Expanded(
              flex: 2,
              child: Text(
                moreItem.moreName,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 12.0,


                ),

              ),
            )

          ],
        ),
      ),
    );
  }
}