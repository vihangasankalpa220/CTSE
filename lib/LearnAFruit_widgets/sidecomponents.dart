import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SideBarMain.dart';
import 'sidewidgets.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
 */

//Creating the building block of About Us Side Navigation
class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<Paginization>(
        create: (context) => Paginization(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<Paginization, PageState>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
