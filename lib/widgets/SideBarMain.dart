

import 'package:bloc/bloc.dart';
import 'package:finalproject/screens/favorite_screen.dart';
import 'package:finalproject/screens/home.dart';


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
       Home();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
         FavoriteScreen();
        break;
      case NavigationEvents.HomePageClickedEvent:
        break;
    }
  }


}
