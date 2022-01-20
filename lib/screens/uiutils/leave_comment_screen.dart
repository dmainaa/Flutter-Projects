import 'package:amc/constants.dart';
import 'package:amc/models/comment.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LeaveCommentScreen extends StatelessWidget {
  NetworkService get networkService => GetIt.I<NetworkService>();
  UIServices get uiService => GetIt.I<UIServices>();

  final String article_id;

  TextEditingController textEditingController = TextEditingController();


  LeaveCommentScreen({this.article_id});

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    context = context;
    return Expanded(
      flex: 1,

      child: Padding(
        padding: EdgeInsets.only(left: kDefaultPadding),
        child: Column(
          children: <Widget>[
            TextField(decoration: InputDecoration(
                hintText: 'Leave A Comment',

            ),
            controller: textEditingController,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(

                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                        IconButton(
                          icon: Icon(Icons.supervised_user_circle),
                        ),
                      ),
//                    Align(
//                      alignment: Alignment.centerLeft,
//                      child: Text('Kelvin', style: TextStyle(
//                          fontSize: 5.0
//                      ),),
//                    )


                    ],),
                ),
                Expanded(
                  child: Column(

                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: (){
                            leaveAComment();
                          },
                          icon: Icon(Icons.send, color: kPrimaryColor,),
                        ),
                      )
                      ,

                    ],),
                ),


              ],
            )
          ],
        ),
      )
    ,
    );
  }

  void leaveAComment() async{
    if(article_id != null){
      String comment_text = textEditingController.text;


      if(comment_text.isNotEmpty){
        Comment comment = new Comment(article_id: this.article_id, commment: comment_text);
        final response = await networkService.makeStringPostRequest(url: COMMENT_URL, includeToken: true, body: comment.toMap(), context: context);

        if(response.error){
          uiService.showToastMessage(message: response.errorMessage);
        }else{
          uiService.showToastMessage(message: "Successfully added comment");
        }
      }
    }
  }
}