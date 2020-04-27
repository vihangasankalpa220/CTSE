

import 'package:bloc/bloc.dart';
import 'package:finalproject/DisplayUI/favorite_screen.dart';
import 'package:finalproject/DisplayUI/MainPageDisplay.dart';


import 'sidebarinvoker.dart';


enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {

  @override
  NavigationStates get initialState => MyAccountsPage();


  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.MyAccountClickedEvent:
       HomeScreenUI();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
         FavoriteScreen();
        break;
      case NavigationEvents.HomePageClickedEvent:
        break;
    }
  }


}
