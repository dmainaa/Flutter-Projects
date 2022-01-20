import 'package:amc/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MAudioPlayer extends StatefulWidget{
  String mediaUrl;

  bool isLocal;

  AudioPlayer audioPlayer;

  MAudioPlayer({this.mediaUrl, this.isLocal, this.audioPlayer});

  @override
  State createState() {
    return _AudioPlayerState();
  }
}

class _AudioPlayerState extends State<MAudioPlayer> with WidgetsBindingObserver{


  Duration duration = new Duration();
  Duration position = new Duration();

  double current_position = 0.0;

  double mduration = 0.0;

  bool playing = false;


  @override
  void initState() {
    debugPrint(widget.mediaUrl);
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      padding: EdgeInsets.all(kDefaultMinPadding),
      color: Colors.white,
      child: Column(
        children: [
          Image(image: AssetImage('assets/images/audio_player_image.PNG'), height: size.height * 0.24,),
          slider(),
          InkWell(
            onTap: (){
                getAudio();
            },
            child: Icon(
              playing == false ? Icons.play_circle_outline : Icons.pause_circle_outline,
              color: kPrimaryColor,
              size: size.height*0.05,
            ),
          )
        ],
      ),

    );
  }

  Widget slider(){
    return Slider.adaptive(
        min: 0.0,
        value: current_position,
        max: mduration,
        onChanged: (double  current_value){
          debugPrint('Seeked at: ' + current_value.toString());
          setState(() {
            current_position = current_value;
            widget.audioPlayer.seek(new Duration(seconds: current_value.toInt()));

          });
        });
  }

  void getAudio() async{
    var url = widget.mediaUrl;

    if(playing){
      //pause the song

      var res = await widget.audioPlayer.pause();

      setState(() {
        playing = false;
      });
    }else{
      //continue playing the song

      var res  = await widget.audioPlayer.play(url, isLocal: false);

      if(res==1){
        setState(() {
          playing = true;
        });
      }
    }

    widget.audioPlayer.onDurationChanged.listen((Duration dd){
        debugPrint('Duration has changed at: ' + dd.toString());
        setState(() {
        duration = dd;
        mduration = dd.inSeconds.toDouble();

      });
    });

    widget.audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      debugPrint('Position has changed at: ' + dd.toString());
      setState(() {
        current_position = dd.inSeconds.toDouble();

      });
    });

    widget.audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        current_position = mduration;
        playing = false;
      });
    });


  }

  Future<int> getDuration() async{

    return widget.audioPlayer.getDuration();

}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      debugPrint('The application was paused');
      widget.audioPlayer.pause();
    }else if(state == AppLifecycleState.resumed){
      debugPrint('The application was resumed');
      widget.audioPlayer.resume();
    }else if(state == AppLifecycleState.detached){
      debugPrint('The application was detached');
      widget.audioPlayer.dispose();
    }
  }


}