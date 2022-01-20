import 'package:amc/constants.dart';
import 'package:amc/screens/mydownloads/mydownloads.dart';
import 'package:amc/screens/mydownloads/pending_downloads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget{

 final  int selectwidget;


  DownloadPage({this.selectwidget = 0});

  @override
  State createState() {
  return  _DownloadPageState();
  }
}

class _DownloadPageState extends State<DownloadPage>{
  Widget selectedWidget = PendingDownloads();
  int selectedItemIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Downloads"),
      ),

      body: selectedWidget,

      bottomNavigationBar: Row(
        children: [
          buildNavBarItem("assets/icons/icon_pending.png", 0, 'Pending'),
          buildNavBarItem("assets/icons/icon_file.png", 1, 'Downloaded'),
        ],
      ),
    );
  }


  Widget buildNavBarItem(String assetlink, int index, String item_name){
    return  GestureDetector(
      onTap: (){
        if(!(selectedItemIndex == index)){
          setState(() {
            selectedItemIndex = index;
            loadSelectedItem();
          });
        }

      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width/2,
        decoration:  BoxDecoration(

            color: kPrimaryColor

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ImageIcon(
                AssetImage(assetlink),
                color: index == selectedItemIndex ? Colors.blueAccent : Colors.white,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(item_name, style: TextStyle(
              fontSize: 10.0,
              color: index == selectedItemIndex ? Colors.blueAccent : Colors.white,
            ),)
          ],
        ),
      ),
    );
  }

  loadSelectedItem(){
    switch(selectedItemIndex){
      case 0:
        setState(() {
          selectedWidget = PendingDownloads();
        });
        break;
      case 1:
        setState(() {
          selectedWidget = MyDownloads();
        });

        break;
    }
  }
}
