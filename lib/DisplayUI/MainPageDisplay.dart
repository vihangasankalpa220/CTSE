import 'dart:io';
import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'FruitBook.dart';
import 'LoginPageDisplay.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the main screen ui
 */


//creating the class to surf as the Home Page for to go Fruit List View  and manage the state of the page
class HomeScreenUI extends StatefulWidget {
  @override
  _HomeScreenUIState createState() => _HomeScreenUIState();
}
//creating the ui screen for Home Screen View
class _HomeScreenUIState extends State<HomeScreenUI> with AutomaticKeepAliveClientMixin<HomeScreenUI>{
//handle the carousel slider in the top of the ui using image list to slide
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  //loading the slider image into the list to show in the slider panel
  List imageList = [
    'assets/intro1.png',
    'assets/intro2.png',
    'assets/intro3.png'
  ];
//declare the private image  file to load the fruit open list button image
  File _image;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);


    return Scaffold(

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Hi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  authNotifier.user != null ?  authNotifier.user.displayName : "Fruity!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10.0),

                FlatButton(
                  onPressed: (){
                    //
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          signout(authNotifier);
                          return LoginPageDisplayUI();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 22, color: Colors.lightBlue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            //Slider Here
            CarouselSlider(
              height: MediaQuery.of(context).size.height/2.4,
              items: imageList.map((i){
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Image.asset(i, fit: BoxFit.fill,),
                    );
                  },
                );
              }).toList(),
              autoPlay: true,
              viewportFraction: 1.0,
              onPageChanged: (index) {
                setState(() {
                });
              },
            ),
            SizedBox(height: 20.0),

            Text(
              "Open Fruit Book",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Color(0xffffbf00),
                          child: ClipOval(
                            child:SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: (_image != null)?Image.file(_image, fit: BoxFit.fill,)
                              :Image.asset(
                                'assets/book.png',
                                width: 600.0,
                                height: 240.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Color(0xffffbf00),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return FruitBook();
                        },
                      ),
                    );
                  },
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  child: Text(
                    'Open',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 10.0),
            SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
