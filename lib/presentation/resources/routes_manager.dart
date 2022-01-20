import 'package:flutter/material.dart';
import 'package:flutter_advanced/presentation/forgot_password/forgot_password.dart';
import 'package:flutter_advanced/presentation/login/login.dart';
import 'package:flutter_advanced/presentation/main/main_view.dart';
import 'package:flutter_advanced/presentation/onboardiing/onboarding.dart';
import 'package:flutter_advanced/presentation/register/register.dart';
import 'package:flutter_advanced/presentation/resources/strings_manager.dart';
import 'package:flutter_advanced/presentation/resources/style_manager.dart';
import 'package:flutter_advanced/presentation/splash/splash.dart';
import 'package:flutter_advanced/presentation/store_details/store_details.dart';

class Routes{
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onboarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String forgotPasswordRoute = "/forgotPassword";
}

class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings routeSettings){

    switch(routeSettings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
        break;
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
        break;
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingView());
        break;
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterView());
        break;
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordView());
        break;
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
        break;
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => StoreDetailsView());
        break;
      default:
        return undefinedRoute();
        break;
    }


  }

  static Route<dynamic> undefinedRoute(){
    return MaterialPageRoute(builder: (_)=>Scaffold(
      appBar: AppBar(title: Text(AppStrings.noRouteFound),),
      body: Center(
        child: Text(AppStrings.noRouteFound, style: getSemiBoldStyle(fontSize: 15.0, color: Colors.purpleAccent),),
      ),

    ));
  }
}