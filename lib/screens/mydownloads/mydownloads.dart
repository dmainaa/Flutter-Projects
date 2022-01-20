import 'dart:io';


import 'package:amc/database/database_helper.dart';
import 'package:amc/models/mediaitem.dart';

import 'package:amc/screens/uiutils/downloads_list_item.dart';
import 'package:amc/screens/uiutils/no_media_widget.dart';

import 'package:chewie/chewie.dart';
//import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyDownloads extends StatefulWidget {


  @override
  State createState() {
    return _MyDownloadsState();
  }
}

class _MyDownloadsState extends State<MyDownloads> with WidgetsBindingObserver{

  int selectedIndex = 0;

  int selectedtab = 0;

  bool isLoading = true;
  bool isReady = false;

  bool noDownloads = false;
  VideoPlayerController playerController;
  ChewieController _chewieController;

  DatabaseHelper _databaseHelper;

  List<MediaItem> mediaItems;

  int selectedItemIndex;







  File selectedFile;

  bool firstTimeLoad = false;




  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    WidgetsBinding.instance.addObserver(this);

    //initialize the first file item
    fetchAllItems();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Builder(
        builder: (_){
          if(isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    getCustomTab(Icons.play_circle_outline, 'Video', size, 0),

                    getCustomTab(Icons.audiotrack, 'Audio', size, 1),

                  ],
                ),
                noDownloads ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: NoMediaWidget(messageText: 'You have no downloads at the moment',),
                  ),
                ) : Expanded(
                  flex: 1,
                 child:   Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,

                            child: Chewie(
                              controller: _chewieController,

                            )
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ListView.builder(
                              itemCount: mediaItems.length,
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedIndex = index;
                                      //initializePath();
                                    });
                                  },
                                  child: DownloadsListItem(
                                    isSelected: selectedIndex == index? true : false,
                                    mediaItem: mediaItems[selectedIndex],
                                    onDeleted: (value){
                                      deleteItem(value);
                                    },

                                  ),
                                );
                              }),
                        )
                      ],
                    )
                ),

              ],
            );
          }
        },
      ),
    );
  }

  Widget getCustomTab(IconData icon, String iconLabel, Size size, int index){
    return GestureDetector(
      onTap: (){
        if(index != selectedtab){
          _chewieController.dispose();
          selectedtab = index;
          fetchAllItems();

        }

      },
      child: Container(
        width: size.width / 2,
        height: size.height * 0.05,
        decoration: index == selectedtab ? BoxDecoration(
            color: Colors.lightBlue
        ) : BoxDecoration(
            color: Colors.blueGrey
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white,),
            SizedBox(width: 5.0,),
            Text(iconLabel, style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.00,
                color: Colors.white
            ),)
          ],
        ),


      ),
    );
  }

  void fetchAllItems() async {

      String type;
      if(selectedtab ==0 ){
        type = "1";
      }else{
        type = "0";
      }
      setState(() {
        isLoading = true;
      });
      debugPrint('I have been called');

      final dbFuture = await  _databaseHelper.getDatabase();

      mediaItems = await _databaseHelper.getAllDownloadsList(type);
      if(mediaItems.isEmpty){
        setState(() {
          isLoading = false;
          noDownloads = true;
        });
      }else{

        //initializePath();
      }

  }

  void deleteItem(String itemid){

  }

  void initializeController(){

    playerController = VideoPlayerController.file(selectedFile);
    _chewieController = ChewieController(
        videoPlayerController: playerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: false,
        errorBuilder: (context, errorMessage){
          return Center(
            child: Text(errorMessage, style: TextStyle(
                color: Colors.white
            ),),
          );
        }
    );
    setState(() {
      isLoading = false;
      noDownloads = false;

    });


  }
//
//  void initializePath() async{
////    var path = await ExtStorage.getExternalStoragePublicDirectory(
////        ExtStorage.DIRECTORY_DOWNLOADS);
//
//    print(path);
//
//    var realPath = selectedtab == 0?  '${path}/amc/${mediaItems[selectedIndex].mediaName}.mp4': '${path}/amc/${mediaItems[selectedIndex].mediaName}mp3';
//
//    selectedFile = File(realPath);
//
//    debugPrint(selectedFile.path);
//
//    initializeController();
//
//
//  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_chewieController != null) {
        _chewieController.pause();
      }

    }else if (state == AppLifecycleState.resumed) {
      if(_chewieController!=null){
        _chewieController.play();
      }
    }

    else if (state == AppLifecycleState.inactive) {
      _chewieController.dispose();
    }

    @override
    void dispose() {
      super.dispose();
      WidgetsBinding.instance.removeObserver(this);
    }
  }
}