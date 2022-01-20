import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';

class ChewieVideoPlayer extends StatefulWidget{
  final  VideoPlayerController videoPlayerController;
  final bool looping;
  final Function isReady;


  ChewieVideoPlayer({Key key,
  @required  this.videoPlayerController, this.looping, this.isReady
}): super(key: key);

  @override
  State createState() {
    return _ChewieVideoPlayerState();
  }

}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer>{
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage){
          return Center(
            child: Text(errorMessage, style: TextStyle(
                color: Colors.white
            ),),
          );
        }
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.isReady());

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   return Container(
      width: double.infinity,
      child: Chewie(
        controller: _chewieController,

      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }


}