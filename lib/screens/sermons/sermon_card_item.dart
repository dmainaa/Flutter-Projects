import 'package:amc/constants.dart';
import 'package:amc/models/mediaitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SermonCardItem extends StatelessWidget{
 final  MediaItem mediaItem;
 final bool isselected;
 SermonCardItem({Key key, this.mediaItem, this.isselected}): super(key: key);

 @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: isselected ?BoxDecoration(
          color: Colors.black45
      ) : BoxDecoration(
          color: Colors.black26
      ),
      height: size.height * 0.12,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: kDefaultPadding),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset('assets/images/vid_holder.PNG', width: size.width * 0.1,),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(mediaItem.mediaName, style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Raleway',
                      color: Colors.white
                    ),
                    overflow: TextOverflow.ellipsis,
                    )
                    ,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: IconButton(
                          icon: Image.asset('assets/icons/listen_icon.png', color: mediaItem.mediaType == 1 ? Colors.white : Colors.blue,),

                        ),

                      ),
                      IconButton(
                        icon: IconButton(icon: Image.asset('assets/icons/watch_icon.png' , color: mediaItem.mediaType == 0 ? Colors.white : Colors.blue),

                        ),


                      ),

                    ],)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}