import 'dart:convert';


import 'package:amc/constants.dart';
import 'package:amc/models/mediaitem.dart';
import 'package:amc/screens/uiutils/media_list_item.dart';
import 'package:amc/screens/uiutils/no_media_widget.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PendingDownloads extends StatefulWidget{

  @override
  State createState() {
  return  _PendingDownloadsState();
  }
}

class _PendingDownloadsState extends State<PendingDownloads>{
  bool isLoading = true;

  String errorText = "Failed. Please check your internet connection";

  NetworkService networkService = GetIt.I<NetworkService>();
  UIServices uiServices = GetIt.I<UIServices>();

  bool error = false;

  List<MediaItem> pendingDownloads;


  @override
  void initState() {
    fetchPendingDownloads();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(
      builder: (_){
        if(isLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(error){
          return NoConnectionScreen(text: errorText, tryAgain: (){},);
        }else{
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Pending Downloads", style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: MediaQuery.textScaleFactorOf(context) * 20,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ),

                SizedBox(height: kDefaultPadding,),

                Flexible(
                    child:  ListView.builder(
                        itemCount: pendingDownloads.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {

                              });
                            },
                            child: MediaListItem(
                              press: (value){

                              },
                              isSelected: false,
                              mediaItem: pendingDownloads[index],
                              downloadPressed: (String media_id){

                                downloadComplete(media_id);

                              },
                              shouldDownload: true,
                              showCost: false,
                            ),
                          );
                        })
                )

              ],
            ),
          );
        }
      },
    );
  }

  void fetchPendingDownloads() async{
    setState(() {
      isLoading = true;

    });



    final response = await networkService.getMediaRequest(url: GET_PENDING_DOWNLOADS_URL, includeToken: true);

    setState(() {
      isLoading = false;
    });

    if(response.error){
      debugPrint(response.errorMessage);
      if(response.errorMessage == 'Failed...Please check your internet connection'){
        setState(() {
          error = true;
          isLoading = false;
          errorText = "Failed...Please check your internet connection";
        });
      }else{
        setState(() {
          error = true;
          isLoading = false;
          errorText = response.errorMessage;
        });
      }
      debugPrint(response.errorMessage);
    }else{
      final jsonData = jsonDecode(response.data);

      final jsonMedia = jsonData['media'] as List;

      pendingDownloads = jsonMedia.map((e) => MediaItem.fromJson(e)).toList();

      if(pendingDownloads.isEmpty){
        setState(() {
          error = true;
          errorText = "You have no pending downloads at the moment";
          isLoading = false;
        });
      }else{
        debugPrint(response.data);
        setState(() {
          error = false;
          isLoading = false;

        });
      }

      debugPrint(response.data);
    }
  }

  void downloadComplete(String media_id) async{
    Map<String, dynamic> bodyparams = new Map();

    bodyparams['media_id'] = media_id;
    final response  = await networkService.makeStringPostRequest(body: bodyparams, url: CONFIRM_DOWNLOAD_URL, includeToken: true, context: context);

    if(response.error){
      uiServices.showToastMessage(message: response.errorMessage, context: context);
    }else{
      uiServices.showToastMessage(message: "Download Completed", context: context);
      fetchPendingDownloads();
    }
  }
}