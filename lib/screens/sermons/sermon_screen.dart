import 'dart:convert';

import 'package:amc/models/mediaitem.dart';
import 'package:amc/screens/sermons/sermon_card_item.dart';
import 'package:amc/screens/uiutils/audio_player.dart';
import 'package:amc/screens/uiutils/lower_vid.dart';
import 'package:amc/screens/uiutils/no_media_widget.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class SermonScreen extends StatefulWidget{

  @override
  State createState() {
    return _SermonScreenState();
  }
}

class _SermonScreenState extends State<SermonScreen> with WidgetsBindingObserver{

  VideoPlayerController playerController;
  ChewieController _chewieController;

  AudioPlayer audioPlayer = AudioPlayer();

  int selected_index = 0;

  bool nomedia = false;
  bool notconnected = false;
  String errortext = "";

  bool firstTimeLoad = true;

  NetworkService get networkService => GetIt.instance<NetworkService>();
  UIServices get uiService => GetIt.instance<UIServices>();

  bool isLoading = true;
  List<MediaItem> allItems = [

    MediaItem(thumbnail: 'assets/images/vid_holder.PNG', mediaName: 'Pastor Godfrey Mabwana - Yesu katika hekalu ya bingu', mediaType: 0),
    MediaItem(thumbnail: 'assets/images/vid_holder.PNG', mediaName: 'Pastor Duncan Mambo - CHRIST & HIS RIGHTEOUSNESS', mediaType: 1),
    MediaItem(thumbnail: 'assets/images/vid_holder.PNG', mediaName: 'Pastor Tom Mwambo - WOMEN IN THE MINISTRY OF CHRIST', mediaType: 1),
    MediaItem(thumbnail: 'assets/images/vid_holder.PNG', mediaName: 'Pastor Randy Steet - LIVING LAWFULLY', mediaType: 0),

  ];


  @override
  void initState() {
    super.initState();
    fetchAllSermons();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: size.height,
        child:Builder(
          builder: (_){
            if(isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            if(notconnected){
              return NoConnectionScreen(text: errortext, tryAgain: (){
                fetchAllSermons();
              },);
            } else{
              return Column(
                children: <Widget>[
                  Container(
                      width: double.infinity,

                      child: Chewie(controller: _chewieController,),
//                      child: allItems[selected_index].mediaType == 1?
//                      Chewie(
//                        controller: _chewieController,
//
//                      ): MAudioPlayer(mediaUrl: allItems[selected_index].mediaUrl, isLocal: false, audioPlayer: audioPlayer,)


                  ),
                  LowerVid(mediaTitle: allItems[selected_index].mediaName,),
                  Flexible(
                    child: ListView.builder(
                        itemCount: allItems.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selected_index = index;
                                initializeController();

                              });
                            },

                            child: SermonCardItem(
                              mediaItem: allItems[index],
                              isselected: selected_index == index ? true : false

                            ),
                          );
                        }
                    ),
                  )
                ],
              );
            }

          },
        ),
      ),
    );
  }

  void initializeController(){

    playerController = VideoPlayerController.network(allItems[selected_index].mediaUrl);
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

      isLoading  = false;
    });
  }

  void fetchAllSermons() async{
    setState(() {
      isLoading = true;
    });
    final response = await networkService.getMediaRequest(url: MEDIA_URL + "sermon", includeToken: true);

    if(response.error){
      debugPrint(response.errorMessage);
      if(response.errorMessage == 'Failed...Please check your internet connection'){
        setState(() {
          notconnected = true;
          isLoading = false;
          errortext = "Failed...Please check your internet connection";
        });
      }else{
        setState(() {
          notconnected = false;
          isLoading = false;
          errortext = response.errorMessage;
        });
      }
    }else{
      final jsonData = jsonDecode(response.data);

      final jsonMedia = jsonData['media'] as List;

      allItems = jsonMedia.map((e) => MediaItem.fromJson(e)).toList();
      initializeController();
      setState(() {

        isLoading = false;
        notconnected = false;

      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      debugPrint('The application was paused');
      firstTimeLoad = false;
      _chewieController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('The application was resumed');
      if (!firstTimeLoad) {
        initializeController();
        fetchAllSermons();
      }
    }
  }
}