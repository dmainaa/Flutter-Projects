import 'package:amc/constants.dart';


import 'package:amc/models/moreitem.dart';
import 'package:amc/screens/allarticles/allarticles_screen.dart';
import 'package:amc/screens/choirs/choirs_screen.dart';
import 'package:amc/screens/family/family_matters.dart';
import 'package:amc/screens/finance/finance_matters_screen.dart';
import 'package:amc/screens/health/health_matters_screen.dart';
import 'package:amc/screens/home/home_screen.dart';
import 'package:amc/screens/hymnal/hymnal_screen.dart';
import 'package:amc/screens/login/login_screen.dart';
import 'package:amc/screens/more/more_widget_card_item.dart';
import 'package:amc/screens/motivation/motivation_matters.dart';
import 'package:amc/screens/mydownloads/downloads_page.dart';
import 'package:amc/screens/mydownloads/mydownloads.dart';
import 'package:amc/screens/profile/profile_screeen.dart';
import 'package:amc/screens/relationship/relationship_matters.dart';
import 'package:amc/screens/scriptures/scripture_screen.dart';
import 'package:amc/screens/sermons/sermon_screen.dart';
import 'package:amc/screens/uiutils/ad_screen.dart';
import 'package:amc/screens/uiutils/uiservices.dart';
import 'package:amc/services/NerworkService.dart';
import 'package:amc/url_constants.dart';
import 'package:amc/utils/menu_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget{

  @override
  State createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>{
  int selectedItemIndex = 0;

  bool showmore = false;

  Widget selectedWidget = HomeScreen();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UIServices get uiService => GetIt.I<UIServices>();
  NetworkService get networkService => GetIt.I<NetworkService>();

  bool shouldshowad = true;
  List<MoreItem> moreItems = [
    MoreItem(icon: Icons.person, moreName: 'Sermons', asset_link: 'assets/icons/sermon_icon.png'),
    MoreItem(icon: Icons.monetization_on, moreName: 'Financial Matters', asset_link: 'assets/icons/financial_matters_icon.png'),
    MoreItem(icon: Icons.local_hospital, moreName: 'Health Matters', asset_link: 'assets/icons/health_matters.png'),
    MoreItem(icon: Icons.show_chart, moreName: 'Motivational Matters', asset_link: 'assets/icons/motivational_matters_icon.png'),
    MoreItem(icon: Icons.people, moreName: 'Relationship Matters', asset_link: 'assets/icons/relationship_matters_icon.png'),
    MoreItem(icon: Icons.person, moreName: 'Family Matters', asset_link: 'assets/icons/family_matters_icon.png'),

  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        appBar: AppBar(
          title: Text('AMC'),
          leading: IconButton(
            icon: Image.asset('assets/icons/amc_icon.png'),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: itemSelected,
                itemBuilder: (BuildContext context){
                  return MenuConstants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Container(
                        decoration: BoxDecoration(

                        ),
                        child: Text(choice, style: TextStyle(
                          color: Colors.blue
                        ),),
                      ),
                    );
                  }).toList();
                })
          ],
        ),
        body:   Stack(

          children: <Widget>[
            selectedWidget,
            shouldshowad ?
            Positioned(
              bottom: 0,
              left: 0,
              child: AdScreen(
                press: (){

                },

                cancelAd: (value){
                  setState(() {
                  shouldshowad  = value;
                });
                },
              ),
            ): Container()
            ,
          Positioned(
            bottom: 0,
            right: 0,
            child: showmore ? getMoreWidget(size):Container(),
          )

          ],
        ),

        bottomNavigationBar: Row(
          children: <Widget>[
            buildNavBarItem("assets/icons/home_icon.png", 0, 'Home'),
            buildNavBarItem("assets/icons/choirs_icon.png", 1, 'Choirs'),
            buildNavBarItem("assets/icons/scriptures_icon.png", 2,'Scriptures'),

            buildNavBarItem("assets/icons/more_icon.png", 3, 'More'),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(String assetlink, int index, String item_name){
    return  GestureDetector(
      onTap: (){
        setState(() {
          selectedItemIndex = index;
          loadSelectedItem();
        });
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width/4,
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

  void itemSelected(String choice){
    debugPrint('Selected Choice $choice');
    if(choice == MenuConstants.mydownloads){
      debugPrint('My Downloads');
      _navigateToPage(DownloadPage());
    }
    else if(choice == MenuConstants.profile){
      _navigateToPage(ProfileScreen());
    }
    else if(choice == MenuConstants.signout){
      logout();
    }
  }

  void loadSelectedItem(){
    switch(selectedItemIndex){
      case 0:
        selectedWidget = HomeScreen();
        setState(() {
          showmore = false;
        });
        break;
      case 1:
        selectedWidget = HymnalScreen();
        setState(() {
          showmore = false;
        });

        break;
      case 2:
        selectedWidget = ScriptureScreen();
        setState(() {
          showmore = false;
        });
        break;

      case 3:
        setState(() {
          showmore ? showmore = false: showmore = true;
        });
        break;
      default: {
        selectedWidget = HomeScreen();
      }

    }


  }

  Widget getMoreWidget(Size size){

    return Container(
      width: size.width * 0.55,
      height: size.height * 0.6,

//      decoration: BoxDecoration(
//        color: Colors.blue.withOpacity(20.0)
//      ),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index){
          return Divider(color: Colors.white, thickness: 0.1, height: 1.0,);
        },
        itemCount: moreItems.length,
          itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            loadExtraItem(index);
          },
          child: MoreWidgetCard(
            moreItem: moreItems[index],
          ),
        );
      },),

    );

  }

  void loadExtraItem(int selected) {
    switch (selected) {
      case 0:
        selectedWidget = SermonScreen();
        setState(() {
          showmore = false;
        });
        break;
      case 1:
        selectedWidget = FinanceMattersScreen();
        setState(() {
          showmore = false;
        });

        break;
      case 2:
        selectedWidget = HealthMattersScreen();
        setState(() {
          showmore = false;
        });
        break;
      case 3:
        setState(() {
          selectedWidget = MotivationMatters();
          showmore = false;
        });
        break;
      case 4:
        setState(() {
          selectedWidget = RelationshipMatters();
          showmore = false;
        });
        break;
      case 5:
        setState(() {
          selectedWidget = FamilyMatters();
          showmore = false;
        });
        break;
      default:
        {
          selectedWidget = HomeScreen();
        }
    }
  }

  void _navigateToPage(Widget widget){
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return widget;
      }
    ));
  }

  void logout(){
    AlertDialog logoutalert =AlertDialog(
      title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
        FlatButton(
        onPressed: () {
      print("you choose no");
      Navigator.of(context).pop(true);
    },
    child: Text('No'),
    ),
    FlatButton(
    onPressed: () {
      Navigator.of(context).pop(true);
      logOutUser();

    },
    child: Text('Yes'),
    ),
  ]
    );

    uiService.showAdialog(context, logoutalert);
  }
  void logOutUser() async{
    //call the logout api
    uiService.showLoaderDialog(context);

    Map<String, dynamic> body = Map();

    final response = await networkService.makeStringPostRequest(body: body, url: LOG_OUT_URL, includeToken: true, context: context);

    if(response.error){
      Navigator.of(context).pop(true);

      if(response.errorMessage == noInternetString){
        uiService.showToastMessage(message: 'You must have Internet Connection to Logout', context: context);

      }else
      uiService.showToastMessage(message: response.errorMessage, context: context);

    }else{
      //clear the preferences

      clearPreferences();

      Navigator.of(context).pop(true);
      _navigateToPage(LoginScreen());

      //navigate back to login screen
    }


  }
  void clearPreferences() async{

    final SharedPreferences prefs = await _prefs;

    prefs.clear();

  }
}