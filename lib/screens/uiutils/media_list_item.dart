

import 'dart:io' ;

import 'package:amc/constants.dart';
import 'package:amc/database/database_helper.dart';
import 'package:amc/models/mediaitem.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:thumbnails/thumbnails.dart';

class MediaListItem extends StatefulWidget{

  final MediaItem mediaItem;
  final Function (int) press;
  final Function (String) downloadPressed;

  final bool isSelected;
  
  final bool shouldDownload;

 final bool showCost;






  MediaListItem({Key key,  this.mediaItem, this.press, this.isSelected, this.downloadPressed, this.shouldDownload, this.showCost = true}): super(key: key){

  }

  @override
  State createState() {
    return _MediaItemListState();
  }


}

class _MediaItemListState extends State<MediaListItem> {
  String userText = "Download @";

  DatabaseHelper _databaseHelper;

  String download_url = "https://firebasestorage.googleapis.com/v0/b/lola-71ccc.appspot.com/o/adverts%2Fmedia%2F0931f446-4be7-4328-b04e-4f80f7226fbf_A%20new%20CAM_ERA%20has%20been%20unlocked%20with%20the%20Camon%2012%20Series.%26%2310%3B%23CTheWorld%20%20with%20us.mp4?alt=media&token=548d1be4-9b28-498b-a7b8-8dc00f7f5449";

  Dio dio = Dio();
  String thumbPath;

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    if(widget.mediaItem.mediaType == 0){
//      _getImage(widget.mediaItem.mediaUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width,
      height: size.height * 0.12,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

      decoration: widget.isSelected ? BoxDecoration(
          color: Colors.black45
      ) : BoxDecoration(
          color: Colors.black26
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Builder(
                builder: (_){
                  if(widget.mediaItem.mediaType == 1){
                    if(thumbPath == null){
                      return Image.asset('assets/images/vid_holder.PNG');
                    }else{
                      return Image.file(File(thumbPath));
                    }
                  }else{
                    return Image.asset('assets/images/audio_player_image.PNG');
                  }
                },
              )
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(widget.mediaItem.mediaName, style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0

                      ),
                        overflow: TextOverflow.ellipsis,

                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                        IconButton(
                          icon: Icon(
                            Icons.arrow_downward, color: Colors.redAccent,),
                          onPressed: () {
                            if(widget.shouldDownload){
                              //downloadFile();
                            }else{
                              widget.downloadPressed(widget.mediaItem.id);
                            }
                            


                          },
                        ),
                        widget.showCost?
                        Text(userText + widget.mediaItem.cost.toString(), style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0)
                          ,):
                        Text(userText, style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0)
                          ,)

                      ],
                    )
                  ],
                ),
              )
          ),

        ],
      ),

    );
  }
//
//  Future<void> downloadFile() async {
//    try {
//      var path = await ExtStorage.getExternalStoragePublicDirectory(
//          ExtStorage.DIRECTORY_DOWNLOADS);
//
//       var realPath = widget.mediaItem.mediaType == 1 ?'${path}/amc/${widget.mediaItem.mediaName}.mp4': '${path}/amc/${widget.mediaItem.mediaName}.mp3';
//
//      bool fileExists = await File(realPath).exists();
//
//
//      if(fileExists){
//        //don't download the file but notify the download complete
//        debugPrint('File already exists in the storage');
//        widget.downloadPressed(widget.mediaItem.id);
//      }else{
//        await dio.download(
//            widget.mediaItem.mediaUrl, realPath, onReceiveProgress: (rec, total) {
//          print('Received: $rec Total: $total');
//
//          setState(() {
//            userText = ((rec / total) * 100).toStringAsFixed(0) + "%";
//          });
//        });
//      }
//
//    } catch (e) {
//      print(e.toString());
//    }
//
//    setState(() {
//      userText = "Completed";
//    });
//
//    insertItemToDatabase();
//  }

//  Future download2(Dio dio, String url, String savePath) async {
//    var path = await ExtStorage.getExternalStoragePublicDirectory(
//        ExtStorage.DIRECTORY_PICTURES);
//    print(path);
//
//    try {
//      Response response = await dio.get(
//        url,
//        onReceiveProgress: showDownloadProgress,
//        //Received data with List<int>
//        options: Options(
//            responseType: ResponseType.bytes,
//            followRedirects: false,
//            validateStatus: (status) {
//              return status < 500;
//            }),
//      );
//      print(response.headers);
//      File file = File('${path}/mdownloads/thedownload.mp4');
//      var raf = file.openSync(mode: FileMode.write);
//      // response.data is List<int> type
//      raf.writeFromSync(response.data);
//      await raf.close();
//    } catch (e) {
//      print(e);
//    }
//  }

  void showDownloadProgress(received, total) {
    //This
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void insertItemToDatabase() async {
    final Future<Database> dbFuture = _databaseHelper.getDatabase();

    dbFuture.then((database) {
      final result = _databaseHelper.insetDownload(widget.mediaItem);

      if (result != 0) {
        debugPrint('The Item was updated successfully');
        widget.downloadPressed(widget.mediaItem.id);

      } else {
        debugPrint('Failed to insert the item');
      }
    });


  }

//  _getImage(videoPathUrl) async{
//    var path = await ExtStorage.getExternalStoragePublicDirectory(
//        ExtStorage.DIRECTORY_PICTURES);
//
//    String thumb = await Thumbnails.getThumbnail(videoFile: videoPathUrl,  imageType: ThumbFormat.PNG, quality: 30);
//
//    print(thumb);
//
//    return thumb;
//  }



}