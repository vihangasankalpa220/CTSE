import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/DisplayUI/LoginPageDisplay.dart';
import 'package:finalproject/DisplayUI/LearnAFruitsplashScreen.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CrudControllers/authentication_Controller.dart';
import 'CrudControllers/Fruit_Controller.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the main class to run the application
 */
//creating the main class to run the application
void main() {
  runApp(
    //loading the authentication and fruit controller to load all the details in the run state
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LearnAFruitProvider()),
        ChangeNotifierProvider(
          builder: (context) => AuthenticationController(),
        ),
        ChangeNotifierProvider(
          builder: (context) => FruitController(),
        ),
      ],
      child: LearnAFruitApp(),
    ),
  );
}

class LearnAFruitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LearnAFruitProvider>(
      builder: (BuildContext context, LearnAFruitProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home://SplashScreen(),
          Consumer<AuthenticationController>(
           builder: (context, notifier, child) {
             //check if the user null or if it is null send to login page ui or not null then send to splash and redirected to the main screen immediately
            return notifier.user != null ? LearnAFruitSplashScreen() : LoginPageDisplayUI();
            },
         ),
        );
      },
    );
  }
}