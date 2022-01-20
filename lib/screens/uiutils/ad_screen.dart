import 'dart:async';
import 'dart:convert';

import 'package:amc/models/ad.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class AdScreen extends StatefulWidget{
  final Image image;
  final Function press;
  final Function(bool) cancelAd;

  
  
  final Function(bool) placeAd;



  AdScreen({Key key, this.image, this.press, this.cancelAd, this.placeAd}): super(key: key);

  @override
  State createState() {
    return _AdScreenState();
  }


}





class _AdScreenState extends State<AdScreen> with WidgetsBindingObserver {
  NetworkService get networkService => GetIt.I<NetworkService>();

  bool isLoading = true;

  Advert ad;

  List<Advert> allAdverts;

  int selectedIndex = 0;

  static const sec = const Duration(seconds:10);

  Timer adTimer;

  @override
  void initState() {
    fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: <Widget>[
      isLoading ? Container() :
        Container(
            child: GestureDetector(
              onTap: () {
                //open the url link

                widget.cancelAd(false);
                _launchURL();
              },
              child: Image.network(allAdverts[selectedIndex].image_url,
                fit: BoxFit.fitWidth,
                width: size.width,
                height: size.height * 0.1,
              ),
            )
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              debugPrint('I have been clicked');
              widget.cancelAd(false);
            },
            child: Icon(
              Icons.cancel,
              color: Colors.redAccent,
            ),
          ),
        )
      ],
    );
  }

  void fetchAds() async {

    final response = await networkService.makeSimpleGetRequest(
          url: GET_ALL_ADVERTS, includeToken: true, context: context);

    if (response.error) {
        debugPrint(response.errorMessage);
    } else {
      final jsonData = jsonDecode(response.data);

      final jsonAds = jsonData['adverts'] as List;

      allAdverts = jsonAds.map((e) => Advert.fromJson(e)).toList();

      if(allAdverts.isEmpty){
        widget.cancelAd(false);
      }else{
        setState(() {
          isLoading = false;
        });

        initializeTimer();
      }



    }
  }

  _launchURL() async {
    String url = allAdverts[selectedIndex].url;
    debugPrint(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.paused){
      debugPrint('The application was paused');
      adTimer.cancel();

    }else if(state == AppLifecycleState.resumed){
      debugPrint('The Application was resumed');
      initializeTimer();
    }
  }


  @override
  void dispose() {
    super.dispose();
    adTimer.cancel();
  }

  initializeTimer() async{
    adTimer =  Timer.periodic(sec, (Timer t) {
      if(selectedIndex == allAdverts.length - 1){
        //this is the last index...
        //revert back to index 1
        setState(() {
          selectedIndex = 0;
        });
      }else{
        setState(() {
          selectedIndex++;
        });
      }
    });
  }
}