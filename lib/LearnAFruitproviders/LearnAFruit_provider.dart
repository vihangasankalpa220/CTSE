import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the dark mode white mode changing class
 */

//creating the class to handle the dark mode and white mode provider mode
class LearnAFruitProvider extends ChangeNotifier{
  //loading the theme in constructor
  LearnAFruitProvider(){
    checkTheme();
  }

  //declare theme variable assign its default to light theme
  ThemeData theme = Constants.lightTheme;
  //declare unique key
  Key key = UniqueKey();
  //declaring the global navigator key to maintain navigation state
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //setting the key value
  void setKey(value) {
    key = value;
    notifyListeners();
  }
 //setting the navigation value
  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }
  //setting the theme to dark mode to white mode vise versa
  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("theme", c).then((val){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: c == "dark" ? Constants.darkPrimary : Constants.lightPrimary,
          statusBarIconBrightness: c == "dark" ? Brightness.light:Brightness.dark,
        ));
      });
    });
    notifyListeners();
  }
  //return theme state
  ThemeData getTheme(value) {
    return theme;
  }
  //checking previous state of the theme and return
  Future<ThemeData> checkTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData t;
    String r = prefs.getString("theme") == null ? "light" : prefs.getString(
        "theme");

    if(r == "light"){
      t = Constants.lightTheme;
      setTheme(Constants.lightTheme, "light");
    }else{
      t = Constants.darkTheme;
      setTheme(Constants.darkTheme, "dark");
    }

    return t;
  }
}