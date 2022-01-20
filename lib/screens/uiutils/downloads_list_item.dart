import 'package:amc/constants.dart';
import 'package:amc/models/mediaitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadsListItem extends StatelessWidget{
  final MediaItem mediaItem;
  final Function (int) press;

  final Function(String) onDeleted;

  final bool isSelected;


  DownloadsListItem({this.mediaItem, this.press, this.isSelected, this.onDeleted});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width,
      height: size.height * 0.1,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

      decoration: isSelected ? BoxDecoration(
          color: Colors.black45
      ) : BoxDecoration(
          color: Colors.black26
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Image.asset('assets/images/vid_holder.PNG')
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(mediaItem.mediaName, style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: kDefaultTitleFont,
                      color: Colors.white
                  ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        onDeleted(mediaItem.id);
                      },
                      child: Icon(Icons.delete, color: kPrimaryColor,),
                    ),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}