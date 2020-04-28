
import 'package:bloc/bloc.dart';
import 'sidebarinvoker.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
 */

//Creating the Abstract class to load About Us



abstract class PageState {}

class Paginization extends Bloc<NavigationEvents, PageState> {

  @override
  PageState get initialState => AboutUs();

  @override
  Stream<PageState> mapEventToState(event) {
    // TODO: implement mapEventToState
  }
}

class NavigationEvents {
}
