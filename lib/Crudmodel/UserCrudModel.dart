import 'package:cloud_firestore/cloud_firestore.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the fruit crud model to perform crud operations
 */
//creating the class to create the attributes for the user crud model to handle the user details
class UserCrudModel {
  //declare string name for the each user crud  to display after login in main screen
  String displayName;
  //declare unique string email for the each user crud
  String email;
  //declare string password for the each user crud
  String password;
  //declare string image for the each user crud
  String image;
  //declare creating time to record the created time for the each user crud
  Timestamp createdAt;
  //declare updating time to record the updated time for the each user crud
  Timestamp updatedAt;

  //default constructor implementation
  UserCrudModel();


  //mapping the string based json data to document using the user crud model
  UserCrudModel.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    email = data['email'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  //returning the created data using user crud model
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


}
