import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginPageDisplay.dart';
import 'UICollectionHandler.dart';


class LearnAFruitSplashScreen extends StatefulWidget {
  @override
  _LearnAFruitSplashScreen createState() => _LearnAFruitSplashScreen();
}

class _LearnAFruitSplashScreen extends State<LearnAFruitSplashScreen> {

  startTimeout() {
    return  Timer(Duration(seconds: 10), changeScreen);
  }

  changeScreen() async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return UICollectionHandler();
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
        margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/learnafruit.gif',
                width: 600.0,
                height: 400.0,
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),

              Expanded(
                flex: 10,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LinearProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    Text(
                      "Loading Learn a Fruit...",
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
