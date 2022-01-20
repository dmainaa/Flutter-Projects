import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaItem{
   String id;
   String thumbnail;
   String mediaUrl;
   String mediaName;
   int mediaType;
   int cost;

  MediaItem({this.id, this.thumbnail="thumbnail", this.mediaUrl, this.mediaName, this.mediaType=0, this.cost});

  factory MediaItem.fromJson(Map<String, dynamic> item){
    return MediaItem(
      id: item['id'],
      mediaType: int.parse(item['file_type']),
      mediaUrl: item['media_url'],
      mediaName: item['title'],
      thumbnail: 'thumbnail',
      cost: int.parse(item['cost'])


    );
  }

  String decodeDestination(Map<String, dynamic> destinations){


   }

  MediaItem.fromMapObject(Map<String, dynamic> map){

    this.id = map['id'];
    this.thumbnail = map['thumbnail'];
    this.mediaName = map['mediaName'];
    this.mediaUrl = map['mediaUrl'];
    this.mediaType = int.parse(map['file_type']);
    this.cost = int.parse(map['cost']);

  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();

    if(id != null){
        map['id'] = id;
    }

    map['thumbnail'] = thumbnail;
    map['mediaName'] = mediaName;
    map['mediaUrl'] = mediaUrl;
    map['mediaType'] = mediaType;

    return map;
  }


}