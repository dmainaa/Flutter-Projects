import 'dart:io';

import 'package:amc/models/mediaitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;

  DatabaseHelper._createInstance();
  static  Database _database;

  static List<String> downloadsColumns = [
    'id', 'thumbnail', 'mediaUrl', 'mediaName', 'mediaType'
  ];

  String downloadsTable = "DownloadsTable";

  factory DatabaseHelper(){

    if(_databaseHelper==null){

      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> getDatabase() async {
    if(_database == null){

      _database = await intialiseDatabase();
    }
  }


  Future<Database> intialiseDatabase () async{

    Directory directory =  await getApplicationDocumentsDirectory();

    String path = directory.path + "downloads.db";

    var downloadsdatabase = await openDatabase(path, version: 1, onCreate: _createDB);

    return downloadsdatabase;


  }

  void _createDB(Database db, int newVersion) async{

      await db.execute('CREATE TABLE $downloadsTable(${downloadsColumns[0]} TEXT, ${downloadsColumns[1]} TEXT, ${downloadsColumns[2]} TEXT, ${downloadsColumns[3]} TEXT, ${downloadsColumns[4]} INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getDownloadsMapList() async{

    Database database = await _database;

    var result = await database.query(downloadsTable, orderBy: '${downloadsColumns[3]} ASC');

    return result;
  }

  Future<List<Map<String, dynamic>>> getAudioDownloadsMapList() async{

    Database database = await _database;

    var result = await database.query(downloadsTable, orderBy: '${downloadsColumns[3]} ASC', where: '${downloadsColumns[4]} = ?', whereArgs: [0] );

    return result;
  }

  Future<List<Map<String, dynamic>>> getVideoDownloadsMapList() async{

    Database database = await _database;

    var result = await database.query(downloadsTable, orderBy: '${downloadsColumns[3]} ASC', where: '${downloadsColumns[4]} = ?', whereArgs: [1] );

    return result;
  }

  Future<int> insetDownload(MediaItem mediaItem) async{
    debugPrint('${mediaItem.mediaUrl} ${mediaItem.mediaName} ${mediaItem.thumbnail} ${mediaItem.id} ${mediaItem.mediaType}');

    Map<String, dynamic> mMap = mediaItem.toMap();

    debugPrint(mMap['mediaName']);

    var result = await _database.insert(downloadsTable, mediaItem.toMap(), nullColumnHack: downloadsColumns[0]);

    return result;

  }

  Future<int> updateDownload(MediaItem mediaItem) async{

    Database database = await _database;

    var results = await database.update(downloadsTable, mediaItem.toMap(), where: '${downloadsColumns[0]} = ?', whereArgs: [mediaItem.id] );

    return results;
  }

  Future<int> deleteDownload(String id) async{

    Database database = await _database;

    var results = await database.rawDelete("DELETE * FROM $downloadsTable WHERE ${downloadsColumns[0]} = $id");

    return results;
  }

  Future<int> deleteAllDownloads() async{

    Database database = await _database;

    var results = await database.rawDelete("DELETE * FROM $downloadsTable");

    return results;
  }



  Future<int> getCount() async{
    Database database = await _database;

    List<Map<String, dynamic>> x = await database.rawQuery("SELECT COUNT (*) FROM $downloadsTable");

    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future <List<MediaItem>> getAllDownloadsList(String media_type) async{

    List<MediaItem> notesList = new List<MediaItem>();

    var noteMapList;

    if(media_type == "0"){
      debugPrint('I should fetch the audio files');
      noteMapList = await getAudioDownloadsMapList();
    }else if(media_type == "1"){
      debugPrint('I should fetch the video files');
      noteMapList = await getVideoDownloadsMapList();
    }else{
      debugPrint('I should fetch all files');
      noteMapList = await getDownloadsMapList();
    }


    int count = noteMapList.length;

    debugPrint("Item Counte" + count.toString());


    for(int i =0; i<count; i++){
      Map<String, dynamic> mapList = noteMapList[i];
      debugPrint('Media url ${mapList['mediaUrl']}');
      notesList.add(MediaItem.fromMapObject(noteMapList[i]));
    }

    return notesList;

  }



}