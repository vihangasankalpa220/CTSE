import 'package:flutter/material.dart';
import 'package:learn_a_fruit_flutter_app/screens/details.dart';
import 'package:learn_a_fruit_flutter_app/util/const.dart';

class GridProduct extends StatelessWidget {

  final String name;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;


  GridProduct({
    Key key,
    @required this.name,
    @required this.img,
    @required this.isFav,
    @required this.rating,
    @required this.raters})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "$img",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: (){},
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      isFav
                          ?Icons.favorite
                          :Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],


          ),

          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Row(
              children: <Widget>[
                Text(
                  " $rating ($raters Reviews)",
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),

              ],
            ),
          ),


        ],
      ),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ProductDetails();
            },
          ),
        );
      },
    );
  }
}
