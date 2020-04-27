import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Crudmodel/FruitCrudModel.dart';
import 'package:finalproject/Crudmodel/UserCrudModel.dart';

import 'package:flutter/cupertino.dart';

class FruitController with ChangeNotifier {
  List<FruitCrudModel> _fruitList = [];
  List<UserCrudModel> _userList= [];
  FruitCrudModel _currentFruit;
  UserCrudModel _currentUser;
  UnmodifiableListView<FruitCrudModel> get fruitList => UnmodifiableListView(_fruitList);
  UnmodifiableListView<UserCrudModel> get userList => UnmodifiableListView(_userList);

  FruitCrudModel get currentFruit => _currentFruit;
  UserCrudModel get currentUser => _currentUser;

  set fruitList(List<FruitCrudModel> fruitList) {
    _fruitList = fruitList;
    notifyListeners();
  }

  set userList(List<UserCrudModel> userList) {
    _userList = userList;
    notifyListeners();
  }

  set currentFruit(FruitCrudModel fruit) {
    _currentFruit = fruit;
    notifyListeners();
  }


  set currentUser(UserCrudModel user) {
    _currentUser = user;
    notifyListeners();
  }

  addFruit(FruitCrudModel fruit) {
    _fruitList.insert(0, fruit);
    notifyListeners();
  }

  addUser(UserCrudModel user) {
    _userList.insert(0, user);
    notifyListeners();
  }

  deleteFruit(FruitCrudModel fruit) {
    _fruitList.removeWhere((_fruit) => _fruit.id == fruit.id);
    notifyListeners();
  }

  deleteFavouriteFruit(FruitCrudModel fruit) {
    _fruitList.removeWhere((_fruit) => _fruit.id == fruit.id);
    notifyListeners();
  }


}
