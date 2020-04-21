

import 'package:bloc/bloc.dart';

import 'package:learn_a_fruit_flutter_app/screens/favorite_screen.dart';
import 'package:learn_a_fruit_flutter_app/screens/home.dart';
import 'package:learn_a_fruit_flutter_app/screens/main_screen.dart';
import 'package:learn_a_fruit_flutter_app/screens/notifications.dart';

import 'sidebarinvoker.dart';


enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {

  @override
  // TODO: implement initialState
  NavigationStates get initialState => MyAccountsPage();


  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.MyAccountClickedEvent:
       Home();
        break;
      case NavigationEvents.MyAccountClickedEvent:
         Notifications();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
         FavoriteScreen();
        break;
      case NavigationEvents.HomePageClickedEvent:
        // TODO: Handle this case.
        break;
    }
  }


}
