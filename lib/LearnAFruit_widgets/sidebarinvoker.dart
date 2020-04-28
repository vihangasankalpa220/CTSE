import 'package:flutter/material.dart';
import 'SideBarMain.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
 */

//Creating the About Us Page
class AboutUs extends StatelessWidget with PageState {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "About Us",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
