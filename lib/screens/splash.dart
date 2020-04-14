import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_a_fruit_flutter_app/screens/login.dart';
import 'package:learn_a_fruit_flutter_app/screens/main_screen.dart';

import 'home.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimeout() {
    return  Timer(Duration(seconds: 5), changeScreen);
  }

  changeScreen() async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return MainScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/app_logo.png',
                width: 600.0,
                height: 240.0,
                fit: BoxFit.cover,
              ),
//              Icon(
//
//
//                          Icons.person
//
//              ),
            SizedBox(width: 40.0),
            ],
          ),
        ),
      ),
    );
  }


}
