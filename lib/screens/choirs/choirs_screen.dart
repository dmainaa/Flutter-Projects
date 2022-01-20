import 'dart:async';
import 'dart:convert';

import 'package:amc/models/mediaitem.dart';
import 'package:amc/screens/mydownloads/downloads_page.dart';
import 'package:amc/screens/uiutils/audio_player.dart';

import 'package:amc/screens/uiutils/lower_vid.dart';
import 'package:amc/screens/uiutils/media_list_item.dart';
import 'package:amc/screens/uiutils/noconnection_screen.dart';
import 'package:amc/screens/uiutils/payment_dialog.dart';
import 'package:amc/screens/uiutils/success_payment_dialog.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/app_utils.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChoirsScreen extends StatefulWidget {
  int selectedtab = 0;

  ChoirsScreen();

  @override
  State createState() {
    return _ChoirScreenState();
  }
}

class _ChoirScreenState extends State<ChoirsScreen>
    with WidgetsBindingObserver {
  int selectedIndex = 0;
  int selectedMediaIndex = 0;
  bool isLoading = true;
  bool isReady = false;
  bool notconnected = false;
  bool nomedia = false;
  String errortext = "";

  VideoPlayerController playerController;
  ChewieController _chewieController;
  AudioPlayer audioPlayer = new AudioPlayer();

  NetworkService get networkService => GetIt.instance<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  AppUtils get appUtils => GetIt.I<AppUtils>();

  @override
  void initState() {
    super.initState();
//    WidgetsBinding.instance.addObserver(this);
    getChoirs();
    initializeController();
  }

  List<MediaItem> allItems = [
    MediaItem(
        thumbnail: 'assets/images/vid_holder.PNG',
        mediaName: 'Twenda juu kwa baba (HQ)'),
    MediaItem(
        thumbnail: 'assets/images/vid_holder.PNG',
        mediaName: 'Tarumbeta itakapolia (HQ)'),
    MediaItem(
        thumbnail: 'assets/images/vid_holder.PNG',
        mediaName: 'Paza Sauti (HQ)'),
    MediaItem(
        thumbnail: 'assets/images/vid_holder.PNG',
        mediaName: 'Mwana kondoo yuaja (HQ)'),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        child: Builder(builder: (_) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (notconnected) {
            return NoConnectionScreen(
              tryAgain: () {
                getChoirs();
              },
              text: errortext,
            );
          } else {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getCustomTab(Icons.play_circle_outline, 'Video', size, 0),
                    getCustomTab(Icons.audiotrack, 'Audio', size, 1),
                  ],
                ),
                nomedia
                    ? Center(
                        child: Text(
                            "There is no downloadable media at the moment.",
                            style: TextStyle(
                                fontFamily: 'Raleway', fontSize: 15.0)))
                    : Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: selectedIndex == 0
                                  ? Chewie(
                                      controller: _chewieController,
                                    )
                                  : MAudioPlayer(
                                      mediaUrl:
                                          "https://www.kozco.com/tech/organfinale.mp3",
                                      isLocal: false,
                                      audioPlayer: audioPlayer,
                                    ),
                            ),
                            LowerVid(
                              mediaTitle:
                                  allItems[selectedMediaIndex].mediaName,
                            ),
                            ListView.builder(
                                itemCount: allItems.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMediaIndex = index;
                                        initializeController();
                                        debugPrint(
                                            'Hurray I have been clicked at: ' +
                                                index.toString());
                                      });
                                    },
                                    child: MediaListItem(
                                      shouldDownload: false,
                                      press: (value) {},
                                      isSelected: selectedMediaIndex == index
                                          ? true
                                          : false,
                                      mediaItem: allItems[index],
                                      downloadPressed: (String media_id) {
                                        requestPayment(media_id);
                                      },
                                      showCost: true,
                                    ),
                                  );
                                })
                          ],
                        ),
                      )
              ],
            );
          }
        }));
  }

  void reInitialize(int value) {
    setState(() {
      isReady = true;
    });
  }

  Widget getCustomTab(IconData icon, String iconLabel, Size size, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          if (selectedIndex == 0) {
            audioPlayer.dispose();
            initializeController();
            getChoirs();
          } else {
            audioPlayer = new AudioPlayer();
            _chewieController.dispose();
            getChoirs();
          }
        });
      },
      child: Container(
        width: size.width / 2,
        height: size.height * 0.05,
        decoration: index == selectedIndex
            ? BoxDecoration(color: Colors.lightBlue)
            : BoxDecoration(color: Colors.blueGrey),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              iconLabel,
              style: TextStyle(
                  fontFamily: 'Raleway', fontSize: 15.00, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void getChoirs() async {
    setState(() {
      isLoading = true;
    });
    String theUrl;
    if (selectedIndex == 0) {
      //selected tab is video
      theUrl = MEDIA_TYPE_URL + "choir" + "/1";
    } else {
      theUrl = MEDIA_TYPE_URL + "choir" + "/0";
      //selected tab is audio

    }

    final response = await networkService.getMediaRequest(
      url: theUrl,
      includeToken: true,
    );

    setState(() {
      isLoading = false;
    });

    if (response.error) {
      debugPrint(response.errorMessage);
      if (response.errorMessage ==
          'Failed...Please check your internet connection') {
        setState(() {
          notconnected = true;
          isLoading = false;
          errortext = "Failed...Please check your internet connection";
        });
      } else if (response.errorMessage == "Media not found.") {
        setState(() {
          notconnected = false;
          isLoading = false;
          nomedia = true;
          errortext = 'No Media at the moment';
        });
      } else {
        setState(() {
          notconnected = true;
          isLoading = false;

          errortext = response.errorMessage;
        });
      }
      debugPrint(response.errorMessage);
    } else {
      final jsonData = jsonDecode(response.data);

      final jsonMedia = jsonData['media'] as List;

      allItems = jsonMedia.map((e) => MediaItem.fromJson(e)).toList();

      if (allItems.isEmpty) {
        setState(() {
          nomedia = true;
          notconnected = false;
          isLoading = false;
        });
      } else {
        debugPrint(response.data);
        setState(() {
          notconnected = false;
          isLoading = false;
          errortext = response.errorMessage;
        });
      }

      debugPrint(response.data);
    }
  }

  void initializeController() {
    playerController = VideoPlayerController.network(
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_2MB.mp4");
    _chewieController = ChewieController(
        videoPlayerController: playerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      debugPrint('The application was paused');
      _chewieController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void requestPayment(String media_id) async {
    Map<String, dynamic> params = new Map();
    params['content_id'] = media_id;
    params['content_type'] = 'media';

    showPaymentDialog();

    final response = await networkService.makeStringPostRequest(
        body: params, url: REQUEST_PAY_URL, includeToken: true);

    debugPrint(response.data);
    if (response.error) {
      Navigator.of(context).pop(true);
      uiService.showToastMessage(
          message: response.errorMessage, context: context);
    } else {
      debugPrint(response.data);
      final jsonData = jsonDecode(response.data);

      bool status = jsonData['status'];

      if (status) {
        listenForPaymentCallback(media_id);
      }
    }
  }

  void listenForPaymentCallback(String media_id) async {
    String url = PAYMENT_CALLBACK_URL + media_id;

    Timer(Duration(seconds: 3), () async {
      debugPrint("Time has lapsed");

      final response = await networkService.makeSimpleGetRequest(
          url: url, includeToken: true);
      debugPrint(response.data);
      if (!response.error) {
        final jsonData = jsonDecode(response.data);
        String message = jsonData["message"];
        if (message == "status: success") {
          debugPrint('Request has been completed successfully');
          Navigator.pop(context);

          showPaymentSuccessdialog();
        } else if (message == "status: pending") {
          listenForPaymentCallback(media_id);
          debugPrint('Request is still pending');
        } else {
          debugPrint('Request has failed');
        }
      } else {}
    });
  }

  void showPaymentDialog() {
    AlertDialog alertDialog = new AlertDialog(
      content: PaymentDialog(),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: PaymentDialog(),
          );
        },
        barrierDismissible: false);
  }

  void showPaymentSuccessdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SuccesPaymentDialog(
              downloadsPagePressed: () {
                Navigator.pop(context);
                appUtils.NavigateToPage(
                    context: context, destination: DownloadPage());
              },
              cancelPressed: () {
                Navigator.pop(context);
                getChoirs();
              },
            ),
          );
        },
        barrierDismissible: false);
  }
}
