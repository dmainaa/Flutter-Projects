import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget{
  String image_url;

  double width;

  double height;


  CacheImage({this.image_url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.image_url,
      imageBuilder: (context, imageProvider){
        return Container(
          width: this.width,
          height: this.height,
          decoration: BoxDecoration(

              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill

              )
          ),
        );
      },
      placeholder: (context, url){
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, url, error){
        return Container(
          child: Center(
            child: Text(
              error,
            ),
          ),
        );
      },
    );
  }


}