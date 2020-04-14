import 'dart:collection';

import 'package:learn_a_fruit_flutter_app/model/fruit.dart';
import 'package:learn_a_fruit_flutter_app/model/user.dart';
import 'package:flutter/cupertino.dart';

class FruitNotifier with ChangeNotifier {
  List<Fruit> _fruitList = [];
  List<User> _userList= [];
  Fruit _currentFruit;
  User _currentUser;
  UnmodifiableListView<Fruit> get fruitList => UnmodifiableListView(_fruitList);
  UnmodifiableListView<User> get userList => UnmodifiableListView(_userList);

  Fruit get currentFruit => _currentFruit;
  User get currentUser => _currentUser;

  set fruitList(List<Fruit> fruitList) {
    _fruitList = fruitList;
    notifyListeners();
  }

  set userList(List<User> userList) {
    _userList = userList;
    notifyListeners();
  }

  set currentFruit(Fruit fruit) {
    _currentFruit = fruit;
    notifyListeners();
  }


  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  addFruit(Fruit fruit) {
    _fruitList.insert(0, fruit);
    notifyListeners();
  }

  addUser(User user) {
    _userList.insert(0, user);
    notifyListeners();
  }

  deleteFruit(Fruit fruit) {
    _fruitList.removeWhere((_fruit) => _fruit.id == fruit.id);
    notifyListeners();
  }
}
