import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:learn_a_fruit_flutter_app/api/fruit_api.dart';
import 'package:learn_a_fruit_flutter_app/notifier/auth_notifier.dart';
import 'package:learn_a_fruit_flutter_app/notifier/fruit_notifier.dart';
import 'package:provider/provider.dart';
import 'package:learn_a_fruit_flutter_app/screens/profile.dart';
import 'package:learn_a_fruit_flutter_app/screens/FruitBook.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>{

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _current = 0;
  
  List imageList = [
    'assets/intro1.png',
    'assets/intro2.png',
    'assets/intro3.png'
  ];

  File _image;
  String _uploadedFileURL;  

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Future openCamera() async{
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    // Future uploadPicture(BuildContext context) async{
    //   String fileName = basename(_image.path);
    //   StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //   await uploadTask.onComplete;
    //   print("Fruit Added!");
    //   firebaseStorageRef.getDownloadURL().then((fileURL){
    //     setState(() {
    //     _uploadedFileURL = fileURL;
    //       // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fruit Added!')));
    //       Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Fruit Uploaded"),
    //       ));
    //     });
    //   });
    // }

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context);

    Future<void> _refreshList() async {
      getFruits(fruitNotifier);
    }

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
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              //  SizedBox(width: 10.0),
                Text(
                  authNotifier.user != null ?  authNotifier.user.displayName : "Fruity!",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10.0),

                FlatButton(
                  onPressed: () => signout(authNotifier),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20, color: Colors.lightBlue),
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
//                enlargeCenterPage: true,
              viewportFraction: 1.0,
//              aspectRatio: 2.0,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   "Fruits",
//                   style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 FlatButton(
//                   child: Text(
//                     "View More",
//                     style: TextStyle(
// //                      fontSize: 22,
// //                      fontWeight: FontWeight.w800,
//                       color: Theme.of(context).accentColor,
//                     ),
//                   ),
//                   onPressed: (){
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (BuildContext context){
//                           return DishesScreen();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
            SizedBox(height: 10.0),

//             GridView.builder(
//               shrinkWrap: true,
//               primary: false,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: MediaQuery.of(context).size.width /
//                     (MediaQuery.of(context).size.height / 1.25),
//               ),
//               itemCount: fruits == null ? 0 :fruits.length,
//               itemBuilder: (BuildContext context, int index) {
// //                Food food = Food.fromJson(foods[index]);
//                 Map food = fruits[index];
// //                print(foods);
// //                print(foods.length);
//                 return GridProduct(
//                   img: food['img'],
//                   isFav: false,
//                   name: food['name'],
//                   rating: 5.0,
//                   raters: 23,
//                 );
//               },
//             ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
