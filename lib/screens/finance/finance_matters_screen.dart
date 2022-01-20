import 'package:amc/constants.dart';
import 'package:amc/screens/allarticles/allarticles_screen.dart';
import 'package:amc/screens/uiutils/extra_main_text.dart';
import 'package:amc/screens/uiutils/extra_top.dart';
import 'package:amc/screens/uiutils/leave_comment_screen.dart';
import 'package:flutter/cupertino.dart';

class FinanceMattersScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AllArticlesScreen(category: 'health',);
  }
}