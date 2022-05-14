import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_with_flutter/pages/mainPages/launcher.dart';
import 'package:shopping_app_with_flutter/pages/mainPages/logInPage.dart';
import 'package:shopping_app_with_flutter/pages/mainPages/signInPage.dart';
import '../main.dart';
import '../pages/categories/electronicCategory.dart';
import '../pages/categories/jewelleryCategory.dart';
import '../pages/categories/menCategory.dart';
import '../pages/categories/suggestionPage.dart';
import '../pages/categories/womenCategoryPage.dart';
import '../pages/mainPages/accountPage.dart';
import '../pages/mainPages/bagPage.dart';
import '../pages/mainPages/favoritePage.dart';
import '../pages/mainPages/introductionScreen.dart';
import '../pages/settingPages/accountSettingPage.dart';
import '../pages/settingPages/changePersonalInfoPage.dart';
import '../pages/settingPages/updatePage.dart';

class RouterClass {
  static Route<dynamic>? detectDevice(RouteSettings settings, Widget toBeSentPage) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
          settings: settings, builder: (BuildContext context) => toBeSentPage);
    } else {
      return MaterialPageRoute(
          settings: settings, builder: (BuildContext context) => toBeSentPage);
    }
  }

  static Route<dynamic>? routerMethod(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return detectDevice(settings, AnimatedSplashScreenPage());
      case "/IntroPage":
        return detectDevice(settings, IntroductionPage());
      case "/LogInPage":
        return detectDevice(settings, LogInPage());
      case "/SignInPage":
        return detectDevice(settings, SignInPage());
      case "/Launcher":
        return detectDevice(settings, Launcher());
      case "/FavoritePage":
        return detectDevice(settings, FavotirePage());
      case "/BagPage":
        return detectDevice(settings, BagPage());
      case "/AccountPage":
        return detectDevice(settings, AccountPage());
      case "/Women":
        return detectDevice(settings, WomenCategory());
      case "/Men":
        return detectDevice(settings, MenCategory());
      case "/Jewel":
        return detectDevice(settings, JewelleryCategory());
      case "/Electronic":
        return detectDevice(settings, ElectronicCategory());
      case "/Suggestion":
        return detectDevice(settings, SuggestionPage());
      case "/AccountSetting":
        return detectDevice(settings, AccountSettingPage());
      case "/ChangeInfo":
        return detectDevice(settings, ChangePersonalPage());
      case "/UpdatePage":
        return detectDevice(settings, UpdatePage());
      default:
        return detectDevice(settings, ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error Page"),
      ),
    );
  }
}